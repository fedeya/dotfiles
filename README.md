# Fedeya Dotfiles

This is my personal dotfiles repository. It contains my configuration files for miscellaneous programs and tools.

## Setup

### Neovim

I use neovim with the next vscode extension: [vscode-neovim](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim)

#### Install Vim Plug

```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

#### Install Plugins

```bash
nvim +PlugInstall +qall
```
