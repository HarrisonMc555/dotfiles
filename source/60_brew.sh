#!/usr/bin/env bash

if is_available brew; then
    eval "$(brew shellenv)"
    if [[ $(uname -m) = arm* ]]; then
        alias oldbrew=/usr/local/bin/brew
    fi

    # Do not use this, it is too slow
    # if is_osx && is_available brew; then
    #     if brew command command-not-found-init > /dev/null 2>&1; then
    #         eval "$(brew command-not-found-init)"
    #     fi
    # fi
fi
