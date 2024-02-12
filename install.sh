#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# install homebrew
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew tap homebrew/bundle
brew bundle

# install zsh
if ! command -v zsh &> /dev/null; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# NPM
npm i -g typescript
npm i -g ts-node

# Link VSCode settings
rm ~/Library/Application\ Support/Code/User/settings.json

# Copy files to ~ folder
stow .

# VSCode plugins
code --install-extension eamodio.gitlens
code --install-extension be5invis.vscode-custom-css
code --install-extension dbaeumer.vscode-eslint
code --install-extension catppuccin.catppuccin-vsc
code --install-extension catppuccin.catppuccin-vsc-icons
code --install-extension github.github-vscode-theme
code --install-extension ms-python.black-formatter
code --install-extension ms-python.debugpy
code --install-extension ms-python.isort
code --install-extension ms-python.python
code --install-extension redhat.vscode-yaml
code --install-extension vincaslt.highlight-matching-tag
code --install-extension visualstudioexptteam.vscodeintellicode

# MacOS settings
source ./.macos;