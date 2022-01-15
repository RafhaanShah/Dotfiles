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
curl -sSL 'https://deb.nodesource.com/setup_17.x' | sudo -E bash -
sudo apt install -y nodejs
mkdir -p "${HOME}/.npm-global/bin"
npm config set prefix "${HOME}/.npm-global"
_add_to_path "${HOME}/.npm-global/bin"

xargs <"${DOTFILE_DIR}/packages/npm-linux.txt" npm install -g
xargs <"${DOTFILE_DIR}/packages/npm.txt" npm install -g

# pip packages
echo "Installing pip packages..."
xargs <"${DOTFILE_DIR}/packages/pip-linux.txt" pip3 install --upgrade
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

# git credential manager
# https://github.com/microsoft/Git-Credential-Manager-Core
install_deb 'https://github.com/GitCredentialManager/git-credential-manager/releases/download/v2.0.632/gcmcore-linux_amd64.2.0.632.34631.deb'

# asdf: language version manager
# https://github.com/asdf-vm/asdf
if [ ! -d "${HOME}/.asdf" ]; then
    git clone 'https://github.com/asdf-vm/asdf.git' "${HOME}/.asdf" --branch 'v0.8.0'
else
    # shellcheck source=/dev/null
    source "${HOME}/.asdf/asdf.sh" && asdf update
fi

# fff: file manager
# https://github.com/dylanaraps/fff
[ ! -d "/tmp/fff" ] && git clone 'https://github.com/dylanaraps/fff.git' "/tmp/fff"
(cd "/tmp/fff" && sudo make install)
rm -rf "/tmp/fff"

# lazygit: git ui
# https://github.com/jesseduffield/lazygit
sudo add-apt-repository ppa:lazygit-team/release -y
sudo apt update && sudo apt install lazygit

# lazydocker: docker ui
# https://github.com/jesseduffield/lazydocker
curl 'https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh' | bash

# micro: better nano
curl 'https://getmic.ro' | bash
sudo mv micro "/usr/bin"

# docker: app containers
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# sudo apt-getupdate && sudo apt-get install -y docker-ce docker-ce-cli containerd.io
# sudo groupadd docker && sudo usermod -aG docker $USER && newgrp docker
# sudo curl -L "https://github.com/docker/compose/releases/download/$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | fx .name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# sudo chmod +x "/usr/local/bin/docker-compose"

# hack nerd font, patched with glyphs
# https://github.com/ryanoasis/nerd-fonts
# mkdir -p "${HOME}/.local/share/fonts"
# curl -L "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf" -o "${HOME}/.local/share/fonts/Hack-Nerd-Mono.tff"

# path picker: apply commands on files
# https://github.com/facebook/PathPicker
if [ ! -d "/usr/local/pathpicker" ]; then
    sudo git clone "https://github.com/facebook/PathPicker.git" "/usr/local/pathpicker"
    sudo ln -s "/usr/local/pathpicker/fpp" "/usr/local/bin/fpp"
else
    sudo git -C "/usr/local/pathpicker" pull
fi

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
