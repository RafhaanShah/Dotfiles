#!/usr/bin/env bash

# exit on any error or failed piped commands
set -eo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../shell/helpers.sh
source "${DOTFILE_DIR}/shell/helpers.sh"

echo "Running WSL setup script..."

if ! _is_wsl; then
    echo "This is only for WSL"
    exit
fi

# https://github.com/nullpo-head/WSL-Hello-sudo
setup_wsl_hello_sudo() {
    echo "Running WSL Hello sudo setup..."
    curl -sSL "http://github.com/nullpo-head/WSL-Hello-sudo/releases/latest/download/release.tar.gz" -o "release.tar.gz"
    tar xvf "release.tar.gz"
    (cd "release" && "./install.sh")
    rm -rf "release" "release.tar.gz"
}

setup_wsl_hello_sudo

echo "Done settings up WSL"
