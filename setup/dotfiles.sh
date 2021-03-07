#!/usr/bin/env bash

# exit on any error or failed piped commands
set -eo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../shell/helpers.sh
source "${DOTFILE_DIR}/shell/helpers.sh"

# folder to backup existing dotfiles
BACKUP_DIR="${DOTFILE_DIR}/old"

# list of files to symlink to repo
SYM_FILES=(
    .bashrc
    .zshrc
)

# list of files to copy so they can be modified as needed
CP_FILES=(
    .bash_profile
    .hushlogin
    .gitconfig
    .nanorc
    .rafrc
)

# list of files for mingw on windows
WIN_FILES=(
    .bash_profile
    .bashrc
    .gitconfig
    .nanorc
    .rafrc
    .minttyrc
)

run_setup() {
    if [ ! -d "${DOTFILE_DIR}" ]; then
        echo "Invalid dotfile folder, ${DOTFILE_DIR}"
        exit 1
    fi

    if _is_mingw; then
        setup_windows
        return
    fi

    mkdir -p "${DOTFILE_DIR}/old"
    copy_dotfiles
    symlink_dotfiles
}

copy_dotfiles() {
    for FILE in "${CP_FILES[@]}"; do
        echo "${FILE}"
        [ -f "${HOME}/${FILE}" ] && mv "${HOME}/${FILE}" "${BACKUP_DIR}/${FILE}"
        cp "${DOTFILE_DIR}/${FILE}" "${HOME}/${FILE}"
    done
}

symlink_dotfiles() {
    for FILE in "${SYM_FILES[@]}"; do
        echo "${FILE}"
        [ -f "${HOME}/${FILE}" ] && mv "${HOME}/${FILE}" "${BACKUP_DIR}/${FILE}"
        ln -s "${DOTFILE_DIR}/${FILE}" "${HOME}/${FILE}"
    done
}

setup_windows() {
    for FILE in "${WIN_FILES[@]}"; do
        echo "${FILE}"
        cp "${DOTFILE_DIR}/${FILE}" "${HOME}/${FILE}"
    done
}

echo "Running dotfile setup script..."

run_setup

echo "Done settings up dotfiles"
