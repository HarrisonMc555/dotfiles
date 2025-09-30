#!/usr/bin/env bash

open -a /Applications/Slack.app/
osascript > /dev/null <<- "EOF"
tell application "System Events"
	tell process "Slack"
		set frontmost to true
	end tell
end tell
EOF
