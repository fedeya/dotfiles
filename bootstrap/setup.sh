#!/usr/bin/env bash
# Setup that mise has no declarative section for. Run by `mise bootstrap`
# (task `bootstrap`) on every apply, so every step must be idempotent.
set -euo pipefail

step() { printf '\n==> %s\n' "$*"; }
has() { command -v "$1" >/dev/null 2>&1; }

if has bun && [ -f ~/.config/opencode/package.json ]; then
	step "opencode plugin deps"
	(cd ~/.config/opencode && bun install --silent)
fi

if has npm && [ -f ~/.pi/agent/npm/package.json ]; then
	step "pi extensions"
	(cd ~/.pi/agent/npm && npm install --silent --no-fund --no-audit)
fi

if has herdr; then
	step "herdr integrations and plugins"
	herdr integration status | grep -q '^opencode: current' || herdr integration install opencode

	installed=$(herdr plugin list 2>/dev/null || true)
	for repo in \
		ChmaraX/herdr-nvim \
		jhochenbaum/herdr-hunk-diff \
		persiyanov/herdr-reviewr \
		paulbkim-dev/vim-herdr-navigation \
		devashish2203/herdr-worktrunk; do
		grep -q "github:$repo@" <<<"$installed" || herdr plugin install "$repo" --yes
	done
	if [ -d ~/pro/herdr-sesh ] && ! grep -q 'local:.*/herdr-sesh' <<<"$installed"; then
		herdr plugin link ~/pro/herdr-sesh
	fi
fi

if has wt && [ ! -f ~/.config/opencode/plugins/worktrunk.ts ]; then
	step "worktrunk opencode plugin"
	wt config plugins opencode install
fi

if [ -x ~/.tmux/plugins/tpm/bin/install_plugins ]; then
	step "tmux plugins"
	~/.tmux/plugins/tpm/bin/install_plugins >/dev/null
fi
