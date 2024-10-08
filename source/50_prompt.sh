#!/usr/bin/env bash

# My awesome bash prompt
#
# Copyright (c) 2012 "Cowboy" Ben Alman
# Licensed under the MIT license.
# http://benalman.com/about/license/
#
# Example:
# [master:!?][cowboy@CowBook:~/.dotfiles]
# [11:14:45] $
#
# Read more (and see a screenshot) in the "Prompt" section of
# https://github.com/cowboy/dotfiles

# Abort if a prompt is already defined.
# [[ "$PROMPT_COMMAND" ]] && return

# ANSI CODES - SEPARATE MULTIPLE VALUES WITH ;
#
#  0  reset          4  underline
#  1  bold           7  inverse
#
# FG  BG  COLOR     FG  BG  COLOR
# 30  40  black     34  44  blue
# 31  41  red       35  45  magenta
# 32  42  green     36  46  cyan
# 33  43  yellow    37  47  white

declare -A FOREGROUND=(
  [black]=30
  [red]=31
  [green]=32
  [yellow]=33
  [blue]=34
  [magenta]=35
  [cyan]=36
  [white]=37
)
declare -A BACKGROUND=(
  [black]=40
  [red]=41
  [green]=42
  [yellow]=43
  [blue]=44
  [magenta]=45
  [cyan]=46
  [white]=47
)
RESET=0
BOLD=1
UNDERLINE=4
INVERSE=7


# if [[ ! "${__prompt_colors[@]}" ]]; then
if true; then
  __prompt_colors=(
    "${FOREGROUND[cyan]}" # information color
    "${FOREGROUND[white]}" # bracket color
    "${FOREGROUND[red]}" # error color
  )

  if [[ "$SSH_TTY" ]]; then
    # connected via ssh
    __prompt_colors[0]="${FOREGROUND[green]}"
  elif [[ "$USER" == "root" ]]; then
    # logged in as root
    __prompt_colors[0]="${FOREGROUND[magenta]}"
  fi
fi

unset FOREGROUND BACKGROUND RESET BOLD UNDERLINE INVERSE

# Inside a prompt function, run this alias to setup local $c0-$c9 color vars.
alias __prompt_get_colors='__prompt_colors[9]=; local i; for i in ${!__prompt_colors[@]}; do local c$i="\[\e[0;${__prompt_colors[$i]}m\]"; done'

# Exit code of previous command.
function __prompt_exit_code() {
  __prompt_get_colors
  [[ $1 != 0 ]] && echo " $c2$1$c9"
}

# Git status.
function __prompt_git() {
  __prompt_get_colors
  local status branch flags
  status="$(git status 2>/dev/null)"
  [[ $? != 0 ]] && return 1;
  branch="$(echo "$status" | awk '/# Initial commit/ {print "(init)"}')"
  [[ "$branch" ]] || branch="$(echo "$status" | awk '/# On branch/ {print $4}')"
  [[ "$branch" ]] || branch="$(git branch | perl -ne '/^\* \(detached from (.*)\)$/ ? print "($1)" : /^\* (.*)/ && print $1')"
  flags="$(
    echo "$status" | awk 'BEGIN {r=""} \
        /^(# )?Changes to be committed:$/        {r=r "+"}\
        /^(# )?Changes not staged for commit:$/  {r=r "!"}\
        /^(# )?Untracked files:$/                {r=r "?"}\
      END {print r}'
  )"
  __prompt_vcs_info=("$branch" "$flags")
}

# hg status.
function __prompt_hg() {
  __prompt_get_colors
  local summary branch bookmark flags
  summary="$(hg summary 2>/dev/null)"
  [[ $? != 0 ]] && return 1;
  branch="$(echo "$summary" | awk '/branch:/ {print $2}')"
  bookmark="$(echo "$summary" | awk '/bookmarks:/ {print $2}')"
  flags="$(
    echo "$summary" | awk 'BEGIN {r="";a=""} \
      /(modified)/     {r= "+"}\
      /(unknown)/      {a= "?"}\
      END {print r a}'
  )"
  __prompt_vcs_info=("$branch" "$bookmark" "$flags")
}

# SVN info.
function __prompt_svn() {
  __prompt_get_colors
  local info last current
  info="$(svn info . 2> /dev/null)"
  [[ ! "$info" ]] && return 1
  last="$(echo "$info" | awk '/Last Changed Rev:/ {print $4}')"
  current="$(echo "$info" | awk '/Revision:/ {print $2}')"
  __prompt_vcs_info=("$last" "$current")
}

# Maintain a per-execution call stack.
__prompt_stack=()
trap '__prompt_stack=("${__prompt_stack[@]}" "$BASH_COMMAND")' DEBUG

# User and host prompt.
# Only displays the user (or host) if it is not the default user (or host)
__DEFAULT_PROMPT_USER=user # replace this in a LOCAL file
__DEFAULT_PROMPT_HOST=host # replace this in a LOCAL file

function __set_prompt_user() {
  unset __prompt_user
  local user
  user="$(whoami)"
  [[ "$__DEFAULT_PROMPT_USER" == "$user" ]] || __prompt_user="$user"
}

function __set_prompt_host() {
  unset __prompt_host
  local host
  host="$(hostname)"
  if [[ "$__DEFAULT_PROMPT_HOST" != "$host" ]] || [[ "$SSH_TTY" ]]; then
      __prompt_host="${host%.local}"
  fi
}

# Shows the level of bash you're in. Perhaps not terribly useful, but it's good
# to be reminded if you accidentally enter a subshell
__set_sublvl() {
  if ((SHLVL > 1)); then printf " ($SHLVL)"; fi
}

function __prompt_command() {
  local i exit_code=$?
  # If the first command in the stack is __prompt_command, no command was run.
  # Set exit_code to 0 and reset the stack.
  [[ "${__prompt_stack[0]}" == "__prompt_command" ]] && exit_code=0
  __prompt_stack=()

  # Manually load z here, after $? is checked, to keep $? from being clobbered.
  [[ "$(type -t _z)" ]] && _z --add "$(pwd -P 2>/dev/null)" 2>/dev/null

  # While the simple_prompt environment var is set, disable the awesome prompt.
  [[ "$simple_prompt" ]] && PS1='\n$ ' && return

  __prompt_get_colors
  # http://twitter.com/cowboy/status/150254030654939137
  PS1="\n"
  is_iterm2 && PS1="$PS1\[$(iterm2_prompt_mark)\]"
  __prompt_vcs_info=()
  # git: [branch:flags]
  __prompt_git || \
  # hg:  [branch:bookmark:flags]
  __prompt_hg || \
  # svn: [repo:lastchanged]
  __prompt_svn
  # path: [user@host:path]
  __set_prompt_user
  __set_prompt_host
  PS1="$PS1$c1["
  if [[ "$__prompt_user" ]] || [[ "$__prompt_host" ]]; then
    if [[ "$__prompt_user" ]] && [[ "$__prompt_host" ]]; then
      PS1="$PS1$c0$__prompt_user$c1@$c0$__prompt_host"
    else
      PS1="$PS1$c0$__prompt_user$__prompt_host"
    fi
    PS1="$PS1$c1:"
  fi
  PS1="$PS1$c0\w$c1]$c9"
  # PS1="$PS1$c1[$c0\u$c1@$c0\h$c1:$c0\w$c1]$c9"
  # Iterate over all vcs info parts, outputting an escaped var name that will
  # be interpolated automatically. This ensures that malicious branch names
  # can't execute arbitrary commands. For more info, see this PR:
  # https://github.com/cowboy/dotfiles/pull/68
  if [[ "${#__prompt_vcs_info[@]}" != 0 ]]; then
    PS1="$PS1$c1[$c0"
    for i in "${!__prompt_vcs_info[@]}"; do
      if [[ "${__prompt_vcs_info[i]}" ]]; then
        [[ $i != 0 ]] && PS1="$PS1$c1:$c0"
        PS1="$PS1\${__prompt_vcs_info[$i]}"
      fi
    done
    PS1="$PS1$c1]$c9"
  fi
  # Shell sublevel (if greater than 1)
  ((SHLVL > 1)) && PS1="$PS1$c1[${c0}sh$SHLVL$c1]$c9"
  # exit code: 127
  PS1="$PS1$(__prompt_exit_code "$exit_code")"
  # misc: [cmd#:hist#]
  # PS1="$PS1$c1[$c0#\#$c1:$c0!\!$c1]$c9"
  PS1="$PS1\n"
  # date: [HH:MM:SS]
  PS1="$PS1$c1[$c0$(date +"%H$c1:$c0%M$c1:$c0%S")$c1]$c9"
  PS1="$PS1 \$ "

  # If not root, store history with more information
  [[ "$(id -u)" != 0 ]] &&
    printf "%s %s %s %s\n" \
           "$(date "+%H:%M:%S")" "$(pwd)" "$(history 1)" "#${exit_code}" >> \
           ~/.logs/bash-history-"$(date "+%Y-%m-%d")".log
}

mkdir -p ~/.logs

PROMPT_COMMAND="__prompt_command"
