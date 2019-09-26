function histeval() {
    history -s "$@"
    eval "$@"
}
