#!/usr/bin/env bash

# exit on any error or failed piped commands
set -eo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../shell/helpers.sh
source "${DOTFILE_DIR}/shell/helpers.sh"

setup_gpg() {
    echo "Setting up GPG..."
    if _is_mingw; then
        local GPG_DIR="${APPDATA}/gnupg/"
        mkdir -p "${GPG_DIR}"
        cp "${DOTFILE_DIR}/config/gpg/gpg-agent.conf" "${GPG_DIR}/gpg-agent.conf"
        return
    fi

    if _is_wsl; then
        local GPG_DIR
        GPG_DIR="$(wslpath "$(wslvar "APPDATA")")/gnupg"
        mkdir -p "${GPG_DIR}"
        cp "${DOTFILE_DIR}/config/gpg/gpg-agent.conf" "${GPG_DIR}/gpg-agent.conf"
    fi

    mkdir -p "${HOME}/.gnupg"
    if _is_macos; then
        cp "${DOTFILE_DIR}/config/gpg/gnupg/gpg-agent.conf" "${HOME}/.gnupg/gpg-agent.conf"
    else
        cp "${DOTFILE_DIR}/config/gpg/gnupg/headless-gpg-agent.conf" "${HOME}/.gnupg/gpg-agent.conf"
    fi
    echo "Done settings up GPG"
}

echo "Running config setup script..."

setup_gpg

echo "Done settings up configs"
