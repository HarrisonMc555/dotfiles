#!/usr/bin/env bash

if ! pgrep 'Google Chrome' &>/dev/null; then
    open -a /Applications/Google\ Chrome.app/ && sleep 3
fi
osascript > /dev/null <<- "EOF"
tell application "System Events"
	tell process "Google Chrome"
		set frontmost to true
		click menu item "Harrison (Harrison McCullough Work)" of menu "Profiles" of menu bar 1
	end tell
end tell
EOF
