# Processes

function psg() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: psg PATTERN"
        return 1
    fi
    ps aux |
        _grep -v -e "$_SEARCH_BINARY $@" -e "$_SEARCH_BINARY -v -e \"'$_SEARCH_BINARY $@'\"" |
        _grep $@ --color=always |
        sed -e 'G' |
        less
}

function ps_process_names() {
    ps aux | tail -n+2 | awk '{ s = ""; for (i = 11; i <= NF; i++) s = s $i " "; print s }'
}

export -f ps_process_names
