#!/usr/bin/env bash

# Searching

if is_available rg; then
    _SEARCH_BINARY=rg

   function _grep() {
       rg "$@"
   }
else
    _SEARCH_BINARY=grep

   function _grep() {
       grep "$@"
   }
fi

export -f _grep
