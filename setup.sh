#!/bin/sh

# exit on any error
set -e

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"

# folder to backup existing dotfiles
BACKUP_DIR="${DOTFILE_DIR}/old"

# list of files to symlink to repo
SYM_FILES=(
    .bash_profile
    .bashrc
    .zshrc
)
    
# list of files to copy so they can be modified as needed
CP_FILES=(
    .hushlogin
    .gitconfig
    .nanorc
)
    
run_setup() {
    [ ! -d "${DOTFILE_DIR}" ] && echo "Inavlid Dotfile folder" && exit 1
    mkdir -p "${DOTFILE_DIR}/old"
    copy_dotfiles
    symlink_dotfiles
}

copy_dotfiles() {
    for FILE in "${DOTFILES[@]}"; do
        echo "${FILE}"
        [ -f "${HOME}/${FILE}" ] && mv "${HOME}/${FILE}" "${BACKUP_DIR}/${FILE}.old"
        cp "${CP_FILES}/${FILE}" "${HOME}/${FILE}"
    done
}

symlink_dotfiles() {
    for FILE in "${SYM_FILES[@]}"; do
        echo "${FILE}"
        [ -f "${HOME}/${FILE}" ] && mv "${HOME}/${FILE}" "${BACKUP_DIR}/${FILE}.old"
        ln -s "${DOTFILE_DIR}/${FILE}" "${HOME}/${FILE}"
    done
}

echo "This will rename existing dotfiles and add symlinks to ${DOTFILE_DIR}"

# prompt for confirmation
read -p "Continue (y/n)? " CONT
if [ "$CONT" != "y" ]; then
    exit 1
else
    run_setup && echo "Done"
fi
