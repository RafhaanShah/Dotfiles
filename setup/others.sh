#!/usr/bin/env bash

# exit on any error, unset variable, or failed piped commands
set -euo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../helpers.sh
source "${DOTFILE_DIR}/helpers.sh"

get_script() {
    curl -sSL "$1" -o "${HOME}/bin/${2}"
    chmod +x "${HOME}/bin/${2}"
}

echo "Installing some scripts..."

# make home bin
mkdir -p "${HOME}/bin"

# cheat.sh: cli cheatsheets
# https://github.com/chubin/cheat.sh
get_script "https://cht.sh/:cht.sh" "cht.sh"

# tldr: better manpages
# https://github.com/tldr-pages/tldr
get_script "https://raw.githubusercontent.com/raylee/tldr/master/tldr" "tldr"

# nano syntax highlighting
# https://github.com/scopatz/nanorc
if [ ! -d "${HOME}/.nano" ]; then
    git clone https://github.com/scopatz/nanorc.git "${HOME}/.nano"
    sed -i 's|# include "~/.nano/*.nanorc"|include "~/.nano/*.nanorc"|' "${HOME}/.nanorc"
else
    git -C "${HOME}/.nano" pull
fi