#!/usr/bin/env bash

# History settings

# Allow use to re-edit a failed history substitution.
shopt -s histreedit
# History expansions will be verified before execution.
shopt -s histverify
# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Entries beginning with space aren't added into history, and duplicate
# entries will be erased (leaving the most recent entry).
export HISTCONTROL="ignoreboth:erasedups"
# Give history timestamps.
export HISTTIMEFORMAT="[%F %T] "
# Lots o' history.
export HISTSIZE=10000
export HISTFILESIZE=10000

# Easily re-execute the last history command.
function p() {
    printf 'Executing last command: '
    fc -s
}
