#!/bin/bash

# Ask for the administrator password upfront
sudo -v

source bootstrap.sh;

# install homebrew
if ! command -v brew &> /dev/null; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
brew tap homebrew/bundle
brew bundle

# install zsh
if ! command -v zsh &> /dev/null; then
    brew install zsh
    brew install zsh-completions
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# NPM
npm install -g grunt-cli

# git credentials
git-credential-manager install

# Link VSCode settings
rm ~/Library/Application\ Support/Code/User/settings.json
ln -s ~/dotfiles/vscode.json ~/Library/Application\ Support/Code/User/settings.json

# VSCode plugins
code --install-extension wesbos.theme-cobalt2
code --install-extension yzhang.markdown-all-in-one
code --install-extension eamodio.gitlens
code --install-extension PeterJausovec.vscode-docker

# MacOS settings
source ./.macos;