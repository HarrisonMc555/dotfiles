#!/usr/bin/env bash

set -e
open -a /Users/harrisonmccullough/Applications/RustRover.app/Contents/MacOS/rustrover
# /Users/harrisonmccullough/Library/Application Support/JetBrains/Toolbox/apps/RustRover/ch-0/232.9921.62/RustRover 2023.2 EAP.app/Contents/MacOS/rustrover

# idea_dir=$(find ~/Library/Application\ Support/JetBrains/Toolbox/apps/IDEA-U/ch-1 -type d -maxdepth 1 |
#                sort -V | tail -n1)
# open -a "$idea_dir"/IntelliJ\ IDEA.app/

# open -a /Applications/IntelliJ\ IDEA.app/
osascript > /dev/null <<- "EOF"
tell application "System Events"
	--tell process "RustRover 2023.2 EAP"
	tell process "rustrover"
		set frontmost to true
	end tell
end tell
EOF
