#!/bin/sh

# nano with fixed rcfile so that 'sudo nano' keeps settings
nano --rcfile "${HOME}/.nanorc" "$@"
