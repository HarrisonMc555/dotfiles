#!/usr/bin/env bash

open -a /Applications/Emacs.app/
osascript > /dev/null <<- "EOF"
tell application "System Events"
	tell process "Emacs"
		set frontmost to true
	end tell
end tell
EOF
