#!/usr/bin/env bash

if is_osx; then
    alias safari='open -a safari'
    alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
    alias firefox='open -a firefox'
    f() {
        for arg in "$@"; do
            if [[ -f "$arg" ]]; then
                open -R "$arg"
            else
                open -a Finder "$arg"
            fi
        done
    }
    fh() {
        if [[ $# -ne 0 ]]; then
            >&2 echo "Usage: fh"
            return 1
        fi
        open -a Finder .
    }
    alias lmk="say '[[volm 0.15]] Process complete.'"
    alias say="say '[[volm 0.15]]'"

    if [[ -d /Applications/Phiewer.app/ ]]; then
        alias phiewer='open -a /Applications/Phiewer.app/'
    fi
fi
