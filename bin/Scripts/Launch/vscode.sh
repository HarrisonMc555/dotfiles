#!/usr/bin/env bash

open -a '/Applications/Visual Studio Code.app/'
osascript > /dev/null <<- "EOF"
tell application "System Events"
	tell process "Code"
		set frontmost to true
	end tell
end tell
EOF
