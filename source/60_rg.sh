#!/usr/bin/env bash

if is_available rg; then

    export RIPGREP_CONFIG_PATH=~/.ripgreprc

    function rgl() {
        if [[ -t 1 ]]; then
            rg -n --color=always --sort path --heading "$@" | less -S
        else
            rg -n --sort path --heading "$@"
        fi
    }

    function rgh() {
        rg -n --hidden --no-ignore --heading "$@"
    }

    function rghl() {
        if [[ -t 1 ]]; then
            rg -n --hidden --no-ignore --color=always --sort path --heading "$@" | less -S
        else
            rg -n --hidden --no-ignore --sort path --heading "$@" | less -S
        fi
    }

    alias rglh=rghl

fi
