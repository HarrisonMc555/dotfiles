#!/usr/bin/env bash

# ~/.local/bin/idea

# # IntelliJ 2020.1
# open -a ~/Library/Application\ Support/JetBrains/Toolbox/apps/IDEA-U/ch-0/201.8743.12/IntelliJ\ IDEA.app/
# IntelliJ 2020.3
# open -a ~/Library/Application\ Support/JetBrains/Toolbox/apps/IDEA-U/ch-1/203.7148.57/IntelliJ\ IDEA.app/
# open -a ~/Library/Application\ Support/JetBrains/Toolbox/apps/IDEA-U/ch-1/211.6693.111/IntelliJ\ IDEA.app/
# open -a ~/Library/Application\ Support/JetBrains/Toolbox/apps/IDEA-U/ch-1/211.7142.45/IntelliJ\ IDEA.app/
# open -a ~/Library/Application\ Support/JetBrains/Toolbox/apps/IDEA-U/ch-1/213.6777.52/IntelliJ\ IDEA.app/
# open -a ~/Library/Application\ Support/JetBrains/Toolbox/apps/IDEA-U/ch-1/213.7172.25/IntelliJ\ IDEA.app/
# open -a ~/Library/Application\ Support/JetBrains/Toolbox/apps/IDEA-U/ch-1/221.6008.13/IntelliJ\ IDEA.app/
# open -a ~/Library/Application\ Support/JetBrains/Toolbox/apps/IDEA-U/ch-1/222.4345.14/IntelliJ\ IDEA.app/
# open -a ~/Library/Application\ Support/JetBrains/Toolbox/apps/IDEA-U/ch-1/223.7571.182/IntelliJ\ IDEA.app/
# open -a /Applications/IntelliJ\ IDEA.app/
# idea_dir=$(find ~/Library/Application\ Support/JetBrains/Toolbox/apps/IDEA-U/ch-1 -type d -maxdepth 1 |
#                sort -V | tail -n1)
# if ps aux "IntelliJ IDEA Ultimate" | grep "IntelliJ IDEA Ultimate" |
#         grep -v grep -q; then
if pgrep -f "IntelliJ IDEA Ultimate.app/Contents/MacOS/idea" >/dev/null; then
# if pgrep aux "IntelliJ IDEA Ultimate" | grep "IntelliJ IDEA Ultimate" |
#         grep -v grep -q; then
# if is_running "IntelliJ IDEA Ultimate"; then
    echo "Bringing to front"
    osascript > /dev/null <<- "EOF"
tell application "System Events"
	tell process "IntelliJ IDEA"
		set frontmost to true
	end tell
end tell
EOF
else
    echo "Opening"
    open -a "/Users/harrisonmccullough/Applications/IntelliJ IDEA Ultimate.app/Contents/MacOS/idea"
fi
