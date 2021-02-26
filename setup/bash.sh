#!/usr/bin/env bash

# exit on any error or failed piped commands
set -eo pipefail

COMPLETION_DIR="${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions"
mkdir -p "${COMPLETION_DIR}"

get_completion() {
    curl -sSL "$1" -o "${COMPLETION_DIR}/${2}"
}

get_completion 'https://cheat.sh/:bash_completion' cht.sh
get_completion 'https://github.com/jarun/googler/raw/master/auto-completion/bash/googler-completion.bash' googler
get_completion 'https://github.com/httpie/httpie/raw/master/extras/httpie-completion.bash' http

# copy completions from bash-it: https://github.com/Bash-it/bash-it
echo "Copying bash-it completions..."
[ ! -d "/tmp/bash-it" ] && git clone --depth=1 'https://github.com/Bash-it/bash-it.git' "/tmp/bash-it"

for FILE in "/tmp/bash-it/completion/available/"*".completion.bash"; do
    cp -- "${FILE}" "${COMPLETION_DIR}"
done

rm -r "/tmp/bash-it"
