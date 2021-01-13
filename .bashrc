### bash configuration
# https://www.gnu.org/software/bash/manual/html_node/index.html

# if not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# load config
[ -f "${HOME}/Dotfiles/.loader" ] && source "${HOME}/Dotfiles/.loader"


### shell variables
# https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html

# remove duplicates and ignore lines starting with a space
HISTCONTROL="erasedups:ignorespace"
# ignores common commands when saving command history
HISTIGNORE="cd*:ls*:pwd:clear:bg*:fg*:exit:history*"
# sets history size
HISTSIZE=1000
# truncates directory names when X levels deep
PROMPT_DIRTRIM=4


### shell options
# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html

# auto cd's into directories when typed in
shopt -s autocd 2> /dev/null # needs Bash v4
# check the window size after each command
shopt -s checkwinsize
# "**" used in a pathname expansion context will match all files and subdirectories
shopt -s globstar 2> /dev/null # needs Bash v4
# history list is appended to instead of overwritten
shopt -s histappend
# attempts spelling correction on directory names during word completion
shopt -s dirspell 2> /dev/null
# minor errors in the spelling of a directory component in a cd command will be corrected
shopt -s cdspell 2> /dev/null
# case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob


### readline settings
# https://www.gnu.org/software/bash/manual/html_node/Readline-Init-File-Syntax.html

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
bind '"\e[A": history-search-backward'
# same for down arrow
bind '"\e[B": history-search-forward'


### programmable completion
# https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion.html

# load default programmable completions
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    elif [[ -f /usr/local/etc/bash_completion ]]; then
        source /usr/local/etc/bash_completion
    fi
fi

# add completion for SSH hostnames based on ~/.ssh/config
[[ -e "${HOME}/.ssh/config" ]] && complete -o "default" \
    -o "nospace" \
    -W "$(grep "^Host" ~/.ssh/config | \
    grep -v "[?*]" | cut -d " " -f2 | \
    tr ' ' '\n')" scp sftp ssh
