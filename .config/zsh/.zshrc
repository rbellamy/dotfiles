# update the function path {{{
if [[ -d "/usr/local/share/zsh-completions" ]] then
  fpath=(~/.config/zsh/functions "/usr/local/share/zsh-completions" $fpath)
else
  fpath=(~/.config/zsh/functions $fpath)
fi
# }}}

# checks {{{
(( $UID == 0 )) && isroot=true || isroot=false
# test if command is available
have() { which $1 &>/dev/null || return 1 }
# }}}

# modules {{{
autoload -U compinit edit-command-line vcs_info zmv bashcompinit
compinit
bashcompinit
zle -N edit-command-line
zmodload zsh/complist
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
  PROMPT='%U%B%F{white}%D{%Y-%m-%d %T}%f%b%u
%K{088}%n@%m%k %F{magenta}${vimode}%f %B%F{cyan}%~%f%b %F{green}%3v%f%B%F{white}%# %f%b'
else
  PROMPT='%U%B%F{white}%D{%Y-%m-%d %T}%f%b%u
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
alias grep="grep --color=auto"
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
alias sprunge="curl -F 'sprunge=<-' sprunge.us"
have hub && alias git=hub
# pacman
have pacmatic && alias pacman=pacmatic && export PACMAN=/usr/bin/pacmatic
have apacman && alias apacman="apacman --noedit --noconfirm"

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

# history search - returns historical commands like
h() {
  if [ -z "$*" ]; then
    history -i 1;
  else
    history -i 1 | egrep "$@";
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
# make zsh/terminfo work for terms with application and cursor modes
case "$TERM" in
  vte*|xterm*)
    zle-line-init() { zle-keymap-select; echoti smkx }
    zle-line-finish() { echoti rmkx }
    zle -N zle-line-init
    zle -N zle-line-finish
    ;;
esac
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
# }}}

# directory setup {{{
[ ! -d "$XDG_CACHE_HOME"/vim/swap ] && mkdir "$XDG_CACHE_HOME"/vim/swap
[ ! -d "$XDG_CACHE_HOME"/vim/backup ] && mkdir "$XDG_CACHE_HOME"/vim/backup
[ ! -d "$XDG_CACHE_HOME"/vim/undo ] && mkdir "$XDG_CACHE_HOME"/vim/undo
[ ! -d "$XDG_CONFIG_HOME"/vim/bundle ] && mkdir "$XDG_CONFIG_HOME"/vim/bundle
# }}}

# cleanup {{{
unset isroot app
# }}}
