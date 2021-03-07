#!/usr/bin/env zsh
# shellcheck shell=bash

# exit on any error or failed piped commands
set -eo pipefail

echo "Running zsh setup script..."

# setup zinit https://github.com/zdharma/zinit
if [[ ! -f "${HOME}/.zinit/bin/zinit.zsh" ]]; then
    echo "Installing zinit..."
    command mkdir -p "${HOME}/.zinit" && command chmod g-rwX "${HOME}/.zinit"
    # shellcheck disable=SC2015
    command git clone 'https://github.com/zdharma/zinit' "${HOME}/.zinit/bin"
fi

echo "Done settings up zsh"
