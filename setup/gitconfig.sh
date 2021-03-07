#!/usr/bin/env bash

# exit on any error or failed piped commands
set -eo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../shell/helpers.sh
source "${DOTFILE_DIR}/shell/helpers.sh"

# .gitconfig
GITCONFIG="${HOME}/.gitconfig"

# gpg program to use
GPG_PROGRAM='gpg'

get_email() {
    regex="email[[:space:]]=[[:space:]]([a-zA-Z0-9@-_\.]+)[[:space:]]"
    config=$(cat "${GITCONFIG}")
    if [[ $config =~ $regex ]]; then
        GPG_EMAIL="${BASH_REMATCH[1]}"
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
    else
        echo "No GPG key found for your email address"
        exit
    fi
}

configure_git() {
    sed -i 's|# signingkey = GPG_KEY_ID|signingkey = '"${GPG_KEY}"'|' "${GITCONFIG}"
    sed -i 's|# gpgsign = true|gpgsign = true|' "${GITCONFIG}"

    if _is_macos; then
        sed -i 's|# helper = osxkeychain|helper = osxkeychain|' "${GITCONFIG}"
        sed -i 's|# program = gpg|program = gpg|' "${GITCONFIG}"
    elif _is_wsl; then
        sed -i 's|# helper = /mnt/c|helper = /mnt/c|' "${GITCONFIG}"
        sed -i 's|# program = /mnt/c|program = /mnt/c|' "${GITCONFIG}"
    else
        sed -i 's|# credentialStore = gpg|credentialStore = gpg|' "${GITCONFIG}"
        sed -i 's|# helper = /usr/bin|helper = /usr/bin|' "${GITCONFIG}"
        sed -i 's|# program = gpg|program = gpg|' "${GITCONFIG}"
    fi
}

check_windows() {
    if _is_wsl; then
        GPG_PROGRAM='/mnt/c/Program Files (x86)/GnuPG/bin/gpg.exe'
        WIN_HOME="$(wslpath "$(wslvar USERPROFILE)")"
        [ -d "${WIN_HOME}/Dotfiles" ] || git clone 'https://github.com/RafhaanShah/Dotfiles' "${WIN_HOME}/Dotfiles"
        [ -f "${WIN_HOME}/.gitconfig" ] || cp "${DOTFILE_DIR}/.gitconfig" "${WIN_HOME}/.gitconfig"
        true
    elif _is_mingw; then
        GPG_PROGRAM='/c/Program Files (x86)/GnuPG/bin/gpg.exe'
        WIN_HOME="${HOME}"
    fi
}

configure_windows() {
    sed -i 's|# signingkey = GPG_KEY_ID|signingkey = '"${GPG_KEY}"'|' "${WIN_HOME}/.gitconfig"
    sed -i 's|# gpgsign = true|gpgsign = true|' "${WIN_HOME}/.gitconfig"
    sed -i 's|# helper = wincred|helper = wincred|' "${WIN_HOME}/.gitconfig"
    sed -i 's|# program = C:|program = C:|' "${WIN_HOME}/.gitconfig"
    sed -i 's|autocrlf = input|autocrlf = true|' "${WIN_HOME}/.gitconfig"
}

setup() {
    if _is_mingw; then
        configure_windows
        return
    fi

    if _is_wsl; then
        configure_windows
    fi

    configure_git
}

echo "Running git setup script..."

git config core.hooksPath ".git-hooks"
chmod -R +x "$(git rev-parse --git-path hooks)"

[ -f "${GITCONFIG}" ] || cp "${DOTFILE_DIR}/.gitconfig" "${GITCONFIG}"
check_windows

if [ "$#" -eq 0 ]; then
    get_email
else
    if [[ $1 == *"@"* ]]; then
        GPG_EMAIL="$1"
        get_gpg_key
    else
        GPG_KEY="$1"
    fi
fi

setup

echo "Done setting up git"
