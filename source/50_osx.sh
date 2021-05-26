#!/usr/bin/env bash

# OSX-only stuff. Abort if not OSX.
if is_osx; then

    # Add paths to beginning
    paths=(
        /usr/local/bin
        /usr/local/opt/coreutils/libexec/gnubin
    )

    paths_rev=()

    for p in "${paths[@]}"; do
        paths_rev=("$p" "${paths[@]}")
    done

    for p in "${paths_rev[@]}"; do
        [[ -d "$p" ]] && PATH="$p:$(path_remove "$p")"
    done
    unset p paths paths_rev

    export PATH

    # Make 'less' more.
    [[ "$(type -P lesspipe.sh)" ]] && eval "$(lesspipe.sh)"

fi
