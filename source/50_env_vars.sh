# Prevent less from clearing the screen while still showing colors.
export LESS=-XRi

if is_available bat; then
    export PAGER=bat
    export BAT_PAGER='less -RX'
else
    export PAGER=/usr/bin/less
fi

function path() {
    echo "$PATH" | tr ':' '\n'
}
