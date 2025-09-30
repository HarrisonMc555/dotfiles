#!/usr/bin/env bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
current_music="${CURRENT_MUSIC:-amazon-music}"
# current_music="${CURRENT_MUSIC:-spotify}"
if [[ "$current_music" = spotify ]]; then
    open -a /Applications/MuteSpotifyAds.app/
fi
"${dir}/${current_music}.sh"

