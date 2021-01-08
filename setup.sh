#!/bin/sh
set -e

DOTFILE_DIR="${HOME}/Dotfiles"

echo "This will rename existing .zshrc and .bashrc and add symlinks to ${HOME}/Dotfiles"

add_symlinks() {
	[ -f "${HOME}/.zshrc" ] && mv "${HOME}/.zshrc" "${HOME}/.zshrc.old"
	[ -f "${HOME}/.bashrc" ] && mv "${HOME}/.bashrc" "${HOME}/.bashrc.old"
	
	ln -s "${DOTFILE_DIR}/.zshrc" "${HOME}/.zshrc"
	ln -s "${DOTFILE_DIR}/.bashrc" "${HOME}/.bashrc"
}

read -p "Continue (y/n)?" CONT
if [ "$CONT" != "y" ]; then
  exit 1
else
  add_symlinks && echo "Done"
fi