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

echo "Restoring up MacOS preferences..."

BACKUP_DIR="${DOTFILE_DIR}/config/MacOSPreferences"
LIST_FILE="${BACKUP_DIR}/pref_list.txt"
mkdir -p "${DOTFILE_DIR}/old/plist"

while IFS= read -r LINE; do
    defaults export "${LINE}" "${DOTFILE_DIR}/old/plist/${LINE}.plist"
    defaults import "${LINE}" "${BACKUP_DIR}/plist/${LINE}.plist"
done <"${LIST_FILE}"

killall Finder
killall Dock

LOGIN_ITEMS="${BACKUP_DIR}/login_items.txt"
while IFS= read -r APP_NAME; do
    osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"/Applications/${APP_NAME}.app\", hidden:false}"
done <"$LOGIN_ITEMS"

echo "Done restoring up MacOS preferences"
