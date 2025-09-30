#!/usr/bin/env bash

# Command-line CSV tool
# https://github.com/dathere/qsv
if is_available qsv; then
    # Convert a CSV table to an Emacs org-mode table
    function qsv2org() {
        if [[ $# -gt 1 ]]; then
            >&2 echo "Usage: qsv2org [FILE]"
            return 1
        fi
        qsv fmt -t '|' "$@" |
            tail -n+2 |
            prepend '|'
    }

    # Reverse a CSV table
    function qsvrev() {
        if [[ $# -lt 1 ]] || [[ $# -gt 2 ]]; then
            >&2 echo "Usage: qsvrev INFILE [OUTFILE]"
            return 1
        fi
        file="$1"
        {
            head -n1 "$file"
            tac "$file" | sed '$d'
        } |
            if [[ "$2" ]]; then
                cat > "$2"
            else
                cat
            fi
    }

    # Reverse a CSV file in-place
    function qsvrev_inplace() {
        if [[ $# -ne 1 ]]; then
            >&2 echo "Usage: qsvrev_inplace FILE"
            return 1
        fi
        file="$1"
        out=$(mktemp)
        qsvrev "$1" "$out"
        command mv -f "$out" "$1"
    }

    # Display statistics about CSV table in a human-readable format
    function qsvstats() {
        qsv stats "$@" |
            qsv search -v -s field 'qsv' |
            qsv select '!/qsv/' |
            qsv transpose |
            qsv table
    }
fi
