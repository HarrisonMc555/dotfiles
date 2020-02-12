#!/usr/bin/env bash

function space2lines() {
    if [[ $# -gt 1 ]]; then
        echo "Usage: lines [file]*"
        return 1
    fi

    cat "$@" | tr ' ' '\n'
}

function doublelines() {
    if [[ $# -gt 1 ]]; then
        echo "Usage: doublelines [file]*"
        return 1
    fi
    cat "$@" | awk '{ print; print "" }'
}
