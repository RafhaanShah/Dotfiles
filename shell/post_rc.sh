### config required at the end of rc file load
# shellcheck shell=bash

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
