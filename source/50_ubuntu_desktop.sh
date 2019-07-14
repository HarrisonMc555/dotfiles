# Ubuntu desktop-only stuff. Abort if not Ubuntu desktop.
is_ubuntu_desktop || return 1

alias pbcopy='xclip -i -selection clipboard'
alias pbpaste='xclip -o -selection clipboard'
alias open="xdg-open"
