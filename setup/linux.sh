#!/usr/bin/env bash

# exit on any error, unset variable, or failed piped commands
set -euo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
source "${DOTFILE_DIR}/.helpers"

# apt packages
echo "Installing apt packages..."
sudo apt update && sudo apt upgrade -y
< "${DOTFILE_DIR}/packages/apt.txt" xargs sudo apt install -y
sudo apt autoremove

# npm packages
echo "Installing npm packages..."
# https://github.com/nodesource/distributions#debinstall
curl -sSL "https://deb.nodesource.com/setup_15.x" | sudo -E bash -
sudo apt install -y nodejs && npm config set prefix '~/.npm-global'

< "${DOTFILE_DIR}/packages/npm-linux.txt" xargs npm install -g
< "${DOTFILE_DIR}/packages/npm.txt" xargs npm install -g

# pip packages
echo "Installing pip packages..."
< "${DOTFILE_DIR}/packages/pip-linux.txt" pip3 install --upgrade
< "${DOTFILE_DIR}/packages/pip.txt" pip3 install --upgrade

# function to download and install a deb
install_deb() {
    echo "Installing ${1##*/}..."
    curl -sSL "$1" -o "${HOME}/app.deb"
    sudo dpkg -i "${HOME}/app.deb"
    rm "${HOME}/app.deb"
}

# bat: better cat
# https://github.com/sharkdp/bat
install_deb "https://github.com/sharkdp/bat/releases/download/v0.17.1/bat-musl_0.17.1_amd64.deb"

# fd: better find
# https://github.com/sharkdp/fd
install_deb "https://github.com/sharkdp/fd/releases/download/v8.2.1/fd_8.2.1_amd64.deb"

# googler: google on the cli
# https://github.com/jarun/googler
install_deb "https://github.com/jarun/googler/releases/download/v4.3.2/googler_4.3.2-1_ubuntu20.04.amd64.deb"

# git credential manager
# https://github.com/microsoft/Git-Credential-Manager-Core
install_deb "https://github.com/microsoft/Git-Credential-Manager-Core/releases/download/v2.0.318-beta/gcmcore-linux_amd64.2.0.318.44100.deb"

# lsd: better ls
# https://github.com/Peltoche/lsd
install_deb "https://github.com/Peltoche/lsd/releases/download/0.19.0/lsd_0.19.0_amd64.deb"

# ripgrep: better grep
# https://github.com/burntsushi/ripgrep
install_deb "https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb"

# vivid: generate LS_COLORS
# https://github.com/sharkdp/vivid
install_deb "https://github.com/sharkdp/vivid/releases/download/v0.6.0/vivid_0.6.0_amd64.deb"

# asdf: language version manager
# https://github.com/asdf-vm/asdf
[ ! -d "${HOME}/.asdf" ] && git clone https://github.com/asdf-vm/asdf.git "${HOME}/.asdf" --branch v0.8.0

# fff: file manager
# https://github.com/dylanaraps/fff
git clone https://github.com/dylanaraps/fff.git "${HOME}/fff"
(cd "${HOME}/fff" && sudo make install)
rm -rf "${HOME}/fff"

# lazygit: git ui
# https://github.com/jesseduffield/lazygit
sudo add-apt-repository ppa:lazygit-team/release
sudo apt update && sudo apt install lazygit

# lazydocker: docker ui
# https://github.com/jesseduffield/lazydocker
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# lolcat: taste the rainbow
# https://github.com/busyloop/lolcat
sudo snap install lolcat

# docker: app containers
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# sudo apt-getupdate && sudo apt-get install -y docker-ce docker-ce-cli containerd.io
# sudo groupadd docker && sudo usermod -aG docker $USER && newgrp docker
sudo curl -L "https://github.com/docker/compose/releases/download/$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | fx .name)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# hack nerd font, patched with glyphs
# https://github.com/ryanoasis/nerd-fonts
mkdir -p "${HOME}/.local/share/fonts"
curl -L "https://github.com/ryanoasis/nerd-fonhttps://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete%20Mono.ttf" -o "${HOME}/.local/share/fonts/Hack-Nerd-Mono.tff"

# path picker: apply commands on files
# https://github.com/facebook/PathPicker
sudo git clone "https://github.com/facebook/PathPicker.git" "/usr/local/pathpicker"
sudo ln -s "/usr/local/pathpicker/fpp" "/usr/local/bin/fpp"

# zoxide: better cd
# https://github.com/ajeetdsouza/zoxide
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/ajeetdsouza/zoxide/master/install.sh | sh

# other scripts
source "${DOTFILE_DIR}/.setup/others.sh"

# set zsh as default shell
echo "Changing shell..."
chsh -s $(which zsh)
