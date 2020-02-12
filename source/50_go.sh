#!/usr/bin/env bash

if is_available go; then

    export GOPATH="${HOME}/.go"
    if is_osx; then
        # brew --prefix is kind of slow
        brew_prefix="$(dirname "$(dirname "$(type -p brew)")")"
        export GOROOT="$brew_prefix"/opt/go
        # export GOROOT="$(brew --prefix golang)/libexec"
    else
        export GOROOT="/usr/local/go"
    fi
    export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
    test -d "${GOPATH}" || mkdir "${GOPATH}"
    test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"

fi
