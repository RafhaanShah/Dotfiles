### wsl specifics
# shellcheck shell=bash

# opens file or folder in default app
alias open='wslview'

# windows HOME directory
export WHOME="$(wslpath "$(wslvar USERPROFILE)")"
