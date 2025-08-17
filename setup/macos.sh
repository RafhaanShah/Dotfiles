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

echo "Running MacOS setup script..."

# iterm2 config
echo "Copying iTerm2 config..."
defaults write com.googlecode.iterm2 PrefsCustomFolder "${DOTFILE_DIR}/config/iTerm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# TextMate config
echo "Copying TextMate config..."
ln -s "${DOTFILE_DIR}/config/TextMate/.tm_properties" "${HOME}/.tm_properties"

# Keyboard layouts
echo "Copying Keyboard Layouts..."
KEYBOARD_LAYOUTS="${HOME}/Library/Keyboard Layouts/"
mkdir -p "${KEYBOARD_LAYOUTS}"
cp "${DOTFILE_DIR}/config/KeyboardLayouts/." "${KEYBOARD_LAYOUTS}"
