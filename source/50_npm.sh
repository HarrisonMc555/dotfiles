#!/usr/bin/env bash

if is_available npm; then
    function nvm() {
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
        # This will define a new nvm function, which will clobber the current
        # nvm function--which is exactly what we want. Call nvm with the
        # original parameters to run the actual command the user request. Any
        # further invocations of nvm will go straight to the "real" nvm
        # function.
        nvm "$@"
    }
fi

