if is_available bat; then
    export PAGER='bat --style=snip'
    export BAT_PAGER='less -RX'
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    alias l='bat --style=plain'
    alias cat=bat
fi

