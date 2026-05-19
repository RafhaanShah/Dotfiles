### wsl specifics
# shellcheck shell=bash

# gets a Windows Environment variable
wslvar() {
    local value
    value=$(powershell.exe -Command "[Environment]::GetEnvironmentVariable('${1}')")
    if [ -z "${value}" ]; then
        return 1
    else
        printf '%s\n' "${value}" | tr -d '\r'
    fi
}

# opens file or folder in default app
alias open='wslview'

# windows HOME directory
WHOME="$(wslpath "$(wslvar USERPROFILE)")"
alias whome='cd ${WHOME}'
alias wh='whome'

# cd with windows path support
unalias c
c() {
    if [[ $1 == *"\\"* ]] || [[ $1 =~ ^[a-zA-Z]: ]]; then
        cd "$(wslpath "$1")" || return
    else
        cd "$@" || return
    fi
}
