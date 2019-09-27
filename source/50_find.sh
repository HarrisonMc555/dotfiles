function find_no_err() {
    find "$@" 2> >(grep -v -E \
                        -e '^find: .*: Permission denied$' \
                        -e '^find: .*: Operation not permitted$')
}

function find_newer() {
    if [[ $# != 1 ]] && [[ $# != 2 ]]; then
        echo "Usage: findnewer val[ymwdHMS] [dir]"
        echo "  Ex: findnewer 1d"
        return 1
    fi
    valstring="$1"
    if [[ "$2" ]]; then
        dir="$2"
    else
        dir=.
    fi
    find_no_err "$dir" \
         -newermt "$(date -v -"$valstring" "+%Y-%m-%d %H:%M:%S")" \
         -type f \
         -print
}
