#!/usr/bin/env bash

# exit on any error or failed piped commands
set -eo pipefail

echo "Running bash setup script..."

COMPLETION_DIR="${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-${HOME}/.local/share}/bash-completion}/completions"
PLUGIN_DIR="${HOME}/.local/share/bash-plugins"
mkdir -p "${COMPLETION_DIR}" "${PLUGIN_DIR}"

get_completion() {
    curl -sSL "$1" -o "${COMPLETION_DIR}/${2}"
}

get_completion "https://cheat.sh/:bash_completion" cht.sh
get_completion "https://github.com/jarun/googler/raw/master/auto-completion/bash/googler-completion.bash" googler
get_completion "https://github.com/httpie/httpie/raw/master/extras/httpie-completion.bash" http

# copy completions from bash-it: https://github.com/Bash-it/bash-it
echo "Copying bash-it completions..."
BASH_IT="/tmp/bash-it"
[ ! -d "${BASH_IT}" ] && git clone --depth=1 "https://github.com/Bash-it/bash-it.git" "${BASH_IT}"

for FILE in "${BASH_IT}/completion/available/"*".completion.bash"; do
    cp -- "${FILE}" "${COMPLETION_DIR}"
done

BASH_PLUGINS=(
    alias-completion
)

echo "Copying bash-it plugins..."
for PLUGIN in "${BASH_PLUGINS[@]}"; do
    cp -- "${BASH_IT}/plugins/available/${PLUGIN}.plugin.bash" "${PLUGIN_DIR}"
done

rm -rf "${BASH_IT}"

echo "Done settings up bash"
