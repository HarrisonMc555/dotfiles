#!/usr/bin/env bash

if is_available jenv; then
    export PATH="$HOME/.jenv/bin:$PATH"
    eval "$(jenv init -)"
fi
