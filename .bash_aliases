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

