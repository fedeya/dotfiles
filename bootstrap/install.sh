#!/usr/bin/env bash
# New machine:
#   curl -fsSL https://raw.githubusercontent.com/fedeya/dotfiles/mise/bootstrap/install.sh | bash
set -euo pipefail

DOTFILES=~/dotfiles

if ! command -v mise >/dev/null 2>&1; then
	curl -fsSL https://mise.run | sh
	export PATH="$HOME/.local/bin:$PATH"
fi

[ -d "$DOTFILES/.git" ] || git clone https://github.com/fedeya/dotfiles.git "$DOTFILES"

# The global mise config lives in the repo; link it so mise can find the rest.
mkdir -p ~/.config/mise
if [ ! -L ~/.config/mise/config.toml ]; then
	[ -e ~/.config/mise/config.toml ] && mv ~/.config/mise/config.toml ~/.config/mise/config.toml.pre-dotfiles
	ln -s "$DOTFILES/home/.config/mise/config.toml" ~/.config/mise/config.toml
fi

mise bootstrap --dry-run
read -r -p "Apply? [y/N] " ok </dev/tty
[ "$ok" = "y" ] && mise bootstrap
