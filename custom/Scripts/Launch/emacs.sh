#!/usr/bin/env bash

open -a /Applications/Emacs.app/
ps aux | awk '{ s = ""; for (i = 11; i <= NF; i++) s = s $i " "; print s }' | grep -v grep | grep '^/Applications/Emacs.app/' -q
