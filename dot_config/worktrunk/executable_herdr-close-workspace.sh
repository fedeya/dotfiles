#!/usr/bin/env bash
# Usage: herdr-close-workspace.sh <worktree-path>
# herdr counterpart of the post-remove `tmux kill-session`: closes the herdr
# workspace opened on a removed worktree. Detaches and waits a moment so `wt`
# can finish even when it runs inside the workspace being closed.
set -eu

[ "${1:-}" = "--detached" ] || { nohup "$0" --detached "$1" >/dev/null 2>&1 & exit 0; }
W=$2
herdr=${HERDR_BIN_PATH:-herdr}

sleep 1
for ws in $("$herdr" workspace list | jq -r '.result.workspaces[].workspace_id'); do
	path=$("$herdr" workspace get "$ws" | jq -r '.result.workspace.worktree.checkout_path // empty')
	if [ "$path" = "$W" ]; then
		"$herdr" workspace close "$ws" >/dev/null
	fi
done
