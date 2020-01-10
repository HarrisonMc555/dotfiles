if is_available bat; then
    export PAGER=bat
    export BAT_PAGER='less -RX'
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    alias l='bat -p'
    alias cat=bat
else
    export PAGER=/usr/bin/less
fi

