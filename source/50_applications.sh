#!/usr/bin/env bash

if is_osx; then
    alias safari='open -a safari'
    alias chrome="open -a google\ chrome"
    alias firefox='open -a firefox'
    alias f='open -a Finder'
    alias fh='open -a Finder .'
    alias lmk="say '[[volm 0.15]] Process complete.'"
    alias say="say '[[volm 0.15]]'"

    if [[ -d /Applications/Phiewer.app/ ]]; then
        alias phiewer='open -a /Applications/Phiewer.app/'
    fi
fi
