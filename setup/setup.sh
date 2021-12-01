#!/usr/bin/env bash

# exit on any error or failed piped commands
set -eo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"

echo "Running setup script..."

[ ! -d "${DOTFILE_DIR}" ] && git clone 'https://github.com/RafhaanShah/Dotfiles' "${DOTFILE_DIR}"

# shellcheck source=../shell/helpers.sh
source "${DOTFILE_DIR}/shell/helpers.sh"

# dotfiles
# shellcheck source=dotfiles.sh
source "${DOTFILE_DIR}/setup/dotfiles.sh"

# macos

# termux

# linux (not termux)

# configs
# shellcheck source=configs.sh
source "${DOTFILE_DIR}/setup/configs.sh"

# gitconfig
# shellcheck source=gitconfig.sh
source "${DOTFILE_DIR}/setup/gitconfig.sh"

# fonts
# shellcheck source=fonts.sh
source "${DOTFILE_DIR}/setup/fonts.sh"

# other scripts
# shellcheck source=others.sh
source "${DOTFILE_DIR}/setup/others.sh"

# bash setup
# shellcheck source=bash.sh
source "${DOTFILE_DIR}/setup/bash.sh"

# zsh setup
# shellcheck source=zsh.sh
source "${DOTFILE_DIR}/setup/zsh.sh"

# set shell
echo "Changing shell..."
chsh -s "$(command -v zsh)"

echo "Finished setup"
