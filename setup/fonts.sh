#!/usr/bin/env bash

# exit on any error or failed piped commands
set -eo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../shell/helpers.sh
source "${DOTFILE_DIR}/shell/helpers.sh"

echo "Installing fonts..."

MESLO_URL="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/Meslo/M/Regular/complete/Meslo%20LG%20M%20Regular%20Nerd%20Font%20Complete.ttf"
MESLO_BOLD_URL="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/Meslo/M/Bold/complete/Meslo%20LG%20M%20Bold%20Nerd%20Font%20Complete.ttf"
JB_MONO_URL="https://download.jetbrains.com/fonts/JetBrainsMono-2.225.zip"

if _is_wsl; then
    FONT_DIR="$(wslpath "$(wslvar USERPROFILE)")"
    wslview "$(wslvar USERPROFILE)"
elif _is_mingw; then
    FONT_DIR="${HOME}"
    start "${FONT_DIR}"
elif _is_macos; then
    FONT_DIR="${HOME}/Downloads"
    open "${FONT_DIR}"
else
    FONT_DIR="${HOME}/.local/share/fonts"
    mkdir -p "${FONT_DIR}"
fi

curl -fLo "${FONT_DIR}/MesloLGM Nerd Font" "${MESLO_URL}"
curl -fLo "${FONT_DIR}/MesloLGM Bold Nerd Font" "${MESLO_BOLD_URL}"
curl -fLo "${FONT_DIR}/JB_Mono.zip" "${JB_MONO_URL}"
unzip "${FONT_DIR}/JB_Mono.zip"
rm "${FONT_DIR}/JB_Mono.zip"

echo "Done installing fonts"
