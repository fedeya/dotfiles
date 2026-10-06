---
name: worktree
description: Create a git worktree to work on a separate branch. Use when the user asks to create a worktree, start a separate branch, or continue a task "in another worktree". Uses Worktrunk (copies .env, runs setup, creates a tmux session) and moves this OpenCode session into the new worktree. Do not use `git worktree add` directly or the native /worktrees command.
---

# Worktree with Worktrunk

The hooks in `~/.config/worktrunk/config.toml` handle setup: they copy `.env`/`.codegraph` (copy-on-write), run `mise trust` + `just install`, and open the worktree with OpenCode resuming the session given in `OC_SESSION`: under tmux, the session `wt-<repo>-<branch>` with nvim; under herdr, a workspace grouped under the repo (it waits until step 3 moves the session before resuming it).

## Steps

1. **Branch**: if the user gave a name, use it; otherwise derive a short kebab-case name from the context (e.g. `fix-login-timeout`). By default it branches from the default branch; if the user wants to branch from the current one use `--base=@`, or the branch they specify.
2. **Create** from the current repo, with your real, full session ID (the whole `ses_…` value, never truncated):
   ```sh
   OC_SESSION=<your session ID> wt switch --create <branch> --no-cd --yes --format=json
   ```
   Read `path` from the JSON output. If it fails (branch exists, dirty repo, etc.), show the error and ask how to proceed.
3. **Move the session**: call `tools.opencode.session_move` (via `execute`) with that `path` as `directory`.
4. **Reply** in one or two lines: branch, path, and where it opened — under tmux the session (`tmux switch-client -t wt-<repo>-<branch>`), under herdr (`HERDR_ENV=1`) the workspace named after the branch.

## Other operations

- List: `wt list`
- Remove (worktree + branch + tmux session): `wt remove <branch> --yes`
- Clean up merged ones: `wt step prune`
