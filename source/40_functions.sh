#!/usr/bin/env bash

histeval() {
    history -s "$@"
    eval "$@"
}

is_available() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: is_available CMD"
        echo "CMD can be a binary, alias, function, or anything that can be "\
             "executed as a command"
        return 1
    fi
    cmd="$1"
    command -v "$cmd" &> /dev/null
}

urlencode() {
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done

    LC_COLLATE=$old_lc_collate
}

urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}
