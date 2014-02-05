#! /bin/bash

alias ack='ack-grep'
alias ssh='TERM=xterm ssh'
alias gsd='sudo ~/utils/get-shit-done/get-shit-done.sh'

function mkmod() {
    mkdir -p "$1/files" "$1/lib" "$1/manifests" "$1/templates" "$1/tests"
}

alias gfi='git flow init'
alias gff='git flow feature'
alias gfr='git flow release'
alias gfh='git flow hotfix'
alias gfs='git flow support'

alias runcms='cd ~/work/mitx && go mitx && rake cms'
alias runlms='cd ~/work/mitx && go mitx && rake lms'

function aws-cfg() {
    export BOTO_PATH="/etc/boto.cfg:~/.boto_cfg/$1.cfg"
    export AWS_DEFAULT_PROFILE="$1"
}

source ~/utils/git/contrib/completion/git-completion.bash

alias git=hub
alias g=hub

__git_complete g __git_main

export TODOTXT_DEFAULT_ACTION=ls
export TODOTXT_SORT_COMMAND='env LC_COLLATE=C sort -k 2,2 -k 1,1n'
alias t="~/utils/todo.txt-cli/todo.sh -d ~/.todo.cfg"

alias o="subl"
alias e="$EDITOR"
alias se="sudo vim"
