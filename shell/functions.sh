### functions
# shellcheck shell=bash

# auto ls after cd
# unalias c
# c() {
#     if [ "$#" -eq 0 ]; then
#         builtin cd && ls
#     else
#         builtin cd "$1" && ls
#     fi
# }

# search / list aliases
al() { alias | grep "${*:-=}"; }

# make dir and cd into it automatically
mkd() { command mkdir -p "$@" && builtin cd "$1" || return; }

# add colours to man
man() {
    env \
        LESS_TERMCAP_mb="$(printf '\e[1;32m')" \
        LESS_TERMCAP_md="$(printf '\e[1;32m')" \
        LESS_TERMCAP_me="$(printf '\e[0m')" \
        LESS_TERMCAP_se="$(printf '\e[0m')" \
        LESS_TERMCAP_so="$(printf '\e[1;33m')" \
        LESS_TERMCAP_ue="$(printf '\e[0m')" \
        LESS_TERMCAP_us="$(printf '\e[1;4;31m')" \
        man "$@"
}

# shows last 25 commands or shows last 10 commands including search words
hist() {
    if [ "$#" -eq 0 ]; then
        history 25
    else
        history 10000 | grep "$*" | grep -v "hist" | tail -n 10
    fi
}

### colour functions

# shows baseic terminal colours in a table
# from https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
colour_table() {
    T='gYw'
    echo -e "\n                 40m     41m     42m     43m\
    44m     45m     46m     47m"

    for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
        '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
        '  36m' '1;36m' '  37m' '1;37m'; do
        FG=${FGs// /}
        echo -en " $FGs \033[$FG  $T  "
        for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do
            echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m"
        done
        echo
    done
    echo
}

# lists all xterm 256 colours
# from https://wiki.archlinux.org/index.php/Color_output_in_console#bash
colour_list() {
    for i in {0..255}; do
        printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
        if ((i == 15)) || ((i > 15)) && (((i - 15) % 6 == 0)); then
            printf "\n"
        fi
    done
}

# prints a colour wave that only works with true colour terminals
# from https://gist.github.com/XVilka/8346728
colour_wave() {
    awk 'BEGIN{
        s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
        for (colnum = 0; colnum<77; colnum++) {
            r = 255-(colnum*255/76);
            g = (colnum*510/76);
            b = (colnum*255/76);
            if (g>255) g = 510-g;
            printf "\033[48;2;%d;%d;%dm", r,g,b;
            printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
            printf "%s\033[0m", substr(s,colnum+1,1);
        }
        printf "\n";
    }'
}

### file / folder functions

# count the number of files and directories
dirstat() {
    local files
    files="$(find . -maxdepth 1 -type f | wc -l)"
    local dirs
    dirs="$(find . -maxdepth 1 -type d | wc -l)"
    _trim "${files} files, ${dirs} directories"
}

# extract archives
extract() {
    if [ -f "$1" ]; then
        case $1 in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar e "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "Could not extract $1" ;;
        esac
    else
        echo "$1 is not a valid file"
    fi
}

# find files by name in current folder
ffile() { find . -not -path '*/\.*' -iname "*${*}*" 2>&1 | grep -v 'Permission denied'; }

# find files containing given text in current folder
ftext() { grep -iIHrn --exclude-dir='.*' "$@"; }

# gets full path of file in current folder
fpath() { echo "$(pwd)/$1"; }

# open github repo in browser
git-hub() {
    _is_git_repo || { echo "Not a git repo" && return 1; }
    local base_url
    base_url="$(git remote get-url origin)"
    base_url="${base_url%\.git}/tree/$(git rev-parse --abbrev-ref HEAD)"
    base_url="${base_url//git@github\.com:/https:\/\/github\.com\/}"
    base_url="${base_url//git:\/\/github\.com/https:\/\/github\.com\/}"
    open "${base_url}/$1"
}

# simple python http server
server() { python3 -m http.server "${1:-8069}"; }

# backs up a directory to a tar
tar-backup() {
    if [ ! -e "$1" ]; then
        echo "Invalid argument"
        return 1
    fi
    local backup_name
    backup_name="${2:-backup.tar.gz}"
    echo "This will backup $1 into ${backup_name}. Continuing in 10 seconds..."
    sleep 10
    echo "Backing up..."
    tar -cpzf "${backup_name}" --exclude="{backup_name}" --one-file-system "$1"
    echo "Backup complete"
}

# unzips a tar to a directory
tar-restore() {
    if [ ! -e "$1" ]; then
        echo "Invalid argument"
        return 1
    fi
    local restore_dir
    restore_dir="${2:-$(pwd)}"
    echo "This will copy everything from $1 into ${restore_dir}. Continuing in 10 seconds..."
    sleep 10
    echo "Restoring..."
    tar -xpzf "$1" -C "${restore_dir}" --numeric-owner
    echo "Restore complete"
}

# list files and folders in a tree format with a default level of 2
tree() {
    if [ "$#" -eq 0 ]; then
        command tree --dirsfirst -C -L 2
    else
        command tree --dirsfirst -C "$@"
    fi
}

### tool related functions

# toggles animations for Android device
adb-anim() {
    case "$1" in
        on)
            adb shell settings put global window_animation_scale 1.0
            adb shell settings put global transition_animation_scale 1.0
            adb shell settings put global animator_duration_scale 1.0
            ;;
        off)
            adb shell settings put global window_animation_scale 0.0
            adb shell settings put global transition_animation_scale 0.0
            adb shell settings put global animator_duration_scale 0.0
            ;;
        *)
            echo "Usage adb-anim [on/off]"
            ;;
    esac
}

# sets max font and display size for Android device (1920x1080 screen)
adb-zoom() {
    case "$1" in
        on)
            adb shell settings put system font_scale 1.3
            adb shell wm density 540
            ;;
        off)
            adb shell settings put system font_scale 1.0
            adb shell wm density 420
            ;;
        *)
            echo "Usage adb-zoom [on/off]"
            ;;
    esac
}

# sets proxy on or off
adb-proxy() {
    case "$1" in
        on)
            ip="$(ifconfig -l | xargs -n1 ipconfig getifaddr)" || true
            first_ip="${ip%% *}"
            adb shell settings put global http_proxy "${first_ip}:${2:-9090}"
            ;;
        off)
            adb shell settings put global http_proxy :0
            ;;
        *)
            echo "Usage adb-proxy [on/off]"
            ;;
    esac
}

# exec into a docker container
dk-exec() { docker exec -it "$1" "${2:-sh}"; }

# file manager: https://github.com/dylanaraps/fff
f() {
    fff "$@"
    cd "$(\cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")" || return
}

# opens command cheat sheet on devhints.io
hint() { open "https://devhints.io/$1"; }

# enerate a qrcode
qrcode() { curl "http://qrenco.de/$1"; }

# shows the current weather
wttr() { curl "http://wttr.in/${1:-London}"; }
