#!/usr/bin/env bash
# Usage: tmux-session.sh <session-name> <worktree-path>
# Creates the worktree's tmux session if it doesn't exist.
# If OC_SESSION is set, the OpenCode pane resumes that session.
set -eu

S=$(printf '%s' "$1" | tr '.:' '--')
W=$2

tmux has-session -t "=$S" 2>/dev/null && exit 0

OC="opencode${OC_SESSION:+ -s $OC_SESSION}"
tmux new-session -d -s "$S" -c "$W" -n editor
tmux send-keys -t "=$S:editor" 'nvim' Enter
tmux split-window -h -l 35% -t "=$S:editor" -c "$W"
tmux send-keys -t "=$S:editor.1" "$OC" Enter
tmux new-window -d -t "=$S" -n zsh -c "$W"
echo "tmux session: $S"
