### wsl specifics
# shellcheck shell=bash

# opens file or folder in default app
alias open='wslview'

# windows HOME directory
WHOME="$(wslpath "$(wslvar USERPROFILE)")"
alias wh='cd ${WHOME}'
