#!/data/data/com.termux/files/usr/bin/env bash
# shellcheck shell=bash

# exit on any error or failed piped commands
set -eo pipefail

echo "Running termux setup script..."

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../shell/helpers.sh
source "${DOTFILE_DIR}/shell/helpers.sh"

if ! _is_termux; then
    echo "This is only for Termux"
    exit 1
fi

mkdir -p "${HOME}/.termux"
ln -s "${DOTFILE_DIR}/config/termux/termux.properties" "${HOME}/.termux"
ln -s "${DOTFILE_DIR}/config/termux/colors.properties" "${HOME}/.termux"

# install termux packages
pkg upgrade
xargs <"${DOTFILE_DIR}/packages/termux.txt" pkg install -y
pkg clean

# https://wiki.termux.com/wiki/Termux-setup-storage
termux-setup-storage

# setup nodejs
mkdir -p "${HOME}/.npm-global/bin"
npm config set prefix "${HOME}/.npm-global"
# shellcheck disable=SC2218
_add_to_path "${HOME}/.npm-global/bin"

xargs <"${DOTFILE_DIR}/packages/npm.txt" npm install -g

# zsh setup
# shellcheck source=zsh.sh
source "${DOTFILE_DIR}/setup/zsh.sh"

# set shell
echo "Changing shell..."
chsh -s "zsh"

echo "Done setting up termux"

# intial ssh setup instructions:
# pkg install openssh
# passwd
# sshd
# ssh -p 8022 TERMUX_IP
