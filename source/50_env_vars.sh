#!/usr/bin/env bash

# Prevent less from clearing the screen while still showing colors.
export LESS=-XRi

function path() {
    echo "$PATH" | tr ':' '\n'
}
