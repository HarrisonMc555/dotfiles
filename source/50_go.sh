if is_available go; then

    export GOPATH="${HOME}/.go"
    if is_osx; then
        export GOROOT="$(brew --prefix golang)/libexec"
    else
        export GOROOT="/usr/local/go"
    fi
    export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
    test -d "${GOPATH}" || mkdir "${GOPATH}"
    test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"

fi
