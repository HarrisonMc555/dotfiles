#!/usr/bin/env bash

export PAGER=/usr/bin/less
alias grep='grep --color=auto'

if is_available delta; then
    export DELTA_PAGER='less -RXSF'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
if is_osx && is_iterm2; then
    function alert() {
        if [[ $# -ne 0 ]]; then
            >&2 echo "Usage: alert"
            return 1
        fi
        tput bel
        it2attention start
    }
    export -f alert
elif is_ubuntu; then
    function alert() {
        return_code=$?
        if [[ $# -ne 0 ]]; then
            >&2 echo "Usage: alert"
            return 1
        fi
        notify-send --urgency=low -i "$([ $return_code = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e 's/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//')"
    }
    export -f alert
fi

# There are a lot of benefits to using the time builtin over the command.
# alias time='/usr/bin/time'

alias e='echo'
alias l='less'
alias lss='less -S'

if is_osx; then
    # Start ScreenSaver. This will lock the screen if locking is enabled.
    alias lock="open -a ScreenSaverEngine"
fi

if is_wsl; then
    function pbcopy() {
        echo "$@" | clip.exe
    }
    export -f pbcopy
elif is_ubuntu; then
    # shellcheck disable=SC2120
    function pbcopy() {
        xclip -i -selection clipboard "$@"
    }
    export -f pbcopy
elif is_windows; then
    function pbcopy() {
        echo "$*" | clip.exe
    }
fi

# Trim trailing new line and copy to clipboard
# shellcheck disable=SC2120
function c() {
    if [[ $# -gt 0 ]]; then
        echo "$@" | perl -pe 'chomp if eof' | pbcopy
    else
        perl -pe 'chomp if eof' | pbcopy
    fi
}

# Transform HTML to rich text.
function html2richtext() {
    sed 's/…/.../g' | textutil -stdin -format html -convert rtf -stdout
}

# Transform HTML to rich text and send to clipboard.
# Example:
# $ pandoc README.md | htmlcopy
function htmlcopy() {
    html2richtext | c
}

function sbashrc() {
    source ~/.bashrc
}

__tput_smul="$(tput smul)"
__tput_rmul="$(tput rmul)"
function e_underline()   {
    if [[ $# != 1 ]]; then
        echo "usage: e_underline <message>"
        return
    fi

    str="$1"
    echo -e "\n${__tput_smul}${str}${__tput_rmul}"
}

function e_title () {
    if [[ $# -eq 0 ]]; then
        echo "usage: e_title <message>"
        return
    fi
    # title=$(echo "$*" | tr '[:lower:]' '[:upper:]')
    box_line=$(echo " $* " | sed -E 's/./─/g' )
    echo
    echo "┌${box_line}┐"
    echo -e "│ \033[1;3m$*\033[0m │"
    echo "└${box_line}┘"
}

# Set the terminal's title bar.
function titlebar() {
    echo -n $'\e]0;'"$*"$'\a'
}

set -o emacs

z_file="$DOTFILES"/vendor/z/z.sh
[[ -f "$z_file" ]] && source "$z_file"

br_source='/Users/harrisonmccullough/Library/Preferences/org.dystroy.broot/launcher/bash/br'
[[ -f "$br_source" ]] && source "$br_source"

function all_colors() {
    for x in {0..8}; do
        for i in {30..37}; do
            # echo -ne "\e[$x;$i""m\\\e[$x;$i    ""\e[0;37;40m "
            echo -ne "\e[$x;$i""m\\\e[$x;$i    ""\e[0m "
            for a in {40..47}; do
                # echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "
                echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0m "
            done
            echo
        done
    done
    echo ""
}

function foreground_colors() {
    for x in {30..39} {90..99}; do
        echo -e "\e[$x""m\\\e[$x""m\e[0m"
    done
}

if is_available q; then
    alias qcsv="q -d',' -H -O"
fi

perlbrew_bashrc=~/perl5/perlbrew/etc/bashrc
if [[ -f "$perlbrew_bashrc" ]]; then
    source "$perlbrew_bashrc"
fi

function slugify() {
    if [[ $# -gt 0 ]]; then
        echo "$@"
    else
        cat
    fi | tr -s -c '[:alnum:]_-' '-' | tr '[:upper:]' '[:lower:]' | sed 's/-*$//'
}

if is_osx; then
    export LC_CTYPE=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
fi

if is_available baobab; then
    function baobab() {
        command baobab "$@" &>/dev/null & disown
    }
fi

if is_osx; then
    function active_apps() {
        if [[ $# -ne 0 ]]; then
            >&2 echo "Usage: active_apps"
            return 1
        fi
        lsappinfo metainfo |
            grep bringForwardOrder |
            grep -E -o '"[^"]+"' |
            tr -d '"'
    }
fi

export -f c html2richtext htmlcopy sbashrc e_underline e_title titlebar \
       all_colors foreground_colors slugify

complete -F _command eachdir
complete -F _command eachfile
