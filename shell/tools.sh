### cli tools
# shellcheck shell=bash

# mise: language version manager
# https://mise.jdx.dev/
if _command_exists "mise"; then
    _is_bash && eval "$(mise activate bash)"
    _is_zsh && eval "$(mise activate zsh)"
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

# fzf: fuzzy finder
# https://github.com/junegunn/fzf
if _command_exists "fzf"; then
    hist() {
        history 10000 | grep "$*" | grep -v "hist" | tac | fzf
    }
fi

# lsd: ls with icons https://github.com/Peltoche/lsd
# needs a patched font, e.g: hack-nerd-font https://github.com/ryanoasis/nerd-fonts
# on iTerm2, set 'non-ascii font'
if _command_exists "lsd"; then
    alias ls='lsd --group-dirs first'
    tree() {
        lsd --group-dirs first --tree --depth "${1:-2}"
    }
fi

# micro: better nano
# https://github.com/zyedidia/micro
if _command_exists "micro"; then
    export EDITOR="micro"
    export VISUAL="${EDITOR}"
    export GIT_EDITOR="${EDITOR}"
    alias nano='micro'
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

# tldr: better man pages
# https://github.com/tldr-pages/tldr
if _command_exists "tldr"; then
    alias man='tldr'
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
    _is_bash && eval "$(zoxide init --no-aliases bash)"
    _is_zsh && eval "$(zoxide init --no-aliases zsh)"
    alias c='__zoxide_z'
    alias cdh='__zoxide_zi'
fi
