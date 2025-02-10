#!/usr/bin/env bash

if is_available jq; then
    function jql() {
        if [[ -t 1 ]]; then
            jq -C "$@" | less -S
        else
            jq "$@"
        fi
    }
fi

if is_available xq; then
    function xql() {
        if [[ -t 1 ]]; then
            xq -C "$@" | less -S
        else
            xq "$@"
        fi
    }
fi
