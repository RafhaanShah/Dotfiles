#!/usr/bin/env bash

# exit on any error or failed piped commands
set -eo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../shell/helpers.sh
source "${DOTFILE_DIR}/shell/helpers.sh"

echo "Running linux setup script..."

if ! _is_linux; then
    echo "This is only for Linux"
    exit
fi

# apt packages
echo "Installing apt packages..."
export DEBIAN_FRONTEND=noninteractive
sudo apt update && sudo apt upgrade -y
xargs <"${DOTFILE_DIR}/packages/apt.txt" sudo apt install -y
sudo apt autoremove -y
unset DEBIAN_FRONTEND

# snap packages
if _command_exists "snap" && ! _is_wsl; then
    xargs <"${DOTFILE_DIR}/packages/snap.txt" sudo snap install
fi

# npm packages
echo "Installing npm packages..."
# https://github.com/nodesource/distributions#debinstall
curl -sSL 'https://deb.nodesource.com/setup_21.x' | sudo -E bash -
sudo apt install -y nodejs
mkdir -p "${HOME}/.npm-global/bin"
npm config set prefix "${HOME}/.npm-global"
_add_to_path "${HOME}/.npm-global/bin"

xargs <"${DOTFILE_DIR}/packages/npm.txt" npm install -g

# pip packages
echo "Installing pip packages..."
xargs <"${DOTFILE_DIR}/packages/pip.txt" pip3 install --upgrade

install_deb() {
    local app="${1##*/}"
    echo "Installing ${app}..."
    curl -sSL "$1" -o "${HOME}/${app}" --fail || {
        echo "Failed to download ${app}"
        return
    }
    sudo dpkg -i "${HOME}/${app}" || echo "Failed to install ${app}"
    rm "${HOME}/${app}"
}

get_repo_deb() {
    echo "Getting latest version of ${1}..."
    local api="https://api.github.com/repos/${1}/releases/latest"
    local ver
    ver=$(curl -s "${api}" --fail) || {
        echo "Failed to get ${1}"
        return
    }
    ver=$(echo "$ver" | fx .name)

    local app="${1##*/}_${ver/v/}_${arch}.deb"
    local url="https://github.com/${1}/releases/download/${ver}/${app}"
    install_deb "${url}"
}

arch=$(dpkg --print-architecture) # amd64 / armhf...
# os=$(uname -s) # Linux / Darwin
# instr=$(uname -m) # x86_64 / armv71...

while read -r line; do
    if [ -n "$line" ]; then
        get_repo_deb "$line" || echo "Something went wrong installing ${line}"
    fi
done <"${DOTFILE_DIR}/packages/deb.txt"

# shellcheck source=linux-etc.sh
source "${DOTFILE_DIR}/setup/linux-etc.sh"

# other scripts
# shellcheck source=others.sh
source "${DOTFILE_DIR}/setup/others.sh"

# zsh setup
# shellcheck source=zsh.sh
source "${DOTFILE_DIR}/setup/zsh.sh"

# set shell
echo "Changing shell..."
chsh -s "$(command -v zsh)"

echo "Done setting up linux"
