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

#### Exclude Untracked Files

```bash
cfg config --local status.showUntrackedFiles no
```

### Neovim

I use neovim with the next vscode extension: [vscode-neovim](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim)

#### Install Neovim

```bash
brew install neovim
```

#### Install Plugins

```bash
nvim --headless "+Lazy! sync" +qall
```

#### Enable Key Repeating
  
```bash
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
```

##### Increase Repeat and Delay Until Repeat

- Repeat

*Settings -> Keyboard -> Key Repeat -> Fast (all the way to the right)*

- Delay Until Repeat

*Settings -> Keyboard -> Delay Until Repeat -> Short - 1 (all the way to the right - 1)* 

