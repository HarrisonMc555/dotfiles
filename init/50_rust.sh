# -*- sh-shell: bash -*-

if ! is_available rustup; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    . "$HOME/.cargo/env"
fi

crates=(
    bat # Pager with syntax highlighting
    fd-find # Find files
    ripgrep # Search files
    sd # Replace patterns in files
    xsv # View, search, and modify CSV files
)

cargo install "${crates[@]}"
