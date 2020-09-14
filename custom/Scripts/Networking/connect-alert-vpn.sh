#!/usr/bin/env bash

osascript <<- "EOF"
tell application "System Events"
	tell current location of network preferences
		set VPN to "Alert VPN"
		set VPNactive to connected of current configuration of service VPN
		-- connect service VPN
		if not VPNactive then
			connect service VPN
		-- else
		--	disconnect service VPN
		end if
	end tell
end tell
EOF
