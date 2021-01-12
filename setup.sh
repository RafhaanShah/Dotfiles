#!/bin/sh

# exit on any error
set -e

# repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# list of files
DOTFILES=(
    .hushlogin
    .bash_profile
    .bashrc
    .zshrc
    .nanorc
)

# add .old to existing files and symlink repo files to home directory
add_symlinks() {
    for FILE in "${DOTFILES[@]}"; do
        echo "${FILE}"
        [ -f "${HOME}/${FILE}" ] && mv "${HOME}/${FILE}" "${HOME}/${FILE}.old"
        ln -s "${DOTFILE_DIR}/${FILE}" "${HOME}/${FILE}"
    done
}

echo "This will rename existing dotfiles and add symlinks to ${DOTFILE_DIR}"

# prompt for confirmation
read -p "Continue (y/n)? " CONT
if [ "$CONT" != "y" ]; then
    exit 1
else
    add_symlinks && echo "Done"
fi
