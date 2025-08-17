#!/usr/bin/env bash

# exit on any error or failed piped commands
set -eo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../shell/helpers.sh
source "${DOTFILE_DIR}/shell/helpers.sh"

echo "Installing fonts..."

# MesloLGMNerdFont-*.ttf
# JetBrainsMonoNerdFont-*.ttf
# https://github.com/ryanoasis/nerd-fonts/wiki/FAQ-and-Troubleshooting#what-do-these-acronym-variations-in-the-font-name-mean-lg-l-m-s-dz-sz
MESLO_URL='https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.tar.xz'
JB_MONO_URL='https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz'

setup_fonts() {
    if _is_mingw; then
        FONT_DIR="${DOTFILE_DIR}/temp"
        # just copying to the fonts folder does NOT install
        echo "Open and install fonts from ${FONT_DIR}"
    elif _is_macos; then
        FONT_DIR="${HOME}/Library/Fonts"
    elif _is_termux; then
        # termux only needs the 1 file
        mkdir -p "${HOME}/.termux"
        curl -sL "${MESLO_URL}" | tar -xO 'MesloLGMNerdFont-Regular.ttf' >"${HOME}/.termux/font.ttf"
        return
    else
        # assume linux
        FONT_DIR="${HOME}/.local/share/fonts"
    fi

    echo "Installing fonts to ${FONT_DIR}"
    mkdir -p "${FONT_DIR}"
    # download directly into tar filtering the right fonts into the folder
    curl -L "${MESLO_URL}" | tar -xJ --wildcards -C "${FONT_DIR}" -f - 'MesloLGMNerdFont-*.ttf'
    curl -L "${JB_MONO_URL}" | tar -xJ --wildcards -C "${FONT_DIR}" -f - 'JetBrainsMonoNerdFont-*.ttf'
    ls -l "${FONT_DIR}"
}

setup_fonts

echo "Done installing fonts"
