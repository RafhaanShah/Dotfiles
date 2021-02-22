### zsh prompt
# http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
# shellcheck shell=bash
# shellcheck disable=SC2034

# runs after each command, before PROMPT is printed
_precmd_prompt() {
    local EXIT="$?"; local _NEWLINE=$'\n' # new line
    PROMPT=$'%{\e]0;%n@%m: %3~\a%}' # set terminal title
    PROMPT+="${_NEWLINE}${_PROMPT_STR}${_NEWLINE}" # user, host, dir, git
    _prompt_dir_changed && ls # auto ls if dir changed
    
    if [ "${EXIT}" -eq 0 ]; then
        PROMPT+="${_PROMPT_CH_OK}"
    else
        PROMPT+="${_PROMPT_CH_ERR}"
    fi
}

precmd_functions+=( _precmd_prompt )

typeset -gA ZSH_HIGHLIGHT_STYLES # define array for highlighting styles

if _colour_true; then
    _PROMPT_COL_USER=$'%{\e[1;38;2;166;226;46m%}' # green
    _PROMPT_COL_HOST=$'%{\e[1;38;2;253;151;31m%}' # orange
    _PROMPT_COL_DIR=$'%{\e[1;38;2;102;217;239m%}' # cyan
    _PROMPT_COL_GIT=$'%{\e[1;38;2;249;38;114m%}' # pink
    _PROMPT_COL_OK=$'%{\e[1;38;2;166;226;46m%}' # green
    _PROMPT_COL_ERR=$'%{\e[1;38;2;248;53;53m%}' # red
    _PROMPT_COL_NORM=$'%{\e[1;38;2;248;248;241m%}' # white
    
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#9e9e9e' # grey
    ZSH_HIGHLIGHT_STYLES[arg0]='fg=#a6e22e,bold' # green
    ZSH_HIGHLIGHT_STYLES[path]='fg=#66d9ef' # blue
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#ffd75f' # yellow
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#ffd75f' # yellow
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#ffd75f' # yellow
elif _colour_256; then
    _PROMPT_COL_USER=$'%{\e[1;38;5;112m%}' # green
    _PROMPT_COL_HOST=$'%{\e[1;38;5;208m%}' # orange
    _PROMPT_COL_DIR=$'%{\e[1;38;5;81m%}' # cyan
    _PROMPT_COL_GIT=$'%{\e[1;38;5;197m%}' # pink
    _PROMPT_COL_OK=$'%{\e[1;38;5;112m%}' # green
    _PROMPT_COL_ERR=$'%{\e[1;38;5;196m%}' # red
    _PROMPT_COL_NORM=$'%{\e[1;38;5;255m%}' # white
    
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=247' # grey
    ZSH_HIGHLIGHT_STYLES[arg0]='fg=112,bold' # green
    ZSH_HIGHLIGHT_STYLES[path]='fg=81' # cyan
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=221' # yellow
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=221' # yellow
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=221' # yellow
else
    _PROMPT_COL_USER=$'%{\e[1;92m%}' # green
    _PROMPT_COL_HOST=$'%{\e[1;93m%}' # yellow
    _PROMPT_COL_DIR=$'%{\e[1;96m%}' # cyan
    _PROMPT_COL_GIT=$'%{\e[1;91m%}' # red
    _PROMPT_COL_OK=$'%{\e[1;92m%}' # green
    _PROMPT_COL_ERR=$'%{\e[1;91m%}' # red
    _PROMPT_COL_NORM=$'%{\e[1;97m%}' # white
    
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8' # grey
    ZSH_HIGHLIGHT_STYLES[arg0]='fg=10,bold' # green
    ZSH_HIGHLIGHT_STYLES[path]='fg=14' # cyan
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=11' # yellow
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=11' # yellow
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=11' # yellow
fi

_PROMPT_COL_RESET=$'%{\e[0m%}' # reset colour
_PROMPT_ARROW=$'\u2192' # git arrow
_PROMPT_CHAR=$'\u276F' # prompt character

_PROMPT_STR="${_PROMPT_COL_USER}%n " # user
_PROMPT_STR+="${_PROMPT_COL_NORM}@ ${_PROMPT_COL_HOST}%m " # host
_PROMPT_STR+="${_PROMPT_COL_NORM}: ${_PROMPT_COL_DIR}%3~ " # directory
_PROMPT_STR+="\$(_prompt_git '${_PROMPT_COL_NORM}${_PROMPT_ARROW} ${_PROMPT_COL_GIT}')" # git

_PROMPT_CH_OK="${_PROMPT_COL_OK}${_PROMPT_CHAR} ${_PROMPT_COL_RESET}" # success prompt
_PROMPT_CH_ERR="${_PROMPT_COL_ERR}${_PROMPT_CHAR} ${_PROMPT_COL_RESET}" # error prompt

unset _PROMPT_COL_USER _PROMPT_COL_HOST _PROMPT_COL_DIR
unset _PROMPT_COL_GIT _PROMPT_COL_OK _PROMPT_COL_ERR _PROMPT_COL_NORM
unset _PROMPT_COL_RESET _PROMPT_CHAR _PROMPT_ARROW
