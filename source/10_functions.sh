#!/usr/bin/env bash

pip() {
    pip3 "$@"
}

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
            [a-zA-Z0-9.~_-]) printf '%s' "$c" ;;
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

# Get the visual "nowait" editor, but fall back to VISUAL, EDITOR, and finally
# vim
visual_nowait_editor() {
    for e in "$VISUAL_NOWAIT" "$VISUAL" "EDITOR" vim; do
        if [[ "$e" ]]; then
            echo "$e"
            return
        fi
    done
}

yesno() {
    if [[ $# -gt 1 ]]; then
        >&2 echo "Usage: yesno [PROMPT]"
        return 2
    fi

    local suffix="[Y]es/No >"
    if [[ "$1" ]]; then
        local prompt="${1} ${suffix}"
    else
        local prompt="$suffix"
    fi

    while true; do
        read -r -p "${prompt} " yn
        case "$yn" in
            "" | [Yy] | [Yy][Ee][Ss] ) return 0;;
            [Nn] | [Nn][Oo] ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

noyes() {
    if [[ $# -gt 1 ]]; then
        >&2 echo "Usage: noyes [PROMPT]"
        return 2
    fi

    local suffix="[N]o/Yes >"
    if [[ "$1" ]]; then
        local prompt="${1} ${suffix}"
    else
        local prompt="$suffix"
    fi

    while true; do
        read -r -p "${prompt} " yn
        case "$yn" in
            "" | [Nn] | [Nn][Oo] ) return 1;;
            [Yy] | [Yy][Ee][Ss] ) return 0;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

is_iterm2() {
  is_osx && [[ "$TERM_PROGRAM" = iTerm.app ]] && [[ "$TERM" != dumb ]]
}

export -f is_available urlencode urldecode visual_nowait_editor yesno noyes \
       is_iterm2
