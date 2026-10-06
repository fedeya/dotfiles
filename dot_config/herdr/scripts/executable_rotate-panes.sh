#!/bin/sh
# Rotate the panes of the current tab one position forward (tmux rotate-window).
set -eu

herdr=${HERDR_BIN_PATH:-herdr}
pane=${HERDR_PANE_ID:-${HERDR_ACTIVE_PANE_ID:-}}

if [ -n "$pane" ]; then
	layout=$("$herdr" pane layout --pane "$pane")
else
	layout=$("$herdr" pane layout)
fi

panes=$(printf '%s' "$layout" | jq -r '.result.layout.panes[].pane_id')
last=$(printf '%s\n' "$panes" | tail -n 1)

printf '%s\n' "$panes" | sed '$d' | tail -r | while read -r other; do
	"$herdr" pane swap --source-pane "$last" --target-pane "$other" >/dev/null
done
