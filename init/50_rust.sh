# -*- sh-shell: bash -*-

if ! is_available rustup; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

crates=(
    bat
    fd-find
    ripgrep
    sd
    xsv
)

cargo install "${crates[@]}"
