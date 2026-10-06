#!/usr/bin/env bash
# tuicr reviews beside the agent, in herdr.
#
# Usage:
#   tuicr-review.sh [auto|branch]  open tuicr in a split beside the focused pane
#     auto    uncommitted changes; the branch diff when the tree is clean
#     branch  the branch against its base, plus uncommitted changes
#   tuicr-review.sh send           send the open review's comments to its agent
#                                  and clear them in tuicr, which stays open
#                                  (run from the tuicr pane or its agent pane)
set -euo pipefail

herdr=${HERDR_BIN_PATH:-herdr}
state=${XDG_STATE_HOME:-$HOME/.local/state}/herdr/tuicr-review
mkdir -p "$state"

notify() { "$herdr" notification show "$1" --body "${2:-}" --sound none >/dev/null 2>&1 || true; }
keys() { "$herdr" pane send-keys "$1" "${@:2}" >/dev/null; }

src=${HERDR_PANE_ID:-${HERDR_ACTIVE_PANE_ID:-}}
[ -n "$src" ] || { echo "no focused pane" >&2; exit 1; }
panes=$("$herdr" pane list)
alive() { jq -e --arg p "$1" '.result.panes | any(.pane_id == $p)' <<<"$panes" >/dev/null; }

# --- send ---------------------------------------------------------------------
if [ "${1:-}" = "send" ]; then
	# State files are "<tuicr pane>": "agent=<pane> root=<path>"
	review=""
	if [ -f "$state/$src" ]; then
		review=$src
	else
		for f in "$state"/*; do
			[ -f "$f" ] || continue
			grep -qx "agent=$src" "$f" && alive "$(basename "$f")" && { review=$(basename "$f"); break; }
		done
	fi
	[ -n "$review" ] && alive "$review" || { notify "tuicr: no open review here" "Open one with prefix+d"; exit 0; }
	agent=$(sed -n 's/^agent=//p' "$state/$review")
	root=$(sed -n 's/^root=//p' "$state/$review")

	# Make tuicr flush comments written in the TUI to its session file
	keys "$review" Escape
	keys "$review" : w Enter
	sleep 0.5

	slug=$(tuicr review list --repo "$root" | jq -r '[.[] | select(.active)] | sort_by(.updated_at) | last | .slug // empty')
	[ -n "$slug" ] || { notify "tuicr: no active session" "$root"; exit 0; }
	comments=$(tuicr review comments --repo "$root" --session "$slug")
	[ "$(jq 'length' <<<"$comments")" -gt 0 ] || { notify "tuicr: no comments to send"; exit 0; }

	body=$(jq -r '
		def tag: if (.comment_type // "none") == "none" then "" else "**[\(.comment_type | ascii_upcase)]** " end;
		to_entries | map("\(.key + 1). \(.value | tag)`\(.value.location // "review")` - \(.value.content)") | join("\n")' <<<"$comments")
	prompt="I reviewed your changes in $root with tuicr and have the following comments. Please address them.

$body"

	if [ -n "$agent" ] && alive "$agent" && "$herdr" agent prompt "$agent" "$prompt" >/dev/null 2>&1; then
		keys "$review" : c l e a r c Enter
		notify "tuicr: sent $(jq 'length' <<<"$comments") comments" "to $agent"
	else
		printf '%s' "$prompt" | pbcopy
		notify "tuicr: review copied" "No agent took it (none, or it is blocked). Comments kept in tuicr."
	fi
	exit 0
fi

# --- open ---------------------------------------------------------------------
mode=${1:-auto}
info=$(jq -c --arg p "$src" '.result.panes[] | select(.pane_id == $p)' <<<"$panes")
cwd=$(jq -r '.cwd' <<<"$info")

root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null) || {
	notify "tuicr: not a git repo" "$cwd"
	exit 0
}

# Agent to send to: the focused pane, else one in the same tab, else in the workspace
agent=$(jq -r --argjson i "$info" '
	[.result.panes[] | select(.agent != null and .workspace_id == $i.workspace_id)
	 | . + {rank: (if .pane_id == $i.pane_id then 0 elif .tab_id == $i.tab_id then 1 else 2 end)}]
	| sort_by(.rank) | .[0].pane_id // empty' <<<"$panes")

# Base branch: upstream (unless it is this branch on the remote), origin/HEAD, main/master
base=""
branch=$(git -C "$root" symbolic-ref --quiet --short HEAD 2>/dev/null || true)
upstream=$(git -C "$root" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null || true)
if [ -n "$upstream" ] && [ "${upstream#*/}" != "$branch" ]; then
	base=$upstream
elif ref=$(git -C "$root" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null); then
	base=$ref
else
	for b in main master; do
		git -C "$root" rev-parse --verify --quiet "$b" >/dev/null && { base=$b; break; }
	done
fi

dirty=$(git -C "$root" status --porcelain | head -1)
ahead=0
[ -n "$base" ] && ahead=$(git -C "$root" rev-list --count "$base..HEAD" 2>/dev/null || echo 0)

args=()
case "$mode" in
branch)
	[ -n "$base" ] || { notify "tuicr: no base branch found" "$root"; exit 0; }
	args=(-r "$base..HEAD")
	[ -n "$dirty" ] && args+=(-w)
	;;
*)
	if [ -n "$dirty" ]; then
		args=(-w)
	elif [ "$ahead" -gt 0 ]; then
		args=(-r "$base..HEAD")
	fi # else: no args, tuicr opens its commit selector
	;;
esac

# Forget reviews whose panes are gone
for f in "$state"/*; do
	[ -f "$f" ] && ! alive "$(basename "$f")" && rm -f "$f"
done

new=$("$herdr" pane split "$src" --direction right --cwd "$root" --focus | jq -r '.result.pane.pane_id')
printf 'agent=%s\nroot=%s\n' "$agent" "$root" >"$state/$new"
"$herdr" pane run "$new" "$(printf '%q ' exec tuicr "${args[@]+"${args[@]}"}")" >/dev/null
