#!/usr/bin/env bash

# exit on any error or failed piped commands
set -euo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../../shell/helpers.sh
source "${DOTFILE_DIR}/shell/helpers.sh"

if ! _is_macos; then
    echo "This is only for macOS"
    exit
fi

echo "Backing up MacOS preferences..."

# PREF_DIR="${HOME}/Library/Preferences"
BACKUP_DIR="${DOTFILE_DIR}/config/MacOSPreferences"
LIST_FILE="${BACKUP_DIR}/pref_list.txt"

while IFS= read -r LINE; do
    defaults export "${LINE}" "${BACKUP_DIR}/plist/${LINE}.plist"
done <"${LIST_FILE}"

LOGIN_ITEMS="${BACKUP_DIR}/login_items.txt"
osascript -e 'tell application "System Events" to get the name of every login item' |
    sed 's/^ *//' | awk -F', ' '{ for (i = 1; i <= NF; ++i) print $i }' \
    >"${LOGIN_ITEMS}"

echo "Done backing up MacOS preferences"
