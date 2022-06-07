#!/usr/bin/env bash

# Editing

export EDITOR='emacsclient -t'

export VISUAL='emacsclient -a ""'
export VISUAL_NOWAIT='emacsclient -a "" -n'

alias emacs="emacsclient -n -a ''"
alias emacsw="emacsclient -c -n -a ''"
alias emacst="emacsclient -c -t -a ''"

function is_emacs_deamon_running() {
    local name
    if is_osx; then
        name='^/Applications/Emacs.app/Contents/MacOS/Emacs.* --bg-daemon'
    else
        name='^/usr/bin/emacs --daemon'
    fi
    is_running "$name"
}
export -f is_emacs_deamon_running

if is_osx; then
    function is_emacs_gui_running() {
        is_running '^/Applications/Emacs.app/'
    }
    export -f is_emacs_gui_running
fi
