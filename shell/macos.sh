### macOS specifics
# shellcheck shell=bash

# brew: package manager for macOS https://brew.sh/
_add_to_path "/opt/homebrew/bin" # M1 mac location
if _command_exists "brew"; then
    HOMEBREW_PREFIX="$(brew --prefix)" # /usr/local

    # brew sbin
    _add_to_path "${HOMEBREW_PREFIX}/sbin"

    # gnu coreutils https://formulae.brew.sh/formula/coreutils
    _add_to_path "${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin"

    # gnu findutils https://formulae.brew.sh/formula/findutils
    _add_to_path "${HOMEBREW_PREFIX}/opt/findutils/libexec/gnubin"

    # gnu grep https://formulae.brew.sh/formula/gnu-grep
    _add_to_path "${HOMEBREW_PREFIX}/opt/grep/libexec/gnubin"

    # gnu make https://formulae.brew.sh/formula/make
    _add_to_path "${HOMEBREW_PREFIX}/opt/make/libexec/gnubin"

    # gnu sed https://formulae.brew.sh/formula/gnu-sed
    _add_to_path "${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin"

    # gnu tar https://formulae.brew.sh/formula/gnu-tar
    _add_to_path "${HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnubin"

    # gnu which https://formulae.brew.sh/formula/gnu-which
    _add_to_path "${HOMEBREW_PREFIX}/opt/gnu-which/libexec/gnubin"

    # asdf: language version manager https://formulae.brew.sh/formula/asdf
    _load_file "${HOMEBREW_PREFIX}/opt/asdf/asdf.sh"

    # brew command not found https://github.com/Homebrew/homebrew-command-not-found
    _load_file "${HOMEBREW_PREFIX}/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"

    # bash completions https://docs.brew.sh/Shell-Completion
    # https://formulae.brew.sh/formula/bash-completion@2
    if _is_bash; then
        if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
            # shellcheck source=/dev/null
            source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
        else
            for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
                # shellcheck source=/dev/null
                [[ -r ${COMPLETION} ]] && source "${COMPLETION}"
            done
        fi
    fi

    # zsh completions https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
    # _is_zsh && _add_to_fpath "${HOMEBREW_PREFIX}/share/zsh/site-functions" # seems to already be added
fi

# non gnu ls options
if ! _command_exists "gls"; then
    export CLICOLOR=1
    export LSCOLORS="GxFxcxdxbxagheabhchdad"
    alias ls='ls -G'
fi

# opens file or folder in default app (the macOS command is open)
unalias open

# clipboard
alias copy='pbcopy'
alias paste='paste'

# shows current ip information
alias ip='(ifconfig -l | xargs -n1 ipconfig getifaddr); curl http://ipecho.net/plain; echo'

# get last wake / sleep events
alias sleeplog='pmset -g log|grep -e " Sleep  " -e " Wake  " | tail'

# backup brew packages
alias brew-bkp='brew bundle dump --describe --force --file "${DOTFILE_DIR}/packages/brew.txt"'

# start spotifyd
alias spotify='spotifyd --no-daemon -b portaudio -d Spotifyd@macOS -B 320 --initial-volume 75 --volume-normalisation'

# sends a system notification
notify() { osascript -e "display notification \"$2\" with title \"$1\""; }

# rm moves to trash instead
unalias rm
rm() {
    for FILE in "$@"; do
        local BASENAME
        BASENAME="$(basename "${FILE}")"
        local COUNTER=1
        while [ -e "${HOME}/.Trash/${BASENAME}" ]; do
            BASENAME="${BASENAME}(${COUNTER})"
            COUNTER=$((COUNTER + 1))
        done
        mv "${FILE}" "${HOME}/.Trash/${BASENAME}"
    done
    unset FILE
}
