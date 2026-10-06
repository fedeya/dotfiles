import { execFile, spawn } from 'node:child_process';
import { promisify } from 'node:util';
import { Plugin } from '@opencode/plugin';

const execute = promisify(execFile);

type Status = 'working' | 'waiting' | 'done';

export default Plugin.define({
  id: 'workmux-status',
  setup(ctx) {
    const directory = ctx.location.directory;

    // OpenCode 2 runs plugins inside a shared background service, so its
    // `TMUX_PANE` belongs to whichever terminal started the service. Resolve the
    // OpenCode panes for this plugin's location instead.
    async function resolvePanes(): Promise<string[]> {
      try {
        const { stdout } = await execute('tmux', [
          'list-panes',
          '-a',
          '-F',
          '#{pane_id}\t#{pane_current_command}\t#{pane_current_path}',
        ]);
        return stdout
          .split('\n')
          .map((line) => line.split('\t'))
          .filter(([, command, path]) => command === 'opencode' && path === directory)
          .map(([paneID]) => paneID);
      } catch {
        // tmux may be unavailable; there is no pane to report to.
        return [];
      }
    }

    // `workmux` can leave a background process holding its stdio open after it
    // exits, so ignore stdio and settle on `exit` (with a timeout) instead of
    // waiting for the pipes to close.
    function workmux(paneID: string, args: string[]) {
      return new Promise<void>((resolve) => {
        const child = spawn('workmux', args, {
          cwd: directory,
          env: { ...process.env, TMUX_PANE: paneID },
          stdio: 'ignore',
        });
        const timer = setTimeout(() => {
          child.kill();
          resolve();
        }, 10_000);
        const done = () => {
          clearTimeout(timer);
          resolve();
        };
        child.once('exit', done);
        child.once('error', done);
      });
    }

    const registeredPanes = new Set<string>();

    async function writeStatus(status: Status) {
      const panes = await resolvePanes();
      await Promise.all(
        panes.map(async (paneID) => {
          if (!registeredPanes.has(paneID)) {
            registeredPanes.add(paneID);
            // Status tracking remains available when registration cannot reach workmux.
            await workmux(paneID, ['register-agent']);
          }
          await workmux(paneID, ['set-window-status', status]);
        }),
      );
    }

    // The service streams events for every location, and durable session events
    // such as `session.execution.*` carry no `location`. Resolve each session's
    // directory once so this instance only reflects its own sessions.
    const ownedBySession = new Map<string, Promise<boolean>>();

    function ownsSession(sessionID: string, location?: { directory: string }) {
      let owned = ownedBySession.get(sessionID);
      if (!owned) {
        owned = location
          ? Promise.resolve(location.directory === directory)
          : ctx.session.get({ sessionID }).then(
              (session) => session.location.directory === directory,
              () => false,
            );
        ownedBySession.set(sessionID, owned);
      }
      return owned;
    }

    // Track every parent and child session so one finished session cannot mark
    // the whole pane done while another session is still working.
    const statusBySession = new Map<string, Status>();
    const deletedSessions = new Set<string>();
    let reportedStatus: Status | undefined;
    let statusQueue = Promise.resolve();

    function queueStatus(status: Status) {
      statusQueue = statusQueue.then(
        () => writeStatus(status),
        () => writeStatus(status),
      );
      return statusQueue;
    }

    async function reportAggregateStatus() {
      const statuses = [...statusBySession.values()];
      let status: Status = 'done';

      if (statuses.includes('waiting')) {
        status = 'waiting';
      } else if (statuses.includes('working')) {
        status = 'working';
      }

      if (reportedStatus === status) {
        return;
      }

      reportedStatus = status;
      await queueStatus(status);
    }

    async function setStatus(sessionID: string, status: Status) {
      if (deletedSessions.has(sessionID)) {
        return;
      }

      const previous = statusBySession.get(sessionID);
      if (previous === status || (status === 'done' && previous === undefined)) {
        return;
      }

      statusBySession.set(sessionID, status);
      await reportAggregateStatus();
    }

    const controller = new AbortController();

    const watcher = (async () => {
      for await (const event of ctx.event.subscribe({ signal: controller.signal })) {
        // OpenCode 2 does not publish `session.status` or `session.idle` on the
        // event stream; a turn is bracketed by `session.execution.*` instead.
        switch (event.type) {
          case 'session.execution.started':
            if (await ownsSession(event.data.sessionID, event.location)) {
              await setStatus(event.data.sessionID, 'working');
            }
            break;
          case 'session.execution.succeeded':
          case 'session.execution.failed':
          case 'session.execution.interrupted':
            if (await ownsSession(event.data.sessionID, event.location)) {
              await setStatus(event.data.sessionID, 'done');
            }
            break;
          case 'permission.asked':
            if (await ownsSession(event.data.sessionID, event.location)) {
              await setStatus(event.data.sessionID, 'waiting');
            }
            break;
          case 'form.created':
            if (await ownsSession(event.data.form.sessionID, event.location)) {
              await setStatus(event.data.form.sessionID, 'waiting');
            }
            break;
          case 'permission.replied':
          case 'form.replied':
          case 'form.cancelled':
            if (statusBySession.get(event.data.sessionID) === 'waiting') {
              await setStatus(event.data.sessionID, 'working');
            }
            break;
          case 'session.deleted': {
            const sessionID = event.data.sessionID;
            deletedSessions.add(sessionID);
            ownedBySession.delete(sessionID);
            if (statusBySession.delete(sessionID)) {
              await reportAggregateStatus();
            }
            break;
          }
        }
      }
    })().catch((error: unknown) => {
      if (!controller.signal.aborted) {
        console.error('workmux status tracking stopped', error);
      }
    });

    return async () => {
      controller.abort();
      await watcher;
      await statusQueue;
    };
  },
});
