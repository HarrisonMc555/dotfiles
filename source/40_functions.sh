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

jirafy() {
    if [[ $# -lt 1 ]]; then
        >&2 echo "Usage: jirafy FILE [options, ...]"
        >&2 echo "    Note that FILE must be the first parameter"
        return 1
    fi

    local file="$1"
    shift
    local out="${file%%.*}.txt"
    pandoc "$file" "$@" -t jira |
        sed 's/\\&/\&/g' |
        perl -pe 'chomp if eof' > "$out"
}

function is_iterm2() {
  is_osx && [[ "$TERM_PROGRAM" = iTerm.app ]] && [[ "$TERM" != dumb ]]
}

export -f is_available urldecode visual_nowait_editor is_iterm2
