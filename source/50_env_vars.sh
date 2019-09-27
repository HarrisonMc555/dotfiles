# Prevent less from clearing the screen while still showing colors.
export LESS=-XRi

export PAGER=/usr/bin/less

function path() {
    echo "$PATH" | tr ':' '\n'
}
