# ~/.config/zsh/.zprofile

# sane UMASK
umask 077

emulate sh
. ~/.profile
emulate zsh

[[ -d "$HOME/.rvm/bin" ]] && export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# rvm - single user mode
# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion
