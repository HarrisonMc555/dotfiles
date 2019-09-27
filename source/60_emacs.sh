is_available emacs || return 1

alias em="emacs"

export OPENBIN_COMMAND="emacsclient -a '' -n"
export EDITBIN_COMMAND="emacsclient -a ''"
