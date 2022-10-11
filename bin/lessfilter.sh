#! /usr/bin/env sh

mime=$(file -bL --mime-type "$1")
category=${mime%%/*}
# kind=${mime##*/}

if [ -d "$1" ]; then
    ls "$1"
elif [ "$category" = text ]; then
    if command -v "bat" >/dev/null 2>&1; then
        bat --color=always --plain --line-range=:100 "$1"
    else
        head -n 100 "$1"
    fi
fi
