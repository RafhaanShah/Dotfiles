#!/usr/bin/env bash

set -eo pipefail

DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../shell/helpers.sh
source "${DOTFILE_DIR}/shell/helpers.sh"

# --- Brew ---
brew_install() {
    read -r -p "Package name: " pkg
    brew install "$pkg"
}
brew_backup() { brew bundle dump --force --describe --file="${DOTFILE_DIR}/packages/brew.txt"; }
brew_restore() { brew bundle --file "${DOTFILE_DIR}/packages/brew.txt"; }
brew_update() { brew update && brew upgrade; }
brew_search() {
    read -r -p "Package name: " pkg
    brew search "$pkg"
}
brew_clean() { brew autoremove && brew cleanup; }
brew_diagnose() { brew doctor; }

# --- APT ---
apt_install() {
    read -r -p "Package name: " pkg
    sudo apt install "$pkg"
}
# shellcheck disable=SC2024
apt_backup() { sudo apt list --installed >"${DOTFILE_DIR}/packages/apt.txt"; }
apt_restore() { xargs <"${DOTFILE_DIR}/packages/apt.txt" sudo apt install -y; }
apt_update() { sudo apt update && sudo apt upgrade -y; }
apt_search() {
    read -r -p "Package name: " pkg
    sudo apt search "$pkg"
}
apt_clean() { sudo apt autoremove && sudo apt autoclean; }

# --- NPM ---
npm_install() {
    read -r -p "Package name: " pkg
    npm install --global "$pkg"
}
npm_backup() { ls -1 "$(npm root --global)" >"${DOTFILE_DIR}/packages/npm.txt"; }
npm_restore() { xargs <"${DOTFILE_DIR}/packages/npm.txt" npm install --global; }
npm_update() { npm update --global; }
npm_search() {
    read -r -p "Package name: " pkg
    npm search "$pkg"
}

# --- PIP (pipx) ---
pip_install() {
    read -r -p "Package name: " pkg
    pipx install "$pkg"
}
pip_backup() { pipx list --short | cut -d' ' -f1 >"${DOTFILE_DIR}/packages/pip.txt"; }
pip_restore() { xargs <"${DOTFILE_DIR}/packages/pip.txt" pipx install; }
pip_update() { pipx upgrade-all; }
pip_search() {
    read -r -p "Package name: " pkg
    pip3 search "$pkg"
}

# --- Snap ---
snap_install() {
    read -r -p "Package name: " pkg
    sudo snap install "$pkg"
}
snap_backup() { snap list >"${DOTFILE_DIR}/packages/snap.txt"; }
snap_restore() { xargs <"${DOTFILE_DIR}/packages/snap.txt" sudo snap install; }
snap_update() { sudo snap refresh; }
snap_search() {
    read -r -p "Package name: " pkg
    snap find "$pkg"
}

# --- Termux ---
termux_install() {
    read -r -p "Package name: " pkg
    pkg install "$pkg"
}
termux_backup() { pkg list-installed >"${DOTFILE_DIR}/packages/termux.txt"; }
termux_restore() { xargs <"${DOTFILE_DIR}/packages/termux.txt" pkg install -y; }
termux_update() { pkg upgrade; }
termux_search() {
    read -r -p "Package name: " pkg
    pkg search "$pkg"
}
termux_clean() { pkg autoclean; }

# --- Menu ---
echo "Select package manager:"
select pkgmgr in "brew" "apt" "npm" "pip" "snap" "termux" "exit"; do
    case $pkgmgr in
        brew | apt | npm | pip | snap | termux) break ;;
        exit) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done

echo "Select command:"
select cmd in "install" "backup" "restore" "update" "search" "clean" "diagnose" "exit"; do
    case $cmd in
        install | backup | restore | update | search | clean | diagnose) break ;;
        exit) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done

if ! _prompt_yes_no "Run '$cmd' for '$pkgmgr'? [y/N]"; then
    echo "Aborted."
    exit 1
fi

case "$pkgmgr-$cmd" in
    brew-install) brew_install ;;
    brew-backup) brew_backup ;;
    brew-restore) brew_restore ;;
    brew-update) brew_update ;;
    brew-search) brew_search ;;
    brew-clean) brew_clean ;;
    brew-diagnose) brew_diagnose ;;

    apt-install) apt_install ;;
    apt-backup) apt_backup ;;
    apt-restore) apt_restore ;;
    apt-update) apt_update ;;
    apt-search) apt_search ;;
    apt-clean) apt_clean ;;

    npm-install) npm_install ;;
    npm-backup) npm_backup ;;
    npm-restore) npm_restore ;;
    npm-update) npm_update ;;
    npm-search) npm_search ;;

    pip-install) pip_install ;;
    pip-backup) pip_backup ;;
    pip-restore) pip_restore ;;
    pip-update) pip_update ;;
    pip-search) pip_search ;;

    snap-install) snap_install ;;
    snap-backup) snap_backup ;;
    snap-restore) snap_restore ;;
    snap-update) snap_update ;;
    snap-search) snap_search ;;

    termux-install) termux_install ;;
    termux-backup) termux_backup ;;
    termux-restore) termux_restore ;;
    termux-update) termux_update ;;
    termux-search) termux_search ;;
    termux-clean) termux_clean ;;

    *)
        echo "Not implemented"
        exit
        ;;
esac
