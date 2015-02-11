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

. $HOME/utils/virtualfish/virtual.fish
. $HOME/utils/virtualfish/auto_activation.fish
. $HOME/utils/virtualfish/projects.fish

set PATH ~/bin $PATH
set PATH ~/.cabal/bin $PATH
set PATH ./.cabal-sandbox/bin $PATH
set PATH ~/utils/todo.txt-cli $PATH
set PATH ~/.rbenv/bin $PATH

set -xU EDITOR "subl --new-window --wait --command toggle_side_bar"
set -xU AWS_CONFIG_FILE ~/.aws
set -xU JSCOVER_JAR ~/work/util/jscover/target/dist/JSCover.jar
set -xU VAGRANT_MOUNT_BASE ~/work
set -xU PROJECT_HOME ~/work
set -xU SELENIUM_BROWSER chrome

set -gx RBENV_ROOT ~/.rbenv
. (rbenv init -|psub)
