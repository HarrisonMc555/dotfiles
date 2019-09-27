if is_available emacs; then

    alias em="emacs"

    export OPENBIN_COMMAND="emacsclient -a '' -n"
    export EDITBIN_COMMAND="emacsclient -a ''"

fi
