### functions used in prompts
# shellcheck shell=bash

# set this varable to disable git-prompt in specific repos
# _PROMPT_GIT_STATUS_BLOCKLIST=(
#     "large-repo"
#     "another-folder"
# )

# checks if either pwd or git st has changed
_prompt_show_status() {
    local rc=1
    _prompt_dir_changed && rc=0
    _prompt_git_changed && rc=0
    return "${rc}"
}

# checks if the working directory has changed
_prompt_dir_changed() {
    [ "${_PROMPT_PWD}" != "${PWD}" ] && _PROMPT_PWD="${PWD}" && return 0
    return 1
}

# checks if there have been any git changes
_prompt_git_changed() {
    _is_git_repo || return 1
    _prompt_git_blocklist || return 1
    local gs
    gs="$(git status --porcelain --branch --ignore-submodules)"
    [ "${_PROMPT_GIT_STATUS}" != "${gs}" ] && _PROMPT_GIT_STATUS="${gs}" && return 0
    return 1
}

# checks if git prompt should be ignored
_prompt_git_blocklist() {
    if _variable_set "${_PROMPT_GIT_STATUS_BLOCKLIST}"; then
        local wd="${PWD##*/}"
        _in_list "${wd}" "${_PROMPT_GIT_STATUS_BLOCKLIST[@]}" && return 1
    fi
}

# git repo status in the form: branch [↓2↑3|✔1✖2✚3●4◯]
# branch name, behind, ahead, clean, conflicts, staged, unstaged, untracked
# adapted from https://github.com/magicmonty/bash-git-prompt/blob/master/gitstatus.sh
_prompt_git() {
    _is_git_repo || return 1
    _prompt_git_blocklist || return 1

    # get git status string in porcelain format with branch
    local gitstatus
    gitstatus="$(git status --porcelain --branch --ignore-submodules)"
    # local gitstatus="${_PROMPT_GIT_STATUS}" # set by _prompt_git_changed

    local num_staged=0
    local num_changed=0
    local num_conflicts=0
    local num_untracked=0
    local stat_line line branch_line

    # loop over status lines
    while IFS='' read -r line || [[ -n ${line} ]]; do
        stat_line="${line:0:2}"
        while [[ -n ${stat_line} ]]; do
            case "${stat_line}" in
                \#\#)
                    branch_line="${line/\#\# /}"
                    break
                    ;; # format: ## master...origin/master
                \?\?)
                    ((num_untracked++))
                    break
                    ;;
                U?)
                    ((num_conflicts++))
                    break
                    ;;
                ?U)
                    ((num_conflicts++))
                    break
                    ;;
                DD)
                    ((num_conflicts++))
                    break
                    ;;
                AA)
                    ((num_conflicts++))
                    break
                    ;;
                ?M) ((num_changed++)) ;;
                ?D) ((num_changed++)) ;;
                ?\ ) ;;
                U) ((num_conflicts++)) ;;
                \ ) ;;
                *) ((num_staged++)) ;;
            esac
            stat_line="${stat_line:0:${#stat_line}-1}"
        done
    done <<<"${gitstatus}"

    # separate branch string
    branch="${branch_line%%...*}" # removes ...origin/master

    local gitstring="${branch} ["
    local upstream
    upstream="$(git rev-list --left-right --count origin/"${branch}"...HEAD 2>/dev/null)"

    # check for divergences from upstream (origin/branch)
    if [ -n "${upstream}" ]; then
        local behind
        behind="$(cut -f1 <<<"${upstream}")"
        local ahead
        ahead="$(cut -f2 <<<"${upstream}")"
        local upstring

        [ "${behind}" -gt 0 ] && upstring+="↓${behind}"   # commits behind
        [ "${ahead}" -gt 0 ] && upstring+="↑${ahead}"     # commits ahead
        [ -n "${upstring}" ] && gitstring+="${upstring}|" # separator
    fi

    # count changes of each type
    if ((num_changed == 0 && \
        num_staged == 0 && \
        num_untracked == 0 && \
        num_conflicts == 0)); then
        gitstring+="✔" # clean
    else
        [ "${num_conflicts}" -gt 0 ] && gitstring+="✖${num_conflicts}" # conflicts
        [ "${num_staged}" -gt 0 ] && gitstring+="✚${num_staged}"       # staged
        [ "${num_changed}" -gt 0 ] && gitstring+="●${num_changed}"     # unstaged
        [ "${num_untracked}" -gt 0 ] && gitstring+="◯${num_untracked}" # untracked
    fi

    echo -e "${1}${gitstring}]"
}

# outputs git branch and status: master [1x+!?]
# branch, number of changes, conflicts, staged, unstaged, untracked
# adapted from https://github.com/mathiasbynens/dotfiles/blob/main/.bash_prompt
_prompt_git_old() {
    _is_git_repo || return 1
    _prompt_git_blocklist || return 1

    local s=''
    local br=''

    # check branch
    br="$(git symbolic-ref --quiet --short HEAD 2>/dev/null ||
        git describe --all --exact-match HEAD 2>/dev/null ||
        git rev-parse --short HEAD 2>/dev/null ||
        echo 'unknown')"

    # check for status counter
    local fcount
    fcount="$(git status --porcelain --ignore-submodules | wc -l | tr -d ' ')"
    if [ "${fcount}" -gt 0 ]; then
        s+="${fcount}"
    fi
    # check for conflicts
    if ! git diff --quiet --ignore-submodules --diff-filter=U; then
        s+='x'
    fi
    # check for uncomitted changes
    if ! git diff --quiet --ignore-submodules --cached; then
        s+='+'
    fi
    # check for unstaged changes
    if ! git diff-files --quiet --ignore-submodules; then
        s+='!'
    fi
    # check for untracked files
    if [ -n "$(git ls-files --others --exclude-standard)" ]; then
        s+='?'
    fi

    [ -n "${s}" ] && s=" [${s}]"
    echo -e "${1}${br}${s}"
}
