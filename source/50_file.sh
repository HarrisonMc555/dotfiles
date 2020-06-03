#!/usr/bin/env bash
# shellcheck disable=SC2209 disable=SC2153

# Files will be created with these permissions:
# files 644 -rw-r--r-- (666 minus 022)
# dirs  755 drwxr-xr-x (777 minus 022)
umask 022

# File size
alias fs="stat -f '%z bytes'"
alias df='df -h'

# Recursively delete `.DS_Store` files
function dsstore() {
    dirs=( "$@" )
    if [[ ! "$1" ]]; then
        dirs=( . )
    fi
    find_no_err "${dirs[@]}" -name '*.DS_Store' -type f -ls -delete
}

# Recursively delete `*~` files
function tilde() {
    dirs=( "$@" )
    if [[ ! "$1" ]]; then
        dirs=( . )
    fi
    find_no_err "${dirs[@]}" -name '*~' -type f -ls -delete
}

function editbin() {
    local editor
    # 
    if [[ "$EDITBIN_COMMAND" ]]; then
        editor="$EDITBIN_COMMAND"
    elif [[ "$VISUAL" ]]; then
        editor="$VISUAL"
    elif [[ "$EDITOR" ]]; then
        editor="$EDITOR"
    else
        editor=vi
    fi

    commandbin "$editor" "$@"
}

function openbin() {
    local opener
    if [[ "$OPENBIN_COMMAND" ]]; then
        opener="$OPENBIN_COMMAND"
    elif [[ "$VISUAL" ]]; then
        opener="$VISUAL"
    elif [[ "$EDITOR" ]]; then
        opener="$EDITOR"
    else
        opener=vi
    fi

    commandbin "$opener" "$@"
}

function editbin() {
    local editor
    if [[ "$EDITBIN_COMMAND" ]]; then
        editor="$EDITBIN_COMMAND"
    elif [[ "$VISUAL" ]]; then
        editor="$VISUAL"
    elif [[ "$EDITOR" ]]; then
        editor="$EDITOR"
    else
        editor=vi
    fi

    commandbin "$editor" "$@"
}

function commandbin() {
    local command="$1"
    shift
    local bin_name="$1"
    shift

    if [[ ! "$command" ]] || [[ ! "$bin_name" ]]; then
        echo "Usage: commandbin <command> <binary> [args]*"
        return 1
    fi

    if [[ $(type -t "$bin_name") != file ]]; then
        echo "Argument must be a file"
        msg="$(type -f "$bin_name" 2>&1)"
        echo "(it was a ${msg})"
        return 1
    fi

    bin_location="$(which "$bin_name")"

    if [[ ! -r "$bin_location" ]]; then
        echo "Argument must be a readable file"
        return 1
    fi

    $command "$bin_location" "$@"
}

function cdbin ()
{
    if [[ $# -ne 1 ]]; then
        echo "Usage: cdbin EXECUTABLE_NAME"
        return 1
    fi
    bin_dir="$(dirname "$(which "$1")")"
    cd "$bin_dir" || >&2 echo "Could not cd to '$bin_dir'"
}


if is_available sd; then
    function sd-sed() {
        "$(which sd)" -p "$@"
    }
fi

alias cdb=cdbin
alias opb=openbin
