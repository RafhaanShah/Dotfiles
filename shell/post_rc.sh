### config required at the end of rc file load
# shellcheck shell=bash

# fx: json processor
# https://github.com/antonmedv/fx
# TODO: check if there's a conflict
if _is_macos && _command_exists "fx"; then
    # shellcheck source=/dev/null
    _is_bash && source <(fx --comp bash)
    # shellcheck source=/dev/null
    _is_zsh && source <(fx --comp zsh)
fi
