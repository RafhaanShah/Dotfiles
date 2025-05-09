#!/usr/bin/env bash

# exit on any error or failed piped commands
set -eo pipefail

echo "Running bash setup script..."

COMPLETION_DIR="${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-${HOME}/.local/share}/bash-completion}/completions"
mkdir -p "${COMPLETION_DIR}"

get_completion() {
    curl -sSL "${1}" -o "${COMPLETION_DIR}/${2}"
}

get_completion "https://cheat.sh/:bash_completion" cht
get_completion "https://github.com/httpie/httpie/raw/master/extras/httpie-completion.bash" http

echo "Done settings up bash"
