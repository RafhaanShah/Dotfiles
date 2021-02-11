#!/usr/bin/env bash

# exit on any error
set -e

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
source "${DOTFILE_DIR}/.helpers"

if ! _is_macos; then
    echo "This is only for macOS"
    exit
fi

if ! _command_exists "brew"; then
    echo "Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing brew packages..."

brew bundle --file "${DOTFILE_DIR}/packages/Brewfile"

chsh -s "$(which zsh)"

echo "Done"
