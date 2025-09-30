#!/usr/bin/env bash

dir="$( dirname -- "${BASH_SOURCE[0]}"; )";   # Get the directory name
dir="$( readlink -f -- "$dir"; )";    # Resolve its full path if need be
./"$dir"/idea.sh "$@"
# ./"$dir"/vscode.sh "$@"
