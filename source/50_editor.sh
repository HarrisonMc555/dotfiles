# Editing

export EDITOR='emacsclient -t'

export VISUAL='emacsclient -a ""'

alias emacs="emacsclient -n -a ''"
alias emacsw="emacsclient -c -n -a ''"
alias emacst="emacsclient -c -t -a ''"

function is_emacs_deamon_running() {
    ps_process_names | _grep '^/Applications/Emacs Daemon.app/' -q
}

function is_emacs_gui_running() {
    ps_process_names | _grep '^/Applications/Emacs.app/' -q
}

export -f is_emacs_deamon_running
export -f is_emacs_gui_running
