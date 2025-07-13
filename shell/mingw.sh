### mingw specifics
# shellcheck shell=bash

# opens file or folder in default app
alias open='start'

# ln does not work in mingw, it just copies
# TODO: replace with powershell or mklink
alias ln='echo "ln does not work in mingw"; false'
