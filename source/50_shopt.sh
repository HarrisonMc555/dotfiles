#!/usr/bin/env bash

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Expand to "" if no glob matches
# WARNING!!! This breaks lots of bash completion scripts
# shopt -s nullglob

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

