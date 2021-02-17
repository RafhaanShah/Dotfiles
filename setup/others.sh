#!/usr/bin/env bash

# exit on any error, unset variable, or failed piped commands
set -euo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
source "${DOTFILE_DIR}/.helpers"

get_script() {
    curl -sSL "$1" -o "${HOME}/bin/${2}"
    chmod +x "${HOME}/bin/{2}"
}

echo "Installing some scripts..."

# make home bin
mkdir -p "${HOME}/bin"

# cheat.sh: cli cheatsheets
# https://github.com/chubin/cheat.sh
get_script "https://cht.sh/:cht.sh" "cht"

# tldr: better manpages
# https://github.com/tldr-pages/tldr
get_script "https://raw.githubusercontent.com/raylee/tldr/master/tldr" "tldr"

# nano syntax highlighting
# https://github.com/scopatz/nanorc
mkdir -p "${HOME}/.nano"
git clone https://github.com/scopatz/nanorc.git "${HOME}/.nano"
sed -i 's|# include "~/.nano/*.nanorc"|include "~/.nano/*.nanorc"|' "${HOME}/.nanorc"
