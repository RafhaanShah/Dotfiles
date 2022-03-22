### bash configuration
# https://www.gnu.org/software/bash/manual/html_node/index.html
# shellcheck shell=bash
# shellcheck source=/dev/null

# if not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return ;;
esac

# load config
[ -f "${HOME}/Dotfiles/shell/loader.sh" ] && source "${HOME}/Dotfiles/shell/loader.sh"

### overrides

# append and read new history after every command so it is available in other terminals
PROMPT_COMMAND="${PROMPT_COMMAND}${PROMPT_COMMAND:+;}history -a; history -n"
PROMPT_COMMAND="${PROMPT_COMMAND//;;/;}"

### shell variables
# https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html

# remove duplicates and ignore lines starting with a space
HISTCONTROL="erasedups:ignorespace"
# ignores common commands when saving command history
HISTIGNORE="cd*:ls*:pwd:clear:bg*:fg*:exit:hist*"
# sets history size
HISTSIZE=10000
# show time with history
HISTTIMEFORMAT="%d.%m.%y %T "
# truncates directory names when X levels deep
PROMPT_DIRTRIM=3

### shell options
# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html

# auto cd's into directories when typed in
shopt -s autocd
# check the window size after each command
shopt -s checkwinsize
# "**" used in a pathname expansion context will match all files and subdirectories
shopt -s globstar
# history list is appended to instead of overwritten
shopt -s histappend
# attempts spelling correction on directory names during word completion
shopt -s dirspell
# minor errors in the spelling of a directory component in a cd command will be corrected
shopt -s cdspell
# case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

### readline settings
# https://www.gnu.org/software/bash/manual/html_node/Readline-Init-File-Syntax.html

# turn off beeps
bind 'set bell-style none'
# displays possible completions using different colors from LS_COLORS
bind 'set colored-stats on'
# when completing case will not be taken into consideration
bind 'set completion-ignore-case on'
# underscores and hyphens are treated equally when completing
bind 'set completion-map-case on'
# sets maximum number of characters to be the common prefix to display for completions
bind 'set completion-prefix-display-length 8'
# completed names which are symbolic links to directories have a slash appended
bind 'set mark-symlinked-directories on'
# displays the common prefix of the list of possible completions
bind 'set menu-complete-display-prefix on'
# attempting completion when the cursor is after the ‘e’ in ‘Makefile’ will result in ‘Makefile’ rather than ‘Makefilefile’
bind 'set skip-completed-text on'
# words which have more than one possible completion cause the matches to be listed immediately
bind 'set show-all-if-ambiguous on'
# any ! combinations will be auto-expanded when you hit space
bind 'Space:magic-space'
# replaces the word to be completed with a single match from the list of possible completions
bind 'TAB:menu-complete'
# menu complete but backwards
bind '"\e[Z":menu-complete-backward'
# up arrow previous command takes in partially typed commands
bind '"\e[A":history-substring-search-backward'
# same for down arrow
bind '"\e[B":history-substring-search-forward'

### programmable completion
# https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion.html
# enable programmable completion features
# https://github.com/scop/bash-completion
if ! shopt -oq posix; then
    if [ -f "/usr/share/bash-completion/bash_completion" ]; then
        source "/usr/share/bash-completion/bash_completion"
    elif [ -f "/etc/bash_completion" ]; then
        source "/etc/bash_completion"
    fi
fi

# https://github.com/Charlietje/bash/blob/master/bashrc.sh#L161
# shellcheck disable=SC2001,SC2086,SC2196,SC2207,SC2155,SC2206,SC2012,SC2035,SC2001,SC2086
_fuzzy_file_completion() {
    local IFS=$'\n'
    if [ -z $2 ]; then
        COMPREPLY=($(\ls))
    else
        local DIR="$2"
        if [[ $DIR =~ ^~ ]]; then
            DIR="${2/\~/$HOME}"
        fi
        local DIRPATH=$(echo "$DIR" | sed 's|[^/]*$||' | sed 's|//|/|')
        local BASENAME=$(echo "$DIR" | sed 's|.*/||')
        local FILTER=$(echo "$BASENAME" | sed 's|.|\0.*|g')
        if [[ $BASENAME == .* ]]; then
            local FILES=$(\ls -A $DIRPATH 2>/dev/null)
        else
            local FILES=$(\ls -A $DIRPATH 2>/dev/null | egrep -v '^\.')
        fi
        local X=$(echo "$FILES" | \grep -i "$BASENAME" 2>/dev/null)
        if [ -z "$X" ]; then
            X=$(echo "$FILES" | \grep -i "$FILTER" 2>/dev/null)
        fi
        COMPREPLY=($X)
        COMPREPLY=("${COMPREPLY[@]/#/$DIRPATH}")
    fi
}

# https://github.com/OpsCharlie/bash/blob/master/bashrc.sh#L194
# shellcheck disable=SC2001,SC2086,SC2196,SC2207,SC2155,SC2206,SC2012,SC2035,SC2001,SC2086
_fuzzy_dir_completion() {
    local IFS=$'\n'
    if [ -z $2 ]; then
        COMPREPLY=($(\ls -d */ | sed 's|/$||'))
    else
        DIR="$2"
        if [[ $DIR =~ ^~ ]]; then
            DIR="${2/\~/$HOME}"
        fi
        DIRPATH=$(echo "$DIR" | sed 's|[^/]*$||' | sed 's|//|/|')
        BASENAME=$(echo "$DIR" | sed 's|.*/||')
        FILTER=$(echo "$BASENAME" | sed 's|.|\0.*|g')
        if [[ $BASENAME == .* ]]; then
            if [ -z "$DIRPATH" ]; then
                DIRS=$(\ls -d .*/ | \egrep -v '^\./$|^\.\./$')
            else
                DIRS=$(\ls -d ${DIRPATH}.*/ | sed "s|^$DIRPATH||g" | \egrep -v '^\./$|^\.\./$')
            fi
        else
            if [ -z "$DIRPATH" ]; then
                DIRS=$(\ls -d ${DIRPATH}*/ 2>/dev/null)
            else
                DIRS=$(\ls -d ${DIRPATH}*/ 2>/dev/null | sed "s|^$DIRPATH||g")
            fi
        fi
        X=$(echo "$DIRS" | \grep -i "$BASENAME" 2>/dev/null | sed 's|/$||g')
        if [ -z "$X" ]; then
            X=$(echo "$DIRS" | \grep -i "$FILTER" 2>/dev/null | sed 's|/$||g')
        fi
        COMPREPLY=($X)
        COMPREPLY=("${COMPREPLY[@]/#/$DIRPATH}")
    fi
}

# https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html
# allows fuzzy completion for file/dir names: cd tuf<TAB> => cd Stuff
complete -o nospace -o filenames -o bashdefault -F _fuzzy_file_completion ls cat less tail cp mv nano
complete -o nospace -o filenames -o bashdefault -F _fuzzy_dir_completion cd mkdir
