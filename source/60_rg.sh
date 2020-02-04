if is_available rg; then

    export RIPGREP_CONFIG_PATH=~/.ripgreprc

    function rgl() {
        rg -n --color=always --sort path --heading "$@" | less
    }

    function rgh() {
        rg -n --hidden --no-ignore --heading "$@"
    }

    function rghl() {
        rg -n --hidden --no-ignore --color=always --sort path --heading "$@" | less
    }

    function rglh() {
        rghl "$@"
    }

fi
