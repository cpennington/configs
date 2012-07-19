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
