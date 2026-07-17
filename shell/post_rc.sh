### config required at the end of rc file load
# shellcheck shell=bash

# Hash maps command names to GNU executables in this shell's command lookup table.
# This leaves existing aliases intact and does not expose the GNU tools through PATH.
if _is_macos; then
    for GNU_DIR in \
        "${HOMEBREW_PREFIX}"/opt/{coreutils,findutils,grep,make,gnu-sed,gnu-tar,gnu-which}/libexec/gnubin; do
        [ -d "${GNU_DIR}" ] || continue
        for GNU_TOOL in "${GNU_DIR}"/*; do
            _is_zsh && hash "${GNU_TOOL##*/}=${GNU_TOOL}"
            _is_bash && hash -p "${GNU_TOOL}" "${GNU_TOOL##*/}"
        done
    done
    unset GNU_DIR GNU_TOOL
fi

# fx: json processor
# https://github.com/antonmedv/fx
# TODO: check if there's a conflict
if _is_macos && _command_exists "fx"; then
    # shellcheck source=/dev/null
    _is_bash && source <(fx --comp bash)
    # shellcheck source=/dev/null
    _is_zsh && source <(fx --comp zsh)
fi

# iTerm2 shell integration
# https://iterm2.com/documentation-shell-integration.html
if [[ ${TERM_PROGRAM} == "iTerm.app" ]]; then
    # Enable tmux integration
    export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=1
    # Standard shell integration setup from iTerm2
    # shellcheck source=/dev/null
    _is_zsh && test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
    # shellcheck source=/dev/null
    _is_bash && test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
fi
