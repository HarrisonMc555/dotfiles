#!/usr/bin/env bash

# This must be AFTER the mac OS changes because this needs to put things before
# the path that the mac OS changes do

if is_available pyenv; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    export PATH="$PYENV_ROOT/bin:$PATH"
    # eval "$(pyenv init --path)"
    # eval "$(pyenv init -)"
    eval "$(pyenv init - bash --no-rehash)"
    (pyenv rehash &)
fi
