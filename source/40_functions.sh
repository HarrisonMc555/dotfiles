function histeval() {
    history -s "$@"
    eval "$@"
}

function is_available() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: is_available CMD"
        echo "CMD can be a binary, alias, function, or anything that can be "\
             "executed as a command"
        return 1
    fi
    cmd="$1"
    command -v "$cmd" &> /dev/null
}
