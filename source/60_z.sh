#!/usr/bin/env bash

if is_available zoxide; then
    eval "$(zoxide init bash)"

    function zp() {
        local prev_dir return_code
        prev_dir=$(pwd)
        z "$@"
        return_code=$?
        # if z "$@"; then
        if [[ "$return_code" = 0 ]]; then
            pushd -n "$prev_dir"
        fi
        return "$return_code"
    }
elif [[ -r "$DOTFILES"/vendor/z/z.sh ]]; then

    # Fast directory switching
    mkdir -p "$DOTFILES"/caches/z
    _Z_NO_RESOLVE_SYMLINKS=1
    _Z_DATA="$DOTFILES"/caches/z/z
    export _Z_NO_RESOLVE_SYMLINKS
    export _Z_DATA
    . "$DOTFILES"/vendor/z/z.sh

    function zp() {
        if pushd . > /dev/null; then
            z "$@" && dirs
        else
            popd > /dev/null || return 1
        fi
    }

fi
