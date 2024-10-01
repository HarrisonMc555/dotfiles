#!/usr/bin/env bash

if is_available pandoc; then
    function pandoc_copy() {
        if [[ $# -lt 2 ]]; then
            >&2 echo "Usage: pandoc_copy FROM TO [pandoc_args...]"
            return 1
        fi
        from="$1"
        to="$2"
        shift; shift;
        pandoc -f "$from" -t "$to" "$@" | c
    }
fi

