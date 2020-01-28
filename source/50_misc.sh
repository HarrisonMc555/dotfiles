export PAGER=/usr/bin/less
alias grep='grep --color=auto'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias time='/usr/bin/time'

alias e='echo'
alias l='less'

if is_osx; then
    # Start ScreenSaver. This will lock the screen if locking is enabled.
    alias lock="open -a ScreenSaverEngine"
fi

if is_ubuntu; then
    function pbcopy() {
        xclip -i -selection clipboard "$@"
    }
fi

# Trim trailing new line and copy to clipboard
function c() {
    if [[ $# -gt 0 ]]; then
        echo "$@" | perl -pe 'chomp if eof' | pbcopy
    else
        perl -pe 'chomp if eof' | pbcopy
    fi
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

function psg() {
    ps aux |
        grep -v -e "grep $@" -e "grep -v -e \"'grep $@'\"" |
        grep $@ --color=always |
        sed -e 'G' |
        less
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
