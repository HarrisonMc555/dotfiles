#!/usr/bin/env bash

if [[ -e /etc/profile.d/rvm.sh ]]; then
    # rvm init
    # shellcheck disable=SC1091
    source /etc/profile.d/rvm.sh
fi

if is_available rbenv; then
    eval "$(rbenv init -)"
elif [[ -d "$HOME/.rbenv/" ]]; then
    export PATH="$HOME/.rbenv/shims:$PATH"
fi
