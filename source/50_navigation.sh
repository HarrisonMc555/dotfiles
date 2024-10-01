#!/usr/bin/env bash

export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
# Always use color output for `ls`
if is_available exa; then
    alias ls='exa -I "*~"'
    alias la='exa -a'
    # h is actually for "header" here
    alias ll='exa -alh --git'
elif is_available lsd; then
    alias ls='lsd -I "*~"'
    alias la='lsd -A'
    alias ll='lsd -l'
else
    if is_osx; then
        alias ls='ls -G'
    else
        alias ls='ls --color=auto'
    fi
    alias la='ls -A'
    alias ll='ls -Alh'
fi

if [[ -x "$(command -v tree)" ]] && [[ -x "$(command  -v which)" ]]; then
    __tree_bin="$(which tree)"
    function tree() {
        "$__tree_bin" -C "$@" | less -FRX
    }
fi

# For typos
alias sl='ls'

# Easier navigation: .., ..., -
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'
alias ~=cd

# Aliasing eachdir like this allows you to use aliases/functions as commands.
alias eachdir='. eachdir'
alias eachfile='. eachfile'
alias forever='. forever'

function cdl()
{
    dir="$1"
    shift
    cd "$dir" && ls "$@"
}

# Create a new directory and enter it
function md() {
    mkdir -p "$@" && {
        if [[ $# -eq 1 ]]; then
            cd "$@" || echo "Could not cd to '$*'"
        else
            echo "Not trying to cd to '$*'"
        fi
    }
}
