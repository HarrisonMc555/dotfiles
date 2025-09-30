#!/usr/bin/env bash

open -a /Applications/Microsoft\ Outlook.app/
osascript > /dev/null <<- "EOF"
tell application "System Events"
	tell process "Microsoft Outlook"
		set frontmost to true
	end tell
end tell
EOF
