#!/usr/bin/env bash

# Searching

if is_available rg; then
    _SEARCH_BINARY=rg

   function _grep() {
       rg "$@"
   }
else
    # shellcheck disable=2209
    _SEARCH_BINARY=grep

   function _grep() {
       grep "$@"
   }
fi

export _SEARCH_BINARY
export -f _grep
