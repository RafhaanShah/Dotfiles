#!/usr/bin/env bash

# exit on any error or failed piped commands
set -eo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../helpers.sh
source "${DOTFILE_DIR}/helpers.sh"

setup_gpg() {
    echo "Setting up GPG..."
    if _is_mingw; then
        local GPG_DIR="${APPDATA}/gnupg/"
        mkdir -p "${GPG_DIR}"
        cp "${DOTFILE_DIR}/config/gpg/windows-gpg-agent.conf" "${GPG_DIR}/gpg-agent.conf"
        return
    fi
    
    if _is_wsl; then
        local GPG_DIR="$(wslpath $(wslvar "APPDATA"))/gnupg"
        mkdir -p "${GPG_DIR}"
        cp "${DOTFILE_DIR}/config/gpg/windows-gpg-agent.conf" "${GPG_DIR}/gpg-agent.conf"
    fi
    
    mkdir -p "${HOME}/.gnupg"
    cp "${DOTFILE_DIR}/config/gpg/gnupg/gpg-agent.conf" "${HOME}/.gnupg/gpg-agent.conf"
}

setup_gpg
