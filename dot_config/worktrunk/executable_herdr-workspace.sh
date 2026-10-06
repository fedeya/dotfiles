#!/usr/bin/env bash
# Usage: herdr-workspace.sh <worktree-path> <primary-worktree-path> <branch>
# herdr counterpart of tmux-session.sh + the post-switch `tmux switch-client`.
# Ensures the worktree has a herdr workspace (grouped under its repo); a new
# linked-worktree workspace starts OpenCode. Then focuses it, unless OC_SESSION
# is set: OpenCode resumes that session there and focus stays where it is.
set -euo pipefail

if [ "${1:-}" = "--resume" ]; then
	W=$2 pane=$3 sid=$4
	herdr=${HERDR_BIN_PATH:-herdr}
	cd "$W"
	full=""
	for _ in $(seq 1 120); do
		full=$(opencode session list --format json 2>/dev/null |
			jq -r --arg s "$sid" --arg w "$W" '[.[] | select((.id | startswith($s)) and .directory == $w)][0].id // empty')
		[ -n "$full" ] && break
		sleep 1
	done
	"$herdr" pane run "$pane" "opencode -s ${full:-$sid}" >/dev/null
	exit 0
fi

W=$1
P=$2
B=$3
herdr=${HERDR_BIN_PATH:-herdr}
OC="opencode${OC_SESSION:+ -s $OC_SESSION}"

ws=$("$herdr" api snapshot | jq -r --arg w "$W" \
	'[.result.snapshot.workspaces[] | select(.worktree.checkout_path == $w)][0].workspace_id // empty')
if [ -z "$ws" ]; then
	ws=$("$herdr" pane list | jq -r --arg w "$W" '[.result.panes[] | select(.cwd == $w)][0].workspace_id // empty')
fi

if [ -z "$ws" ]; then
	if [ "$W" = "$P" ]; then
		"$herdr" workspace create --cwd "$P" --label "$(basename "$P")" --no-focus >/dev/null
	else
		"$herdr" worktree open --cwd "$P" --path "$W" --label "$B" --no-focus >/dev/null
	fi
	ws=$("$herdr" api snapshot | jq -r --arg w "$W" \
		'[.result.snapshot.workspaces[] | select(.worktree.checkout_path == $w)][0].workspace_id // empty')
	if [ -n "$ws" ] && [ "$W" != "$P" ]; then
		pane=$("$herdr" pane list --workspace "$ws" | jq -r '.result.panes[0].pane_id // empty')
		if [ -n "$pane" ] && [ -n "${OC_SESSION:-}" ]; then
			# The OpenCode worktree skill moves the session into the worktree
			# (session_move) only after `wt switch` returns, and may pass a
			# truncated id. Wait until the session shows up in this directory,
			# then resume it by its full id.
			nohup "$0" --resume "$W" "$pane" "$OC_SESSION" >/dev/null 2>&1 &
		elif [ -n "$pane" ]; then
			"$herdr" pane run "$pane" "$OC" >/dev/null
		fi
	fi
fi

if [ -n "$ws" ] && [ -z "${OC_SESSION:-}" ]; then
	"$herdr" workspace focus "$ws" >/dev/null
fi
