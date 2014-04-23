# ~/.config/zsh/.zprofile

# set a secure mask
umask 077

# constant environment variables
export PATH="$HOME"/.local/bin:$PATH

# JAVA_OPTIONS
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

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
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/settings.ini

export XAUTHORITY="$XDG_RUNTIME_DIR"/X11-authority

# default editor - visual and terminal
export EDITOR=vim
export VISUAL=vim

# less is more
export PAGER=less
export LESSHISTFILE="$XDG_CACHE_HOME"/lesshist

# highest compression
export GZIP=-9 \
  BZIP=-9 \
  XZ_OPT=-9

# browser depends on terminal or X
if [[ -n $DISPLAY ]]; then
    export BROWSER=chrome
  else
    export BROWSER=elinks
fi
#export TERMINAL=termite

# colored grep
export GREP_OPTIONS=--color=auto
# correct colored less - use ANSI-only raw control characters
export LESS=-R

# Simple DirectMedia Layer default sound backend - used for Valve and Steam
export SDL_AUDIODRIVER=pulse

# draw lines whether in UTF8 or not
export NCURSES_NO_UTF8_ACS=1

# colors
eval $(dircolors -b ~/.config/dircolors-solarized/dircolors.256dark)

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
