#!/usr/bin/env bash

# exit on any error or failed piped commands
set -eo pipefail

# dotfile repo folder
DOTFILE_DIR="${HOME}/Dotfiles"
# shellcheck source=../shell/helpers.sh
source "${DOTFILE_DIR}/shell/helpers.sh"

echo "Running test script..."

_prompt_yes_no "Do a thing?" && echo "Did a thing"

echo "Finished test script"
