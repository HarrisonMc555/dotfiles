#!/usr/bin/env bash

# OSX-only stuff. Abort if not OSX.
if is_osx; then

    # Add paths to beginning
    paths=(
        /opt/homebrew/bin
        /opt/homebrew/sbin
        /opt/homebrew/opt/coreutils/libexec/gnubin
        /usr/local/opt/coreutils/libexec/gnubin
        /opt/homebrew/opt/mysql@5.7/bin
        /usr/local/bin
        /usr/bin
    )

    paths_rev=()

    for p in "${paths[@]}"; do
        paths_rev=("$p" "${paths_rev[@]}")
    done

    for p in "${paths_rev[@]}"; do
        [[ -d "$p" ]] && PATH="$p:$(path_remove "$p")"
    done
    unset p paths paths_rev

    export PATH

    # Make 'less' more.
    [[ "$(type -P lesspipe.sh)" ]] && eval "$(lesspipe.sh)"

    alias preview='open -a /System/Applications/Preview.app'
fi
