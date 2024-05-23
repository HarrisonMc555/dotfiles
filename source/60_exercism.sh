#!/usr/bin/env bash

[ -f ~/.config/exercism/exercism_completion.bash ] &&
    source ~/.config/exercism/exercism_completion.bash

if is_available exercism; then
    exercism () {
        local out
        readarray -t out < <(command exercism "$@")
        printf '%s\n' "${out[@]}"
        if [[ $1 == "download" && -d "${out[-1]}" ]]; then
            cd "${out[-1]}" || return 1
        fi
    }
fi
