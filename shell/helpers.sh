### common use helper functions
# shellcheck shell=bash

# checks if the given command exists
_command_exists() { command -v "$1" >/dev/null 2>&1; }

# checks if the given variable is set
_variable_set() { [ -n "$1" ]; }

# checks if $2 begins with $1
_begins_with() { case "$2" in "$1"*) true ;; *) false ;; esac }

# checks if $2 ends with $1
_ends_with() { case "$2" in *"$1") true ;; *) false ;; esac }

# checks if $2 is in $1
_in_string() { case "$2" in *"$1"*) true ;; *) false ;; esac }

# checks if we are running bash
_is_bash() { _variable_set "${BASH_VERSION}"; }

# checks if we are running zsh
_is_zsh() { _variable_set "${ZSH_VERSION}"; }

# checks if we are in a git repo
_is_git_repo() { git rev-parse --is-inside-work-tree &>/dev/null; }

# checks if we are running linux
_is_linux() { [ "$(uname -s)" = "Linux" ]; }

# checks if we are running in termux
_is_termux() { _begins_with "/data/data/com.termux" "${PREFIX}"; }

# checks if we are running in wsl
_is_wsl() { _variable_set "${WSL_DISTRO_NAME}"; }

# checks if we are running mingw / cygwin in windows
_is_mingw() {
    local name
    name="$(uname -s)"
    _begins_with "MINGW" "${name}" || _begins_with "MSYS" "${name}" || _begins_with "CYGWIN" "${name}"
}

# checks if we are running on macOS
_is_macos() { [ "$(uname -s)" = "Darwin" ]; }

# checks if we a running on an M1 mac
_is_m1_mac() { _is_macos && _in_string "Apple" "$(sysctl -n machdep.cpu.brand_string)"; }

# trims given text
_trim() {
    local var="$*"
    var="${var#"${var%%[![:space:]]*}"}" # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}" # remove trailing whitespace characters
    echo "${var}"
}

# checks if true colour is supported, this is not set by all terminals
# https://gist.github.com/XVilka/8346728
_colour_true() { _variable_set "${COLORTERM}"; }

# checks if 256 colours are supported by the terminal
_colour_256() {
    # [ $(tput colors) -eq 256 ]
    case "$TERM" in
        xterm-color | *-256color) return 0 ;;
        *) return 1 ;;
    esac
}

# checks if this is an xterm
_is_xterm() {
    case "$TERM" in
        xterm* | rxvt*) return 0 ;;
        *) return 1 ;;
    esac
}

# checks if $1 is in an array $2, must be passed as "${array[@]}"
# does not work with spaces in elements as that requires looping
_in_list() {
    local str="$1"
    shift
    [[ " $* " == *" ${str} "* ]]
}

# adds a path to the front of fpath if it exists
_add_to_fpath() {
    [ -d "$1" ] && fpath=("$1" "${fpath[@]}")
}

# adds a folder to front of PATH
# if it is already in PATH, remove it first
_add_to_path() {
    if [ -d "$1" ]; then
        case ":${PATH:=$1}:" in
            *:"$1":*) _remove_from_path "$1" ;;
            *) ;;
        esac
        PATH="$1:${PATH}"
    fi
}

# removes a dir from PATH
_remove_from_path() {
    local p d
    p=":$1:"
    d=":$PATH:"
    d="${d//$p/:}"
    d="${d/#:/}"
    PATH="${d/%:/}"
}

# gets a Windows Environment variable
wslvar() {
    local value
    value=$(powershell.exe -Command "[Environment]::GetEnvironmentVariable('${1}')")
    if [ -z "${value}" ]; then
        return 1
    else
        echo "$value"
    fi
}
