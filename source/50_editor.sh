# Editing

export EDITOR='emacsclient -t'

export VISUAL='emacsclient -a ""'

alias emacs="emacsclient -n -a ''"
alias emacsw="emacsclient -c -n -a ''"
alias emacst="emacsclient -c -t -a ''"

if is_available rg; then
    function is_emacs_deamon_running() {
        ps_process_names | rg '^/Applications/Emacs Daemon.app/' -q
    }

    function is_emacs_gui_running() {
        ps_process_names | rg '^/Applications/Emacs.app/' -q
    }
else
    function is_emacs_deamon_running() {
        ps_process_names | grep '^/Applications/Emacs Daemon.app/' -q
    }

    function is_emacs_gui_running() {
        ps_process_names | grep '^/Applications/Emacs.app/' -q
    }
fi
export -f is_emacs_deamon_running
export -f is_emacs_gui_running
