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

echo "Installing fonts..."

# MesloLGMNerdFont-*.ttf
# JetBrainsMonoNerdFont-*.ttf
# https://github.com/ryanoasis/nerd-fonts/wiki/FAQ-and-Troubleshooting#what-do-these-acronym-variations-in-the-font-name-mean-lg-l-m-s-dz-sz
MESLO_URL='https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.tar.xz'
JB_MONO_URL='https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz'

setup_fonts() {
    if _is_wsl; then
        FONT_DIR="$(wslpath "$(wslvar LOCALAPPDATA)")/Microsoft/Windows/Fonts"
    elif _is_mingw; then
        FONT_DIR="${LOCALAPPDATA}/Microsoft/Windows/Fonts"
    elif _is_macos; then
        FONT_DIR="${HOME}/Library/Fonts"
    elif _is_termux; then
        # termux only needs the 1 file
        mkdir -p "${HOME}/.termux"
        curl -sL "${MESLO_URL}" | tar -xO 'MesloLGMNerdFont-Regular.ttf' >"${HOME}/.termux/font.ttf"
        return
    else
        FONT_DIR="${HOME}/.local/share/fonts"
    fi

    mkdir -p "${FONT_DIR}"
    # download directly into tar filtering the right fonts into the folder
    curl -sL "${MESLO_URL}" | tar -xJ --wildcards -C "${FONT_DIR}" -f - 'MesloLGMNerdFont-*.ttf'
    curl -sL "${JB_MONO_URL}" | tar -xJ --wildcards -C "${FONT_DIR}" -f - 'JetBrainsMonoNerdFont-*.ttf'
}

setup_fonts

echo "Done installing fonts"
