#!/usr/bin/env bash

grep_ignore_grep () 
{ 
    rg -v rg | rg "$@"
}

process_name="com.romaric.mcs.gui.shell.MCSUI"
pid=$(ps aux |
          tail -n+2 |
          rg "$process_name" |
          awk '$11 != rg { print $2 }' |
          head -n1) ||
    exit
          # grep_ignore_grep "$process_name" |
          # head -n1 |
          # awk '{ print $2 }') ||

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
foreground_pid_scpt="${dir}/foreground-pid.scpt"
osascript "$foreground_pid_scpt" "$pid"

# Script contents:
# tell application "System Events"
#     set frontmost of every process whose unix id is ${pid} to true
# end tell

