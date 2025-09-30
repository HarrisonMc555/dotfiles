#!/usr/bin/env bash

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

function ps_process_names() {
    if [[ $# -ne 0 ]]; then
        >&2 echo "Usage: ps_process_names"
        return 1
    fi
    ps aux |
        tail -n+2 |
        awk '{ s = ""; for (i = 11; i <= NF; i++) s = s $i " "; print s }' |
        # Ignore the processes that we started, i.e. ps, tail, awk, and the
        # search binary
        _grep -v "^(ps aux |$_SEARCH_BINARY |tail -n\+2 |awk \{ s = \"\")"
}

function is_running() {
    if [[ $# -ne 1 ]]; then
        >&2 echo "Usage: is_running APP_NAME"
        return 1
    fi
    ps_process_names | grep_ignore_grep -q "$1"
}

function top_proc() {
    if [[ $# -eq 0 ]]; then
        >&2 echo "Usage: top_proc CMD [CMD, ..]"
        return 1
    fi
    # shellcheck disable=SC2046
    top $(pgrep "$@" | sed 's/^/-pid /' | tr '\n' ' ')
}

export -f psg ps_process_names is_running
