#!/usr/bin/env bash

if is_available go; then

    export GOPATH="${HOME}/.go"
    export PATH="$PATH:${GOPATH}/bin"
    test -d "${GOPATH}" || mkdir "${GOPATH}"
    test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"

fi
