#!/usr/bin/env bash

pip() {
    pip3 "$@"
}

histeval() {
    history -s "$@"
    eval "$@"
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
  [[ "$ITERM_SHELL_INTEGRATION_INSTALLED" = Yes ]]
}

bak() {
    if [[ $# -eq 0 ]]; then
        >&2 echo "Usage: bak FILE [FILE2,...]";
        return 1
    fi
    backup_dir=backup
    date_prefix=$(date +%Y-%m-%d_%H-%M-%S_)
    mkdir -p "$backup_dir" &&
        for f in "$@"; do
            filename=$(basename "$f")
            mv "$f" "${backup_dir}/${date_prefix}${filename}" ||
                >&2 echo "Could not back up file '$f'"
        done
}

prepend() {
    if [[ $# -eq 0 ]]; then
        >&2 echo "Usage: prepend PREFIX"
        return 1
    fi
    prefix="$*"
    awk -v prefix="$prefix" '{ print prefix $0}'
}

append() {
    if [[ $# -ne 1 ]]; then
        >&2 echo "Usage: append SUFFIX"
        return 1
    fi
    suffix="$1"
    awk -v suffix="$suffix" '{ print $0 suffix}'
}

function countdown(){
    local now end
    now=$(date +%s) || return 1
    end=$((now + $1))
    while (( now < end )); do
        printf "%s\r" "$(date -u -d @$((end - now)) +%T)"
        sleep 0.25
        now=$(date +%s)
    done
    echo
}

timer() {
    local rest numeric
    if [[ $# -eq 0 ]] || [[ $# -gt 2 ]]; then
        >&2 echo "Usage: timer AMOUNT_OF_TIME [SECOND_MINUTE_HOUR_ETC]"
        return 1
    fi
    if [[ $# -eq 1 ]]; then
        rest="${1##+([0-9])}"
        numeric="${1%$rest}"
    elif [[ $# -eq 2 ]]; then
        numeric="$1"
        rest="$2"
    else
        >&2 echo "Usage: timer AMOUNT_OF_TIME [SECOND_MINUTE_HOUR_ETC]"
        >&2 echo "Internal error"
        return 1
    fi

    if ! [[ "$numeric" =~ ^[0-9]$ ]]; then
        >&2 echo "First argument must be or start numeric, received: "\
            "\"$numeric\""
        return 1
    fi
    if ! [[ "$rest" =~ ^[a-zA-Z]$ ]] && [[ "$rest" != "" ]]; then
        >&2 echo "Second argument or end of first argument must be alphabetic "\
            "or non-empty, received: \"$rest\""
        return 1
    fi

    case "$rest" in
        d) rest="days";;
        h) rest="hours";;
        m) rest="minutes";;
        s | "") rest="seconds";;
    esac

    current_date=$(date) || return 1
    current_seconds=$(date -d "$current_date" +%s) || return 1
    future_seconds=$(date -d "${current_date} + ${numeric} ${rest}" +%s) ||
        return 1
    total_seconds=$((future_seconds - current_seconds))

    countdown "$total_seconds"
}

if is_osx; then
    notify() {
        if [[ $# -lt 1 ]]; then
            >&2 echo "Usage: notify [TITLE] MESSAGE"
            return 1
        fi
        title="$1"
        if [[ $# -gt 1 ]]; then
            shift
        fi
        message="$*"
        script="display notification \"${message}\" with title \"${title}\""
        osascript -e "$script"
        say "$message"
    }

    notify_result() {
        result=$?


        if [[ "$result" = 0 ]]; then
            result_phrase="Success"
        else
            result_phrase="Failure"
        fi

        title="$result_phrase"
        if [[ $# -gt 0 ]]; then
            title+=": $1"
            shift
        fi

        if [[ $# -eq 0 ]]; then
            args=()
        else
            args=("$result_phrase" "$@")
        fi

        notify "$title" "${args[@]}"
    }

    export -f notify notify_result
fi

random() {
    case $# in
         1) min=1; max="$1";;
         2) min="$1"; max="$2";;
         *) >&2 echo "Usage: random MAX, random MIN MAX"; return 1;;
    esac
    diff=$((max - min + 1))
    echo $((min + RANDOM % diff))
}

random_exclusive() {
    case $# in
         1) min=0; max="$1";;
         2) min="$1"; max="$2";;
         *) >&2 echo "Usage: random MAX, random MIN MAX"; return 1;;
    esac
    diff=$((max - min))
    echo $((min + RANDOM % diff))
}

# Test if stdin is empty or not
# Taken from https://stackoverflow.com/a/77595243
stdin_empty() {
    if IFS= read -r -d '' -n 1; then
        # Forward data along if you want to
        if [[ -n "$REPLY" ]]; then
            printf "%s" "$REPLY"
        else
            # Properly handle zero byte in input
            printf "\x00"
        fi
        cat
        return 1
    else
        # Empty
        return 0
    fi
}

pause() {
    local x
    read -n1 -r -s -p $'Press any key to continue...\n' x
}

export -f pip histeval urlencode urldecode visual_nowait_editor \
          yesno noyes is_iterm2 bak prepend append countdown timer notify \
          notify_result random random_exclusive stdin_empty pause
