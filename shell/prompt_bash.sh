### bash prompt
# https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html#Controlling-the-Prompt
# shellcheck shell=bash

# runs after each command, before PS1 is printed
_prompt_command() {
    local EXIT="$?"
    PS1="\[\e]0;\u@\h: \w\a\]"     # set terminal title
    PS1+="\n${_PROMPT_STR}"$'\n'"" # user, host, dir, git
    _prompt_dir_changed && ls      # auto ls if dir changed

    if [ "${EXIT}" -eq 0 ]; then
        PS1+="${_PROMPT_CH_OK}"
    else
        PS1+="${_PROMPT_CH_ERR}"
    fi
}

PROMPT_COMMAND="${PROMPT_COMMAND}${PROMPT_COMMAND:+;}_prompt_command"
PROMPT_COMMAND="${PROMPT_COMMAND//;;/;}"

if _colour_true; then
    _PROMPT_COL_USER="\[\e[1;38;2;166;226;46m\]"  # green
    _PROMPT_COL_HOST="\[\e[1;38;2;253;151;31m\]"  # orange
    _PROMPT_COL_DIR="\[\e[1;38;2;102;217;239m\]"  # cyan
    _PROMPT_COL_GIT="\[\e[1;38;2;249;38;114m\]"   # pink
    _PROMPT_COL_OK="\[\e[1;38;2;166;226;46m\]"    # green
    _PROMPT_COL_ERR="\[\e[1;38;2;248;53;53m\]"    # red
    _PROMPT_COL_NORM="\[\e[1;38;2;248;248;241m\]" # white
elif _colour_256; then
    _PROMPT_COL_USER="\[\e[1;38;5;112m\]" # green
    _PROMPT_COL_HOST="\[\e[1;38;5;208m\]" # orange
    _PROMPT_COL_DIR="\[\e[1;38;5;81m\]"   # cyan
    _PROMPT_COL_GIT="\[\e[1;38;5;197m\]"  # pink
    _PROMPT_COL_OK="\[\e[1;38;5;112m\]"   # green
    _PROMPT_COL_ERR="\[\e[1;38;5;196m\]"  # red
    _PROMPT_COL_NORM="\[\e[1;38;5;255m\]" # white
else
    _PROMPT_COL_USER="\[\e[1;92m\]" # green
    _PROMPT_COL_HOST="\[\e[1;93m\]" # yellow
    _PROMPT_COL_DIR="\[\e[1;96m\]"  # cyan
    _PROMPT_COL_GIT="\[\e[1;91m\]"  # red
    _PROMPT_COL_OK="\[\e[1;92m\]"   # green
    _PROMPT_COL_ERR="\[\e[1;91m\]"  # red
    _PROMPT_COL_NORM="\[\e[1;97m\]" # white
fi

_PROMPT_COL_RESET="\[\e[0m\]" # reset colour
_PROMPT_ARROW=$'\u2192'       # git arrow
_PROMPT_CHAR=$'\u276F'        # prompt character

_PROMPT_STR="${_PROMPT_COL_USER}\u "                                                      # user
_PROMPT_STR+="${_PROMPT_COL_NORM}@ ${_PROMPT_COL_HOST}\h "                                # host
_PROMPT_STR+="${_PROMPT_COL_NORM}: ${_PROMPT_COL_DIR}\w "                                 # directory
_PROMPT_STR+="\$(_prompt_git \"${_PROMPT_COL_NORM}${_PROMPT_ARROW} ${_PROMPT_COL_GIT}\")" # git

_PROMPT_CH_OK="${_PROMPT_COL_OK}${_PROMPT_CHAR} ${_PROMPT_COL_RESET}"   # success prompt
_PROMPT_CH_ERR="${_PROMPT_COL_ERR}${_PROMPT_CHAR} ${_PROMPT_COL_RESET}" # error prompt

unset _PROMPT_COL_USER _PROMPT_COL_HOST _PROMPT_COL_DIR
unset _PROMPT_COL_GIT _PROMPT_COL_OK _PROMPT_COL_ERR _PROMPT_COL_NORM
unset _PROMPT_COL_RESET _PROMPT_CHAR _PROMPT_ARROW
