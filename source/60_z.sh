#!/usr/bin/env bash

if is_available z; then

    # Fast directory switching
    mkdir -p "$DOTFILES"/caches/z
    _Z_NO_PROMPT_COMMAND=1
    _Z_DATA="$DOTFILES"/caches/z/z
    . "$DOTFILES"/vendor/z/z.sh

    function zp() {
        pushd . > /dev/null && {
            z "$@" &&
                dirs
        } || {
            popd > /dev/null
        }
    }
fi
