#!/usr/bin/env zsh
# shellcheck shell=bash

# exit on any error, unset variable, or failed piped commands
set -euo pipefail

# setup zinit https://github.com/zdharma/zinit
if [[ ! -f "${HOME}/.zinit/bin/zinit.zsh" ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "${HOME}/.zinit" && command chmod g-rwX "${HOME}/.zinit"
    # shellcheck disable=SC2015
    command git clone 'https://github.com/zdharma/zinit' "${HOME}/.zinit/bin" &&
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" ||
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
