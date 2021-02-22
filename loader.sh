### loads all other dot files
# shellcheck shell=bash

# source file if it exists
# shellcheck source=/dev/null
_load_file() { [ -f "${1}" ] && source "${1}"; }

# location of dotfile repository
DOTFILE_DIR="${HOME}/Dotfiles"

# helper functions
_load_file "${DOTFILE_DIR}/helpers.sh"

# exported environment variables
_load_file "${DOTFILE_DIR}/exports.sh"

# aliases
_load_file "${DOTFILE_DIR}/aliases.sh"

# if on wsl, load wsl file
_is_wsl && _load_file "${DOTFILE_DIR}/wsl.sh"

# if on macOS, load macOS file
_is_macos && _load_file "${DOTFILE_DIR}/macos.sh"

# custom profile file for machine specific stuff
_load_file "${HOME}/.rafrc"

# functions (to be loaded after aliases as aliases are read at function definition)
_load_file "${DOTFILE_DIR}/functions.sh"

# cli tools
_load_file "${DOTFILE_DIR}/tools.sh"

# prompt functions
_load_file "${DOTFILE_DIR}/prompt_functions.sh"

# print version info and load prompt
_is_bash && echo -n "bash ${BASH_VERSION} - " && date &&
    _load_file "${DOTFILE_DIR}/prompt_bash.sh"

_is_zsh && echo -n "zsh ${ZSH_VERSION} - " && date &&
    _load_file "${DOTFILE_DIR}/prompt_zsh.sh"

unset DOTFILE_DIR
