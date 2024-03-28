# -*- sh-shell: bash -*-

is_available() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: is_available CMD"
        echo "CMD can be a binary, alias, function, or anything that can be "\
             "executed as a command"
        return 1
    fi
    cmd="$1"
    command -v "$cmd" &> /dev/null
}

if ! is_available rustup; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

crates=(
    bat
    fd-find
    hx
    lsd
    ripgrep
    runiq
    sd
    xsv
)

cargo install "${crates[@]}"
