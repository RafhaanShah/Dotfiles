#!/usr/bin/env zsh
# shellcheck shell=bash

# exit on any error or failed piped commands
set -eo pipefail

echo "Running zsh setup script..."

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../shell/helpers.sh
source "${DOTFILE_DIR}/shell/helpers.sh"

# setup zinit https://github.com/zdharma/zinit
if [[ ! -f "${HOME}/.zinit/bin/zinit.zsh" ]]; then
    echo "Installing zinit..."
    command mkdir -p "${HOME}/.zinit" && command chmod g-rwX "${HOME}/.zinit"
    # shellcheck disable=SC2015
    command git clone 'https://github.com/zdharma-continuum/zinit' "${HOME}/.zinit/bin"
fi

# set shell
if _prompt_yes_no "Set zsh as shell? [y/N]"; then
    echo "Changing shell..."
    command -v zsh | sudo tee -a /etc/shells
    chsh -s "$(command -v zsh)"
fi

echo "Done settings up zsh"
