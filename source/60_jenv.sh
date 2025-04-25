#!/usr/bin/env bash

if is_available jenv; then
    # export PATH="$HOME/.jenv/bin:$PATH"
    eval "$(jenv init - --no-rehash)"
    (jenv rehash &) 2> /dev/null

    # https://github.com/jenv/jenv/issues/148
    # function load_jenv() {
    #     export PATH="$HOME/.jenv/bin:$PATH"
    #     eval "$(jenv init -)"
    # }

    # function jenv() {
    #     # This will define a new jenv function, which will clobber the current
    #     # jenv function--which is exactly what we want. Call jenv with the
    #     # original parameters to run the actual command the user request. Any
    #     # further invocations of jenv will go straight to the "real" jenv
    #     # function.
    #     load_jenv
    #     jenv "$@"
    # }

    # function java() {
    #     # This will NOT define a new function, but will simply modify the
    #     # path. Manually unset this function after modifying the path. This
    #     # works, even though it is unloading a function while it is in the
    #     # function.
    #     load_jenv
    #     unset -f java
    #     java "$@"
    # }

    # function mvn() {
    #     # This will NOT define a new function, but will simply modify the
    #     # path. Manually unset this function after modifying the path. This
    #     # works, even though it is unloading a function while it is in the
    #     # function.
    #     load_jenv
    #     unset -f mvn
    #     mvn "$@"
    # }
fi
