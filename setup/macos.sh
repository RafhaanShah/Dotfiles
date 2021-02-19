#!/usr/bin/env zsh
# shellcheck shell=bash

# exit on any error
set -e

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../.helpers
source "${DOTFILE_DIR}/.helpers"

if ! _is_macos; then
    echo "This is only for macOS"
    exit
fi

if ! _command_exists "brew"; then
    echo "Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# brew packages
echo "Installing brew packages..."
brew bundle --file "${DOTFILE_DIR}/packages/brew.txt"

# npm packages
echo "Installing npm packages..."
npm config set prefix "${HOME}/.npm-global"
< "${DOTFILE_DIR}/packages/npm.txt" xargs npm install -g

# pip packages
echo "Installing pip packages..."
< "${DOTFILE_DIR}/packages/pip.txt" xargs pip3 install --upgrade

# other scripts
# shellcheck source=others.sh
source "${DOTFILE_DIR}/setup/others.sh"

# zsh setup
# shellcheck source=zsh.sh
source "${DOTFILE_DIR}/setup/zsh.sh"

# set shell
echo "Changing shell..."
chsh -s "$(which zsh)"
