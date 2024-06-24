#!/usr/bin/env bash

echo "Installing Homebrew"

curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh

echo "Installing Homebrew Packages"

brew install \
  neovim \
  ripgrep \
  bat \
  eza \
  asdf \
  zoxide \
  fzf \
  fd \
  the_silver_searcher

echo "Installing Homebrew Casks"

brew install --cask \
  google-chrome \
  spotify \
  slack \
  notion \
  1password \
  discord \
  kitty \
  raycast \

echo "Installing Homebrew Fonts"

brew tap homebrew/cask-fonts

brew install --cask \
  font-jetbrains-mono-nerd-font \
