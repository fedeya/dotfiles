# Fedeya Dotfiles

This is my personal dotfiles repository. It contains my configuration files for miscellaneous programs and tools.

## Setup

### Clone and Usage

Clone repo as bare repo in your home directory:
```bash
git clone --bare https://github.com/fedeya/dotfiles.git $HOME/.dotfiles
```

Define the alias in the current shell scope:
```bash
alias cfg='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

Checkout the actual content from the bare repository to your $HOME:
```bash
cfg checkout
```

### Neovim

I use neovim with the next vscode extension: [vscode-neovim](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim)

#### Install Plugins

```bash
nvim --headless "+Lazy! sync" +qall
```
