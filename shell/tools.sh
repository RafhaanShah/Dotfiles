### cli tools
# shellcheck shell=bash

# asdf: language version manager
# https://github.com/asdf-vm/asdf
if [ -f "${HOME}/.asdf/asdf.sh" ]; then
    export ASDF_DIR="${HOME}/.asdf"
    _load_file "${ASDF_DIR}/asdf.sh"                           # load asdf
    _is_bash && _load_file "${ASDF_DIR}/completions/asdf.bash" # asdf bash completions
    _is_zsh && _add_to_fpath "${ASDF_DIR}/completions"         # asdf zsh completions
fi

# bat: better cat
# https://github.com/sharkdp/bat
if _command_exists "bat"; then
    alias cat='bat --plain'
    alias view='bat'
fi

# bpytop: better top
# https://github.com/aristocratos/bpytop
if _command_exists "bpytop"; then
    alias top='bpytop'
fi

# fd: better find
# https://github.com/sharkdp/fd
if _command_exists "fd"; then
    unset -f ffile
    alias ffile='fd'
fi

# lsd: ls with icons https://github.com/Peltoche/lsd
# needs a patched font, e.g: hack-nerd-font https://github.com/ryanoasis/nerd-fonts
# on iTerm2, set 'non-ascii font'
if _command_exists "lsd"; then
    alias ls='lsd --group-dirs first'
    tree() {
        if [ "$#" -eq 0 ]; then
            lsd --group-dirs first --tree --depth 2
        else
            lsd --group-dirs first --tree --depth "$@"
        fi
    }
fi

# micro: better nano
# https://github.com/zyedidia/micro
if _command_exists "micro"; then
    export EDITOR="micro"
    export VISUAL="${EDITOR}"
    export GIT_EDITOR="${EDITOR}"
fi

# ripgrep: better grep
# https://github.com/burntsushi/ripgrep
if _command_exists "rg"; then
    unset -f ftext
    alias ftext='rg'
fi

# thefuck: magnificent corrector
# https://github.com/nvbn/thefuck
if _command_exists "thefuck"; then
    unalias fuck
    # eval $(thefuck --alias)
fi

# vivid: generate LS_COLORS
# https://github.com/sharkdp/vivid
if _command_exists "vivid"; then
    if _colour_true; then
        LS_COLORS="$(vivid generate "${DOTFILE_DIR}/config/vivid/monokai.yml")"
    elif _colour_256; then
        LS_COLORS="$(vivid -m 8-bit generate "${DOTFILE_DIR}/config/vivid/monokai.yml")"
    fi
    export LS_COLORS
fi

# zoxide: better cd
# https://github.com/ajeetdsouza/zoxide
if _command_exists "zoxide"; then
    _is_bash && eval "$(zoxide init bash)"
    _is_zsh && eval "$(zoxide init zsh)"
    alias c='z'
fi
