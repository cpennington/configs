if not status --is-interactive
    exit
end

# Theme
set fish_theme vengefulpickle

# Base16 Shell
# eval sh $HOME/utils/base16-shell/scripts/base16-brewer.sh

eval (python -m virtualfish auto_activation projects) 

. $HOME/.config/fish/aliases.fish

set PATH ~/bin $PATH
set PATH ~/.local/bin $PATH
set PATH ./.cabal-sandbox/bin $PATH

set -xU EDITOR vim
set -xU AWS_CONFIG_FILE ~/.aws
set -xU JSCOVER_JAR ~/work/util/jscover/target/dist/JSCover.jar
set -xU PROJECT_HOME ~/work
set -xU SELENIUM_BROWSER chrome
set -xU GOPATH ~/.go

set -x PATH "/home/cpennington/.pyenv/bin" $PATH
status --is-interactive; and . (pyenv init -|psub)
status --is-interactive; and . (pyenv virtualenv-init -|psub)
