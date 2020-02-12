#!/usr/bin/env bash

if is_available rustc; then
    export RUST_BACKTRACE=1
    if is_available cargo; then
        source "$(rustc --print sysroot)"/etc/bash_completion.d/cargo
    fi
fi

