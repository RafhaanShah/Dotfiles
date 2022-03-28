### zsh configuration
# http://zsh.sourceforge.net/Doc/Release/
# shellcheck shell=bash
# shellcheck disable=SC2034
# shellcheck source=/dev/null

# load config
[ -f "${HOME}/Dotfiles/shell/loader.sh" ] && source "${HOME}/Dotfiles/shell/loader.sh"

### shell hook functions
# http://zsh.sourceforge.net/Doc/Release/Functions.html#Hook-Functions

# do not add HIST_IGNORE commands to interactive history, filter overly long commands
# shellcheck disable=SC2053
_zshaddhistory_filter() { [[ ${1%%$'\n'} != ${~HISTORY_IGNORE} ]] && [ ${#1%%$'\n'} -lt 50 ]; }
zshaddhistory_functions+=(_zshaddhistory_filter)

### overrides

# prevents zsh trying to correct commands to filenames with sudo
# https://stackoverflow.com/questions/17399056/zsh-tries-to-correct-a-command-to-a-file
alias sudo='nocorrect sudo '

# make history command behave like bash
history() { builtin history -E -"$*"; }

### shell parameters
# http://zsh.sourceforge.net/Doc/Release/Parameters.html#Parameters-Used-By-The-Shell

# history file
HISTFILE="${HOME}/.zsh_history"
# history file size
HISTSIZE=10000
# ignores common commands when saving command history
HISTORY_IGNORE="(cd*|ls*|pwd|clear|bg*|fg*|exit|hist*)"
# maximum number of history events
SAVEHIST=10000

### shell options
# http://zsh.sourceforge.net/Doc/Release/Options.html

# disable beep on completion list
unsetopt LIST_BEEP
# corrects "c" to "C" and shows the completion menu in 1 tab press
unsetopt LIST_AMBIGUOUS

# automatically cd if given a directory name
setopt AUTO_CD
# make cd push the old directory
setopt AUTO_PUSHD
# Assume that the terminal displays combining characters correctly
setopt COMBINING_CHARS
# try to correct the spelling of commands
setopt CORRECT
# try to correct the spelling of all arguments (gets a bit annoying sometimes)
# setopt CORRECT_ALL
# treat ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation
setopt EXTENDED_GLOB
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST
# ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# remove old duplications
setopt HIST_IGNORE_ALL_DUPS
# remove lines starting with a space
setopt HIST_IGNORE_SPACE
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
# perform !! expansion for confirmation
setopt HIST_VERIFY
# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY
# print error when pattern has no matches
setopt NOMATCH
# expand prompt strings
setopt PROMPT_SUBST
# ignore pushd duplicates
setopt PUSHD_IGNORE_DUPS
# make pushd silent
setopt PUSHD_SILENT
# share history across multiple zsh sessions
setopt SHARE_HISTORY

### zsh plugins
# zinit: fast plugin manager: https://github.com/zdharma/zinit
# zinit self-update (zinit) | zinit update --all (plugins)

_configure_autosuggestions() {
    # disable automatic widget re-binding on each precmd for speed
    ZSH_AUTOSUGGEST_MANUAL_REBIND=1
    # use async suggestion loading
    ZSH_AUTOSUGGEST_USE_ASYNC=1
    # disable suggestion for large buffers
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
    # suggest from history and possible completions
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    # ignore patterns for history suggestions
    ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *|c *|mkdir *|mkd *|cat *|nano *|?(#c50,)"
    # ignore patterns for completion suggestions
    ZSH_AUTOSUGGEST_COMPLETION_IGNORE="echo *"
    # accept the current suggestion word with ctrl space
    bindkey '^ ' forward-word
}

_load_completions() {
    zinit ice blockf # block the traditional method of adding completions, zinit uses own method
    zinit light zsh-users/zsh-completions
    
    zinit ice as"completion" id-as"_cht.sh" # needs to be _command to work
    zinit snippet 'https://cheat.sh/:zsh'
    
    zinit ice as"completion"
    zinit snippet 'OMZ::plugins/docker/_docker'
    
    zinit ice as"completion"
    zinit snippet 'OMZ::plugins/docker-compose/_docker-compose'
    
    zinit ice as"completion"
    zinit snippet 'OMZ::plugins/pip/_pip'
}

# if zinit is installed, setup and load plugins
if [[ -f "${HOME}/.zinit/bin/zinit.zsh" ]]; then
    source "${HOME}/.zinit/bin/zinit.zsh"
    autoload -Uz _zinit
    # shellcheck disable=SC2154
    (( ${+_comps} )) && _comps[zinit]=_zinit

    zinit light-mode for \
        'zdharma-continuum/zinit-annex-readurl' \
        'zdharma-continuum/zinit-annex-bin-gem-node' \
        'zdharma-continuum/zinit-annex-patch-dl' \
        'zdharma-continuum/zinit-annex-rust'

	{ command -v "fzf" >/dev/null 2>&1 && zinit light 'Aloxaf/fzf-tab'} || true

    _load_completions
    _configure_autosuggestions
    
    zinit ice wait lucid atload'_zsh_autosuggest_start'
    zinit light 'zsh-users/zsh-autosuggestions'

    zinit light 'djui/alias-tips'
    export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES="_ - -- .. cd.. c cat cmd cls dl dk dkc fu g l ll la o open plz v view"
    
    zinit light 'romkatv/gitstatus'
    _prompt_git_fast

    zinit ice wait'1' lucid
    zinit light 'laggardkernel/zsh-thefuck'

    # syntax highlighting must be sourced last
    zinit light 'zsh-users/zsh-syntax-highlighting'

    # but history substring search must be sourced after syntax highlighting
    zinit light 'zsh-users/zsh-history-substring-search'
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
else
    # better history search with arrows
    # https://coderwall.com/p/jpj_6q/zsh-better-history-searching-with-arrow-keys
    autoload -U up-line-or-beginning-search
    autoload -U down-line-or-beginning-search
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search
    bindkey '^[[A' up-line-or-beginning-search
    bindkey '^[[B' down-line-or-beginning-search
    bindkey "$terminfo[kcuu1]" up-line-or-beginning-search
    bindkey "$terminfo[kcud1]" down-line-or-beginning-search
fi

# unset plugin functions
unset -f _configure_autosuggestions _load_completions

### zsh completion
# http://zsh.sourceforge.net/Doc/Release/Completion-System.html

# completer functions to use
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
# case insensitive fuzzy completion https://scriptingosx.com/2019/07/moving-to-zsh-part-5-completions/
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
# max errors for _approximate _correct completer functions
zstyle ':completion:*' max-errors 0 # 0 works better with fuzzy completion
# set color specifications for completion, use LS_COLORS
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# 1st tab lists suggestions, 2nd tab starts menu
zstyle ':completion:*' menu select
# what is displayed during menu selection
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

# fzf-tab previews https://github.com/Aloxaf/fzf-tab/wiki/Preview
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd "${realpath}"'
zstyle ':fzf-tab:complete:(cat|bat|head|tail|less|more):*' fzf-preview 'bat --color=always --plain --line-range=:100 "${realpath}"'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status "${word}"'
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo "${(P)word}"'

# initialize zsh completion (should be after zinit plugins)
autoload -Uz compinit
if [[ -n  "${ZDOTDIR:-${HOME}}/.zcompdump"(#qN.mh+20) ]]; then
	compinit;
else
	compinit -C;
fi

# complete 'zoxide' command with directories
compdef _directories __zoxide_z __zoxide_zi

### shell key bindings
# accept menu option and run command with one enter press like bash
zmodload -i zsh/complist # http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html#The-zsh_002fcomplist-Module
bindkey -M menuselect '^M' .accept-line
