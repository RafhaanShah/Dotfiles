### aliases
# shellcheck shell=bash

### common

# carries over aliases with sudo (bash)
alias sudo='sudo '

# ls aliases
alias l='ls'
alias ls='ls --color --group-directories-first' # show colours, dirs first
alias la='ls -A'                                # include hidden files
alias ll='ls -lh'                               # long human readable format
alias lla='ls -Alh'                             # long human readable with hidden
alias ls-file='ls -F | grep -v /'               # list files only
alias ls-dir='ls -d */ 2> /dev/null'            # list folders only
alias ls-dot='ls -d .[^.]* 2> /dev/null'        # list hidden items only
alias ls-size='ls -lSrh'                        # sort by size
alias ls-date='ls -ltrh'                        # sort by date
alias ls-ext='ls -lXh'                          # sort by extension

# cd aliases
alias c='cd'
alias -- -='cd -' # the alias is just '-'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# git aliases
alias g='git'
alias gad='git add'
alias gcm='git commit --message'
alias gco='git checkout'
alias gcl='git clone'
alias gll='git log'
alias glg='git lg'
alias gpl='git pull'
alias gps='git push'
alias gst='git status'

# coloured grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# safer file operations
alias rm='rm -Irv'
alias mv='mv -iv'
alias cp='cp -aiv'

### general

# bechmark shell startup time
# shellcheck disable=SC2142
alias bench_shell='time "${0//-}" -i -c "echo -n"'

# shortcut for 'command' to ignore aliases and functions
alias cmd='command'

# clear screen (ctrl-l)
alias cls='clear'

# clear screen and scrollback (command-k)
alias clean='clear && printf "\e[3J"'

# clipboard
alias copy='xclip -selection clipboard'
alias paste='xclip -selection clipboard -o'

# download file
alias download='curl -LJO'
alias dl='download'

# opens editor
alias e='${EDITOR}'

# re-do last command with sudo
alias fuck='sudo $(fc -ln -1)'
alias fu='fuck'
alias please='fuck'
alias plz='please'

# opens hosts file for editing
alias hosts='sudo "${EDITOR}" /etc/hosts'

# shows current ip information
alias ip='ipconfig getifaddr en0 && curl http://ipecho.net/plain; echo'

# get exit code of last command
alias lexit='echo $?'

# gets the last command
alias lcommand='fc -ln -1'

# opens file or folder in default app
alias open='xdg-open'
alias o='open'

# shows path
alias path='echo -e "${PATH//:/\\n}"'

# generates a random password
alias passgen='openssl rand -base64 14'

# shows listening ports
alias ports='sudo lsof -i | grep LISTEN'

# reloads shell
# shellcheck disable=SC2142
alias reload='exec "${0//-}" -l'

# adds execute permissions
alias runnable='chmod +x'

# gets the size of a file or directory
alias sizeof='du -h'

# get the name of the current directory
alias wd='echo ${PWD##*/}'

### tools

# adb clear app data
alias adb-clear='adb shell pm clear'

# cht.sh: cheatsheets https://github.com/chubin/cheat.sh
alias cht='cht.sh'

# docker: app containers https://docs.docker.com/engine/install/
alias dk='docker'
alias dkc='docker-compose'
alias dkc-upd='docker-compose pull && docker-compose up -d'
alias dkc-bld='docker-compose build && docker-compose up -d'

# lazydocker: docker ui https://github.com/jesseduffield/lazydocker
alias dk-ui='lazydocker'

# fx: json processor https://github.com/antonmedv/fx
alias json='fx'
alias jq='fx'

# lazygit: git ui https://github.com/jesseduffield/lazygit
alias git-ui='lazygit'

# googler: search google https://github.com/jarun/googler
alias google='googler'
alias goog='google'
alias define='googler -n 2 define'
alias so='googler -j -w stackoverflow.com'
