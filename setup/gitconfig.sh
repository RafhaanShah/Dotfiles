#!/usr/bin/env bash

# exit on any error, unset variable, or failed piped commands
set -euo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../helpers.sh
source "${DOTFILE_DIR}/helpers.sh"

# .gitconfig
GITCONFIG="${HOME}/.gitconfig"

get_email() {
    regex="email[[:space:]]=[[:space:]]([a-zA-Z0-9@-_\.]+)[[:space:]]"
    config=$(cat "${GITCONFIG}")
    if [[ $config =~ $regex ]]; then
        GPG_EMAIL="${BASH_REMATCH[1]}"
    else
        echo "No email address found in .gitconfig"
        echo "Re-run with your GPG email: ./gitconfig.sh user@mail.com"
        exit
    fi
}

get_gpg_key() {
    echo "GPG email: $GPG_EMAIL"
    regex="sec[[:space:]]+rsa[0-9]+\/([a-zA-Z0-9]+)[[:space:]]"
    gpg="$(gpg2 --list-secret-keys --keyid-format LONG "${GPG_EMAIL}")"

    if [[ $gpg =~ $regex ]]; then
        key="${BASH_REMATCH[1]}"
        sed -i 's|# signingkey = GPG_KEY_ID|'"${key}"'|' "${GITCONFIG}"
        echo "GPG key: ${key}"
        configure_git
    else
        echo "No GPG key found for your email address"
        exit
    fi
}

configure_git() {
    sed -i 's|# gpgsign = true|gpgsign = true|' "${GITCONFIG}"
    
    if _is_macos; then
        sed -i 's|# helper = osxkeychain|helper = osxkeychain|' "${GITCONFIG}"
    elif _is_wsl; then
        sed -i 's|# helper = wincred|helper = wincred|' "${GITCONFIG}"
    else
        sed -i 's|# credentialStore = gpg|credentialStore = gpg|' "${GITCONFIG}"
        sed -i 's|# helper = /usr/bin/git-credential-manager-core|helper = /usr/bin/git-credential-manager-core|' "${GITCONFIG}"
    fi
    
    if _is_wsl; then
        sed -i 's|# program = C:\\Program Files (x86)\\GnuPG\\bin\\gpg.exe|program = C:\\Program Files (x86)\\GnuPG\\bin\\gpg.exe|' "${GITCONFIG}"  
    else
        sed -i 's|# program = gpg2|program = gpg2|' "${GITCONFIG}"
    fi
}

echo "Configuring git"
[ -f "${GITCONFIG}" ] && echo "No .gitconfig found" && exit

if [ "$#" -eq 0 ]; then
    get_email
else
    GPG_EMAIL="$1"
fi

get_gpg_key
