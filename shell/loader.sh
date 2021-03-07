### loads all other dot files
# shellcheck shell=bash

# source file if it exists
# shellcheck source=/dev/null
_load_file() { [ -f "${1}" ] && source "${1}"; }

# location of dotfile repository
DOTFILE_DIR="${HOME}/Dotfiles"

# helper functions
_load_file "${DOTFILE_DIR}/shell/helpers.sh"

# exported environment variables
_load_file "${DOTFILE_DIR}/shell/exports.sh"

# aliases
_load_file "${DOTFILE_DIR}/shell/aliases.sh"

# if on wsl, load wsl file
_is_wsl && _load_file "${DOTFILE_DIR}/shell/wsl.sh"

# if on mingw, load mingw file
_is_mingw && _load_file "${DOTFILE_DIR}/shell/mingw.sh"

# if on macOS, load macOS file
_is_macos && _load_file "${DOTFILE_DIR}/shell/macos.sh"

# if on termux, load termux file
_is_macos && _load_file "${DOTFILE_DIR}/shell/termux.sh"

# custom profile file for machine specific stuff
_load_file "${HOME}/.rafrc"

# functions (to be loaded after aliases as aliases are read at function definition)
_load_file "${DOTFILE_DIR}/shell/functions.sh"

# cli tools
_load_file "${DOTFILE_DIR}/shell/tools.sh"

# prompt functions
_load_file "${DOTFILE_DIR}/shell/prompt_functions.sh"

# print version info and load prompt
_is_bash && echo -n "bash ${BASH_VERSION} - " && date &&
    _load_file "${DOTFILE_DIR}/shell/prompt_bash.sh"

_is_zsh && echo -n "zsh ${ZSH_VERSION} - " && date &&
    _load_file "${DOTFILE_DIR}/shell/prompt_zsh.sh"
