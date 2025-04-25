#!/usr/bin/env bash
# shellcheck disable=SC2209 disable=SC2153

# Avoid errors
alias cp='cp -i'
alias mv='mv -i'

# Files will be created with these permissions:
# files 644 -rw-r--r-- (666 minus 022)
# dirs  755 drwxr-xr-x (777 minus 022)
umask 022

# File size
alias fs="stat -f '%z bytes'"
alias df='df -h'

# Recursively delete `.DS_Store` files
function dsstore() {
    if [[ $# -eq 0 ]]; then
        dirs=( . )
    else
        dirs=( "$@" )
    fi
    find_no_err "${dirs[@]}" -name '.DS_Store' -type f -print0 | xargs -0 rm
}

# Recursively delete `*~` files
function tilde() {
    if [[ $# -eq 0 ]]; then
        dirs=( . )
    else
        dirs=( "$@" )
    fi
    find_no_err "${dirs[@]}" -name '*~' -type f -print0 | xargs -0 rm
}

# Recursively delete `#*` files
function pound() {
    if [[ $# -eq 0 ]]; then
        dirs=( . )
    else
        dirs=( "$@" )
    fi
    find_no_err "${dirs[@]}" -name '#*' -type f -print0 | xargs -0 rm
}

# Recursively delete `__MACOSX` directories
function __macosx() {
    if [[ $# -eq 0 ]]; then
        dirs=( . )
    else
        dirs=( "$@" )
    fi
    find_no_err "${dirs[@]}" -name '__MACOSX' -type d -print0 | xargs -0 rm -r
}

function cleanup() {
    if [[ $# -eq 0 ]]; then
        dirs=( . )
    else
        dirs=( "$@" )
    fi
    find_no_err "${dirs[@]}" \
                \( \
                \( -name '__MACOSX' -type d \) -o \
                \( -name '.DS_Store' -type f \) -o \
                \( -name '*~' -type f \) -o \
                \( -name '#*' -type f \) \
                \) -print0 |
        xargs -0 rm -r
}

function remove-empty-directories() {
    if [[ $# -eq 0 ]]; then
        directories=(.)
    else
        directories=("$@")
    fi
    # I cannot delete the .Trash folder in OneDrive. That's fine.
    find "${directories[@]}" -type d -empty -and -not -name .Trash -print -delete
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

alias edb=editbin
alias cdb=cdbin
alias opb=openbin

complete -F _command editbin
complete -F _command openbin
complete -F _command cdbin

complete -F _command edb
complete -F _command opb
complete -F _command cdb
