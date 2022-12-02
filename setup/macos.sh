#!/usr/bin/env zsh
# shellcheck shell=bash

# exit on any error or failed piped commands
set -eo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../shell/helpers.sh
source "${DOTFILE_DIR}/shell/helpers.sh"

if ! _is_macos; then
    echo "This is only for macOS"
    exit
fi

if ! _command_exists "brew"; then
    echo "Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# brew packages
echo "Installing brew packages..."
brew analytics off
brew bundle --file "${DOTFILE_DIR}/packages/brew.txt"

# npm packages
echo "Installing npm packages..."
npm config set prefix "${HOME}/.npm-global"
xargs <"${DOTFILE_DIR}/packages/npm.txt" npm install -g

# pip packages
echo "Installing pip packages..."
xargs <"${DOTFILE_DIR}/packages/pip.txt" pip3 install --upgrade

# other scripts
# shellcheck source=others.sh
source "${DOTFILE_DIR}/setup/others.sh"

# zsh setup
# shellcheck source=zsh.sh
source "${DOTFILE_DIR}/setup/zsh.sh"

# iterm2 config
defaults write com.googlecode.iterm2 PrefsCustomFolder "${DOTFILE_DIR}/config/iTerm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# TextMate config
ln -s "${DOTFILE_DIR}/config/TextMate/.tm_properties" "${HOME}/.tm_properties"

# set shell
echo "Changing shell..."
command -v zsh | sudo tee -a /etc/shells
chsh -s "$(command -v zsh)"
