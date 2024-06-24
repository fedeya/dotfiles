# CodeWhisperer pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

export EDITOR=nvim

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(asdf zsh-vi-mode git fast-syntax-highlighting)

zvm_after_init_commands+=('source $ZSH/plugins/fzf/fzf.plugin.zsh')

source $ZSH/oh-my-zsh.sh

ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

# export PATH="$(asdf where nodejs)/.npm/bin:$PATH"

pro() {
  cd $HOME/Fede/pro/$1
}

dev() {
  cd $HOME/Fede/dev/$1
}

alias cat="bat --theme 'Catppuccin-mocha'"
alias icat="kitten icat"
alias ls="eza --icons"
alias cd="z"
alias tf="terraform"
alias kali="docker exec kali"

# bun completions
 # [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
# export DYLD_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_LIBRARY_PATH"
# export DYLD_LIBRARY_PATH=/opt/homebrew/lib/

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# ruby
export RUBYOPT="-W0 -W:no-deprecated -W:no-performance -W:no-experimental"

# java
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home

# android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

alias cfg='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# CodeWhisperer post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh"

export PATH=$PATH:/Users/aerolab/.spicetify

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(zoxide init zsh)"
