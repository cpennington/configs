# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/work
source /usr/local/bin/virtualenvwrapper.sh

alias go='workon'

export PATH=./.cabal-sandbox/bin:~/bin:~/.cabal/bin:~/utils/todo.txt-cli:$PATH
export EDITOR="subl --new-window --wait --command toggle_side_bar"
export LD_PRELOAD="/home/cpennington/utils/stderred/build/libstderred.so"
export AWS_CONFIG_FILE=~/.aws
export JSCOVER_JAR=~/work/util/jscover/target/dist/JSCover.jar
export VAGRANT_MOUNT_BASE=~/work

#source ~/.bash_prompt

(which opam > /dev/null) && eval $(opam config -env)

# source ~/utils/git/contrib/completion/git-prompt.sh

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# Change email to your onelogin email, usually {first inital}{last name}@edx.org
export ONELOGIN_EMAIL="cale@edx.org"

# Optional: Add the following to have your CLI prompt updated to show what account you've assumed
# This will update you propt to look like the following when you assume a role.
# (aws edx-tools-readonly Apr 06 17:52) $
# The time is when the role assumption session will expire
# Comment this out if you don't want your shell prompt modified
export UPDATE_PS1_ASSUME_ROLE=true

source ~/work/edx-internal/scripts/assume-role-onelogin.sh


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# added by travis gem
source /home/cpennington/.travis/travis.sh


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
