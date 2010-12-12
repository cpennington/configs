# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

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
#force_colored_prompt=yes

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

#if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
#unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
#    ;;
#*)
#    ;;
#esac
[[ $- == *i* ]]   &&   . /home/cpenning/work/3p/git-prompt/git-prompt.sh

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

function assh {
    hostname=$1
    shift
    
    if [[ $hostname == aad[0-9]* ]]; then
        /usr/bin/ssh `echo $hostname | sed 's/aad/arisappdev/' | sed 's/$/.aris.wgenhq.net/'` $@
    elif [[ $hostname == add[0-9]* ]]; then
        /usr/bin/ssh `echo $hostname | sed 's/add/arisdatadev/' | sed 's/$/.aris.wgenhq.net/'` $@
    elif [[ $hostname == doe[0-9]* ]]; then
        /usr/bin/ssh `echo $hostname | sed 's/doe/10.154.0./'` $@
    elif [[ $hostname == doh[0-9]* ]]; then
        /usr/bin/ssh `echo $hostname | sed 's/doh/10.101.1./'` $@
    elif [[ $hostname == dot[0-9]* ]]; then
        /usr/bin/ssh `echo $hostname | sed 's/dot/10.110.0./'` $@
    else
        /usr/bin/ssh $hostname $@
    fi
}

export CVSROOT=:pserver:cpennington@repository.wgenhq.net:2401/home/cvs/repository 

alias rvim='gvim --remote'
alias ack='ack-grep'
alias dsup='dtach -A ~/.dtach/sup sup'
alias dirssi='dtach -A ~/.dtach/irssi irssi'

export EDITOR='vim'
export JAVA_HOME=/usr/lib/jvm/default-java

export PATH=/var/lib/gems/1.8/bin:~/.cabal/bin:$PATH
export SUP_INDEX=xapian
export _JAVA_AWT_WM_NONREPARENTING=1 
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/xulrunner-`xulrunner-1.9.2 --gre-version`

source ~/.cabal/share/compleat-1.0/compleat_setup
source ~/work/z/z.sh

source /etc/profile
