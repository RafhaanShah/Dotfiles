#!/usr/bin/env bash

# exit on any error, unset variable, or failed piped commands
set -euo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../helpers.sh
source "${DOTFILE_DIR}/helpers.sh"

# .gitconfig
GITCONFIG="${HOME}/.gitconfig"

# gpg program to use
GPG_PROGRAM='gpg'

get_email() {
    regex="email[[:space:]]=[[:space:]]([a-zA-Z0-9@-_\.]+)[[:space:]]"
    config=$(cat "${GITCONFIG}")
    if [[ $config =~ $regex ]]; then
        GPG_EMAIL="${BASH_REMATCH[1]}"
        echo "Using email: ${GPG_EMAIL}"
        get_gpg_key
    else
        echo "No email address found in .gitconfig"
        echo "Re-run with your GPG email or key: ./gitconfig.sh user@mail.com OR ./gitconfig.sh 1234ABCD"
        exit
    fi
}

get_gpg_key() {
    echo "GPG email: $GPG_EMAIL"
    regex="sec[[:space:]]+rsa[0-9]+\/([a-zA-Z0-9]+)[[:space:]]"
    gpg_result="$("${GPG_PROGRAM}" --list-secret-keys --keyid-format LONG "${GPG_EMAIL}")"

    if [[ $gpg_result =~ $regex ]]; then
        GPG_KEY="${BASH_REMATCH[1]}"
        echo "Using GPG key: ${GPG_KEY}"
        set_gpg_key
    else
        echo "No GPG key found for your email address"
        exit
    fi
}

set_gpg_key() {
    sed -i 's|# signingkey = GPG_KEY_ID|signingkey = '"${GPG_KEY}"'|' "${GITCONFIG}"
    _is_wsl && sed -i 's|# signingkey = GPG_KEY_ID|signingkey = '"${GPG_KEY}"'|' "${WSL_HOME}/.gitconfig"
    configure_git
}

configure_git() {
    sed -i 's|# gpgsign = true|gpgsign = true|' "${GITCONFIG}"
    _is_wsl && sed -i 's|# gpgsign = true|gpgsign = true|' "${WSL_HOME}/.gitconfig"

    if _is_macos; then
        sed -i 's|# helper = osxkeychain|helper = osxkeychain|' "${GITCONFIG}"
    elif _is_wsl; then
        sed -i 's|# helper = /mnt/c|helper = /mnt/c|' "${GITCONFIG}"
        sed -i 's|# helper = wincred|helper = wincred|' "${WSL_HOME}/.gitconfig"
    else
        sed -i 's|# credentialStore = gpg|credentialStore = gpg|' "${GITCONFIG}"
        sed -i 's|# helper = /usr/bin|helper = /usr/bin|' "${GITCONFIG}"
    fi

    if _is_wsl; then
        sed -i 's|# program = C:\\Program|program = C:\\Program|' "${WSL_HOME}/.gitconfig"
        sed -i 's|# program = /mnt/c|program = /mnt/c|' "${GITCONFIG}"
    else
        sed -i 's|# program = gpg|program = gpg|' "${GITCONFIG}"
    fi
}

setup_wsl() {
    GPG_PROGRAM='/mnt/c/Program Files (x86)/GnuPG/bin/gpg.exe'
    WSL_HOME="$(wslpath "$(wslvar USERPROFILE)")"
    [ ! -d "${WSL_HOME}/Dotfiles" ] && git clone 'https://github.com/RafhaanShah/Dotfiles' "${WSL_HOME}/Dotfiles"
    cp "${DOTFILE_DIR}/.gitconfig" "${WSL_HOME}/.gitconfig"
}

echo "Configuring git with gpg"
if [ ! -f "${GITCONFIG}" ]; then
    echo "No .gitconfig found"
    exit
fi

git config core.hooksPath ".git-hooks"
_is_wsl && setup_wsl

if [ "$#" -eq 0 ]; then
    get_email
else
    if [[ $1 == *"@"* ]]; then
        GPG_EMAIL="$1"
        get_gpg_key
    else
        GPG_KEY="$1"
        set_gpg_key
    fi
fi

echo "Done configuring git"
