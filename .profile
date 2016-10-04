# ~/.profile
#(( $UID == 0 )) && umask=0022 || umask=0027

# constant environment variables
export PATH="$HOME"/.local/bin:$PATH
export PLATFORM=$(uname -s)

# JAVA_OPTIONS
[[ "$PLATFORM" == "Darwin" ]] && JHOME=$(/usr/libexec/java_home) || JHOME=/usr/lib/jvm/default
export JAVA_HOME="$JHOME"
# IntelliJ IDEA JDK
[[ "$PLATFORM" == "Linux" ]] && export IDEA_JDK="/usr/lib/jvm/java-8-openjdk"
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

# default editor - visual and terminal
export EDITOR=vim
export VISUAL=vim

# less is more
export PAGER=less
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

[[ -d /opt/maven ]] && export M2_HOME=/opt/maven
[[ -d /usr/local/Cellar/maven/3.3.3/libexec ]] && export M2_HOME=/usr/local/Cellar/maven/3.3.3/libexec
[[ -f /usr/local/Oracle/product/instantclient/11.2.0.4.0/share/instantclient/instantclient.sh ]] && source /usr/local/Oracle/product/instantclient/11.2.0.4.0/share/instantclient/instantclient.sh
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion
