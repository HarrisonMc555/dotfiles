# -*- sh-shell: bash -*-

if is_available tldr; then
    tldr --seed-config && tldr --update
fi
