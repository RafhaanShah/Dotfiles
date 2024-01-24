### functions used in prompts
# shellcheck shell=bash
# shellcheck disable=SC2317

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

        _is_zsh && IFS=$'/' read -r -A _PATH_PARTS <<<"${PWD}"
        _is_bash && IFS=$'/' read -r -a _PATH_PARTS <<<"${PWD}"

        for part in "${_PATH_PARTS[@]}"; do
            _in_list "${part}" "${_PROMPT_GIT_STATUS_BLOCKLIST[@]}" && return 1
        done
    fi

    return 0
}

# faster git status for prompts
# https://github.com/romkatv/gitstatus
_prompt_git_fast() {
    # start gitstatusd instance with name "MY"
    # enable staged, unstaged, conflicted and untracked counters.
    gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'

    # git repo status in the form: branch [↓1↑2|✔ ✖3✚4●5◯6‡7]
    # branch name, behind, ahead, clean, conflicts, staged, unstaged, untracked, stashes
    _prompt_git() {
        _prompt_git_blocklist || return 1
        if gitstatus_query 'MY' && [[ ${VCS_STATUS_RESULT} == 'ok-sync' ]]; then
            local gitstring
            gitstring="${VCS_STATUS_LOCAL_BRANCH:-${VCS_STATUS_COMMIT:0:7}} ["

            local upstream
            [ "${VCS_STATUS_COMMITS_BEHIND}" -gt 0 ] && upstream+="↓${VCS_STATUS_COMMITS_BEHIND}"
            [ "${VCS_STATUS_COMMITS_AHEAD}" -gt 0 ] && upstream+="↑${VCS_STATUS_COMMITS_AHEAD}"
            [ -n "${upstream}" ] && gitstring+="${upstream}|"

            local changes
            [ "${VCS_STATUS_NUM_CONFLICTED}" -gt 0 ] && changes+="✖${VCS_STATUS_NUM_CONFLICTED}"
            [ "${VCS_STATUS_NUM_STAGED}" -gt 0 ] && changes+="✚${VCS_STATUS_NUM_STAGED}"
            [ "${VCS_STATUS_NUM_UNSTAGED}" -gt 0 ] && changes+="●${VCS_STATUS_NUM_UNSTAGED}"
            [ "${VCS_STATUS_NUM_UNTRACKED}" -gt 0 ] && changes+="◯${VCS_STATUS_NUM_UNTRACKED}"
            [ "${VCS_STATUS_STASHES}" -gt 0 ] && changes+="‡${VCS_STATUS_STASHES}"

            changes="${changes:-✔}"
            gitstring+="${changes}"
            echo -e "${1}${gitstring}]"
        fi
    }
}

# git repo status in the form: branch [↓1↑2|✔ ✖3✚4●5◯]
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
    local changes
    [ "${num_conflicts}" -gt 0 ] && changes+="✖${num_conflicts}" # conflicts
    [ "${num_staged}" -gt 0 ] && changes+="✚${num_staged}"       # staged
    [ "${num_changed}" -gt 0 ] && changes+="●${num_changed}"     # unstaged
    [ "${num_untracked}" -gt 0 ] && changes+="◯${num_untracked}" # untracked

    changes="${changes:-✔}" # clean
    gitstring+="${changes}"

    echo -e "${1}${gitstring}]"
}

# git repo status in the form: branch [1x+!?]
# branch, number of changes, conflicts, staged, unstaged, untracked
# adapted from https://github.com/mathiasbynens/dotfiles/blob/main/.bash_prompt
_prompt_git_basic() {
    _is_git_repo || return 1
    _prompt_git_blocklist || return 1

    local str=''
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
        str+="${fcount}"
    fi
    # check for conflicts
    if ! git diff --quiet --ignore-submodules --diff-filter=U; then
        str+='x'
    fi
    # check for uncomitted changes
    if ! git diff --quiet --ignore-submodules --cached; then
        str+='+'
    fi
    # check for unstaged changes
    if ! git diff-files --quiet --ignore-submodules; then
        str+='!'
    fi
    # check for untracked files
    if [ -n "$(git ls-files --others --exclude-standard)" ]; then
        str+='?'
    fi

    [ -n "${str}" ] && str=" [${str}]"
    echo -e "${1}${br}${str}"
}
