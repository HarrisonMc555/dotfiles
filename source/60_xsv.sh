#!/usr/bin/env bash

if is_available xsv; then
    # shellcheck disable=SC2016
    function xsv2org() {
        if [[ $# -gt 1 ]]; then
            >&2 echo "Usage: xsv2org [FILE]"
            return 1
        fi
        xsv fmt -t '|' "$@" |
            tail -n+2 |
            prepend '|'
    }

    function xsvrev() {
        if [[ $# -lt 1 ]] || [[ $# -gt 2 ]]; then
            >&2 echo "Usage: xsvrev INFILE [OUTFILE]"
            return 1
        fi
        file="$1"
        {
            head -n1 "$file"
            tac "$file" | sed '$d'
            # tail -n+2 "$file" | tac
        } |
            if [[ "$2" ]]; then
                cat > "$2"
            else
                cat
            fi
    }

    function xsvrev_inplace() {
        if [[ $# -ne 1 ]]; then
            >&2 echo "Usage: xsvrev_inplace FILE"
            return 1
        fi
        file="$1"
        out=$(mktemp)
        xsvrev "$1" "$out"
        command mv -f "$out" "$1"
    }
fi
