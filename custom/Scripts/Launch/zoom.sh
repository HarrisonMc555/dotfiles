#!/usr/bin/env bash

if pgrep 'zoom.us' &>/dev/null; then
    open -a /Applications/zoom.us.app/ &>/dev/null || true
fi
