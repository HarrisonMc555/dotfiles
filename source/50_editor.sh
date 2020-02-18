#!/usr/bin/env bash

# Editing

export EDITOR='emacsclient -t'

export VISUAL='emacsclient -a ""'
export VISUAL_NOWAIT='emacsclient -a "" -n'

alias emacs="emacsclient -n -a ''"
alias emacsw="emacsclient -c -n -a ''"
alias emacst="emacsclient -c -t -a ''"

if is_osx; then
    function is_emacs_deamon_running() {
        local name='^/Applications/Emacs.app/Contents/MacOS/Emacs-x86_64-10_14 --bg-daemon'
        ps_process_names | _grep "$name" -q
    }

    function is_emacs_gui_running() {
        ps_process_names | _grep '^/Applications/Emacs.app/' -q
    }

    export -f is_emacs_deamon_running
    export -f is_emacs_gui_running
fi
