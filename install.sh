#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# Copy files to ~ folder
cp .bash_profile ~/.bash_profile
cp .gitconfig ~/.gitconfig
cp .hyper.js ~/.hyper.js
cp .zshrc ~/.zshrc

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
npm i -g typescript
npm i -g ts-node

# Link VSCode settings
rm ~/Library/Application\ Support/Code/User/settings.json
ln -s ~/dotfiles/vscode.json ~/Library/Application\ Support/Code/User/settings.json

# VSCode plugins
code --install-extension wesbos.theme-cobalt2
code --install-extension tinkertrain.theme-panda
code --install-extension eamodio.gitlens
code --install-extension be5invis.vscode-custom-css
code --install-extension dbaeumer.vscode-eslint

# MacOS settings
source ./.macos;