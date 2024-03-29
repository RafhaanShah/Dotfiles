#!/usr/bin/env bash

# exit on any error or failed piped commands
set -eo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../shell/helpers.sh
source "${DOTFILE_DIR}/shell/helpers.sh"

echo "Installing linux extra packages"

if ! _is_linux; then
    echo "This is only for Linux"
    exit
fi

# git credential manager
# https://github.com/git-ecosystem/git-credential-manager
install_deb 'https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.4.1/gcm-linux_amd64.2.4.1.deb'

# asdf: language version manager
# https://github.com/asdf-vm/asdf
if [ ! -d "${HOME}/.asdf" ]; then
    git clone 'https://github.com/asdf-vm/asdf.git' "${HOME}/.asdf" --branch 'v0.14.0'
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

# termscp: terminal SCP tool
# https://github.com/veeso/termscp
curl --proto '=https' --tlsv1.2 -sSLf "https://git.io/JBhDb" | sh

echo "Done running linux extra packages"
