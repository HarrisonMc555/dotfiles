#!/usr/bin/env bash

if is_available bat; then
    export PAGER='bat --style=plain'
    export BAT_PAGER='less -RX'
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    alias l='bat --style=plain'
    if is_available batgrep; then
        alias bag='batgrep -p'
    fi
fi

