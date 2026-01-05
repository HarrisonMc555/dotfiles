#!/usr/bin/env bash

if is_available bat; then
    export PAGER='bat --style=plain'
    export BAT_PAGER='less -RXS'
    if is_osx; then
        export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    else
        export MANPAGER="bat -l man -p"
    fi
    alias l='bat --style=plain'
    if is_available batgrep; then
        alias bag='batgrep -p'
    fi
fi

