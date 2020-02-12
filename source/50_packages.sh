#!/usr/bin/env bash

if is_osx; then
    alias cask="brew cask"
fi

if is_ubuntu; then
    # Package management
    alias update="sudo apt-get -qq update && sudo apt-get upgrade"
    alias install="sudo apt-get install"
    alias remove="sudo apt-get remove"
    alias search="apt-cache search"

    # Make 'less' more.
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
fi

if is_ubuntu_desktop; then
    alias pbcopy='xclip -i -selection clipboard'
    alias pbpaste='xclip -o -selection clipboard'
    alias open="xdg-open"
    alias say=spd-say
fi
