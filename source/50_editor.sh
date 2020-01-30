# Editing

export EDITOR='emacsclient -t'

export VISUAL='emacsclient -a ""'

alias emacs="emacsclient -n -a ''"
alias emacsw="emacsclient -c -n -a ''"
alias emacst="emacsclient -c -t -a ''"

if is_available rg; then
    function is_emacs_deamon_running() {
        ps aux |
            rg '/Applications/Emacs Daemon.app/Contents/MacOS/Emacs Daemon$' \
                 -q
    }
else
    function is_emacs_deamon_running() {
        ps aux |
            grep '/Applications/Emacs Daemon.app/Contents/MacOS/Emacs Daemon$' \
                 -q
    }
fi
export -f is_emacs_deamon_running
