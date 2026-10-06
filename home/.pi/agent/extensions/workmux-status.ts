/**
 * Workmux status tracking extension for pi.
 *
 * Reports agent status to workmux for tmux window status display.
 * See: https://workmux.raine.dev/guide/status-tracking
 */

import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

type AssistantState = { stopReason?: string; errorMessage?: string };

export default function (pi: ExtensionAPI) {
  function setStatus(status: string) {
    return pi.exec("workmux", ["set-window-status", status]).catch(() => {});
  }

  function latestAssistantWasAborted(ctx: ExtensionContext) {
    const branch = ctx.sessionManager.getBranch() as Array<{
      type?: string;
      message?: AssistantState & { role?: string };
    }>;
    for (let index = branch.length - 1; index >= 0; index--) {
      const entry = branch[index];
      if (entry?.type !== "message" || entry.message?.role !== "assistant") {
        continue;
      }
      return (
        entry.message.stopReason === "aborted" ||
        (entry.message.stopReason === "error" &&
          /\boperation was aborted\b/i.test(entry.message.errorMessage ?? ""))
      );
    }
    return false;
  }

  pi.on("session_start", async () => {
    await pi.exec("workmux", ["register-agent"]).catch(() => {});
  });

  pi.on("agent_start", async () => {
    await setStatus("working");
  });

  pi.on("agent_settled", async (_event, ctx) => {
    if (!latestAssistantWasAborted(ctx)) {
      await setStatus("done");
    }
  });
}
