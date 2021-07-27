### exported environment variables
# shellcheck shell=bash

# add extra directories to the PATH
PATH_DIRS=(
    "${HOME}/bin"                                # home bin
    "${HOME}/.local/bin"                         # alternative bin
    "${HOME}/.npm-global/bin"                    # npm global bin
    "${HOME}/Library/Android/sdk/platform-tools" # macOS Android tools
    "/usr/local/go/bin"                          # go
    "/snap/bin"                                  # snap bin
)

for DIR in "${PATH_DIRS[@]}"; do
    _add_to_path "${DIR}"
done

unset DIR PATH_DIRS

# colours used in ls # https://geoff.greer.fm/lscolors/
export LS_COLORS="di=1;36:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=30;46:cd=37;44:su=30;41:sg=37;42:tw=37;43:ow=30;43"

# default text editor
export EDITOR="nano"

# default visual text editor
export VISUAL="${EDITOR}"

# default pager
export PAGER="less"

# for using GPG with git
# shellcheck disable=SC2155
export GPG_TTY="$(tty)"

# set NPM global path to workaround permission issues
# https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally
export NPM_CONFIG_PREFIX="${HOME}/.npm-global"

# https://consoledonottrack.com/
export DO_NOT_TRACK=1
