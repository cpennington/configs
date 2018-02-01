if not status --is-interactive
    exit
end

# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish

# Theme
set fish_theme vengefulpickle

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-fish/plugins/*)
# Custom plugins may be added to ~/.oh-my-fish/custom/plugins/
# Example format: set fish_plugins autojump bundler

# Path to your custom folder (default path is $FISH/custom)
#set fish_custom $HOME/dotfiles/oh-my-fish

# Load oh-my-fish configuration.
. $fish_path/oh-my-fish.fish

# Base16 Shell
# eval sh $HOME/utils/base16-shell/scripts/base16-brewer.sh

. $HOME/utils/virtualfish/virtual.fish
. $HOME/utils/virtualfish/auto_activation.fish
. $HOME/utils/virtualfish/projects.fish

. $HOME/.config/fish/aliases.fish

set PATH ~/bin $PATH
set PATH ~/.local/bin $PATH
set PATH ./.cabal-sandbox/bin $PATH
set PATH ~/utils/todo.txt-cli $PATH
set PATH ~/.go/bin $PATH

set -xU EDITOR vim
set -xU AWS_CONFIG_FILE ~/.aws
set -xU JSCOVER_JAR ~/work/util/jscover/target/dist/JSCover.jar
set -xU PROJECT_HOME ~/work
set -xU SELENIUM_BROWSER chrome
set -xU GOPATH ~/.go

set -x PATH "/home/cpennington/.pyenv/bin" $PATH
status --is-interactive; and . (pyenv init -|psub)
status --is-interactive; and . (pyenv virtualenv-init -|psub)
