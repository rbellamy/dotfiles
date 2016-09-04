# ~/.config/zsh/.zprofile

emulate sh
. ~/.profile
emulate zsh


# nvm
[[ -s "$HOME/.config/zsh-nvm/zsh-nvm.plugin.zsh" ]] && source "$HOME/.config/zsh-nvm/zsh-nvm.plugin.zsh"
