#!/usr/bin/env bash

if is_available procs; then
    function psg() {
        if [[ $# -lt 1 ]]; then
            echo "Usage: psg PATTERN [, PATTERN*]"
            return 1
        fi
        # `procs' appends extra spaces to the end of every line, I assume to
        # make every line the same width. This is annoying when looking at less
        # without `-S', so we use sed to strip them. The weird bit is for the
        # color escape that `procs' also puts at the end of each line (for good
        # reason).
        procs --color=always "$@" |
            sed -E 's/ +\[0m$/\[0m/' |
            less -S
    }
else
    function psg() {
        if [[ $# -ne 1 ]]; then
            echo "Usage: psg PATTERN"
            return 1
        fi
        ps aux |
            _grep -v -e "$_SEARCH_BINARY $*" -e "$_SEARCH_BINARY -v -e \"'$_SEARCH_BINARY $*'\"" |
            _grep "$@" --color=always |
            sed -e 'G' |
            less
    }
fi

function ps_process_names() {
    if [[ $# -ne 0 ]]; then
        >&2 echo "Usage: ps_process_names"
        return 1
    fi
    ps aux | tail -n+2 | awk '{ s = ""; for (i = 11; i <= NF; i++) s = s $i " "; print s }'
}

function is_running() {
    if [[ $# -ne 1 ]]; then
        >&2 echo "Usage: is_running APP_NAME"
        return 1
    fi
    ps_process_names | grep_ignore_grep -q "$1"
}

export -f ps_process_names is_running
