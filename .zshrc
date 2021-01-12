### zsh configuration
# http://zsh.sourceforge.net/Doc/Release/

# print date
command -v date > /dev/null 2>&1 && date


### overrides

# make history command behave like bash
history() { builtin history -"$*" }


### load config

# location of dotfile repository
DOTFILE_DIR="${HOME}/Dotfiles"

# load other dot files
[ -f "${DOTFILE_DIR}/.loader" ] && source "${DOTFILE_DIR}/.loader"


### shell hook functions
# http://zsh.sourceforge.net/Doc/Release/Functions.html#Hook-Functions

# do not add HIST_IGNORE commands to interactive history
function zshaddhistory() {
  [[ ${1%%$'\n'} != ${~HISTORY_IGNORE} ]]
}


### shell parameters
# http://zsh.sourceforge.net/Doc/Release/Parameters.html#Parameters-Used-By-The-Shell

# history file
HISTFILE="${HOME}/.zsh_history"
# history file size
HISTSIZE=1000
# ignores common commands when saving command history
HISTORY_IGNORE="(cd*|ls*|pwd|clear|bg*|fg*|exit|history*)"
# maximum number of history events
SAVEHIST=1000


### shell options
# http://zsh.sourceforge.net/Doc/Release/Options.html

# disable beep on completion list
unsetopt LIST_BEEP
# corrects "c" to "C" and shows the completion menu in 1 tab press
unsetopt LIST_AMBIGUOUS

# automatically cd if given a directory name
setopt AUTO_CD
# make cd push the old directory
setopt AUTO_PUSHD
# Assume that the terminal displays combining characters correctly
setopt COMBINING_CHARS
# try to correct the spelling of commands
setopt CORRECT
# try to correct the spelling of all arguments
setopt CORRECT_ALL
# treat ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation
setopt EXTENDED_GLOB
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST
# ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# remove old duplications
setopt HIST_IGNORE_ALL_DUPS
# remove lines starting with a space
setopt HIST_IGNORE_SPACE
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
# perform !! expansion for confirmation
setopt HIST_VERIFY
# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY
# print error when pattern has no matches
setopt NOMATCH
# ignore pushd duplicates
setopt PUSHD_IGNORE_DUPS
# make pushd silent
setopt PUSHD_SILENT
# share history across multiple zsh sessions
setopt SHARE_HISTORY


### shell key bindings
# use partial commands for history search with arrows
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search


### zsh completion
# http://zsh.sourceforge.net/Doc/Release/Completion-System.html

# completer functions to use
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
# small letters will match small and capital letters
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# max errors for _approximate _correct completer functions
zstyle ':completion:*' max-errors 1
# set color specifications for completion, use LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# 1st tab lists suggestions, 2nd tab starts menu
zstyle ':completion:*' menu select
# what is displayed during menu selection
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# initialize zsh completion
autoload -Uz compinit && compinit
