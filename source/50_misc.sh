# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Expand to "" if no glob matches
shopt -s nullglob

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

alias grep='grep --color=auto'

# Prevent less from clearing the screen while still showing colors.
export LESS=-XRi

# Set the terminal's title bar.
function titlebar() {
  echo -n $'\e]0;'"$*"$'\a'
}

# SSH auto-completion based on entries in known_hosts.
if [[ -e ~/.ssh/known_hosts ]]; then
  complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq | grep -v '[0-9]')" ssh scp sftp
fi

# Run a command repeatedly in a loop, with a delay (defaults to 1 sec).
# Usage:
#   loop [delay] single_command [args]
#   loopc [delay] 'command1 [args]; command2 [args]; ...'
# Note, these do the same thing:
#   loop 5 bash -c 'echo foo; echo bar;
#   loopc 5 'echo foo; echo bar'
function loopc() { loop "$@"; }
function loop() {
  local caller=$(caller 0 | awk '{print $2}')
  local delay=1
  if [[ $1 =~ ^[0-9]*(\.[0-9]+)?$ ]]; then
    delay=$1
    shift
  fi
  while true; do
    if [[ "$caller" == "loopc" ]]; then
      bash -c "$@"
    else
      "$@"
    fi
    sleep $delay
  done
}

export RIPGREP_CONFIG_PATH=~/.ripgreprc

function rgl() {
    rg --color=always "$@" --sort path | less
}

function rgh() {
    rg --hidden --no-ignore "$@"
}

function rghl() {
    rg --hidden --no-ignore --color=always "$@" --sort path | less
}

function rglh() {
    rghl "$@"
}

function svndiff()
{
    svn diff "$@" | colordiff | less -RFX
}

function svnpraise()
{
    svn praise "$@" | cat -n | less
}
alias svnblame=svnpraise

function sbashrc() {
    source ~/.bashrc
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
alias time='/usr/bin/time'
export RUST_BACKTRACE=1

[ -f ~/.config/exercism/exercism_completion.bash ] &&
    source ~/.config/exercism/exercism_completion.bash

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

is_osx &&
    test -e ~/.iterm2_shell_integration.bash &&
    source ~/.iterm2_shell_integration.bash

export SHELLCHECK_OPTS="-e SC1090"

function path() {
    echo "$PATH" | tr ':' '\n'
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

export PAGER=/usr/bin/less

function editbin() {
    local bin_name="$1"
    shift

    if [[ ! "$bin_name" ]]; then
        echo "Usage: editbin <binary>"
        return 1
    fi

    if [[ $(type -t "$bin_name") != file ]]; then
        echo "Argument must be a file"
        echo "(it was a $(type -f "$bin_name"))"
        return 1
    fi

    bin_location="$(which "$bin_name")"

    if [[ ! -r "$bin_location" ]]; then
        echo "Argument must be a readable file"
        return 1
    fi

    local editor
    if [[ "$VISUAL" ]]; then
        editor="$VISUAL"
    elif [[ "$EDITOR" ]]; then
        editor="$EDITOR"
    else
        editor=vi
    fi

    $editor "$bin_location" $@
}

function psg() {
    ps aux |
        rg -v -e "rg $@" -e "rg -v -e \"'rg $@'\"" |
        rg $@ --color=always |
        sed -e 'G' |
        less
}

function space2lines() {
    if [[ $# > 1 ]]; then
        echo "Usage: lines [file]"
        return 1
    fi

    if [[ "$1" ]]; then
        cat "$1" | __space2lines
    else
        __space2lines
    fi
}

function __space2lines() {
    tr ' ' '\n'
}

function doublelines() {
    if [[ $# > 1 ]]; then
        echo "Usage: doublelines [file]"
        return 1
    fi

    if [[ "$1" ]]; then
        cat "$1" | __doublelines
    else
        __doublelines
    fi
}

function __doublelines() {
    awk '{ print; print "" }'
}

[[ -f ~/.ghcup/env ]] && source ~/.ghcup/env

alias e="echo"
alias l="less"
alias em="emacs"
