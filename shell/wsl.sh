### wsl specifics
# shellcheck shell=bash

# gets a Windows Environment variable
wslvar() {
    local value
    value=$(powershell.exe -Command "[Environment]::GetEnvironmentVariable('${1}')")
    if [ -z "${value}" ]; then
        return 1
    else
        echo "$value"
    fi
}

# opens file or folder in default app
alias open='wslview'

# windows HOME directory
WHOME="$(wslpath "$(wslvar USERPROFILE)")"
alias wh='cd ${WHOME}'
