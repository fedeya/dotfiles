#!/usr/bin/env bash
# Jump to the agent that needs you most (tmux `radar next` equivalent):
# blocked agents first, then done ones, most recent state change first.
# Skips the focused pane, so repeating it walks through the queue.
set -euo pipefail

herdr=${HERDR_BIN_PATH:-herdr}

target=$("$herdr" agent list | jq -r '
	[.result.agents[]
	 | select(.focused | not)
	 | select(.agent_status == "blocked" or .agent_status == "done")
	 | . + {prio: (if .agent_status == "blocked" then 0 else 1 end)}]
	| sort_by(.prio, -.state_change_seq)
	| .[0].pane_id // empty')

if [ -n "$target" ]; then
	"$herdr" agent focus "$target" >/dev/null
else
	"$herdr" notification show "No agents waiting" --body "No blocked or done agents" --sound none >/dev/null
fi
