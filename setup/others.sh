#!/usr/bin/env bash

# exit on any error or failed piped commands
set -eo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
[ ! -d "${DOTFILE_DIR}" ] && {
    echo "Invalid Dotfile folder"
    exit 1
}
# shellcheck source=../shell/helpers.sh
source "${DOTFILE_DIR}/shell/helpers.sh"

echo "Installing some scripts..."

get_script() {
    curl -sSL "$1" -o "${HOME}/bin/${2}"
    chmod +x "${HOME}/bin/${2}"
}

# make home bin
mkdir -p "${HOME}/bin"

# cheat.sh: cli cheatsheets
# https://github.com/chubin/cheat.sh
get_script "https://cht.sh/:cht.sh" "cht.sh"

# python simple http server with directory listing and upload
# https://github.com/sgrontflix/simplehttpserverwithupload
get_script "https://raw.githubusercontent.com/sgrontflix/simplehttpserverwithupload/main/main.py" "server.py"

# nano syntax highlighting
# https://github.com/scopatz/nanorc
echo "Setting up nano syntax highlighting..."
sed -i 's|# include "~/.nano/*.nanorc"|include "~/.nano/*.nanorc"|' "${HOME}/.nanorc"
if [ ! -d "${HOME}/.nano" ]; then
    git clone 'https://github.com/scopatz/nanorc.git' "${HOME}/.nano"
else
    git -C "${HOME}/.nano" pull
fi

echo "Done installing scripts"
