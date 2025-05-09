#!/usr/bin/env bash

# Generic script to adapt to backup files and folders on a specific machine
set -euo pipefail

# Define the list of files to copy
FILES=(
    "${HOME}/.ssh"
    "${HOME}/.gitconfig"
    "${HOME}/.rafrc"
    "${HOME}/bin"
)

# Define the destination directory
DEST_DIR="${HOME}/MyBackup"

if [ ! -d "${DEST_DIR}" ]; then
    echo "Error: Destination directory ${DEST_DIR} does not exist." >&2
    exit 1
fi

# Copy each file or directory to the destination directory
for FILE in "${FILES[@]}"; do
    if [ -f "${FILE}" ]; then
        cp -f "${FILE}" "${DEST_DIR}/"
        echo "Copied file: ${FILE} -> ${DEST_DIR}/"
    elif [ -d "${FILE}" ]; then
        cp -rf "${FILE}" "${DEST_DIR}/"
        echo "Copied directory: ${FILE} -> ${DEST_DIR}/"
    else
        echo "Warning: ${FILE} does not exist. Skipping." >&2
    fi
done
