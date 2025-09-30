#!/usr/bin/env bash

# open -a /Applications/Microsoft\ Teams.app/
# open -a /Applications/Microsoft\ Teams\ classic.app/
# open -a '/Applications/Microsoft Teams (work or school).app'
open -a '/Applications/Microsoft Teams.app'
osascript > /dev/null <<- "EOF"
tell application "System Events"
	-- tell process "Microsoft Teams classic"
	-- tell process "Microsoft Teams (work or school)"
	-- tell process "Microsoft Teams WebView"
	tell process "Microsoft Teams"
		set frontmost to true
	end tell
end tell
EOF
