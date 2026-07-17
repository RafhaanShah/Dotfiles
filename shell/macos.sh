### macOS specifics
# shellcheck shell=bash

# brew: package manager for macOS https://brew.sh/
HOMEBREW_PATH="/opt/homebrew/bin/brew"
if [ -f "${HOMEBREW_PATH}" ]; then
    eval "$(${HOMEBREW_PATH} shellenv)"

    # GNU tool hashes are set in post_rc.sh because later PATH changes clear them.

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
    # done in .zshrc
fi

# non gnu ls options
# default ls does not have some options
if ! _command_exists "gls"; then
    unalias ls
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
alias ip-address='(ifconfig -l | xargs -n1 ipconfig getifaddr); curl http://ipecho.net/plain; echo'

# get last wake / sleep events
alias sleeplog='pmset -g log|grep -e " Sleep  " -e " Wake  " | tail'

# backup brew packages
alias brew-bkp='brew bundle dump --describe --force --file "${DOTFILE_DIR}/packages/brew.txt"'

# start spotifyd
alias spotify='spotifyd --no-daemon -b portaudio -d Spotifyd@macOS -B 320 --initial-volume 75 --volume-normalisation'

# restarts audio service
alias kill-audio='sudo launchctl kickstart -k system/com.apple.audio.coreaudiod'

# allow all programs in a folder
# https://superuser.com/questions/1618945/file-developer-cannot-be-verified-error
alias allow-folder='xattr -d -r com.apple.quarantine'

# sends a system notification
notify() { osascript -e "display notification \"$2\" with title \"$1\""; }
