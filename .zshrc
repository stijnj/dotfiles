export ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

alias chromenocors='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir="$HOME/tmp/james_bonds_browser" --disable-web-security -h &'

eval "$(rbenv init -)"
. /usr/local/opt/asdf/libexec/asdf.sh

export ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

export STARSHIP_CONFIG=~/dotfiles/starship.toml
eval "$(starship init zsh)"
