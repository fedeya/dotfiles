#!/usr/bin/env bash
# Tab bar status entry: name of the focused workspace (repo/branch for worktrees).
set -euo pipefail

"${HERDR_BIN_PATH:-herdr}" api snapshot | jq -r '
	.result.snapshot as $s
	| $s.workspaces[] | select(.workspace_id == $s.focused_workspace_id)
	| if .worktree.is_linked_worktree then "\(.worktree.repo_name)/\(.label)" else .label end'
