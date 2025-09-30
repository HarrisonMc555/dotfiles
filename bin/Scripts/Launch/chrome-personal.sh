#!/usr/bin/env bash

notify() {
    if [[ $# -lt 2 ]]; then
        >&2 echo "Usage: notify TITLE MESSAGE"
        return 1
    fi
    title="$1"
    shift
    osascript -e "display notification \"$*\" with title \"${title}\""
}

if ~/.dotfiles/bin/is_limit_personal_time; then
    notify "Limiting personal time" "We are currently limiting personal time"
    exit
fi

if ! pgrep 'Google Chrome' &>/dev/null; then
    open -a /Applications/Google\ Chrome.app/ && sleep 3
fi
osascript > /dev/null <<- "EOF"
tell application "System Events"
	tell process "Google Chrome"
		set frontmost to true
		click menu item "Harrison (Harrison McCullough)" of menu "Profiles" of menu bar 1
	end tell
end tell
EOF
