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


# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Meslo.tar.xz
# TODO: download, unzip, install
# MesloLGMNerdFont-*
# MESLO_URL='https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/Meslo/M/Regular/complete/Meslo%20LG%20M%20Regular%20Nerd%20Font%20Complete.ttf'
# MESLO_BOLD_URL='https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/Meslo/M/Bold/complete/Meslo%20LG%20M%20Bold%20Nerd%20Font%20Complete.ttf'
JB_MONO_URL='https://download.jetbrains.com/fonts/JetBrainsMono-2.225.zip'

setup_fonts() {
    if _is_wsl; then
        FONT_DIR="$(wslpath "$(wslvar USERPROFILE)")"
        wslview "$(wslvar USERPROFILE)"
    elif _is_mingw; then
        FONT_DIR="${HOME}"
        start "${FONT_DIR}"
    elif _is_macos; then
        FONT_DIR="${HOME}/Downloads"
        open "${FONT_DIR}"
    elif _is_termux; then
        curl -fLo "${HOME}/.termux/font.ttf" "${MESLO_URL}"
        return
    else
        FONT_DIR="${HOME}/.local/share/fonts"
        mkdir -p "${FONT_DIR}"
    fi

    # curl -fLo "${FONT_DIR}/MesloLGM Nerd Font.ttf" "${MESLO_URL}"
    # curl -fLo "${FONT_DIR}/MesloLGM Bold Nerd Font.ttf" "${MESLO_BOLD_URL}"
    curl -fLo "${FONT_DIR}/JB_Mono.zip" "${JB_MONO_URL}"
    unzip -j "${FONT_DIR}/JB_Mono.zip" "fonts/ttf/*" -d "${FONT_DIR}"
    rm "${FONT_DIR}/JB_Mono.zip"
}

setup_fonts

echo "Done installing fonts"
