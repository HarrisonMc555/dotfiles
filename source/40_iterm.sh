#!/usr/bin/env bash

if is_osx && test -e ~/.iterm2_shell_integration.bash; then
    source ~/.iterm2_shell_integration.bash
    export ITERM2_SQUELCH_MARK=1
fi
