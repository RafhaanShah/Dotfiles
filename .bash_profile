### bash profile file to be executed at login shells
# https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files
# shellcheck shell=bash

# source bashrc
# shellcheck source=.bashrc
[ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"
