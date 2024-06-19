# CodeWhisperer pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zprofile.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zprofile.pre.zsh"
# # CodeWhisperer pre block. Keep at the top of this file.
# # # Fig pre block. Keep at the top of this file.
# [[ -f "$HOME/.fig/shell/zprofile.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zprofile.pre.zsh"
# eval "$(/opt/homebrew/bin/brew shellenv)"
#

# Added by Toolbox App
export PATH="$PATH:/Users/aerolab/Library/Application Support/JetBrains/Toolbox/scripts"

eval "$(/opt/homebrew/bin/brew shellenv)"

# # Fig post block. Keep at the bottom of this file.
# [[ -f "$HOME/.fig/shell/zprofile.post.zsh" ]] && builtin source "$HOME/.fig/shell/zprofile.post.zsh"

# # CodeWhisperer post block. Keep at the bottom of this file.
#

# CodeWhisperer post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zprofile.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zprofile.post.zsh"

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
