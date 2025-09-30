#!/usr/bin/env bash

open -a /Applications/Amazon\ Music.app/
osascript > /dev/null <<- "EOF"
tell application "System Events"
	tell process "Amazon Music"
		set frontmost to true
	end tell
end tell
EOF
