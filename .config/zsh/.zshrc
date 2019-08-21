# ~/.profile {{{

# checks {{{
(( $UID == 0 )) && isroot=true || isroot=false
# test if command is available
have() { which $1 &>/dev/null || return 1 }
# }}}

# constant environment variables {{{
export PLATFORM=$(uname -s)

# JAVA_OPTIONS
[[ "$PLATFORM" == "Darwin" ]] && JHOME=$(/usr/libexec/java_home) || JHOME=/usr/lib/jvm/default
export JAVA_HOME="$JHOME"
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'

# manpage colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# xdg stuffs
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_DATA_HOME="$HOME"/.local/share

# homes - based on xdg config
export MPV_HOME="$XDG_CONFIG_HOME"/mpv
export GNUPGHOME="$XDG_CONFIG_HOME"/gnupg
export GIMP2_DIRECTORY="$XDG_CONFIG_HOME"/gimp
export ELINKS_CONFDIR="$XDG_CONFIG_HOME"/elinks
export ATOM_HOME="$XDG_CONFIG_HOME"/atom
export VAGRANT_HOME="$XDG_CONFIG_HOME"/vagrant

export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/settings.ini
#export XAUTHORITY="$XDG_RUNTIME_DIR"/X11-authority

# Set vimrc's location and source it on vim startup
# Based on XDG_CONFIG_HOME
#export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
export VIMINIT="source $XDG_CONFIG_HOME/vim/vimrc"

# R environment stuffs
export R_CONFIG_HOME="$XDG_CONFIG_HOME"/R
export R_PROFILE_USER="$R_CONFIG_HOME"/RProfile
export R_LIBS_USER="$R_CONFIG_HOME"/libs_%v
export R_LIBS_USER_DEV="$R_CONFIG_HOME"/libs_dev
export R_HISTFILE="$R_CONFIG_HOME"/RHistory

# psql environment stuffs
export PSQL_CONFIG_HOME="$XDG_CONFIG_HOME/pg"
export PSQLRC="$PSQL_CONFIG_HOME/psqlrc"
export PSQL_HISTORY="$XDG_CACHE_HOME/pg/psql_history"
export PGPASSFILE="$PSQL_CONFIG_HOME/pgpass"
export PGSERVICEFILE="$PSQL_CONFIG_HOME/pg_service.conf"

# k8s
export KUBECONFIG="$HOME/.kube/config"
KUBECONFIG+=":$XDG_CONFIG_HOME/kube/config"
KUBECONFIG+=":$HOME/Development/Terradatum/k8s/infrastructure/terraform/aws/environments/dev-usw2/phase2/040-eks-cluster/kubeconfig_eks-dev-cluster"
KUBECONFIG+=":$HOME/Development/Terradatum/k8s/infrastructure/terraform/aws/environments/stage-prod-usw2/phase2/040-eks-cluster/kubeconfig_eks-stage-prod-cluster"

# default editor - visual and terminal
export EDITOR=vim
export VISUAL=vim

# less is more
export YELLOW=`echo -e '\033[1;33m'`
export LIGHT_CYAN=`echo -e '\033[1;36m'`
export GREEN=`echo -e '\033[0;32m'`
export NOCOLOR=`echo -e '\033[0m'`
export LESS="-iMSx4 -FXR"
#export PAGER="sed \"s/^\(([0-9]\+ [rows]\+)\)/$GREEN\1$NOCOLOR/;s/^\(-\[\ RECORD\ [0-9]\+\ \][-+]\+\)/$GREEN\1$NOCOLOR/;s/|/$GREEN|$NOCOLOR/g;s/^\([-+]\+\)/$GREEN\1$NOCOLOR/\" 2>/dev/null | less"
export LESSHISTFILE="$XDG_CACHE_HOME"/lesshist

# browser depends on terminal or X
if [[ -n $DISPLAY ]] || [[ "$PLATFORM" == "Darwin" ]]; then
  export BROWSER=chrome
else
  export BROWSER=elinks
fi
#export TERMINAL=termite

# correct colored less - use ANSI-only raw control characters
export LESS=-R

# Simple DirectMedia Layer default sound backend - used for Valve and Steam
export SDL_AUDIODRIVER=pulse

# draw lines whether in UTF8 or not
export NCURSES_NO_UTF8_ACS=1

# libvirt default uri
export LIBVIRT_DEFAULT_URI=qemu:///system

# gpg tty
export GPG_TTY=$(tty)

# }}}

# }}}

# modules {{{
autoload -Uz compinit edit-command-line vcs_info zmv bashcompinit
compinit
bashcompinit
zle -N edit-command-line
zmodload zsh/complist
# }}}

# path and source magic {{{
[[ -d /etc/bash_completion.d ]] && for c in /etc/bash_completion.d/*; do source "$c"; done
[[ -d /opt/maven ]] && export M2_HOME=/opt/maven
[[ -d /usr/local/Cellar/maven/3.5.4/libexec ]] && export M2_HOME=/usr/local/Cellar/maven/3.5.4/libexec

#[[ $- == *i* ]] && source "$HOME/.local/bin/fzf/shell/completion.zsh" 2> /dev/null
#[[ -r "$HOME/.local/bin/fzf/shell/key-bindings.zsh" ]] && source "$HOME/.local/bin/fzf/shell/key-bindings.zsh"
[[ -r "$HOME/.local/bin/kubectl" ]] && source <($HOME/.local/bin/kubectl completion zsh)
[[ -r "$XDG_CONFIG_HOME/zsh/kube-ps1/kube-ps1.sh" ]] && source "$XDG_CONFIG_HOME/zsh/kube-ps1/kube-ps1.sh"

#export PATH="$PATH:$HOME/.yarn/bin" # Add yarn to PATH
#[[ -d "$HOME/.rvm/bin" ]] && export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
#have ruby && export PATH="`ruby -e 'puts Gem.user_dir'`/bin:$PATH"
export N_PREFIX="$HOME/.local/share/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
[[ -d "$HOME/.dotnet/tools" ]] && PATH+=":$HOME/.dotnet/tools"

#[[ -r "$HOME/.venv/bin/activate" ]] && source "$HOME/.venv/bin/activate" # Load the Python 3 venv
#[[ -r "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
#[[ -r "$rvm_path/scripts/completion" ]] && source "$rvm_path/scripts/completion" # Load RVM script completions
have awless && source <(awless completion zsh)
# conda init {{{
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/rbellamy/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
  eval "$__conda_setup"
else
  if [ -f "/home/rbellamy/anaconda3/etc/profile.d/conda.sh" ]; then
    . "/home/rbellamy/anaconda3/etc/profile.d/conda.sh"
  else
    export PATH="/home/rbellamy/anaconda3/bin:$PATH"
  fi
fi
unset __conda_setup
# <<< conda initialize <<<
# }}}
# }}}

# update the function path {{{
if [[ -d "/usr/local/share/zsh-completions" ]] then
  fpath=(~/.config/zsh/functions ~/.config/zsh/functions/zsh-completions/src "/usr/local/share/zsh-completions" "${fpath[@]}")
else
  fpath=(~/.config/zsh/functions ~/.config/zsh/functions/zsh-completions/src "${fpath[@]}")
fi
# }}}

# completions {{{
# Because .profile/.zprofile are loaded BEFORE .zshrc
[[ -r "/usr/local/share/zsh/site-functions/_aws" ]] && source "/usr/local/share/zsh/site-functions/_aws"
# }}}

# shell options {{{
setopt NO_BEEP \
  NOTIFY \
  NO_BG_NICE \
  CORRECT \
  INTERACTIVE_COMMENTS \
  PRINT_EXIT_VALUE \
  AUTO_CD \
  AUTO_PUSHD \
  PUSHD_TO_HOME \
  CHASE_LINKS \
  HIST_VERIFY \
  HIST_APPEND \
  SHARE_HISTORY \
  HIST_REDUCE_BLANKS \
  HIST_IGNORE_SPACE \
  HIST_IGNORE_DUPS \
  HIST_SAVE_NO_DUPS \
  BRACE_CCL \
  DOT_GLOB \
  EXTENDED_GLOB \
  NUMERIC_GLOB_SORT \
  NO_LIST_TYPES \
  PROMPT_SUBST \
  COMPLETE_ALIASES \
  EXTENDED_HISTORY

# input with no command
READNULLCMD=$PAGER
# history
HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
DIRSTACKSIZE=20
# }}}

# completion style {{{
# menu completion
zstyle ':completion:*' menu select

# colors
if have dircolors; then
  eval $(dircolors -b ~/.config/dircolors-solarized/dircolors.256dark)
  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
  alias ls='ls -Ah --color=auto'
elif [ "$PLATFORM" = Darwin ]; then
  export CLICOLOR=1
  zstyle ':completion:*:default' list-colors ''
  alias ls='ls -G'
fi

# complete all processes
zstyle ':completion:*:processes' command 'ps -e'
zstyle ':completion:*:processes-names' command 'ps -eo comm'
# cache completion
zstyle ':completion:*' use-cache on
# don't complete working directory in parent
zstyle ':completion:*' ignore-parents parent pwd
# }}}

# title (for vte, xterm and rxvt) {{{
case "$TERM" in
  vte*|xterm*|rxvt*|putty*)
    update_title() {
      print -Pn '\e];%n (%~) - Terminal\a'
    }
    ;;
  *)
    update_title() {}
    ;;
esac
# }}}

# prompt {{{
#zstyle ':vcs_info:*+*:*' debug true
zstyle ':vcs_info:*:prompt-rbellamy:*' enable git hg
zstyle ':vcs_info:*:prompt-rbellamy:*' actionformats '%b %a '
zstyle ':vcs_info:*:prompt-rbellamy:*' formats '%b '
zstyle ':prompt:rbellamy:vcs:*' whitelist-dirs ~/Development(N:A) ~/.config(N:A) ~/.local(N:A)
# initialize vimode (stops linux console glitch)
vimode=i
# set vimode to current editing mode
function zle-line-init zle-keymap-select {
  vimode="${${KEYMAP/vicmd/c}/(main|viins)/i}"
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# Style
# %m       : hostname up to the first . (dot)
# %n       : $USERNAME
# %#       : a % if the shell is running with privileges, a % if not
# ${vimode}: the vi mode we're in on the prompt
# %F{cyan} : foreground color cyan
# %~       : current working directory, if $HOME then ~
# %f       : reset foreground color to default
if $isroot; then
  PROMPT='%U%B%F{white}%D{%Y-%m-%d %T}%f%b%u $(kube_ps1)
%K{088}%n@%m%k %F{magenta}${vimode}%f %B%F{cyan}%~%f%b %F{green}%3v%f%B%F{white}%# %f%b'
else
  PROMPT='%U%B%F{white}%D{%Y-%m-%d %T}%f%b%u $(kube_ps1)
%K{018}%n@%m%k %F{magenta}${vimode}%f %B%F{cyan}%~%f%b %F{green}%3v%f%B%F{white}%# %f%b'
fi
# }}}

# aliases {{{
alias ...='cd ../..'
alias ....='cd ../../..'
have colordiff && alias diff=colordiff
alias df='df -h'
alias du='du -h'
alias free='free -m'
alias cp='cp -iv'
alias grep="egrep --color=auto"
alias mv='mv -iv'
alias ln='ln -iv'
alias install='install -v'
alias mount='mount -v'
alias umount='umount -v'
if [[ "$PLATFORM" == "Linux" ]]; then
  alias chown='chown -c --preserve-root'
  alias chmod='chmod -c --preserve-root'
  alias chgrp='chgrp -c --preserve-root'
  alias rm='rm -Iv'
elif [[ "$PLATFORM" == "Darwin" ]]; then
  alias chown='chown -v'
  alias chmod='chmod -v'
  alias chgrp='chgrp -v'
  alias rm='rm -iv'
fi

alias rmdir='rmdir -v'
alias mkdir='mkdir -vp'
alias cling='cling --nologo -std=c++11'
alias gdb='gdb -q'
alias ll='ls -l'
alias rr='rm -r'
alias pu=pushd
alias po=popd
alias rh=rehash
alias dirs='dirs -p'
alias weechat-curses='dtach -A $XDG_RUNTIME_DIR/weechat weechat-curses'
alias mutt='dtach -A $XDG_RUNTIME_DIR/mutt mutt -F ~/.config/mutt/muttrc'
alias sprunge="curl -F c=@- https://sprunge.us"
alias ptpb="curl -F c=@- https://ptpb.pw"
alias ix="curl -F c=@- https://ix.io"
have hub && alias git='hub --no-pager'
#have repose && alias eanna='repose -vf eanna -r /var/cache/pacman/eanna'
alias dotfiles='git --git-dir=$HOME/.dot/ --work-tree=$HOME'
alias cleos='docker exec -it eosio /opt/eosio/bin/cleos --url http://127.0.0.1:7777 --wallet-url http://127.0.0.1:5555'
have sbt && alias sbt='sbt -sbt-launch-repo https://nexus.terradatum.com/content/groups/sbt-ivy'
have code-insiders && alias code='code-insiders'

# vim
alias vim='vim -p'
alias gvim='gvim -p'
if ! $isroot; then
  alias visudo="sudo EDITOR='$EDITOR' visudo"
  alias vipw="sudo EDITOR='$EDITOR' vipw"
  alias vigr="sudo EDITOR='$EDITOR' vigr"
fi

if ! $isroot; then
  alias sudo="sudo "
  # sudo apps
  for app in \
    powertop nmap iptables arptables pwck grpck updatedb nmon
  do
    alias $app="sudo $app"
  done
  # sudo guis
  alias gparted='sudo -b gparted &>/dev/null'
  alias zenmap='sudo -b zenmap &>/dev/null'
else
  # root guis
  alias gparted='gparted &>/dev/null &'
  alias zenmap='zenmap &>/dev/null &'
fi
# }}}

# functions {{{
case "$TERM" in
  xterm-termite)
    . /etc/profile.d/vte.sh
    __vte_osc7
    ;;
  *-256color)
    alias ssh='TERM=${TERM%-256color} ssh'
    ;;
  *)
    POTENTIAL_TERM=${TERM}-256color
    POTENTIAL_TERMINFO=${TERM:0:1}/$POTENTIAL_TERM

    # better to check $(toe -a | awk '{print $1}') maybe?
    BOX_TERMINFO_DIR=/usr/share/terminfo
    [[ -f ${BOX_TERMINFO_DIR}/${POTENTIAL_TERMINFO} ]] && \
      export TERM=${POTENTIAL_TERM}

    HOME_TERMINFO_DIR=$HOME/.terminfo
    [[ -f ${HOME_TERMINFO_DIR}/${POTENTIAL_TERMINFO} ]] && \
      export TERM=${POTENTIAL_TERM}
    ;;
esac

# show_mod_parameters {{{
#
autoload show_mod_parameter_info
# }}}

# spectrum {{{
# And now that we've got our terminal sorted out - grabulating a
# 256 color terminal if at all possible, we can do that spectrum thang!
# Find out how many colors the terminal is capable of putting out.
# Color-related settings _must_ use this if they don't want to blow up on less
# endowed terminals.
C=$(tput colors)

autoload spectrum
if (( C == 256 )); then
  spectrum # Set up 256 color support.
else
  spectrum ${C} # Set up color support based on C
fi
# }}}

precmd() {
  update_title

  local vcs_info_msg_{0..1}_
  local -a whitelist_dirs
  local -a pwdsplit
  local dir
  local abort=1

  psvar[3]=('')
  psvar[4]=('')

  zstyle -a ':prompt:rbellamy:vcs:' whitelist-dirs whitelist_dirs
  if [[ -z ${whitelist_dirs} || ${_SHOWGITSTUFF} == 1 ]]; then
    abort=0
  else
    for dir in ${(s:/:)PWD}; do
      pwdsplit+=($pwdsplit[-1]/$dir)
    done
    [[ -n ${pwdsplit:*whitelist_dirs} ]] && abort=0
  fi

  [[ ${abort} == 1 ]] && return 0

  vcs_info prompt-rbellamy
  psvar[3]=${vcs_info_msg_0_}
  psvar[4]=${vcs_info_msg_1_}
}
# start ssh-agent
add_ssh_keys() {
  ssh-add ~/.ssh/id_rsa*~*.pub~*.ppk
}
start_ssh_agent() {
  if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
    add_ssh_keys
  fi
}
autoload start_ssh_agent

# history search - returns historical commands like
h() {
  if [ -z "$*" ]; then
    history -i 1;
  else
    history -i 1 | egrep --color=auto "$@";
  fi
}

# gitignore.io
function gi() { curl -L -s https://www.gitignore.io/api/"$@" ;}

function dc_trace_cmd() {
  local parent=`docker inspect -f '{{ .Parent }}' $1` 2>/dev/null
  declare -i level=$2
  echo ${level}: `docker inspect -f '{{ .ContainerConfig.Cmd }}' $1 2>/dev/null`
  level=level+1
  if [ "${parent}" != "" ]; then
    echo ${level}: $parent
    dc_trace_cmd $parent $level
  fi
}

compdefas() {
  local a
  a="$1"
  shift
  compdef "$_comps[$a]" "${(@)*}=$a"
}

# bg on empty line, push-input on non-empty line
fancy-ctrl-z() {
  if [[ $#BUFFER -eq 0 ]]; then
    bg
    zle redisplay
  else
    zle push-input
  fi
}
zle -N fancy-ctrl-z

# up-line-or-search with more than the first word
up-line-or-history-beginning-search-backward () {
  if [[ -n $PREBUFFER ]]; then
    zle up-line-or-history
  else
    zle history-beginning-search-backward
  fi
}
zle -N up-line-or-history-beginning-search-backward

# down-line-or-search with more than the first word
down-line-or-history-beginning-search-forward () {
  if [[ -n $PREBUFFER ]]; then
    zle down-line-or-history
  else
    zle history-beginning-search-forward
  fi
}
zle -N down-line-or-history-beginning-search-forward
# }}}

# zle keybindings (vim-like) {{{
# create a zkbd compatible hash;
# to add other keys to this hash, see man 5 terminfo
# vi editing mode
bindkey -v
# shift-tab
if [[ -n $terminfo[kcbt] ]]; then
  bindkey          "$terminfo[kcbt]"  reverse-menu-complete
fi
# do history expansion on space
bindkey            ' '                magic-space
# delete
if [[ -n $terminfo[kdch1] ]]; then
  bindkey          "$terminfo[kdch1]" delete-char
  bindkey -M vicmd "$terminfo[kdch1]" vi-delete-char
fi
# insert
if [[ -n $terminfo[kich1] ]]; then
  bindkey          "$terminfo[kich1]" overwrite-mode
  bindkey -M vicmd "$terminfo[kich1]" vi-insert
fi
# home
if [[ -n $terminfo[khome] ]]; then
  bindkey          "$terminfo[khome]" vi-beginning-of-line
  bindkey -M vicmd "$terminfo[khome]" vi-beginning-of-line
fi
# end
if [[ -n $terminfo[kend] ]]; then
  bindkey          "$terminfo[kend]"  vi-end-of-line
  bindkey -M vicmd "$terminfo[kend]"  vi-end-of-line
fi
# backspace (and <C-h>)
if [[ -n $terminfo[kbs] ]]; then
  bindkey          "$terminfo[kbs]"   backward-delete-char
  bindkey -M vicmd "$terminfo[kbs]"   backward-char
fi
bindkey            '^H'               backward-delete-char
bindkey -M vicmd   '^H'               backward-char
# page up (and <C-b> in vicmd)
if [[ -n $terminfo[kpp] ]]; then
  bindkey          "$terminfo[kpp]"   beginning-of-buffer-or-history
  bindkey -M vicmd "$terminfo[kpp]"   beginning-of-buffer-or-history
fi
bindkey -M vicmd   '^B'               beginning-of-buffer-or-history
# page down (and <C-f> in vicmd)
if [[ -n $terminfo[knp] ]]; then
  bindkey          "$terminfo[knp]"   end-of-buffer-or-history
  bindkey -M vicmd "$terminfo[knp]"   end-of-buffer-or-history
fi
bindkey -M vicmd   '^F'               end-of-buffer-or-history
# up arrow (history search)
if [[ -n $terminfo[kcuu1] ]]; then
  bindkey          "$terminfo[kcuu1]" up-line-or-history-beginning-search-backward
  bindkey -M vicmd "$terminfo[kcuu1]" up-line-or-history-beginning-search-backward
fi
# down arrow (history search)
if [[ -n $terminfo[kcud1] ]]; then
  bindkey          "$terminfo[kcud1]" down-line-or-history-beginning-search-forward
  bindkey -M vicmd "$terminfo[kcud1]" down-line-or-history-beginning-search-forward
fi
# left arrow (whichwrap)
if [[ -n $terminfo[kcub1] ]]; then
  bindkey          "$terminfo[kcub1]" backward-char
  bindkey -M vicmd "$terminfo[kcub1]" backward-char
fi
# right arrow (whichwrap)
if [[ -n $terminfo[kcuf1] ]]; then
  bindkey          "$terminfo[kcuf1]" forward-char
  bindkey -M vicmd "$terminfo[kcuf1]" forward-char
fi
# shift-left
if [[ -n $terminfo[kLFT] ]]; then
  bindkey          "$terminfo[kLFT]"  vi-backward-word
  bindkey -M vicmd "$terminfo[kLFT]"  vi-backward-word
fi
# shift-right
if [[ -n $terminfo[kRIT] ]]; then
  bindkey          "$terminfo[kRIT]"  vi-forward-word
  bindkey -M vicmd "$terminfo[kRIT]"  vi-forward-word
fi
# ctrl-left
bindkey            '^[[1;5D'          vi-backward-blank-word
# ctrl-right
bindkey            '^[[1;5C'          vi-forward-blank-word
# no vi-backward-kill-word
bindkey            '^W'               backward-kill-word
# h and l whichwrap
bindkey -M vicmd   'h'                backward-char
bindkey -M vicmd   'l'                forward-char
# incremental undo and redo
bindkey -M vicmd   '^R'               redo
bindkey -M vicmd   'u'                undo
# misc
bindkey -M vicmd   'ga'               what-cursor-position
# open in editor
bindkey -M vicmd   'v'                edit-command-line
# fancy <C-z>
bindkey            '^Z'               fancy-ctrl-z
bindkey -M vicmd   '^Z'               fancy-ctrl-z
# make zsh/terminfo work for terms with application and cursor modes
case "$TERM" in
  vte*|xterm*|screen*)
    zle-line-init() { zle-keymap-select; echoti smkx }
    zle-line-finish() { echoti rmkx }
    zle -N zle-line-init
    zle -N zle-line-finish
    ;;
esac
# }}}

# directory setup {{{
[ ! -d "$XDG_CACHE_HOME"/vim/swap ] && mkdir "$XDG_CACHE_HOME"/vim/swap
[ ! -d "$XDG_CACHE_HOME"/vim/backup ] && mkdir "$XDG_CACHE_HOME"/vim/backup
[ ! -d "$XDG_CACHE_HOME"/vim/undo ] && mkdir "$XDG_CACHE_HOME"/vim/undo
[ ! -d "$XDG_CONFIG_HOME"/vim/bundle ] && mkdir "$XDG_CONFIG_HOME"/vim/bundle
[ ! -d "$XDG_CONFIG_HOME"/pg ] && mkdir "$XDG_CONFIG_HOME"/pg
[ ! -d "$XDG_CACHE_HOME"/pg ] && mkdir "$XDG_CACHE_HOME"/pg
[ ! -d "$XDG_CONFIG_HOME"/R ] && mkdir "$XDG_CONFIG_HOME"/R
# }}}

# cleanup {{{
# these really should only be sourced during an interactive shell:
unset isroot app
# {{{
# de-dupe PATH
PATH="$HOME/.local/bin:$PATH"
PATH=$(printf "%s" "$PATH" | awk -v RS=':' '!a[$1]++ { if (NR > 1) printf RS; printf $1 }')
export PATH
# }}}
# }}}
