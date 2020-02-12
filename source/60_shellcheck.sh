#!/usr/bin/env bash

if is_available shellcheck; then

    export SHELLCHECK_OPTS="-e SC1090"

fi
