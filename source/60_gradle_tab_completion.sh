#!/usr/bin/env bash

# https://gist.github.com/nolanlawson/8694399

_gradle()
{
  local cur=${COMP_WORDS[COMP_CWORD]}
  local gradle_cmd='gradle'
  if [[ -x ./gradlew ]]; then
    gradle_cmd='./gradlew'
  fi
  if [[ -x ../gradlew ]]; then
    gradle_cmd='../gradlew'
  fi

  local commands=''
  local cache_dir="$HOME/.gradle_tabcompletion"
  mkdir -p "$cache_dir"

  # TODO: include the gradle version in the checksum?  It's kinda slow
  #local gradle_version=$($gradle_cmd --version --quiet --no-color | grep '^Gradle ' | sed 's/Gradle //g')

  local gradle_files_checksum=''
  local possible_gradle_files=(
    build.gradle
    build.gradle.kts
    settings.gradle
    settings.gradle.kts
  )
  local found_gradle_file=''
  for f in "${possible_gradle_files[@]}"; do
    if [[ -f "$f" ]]; then
      found_gradle_file="$f"
    fi
  done
  if [[ -n "$found_gradle_file" ]]; then # top-level gradle file
    if [[ -x $(which md5 2> /dev/null) ]]; then # mac
      gradle_files_checksum=$(md5 -q "$found_gradle_file") || return
    else # linux
      gradle_files_checksum=$(md5sum "$found_gradle_file") || return
    fi
  else # no top-level gradle file
    gradle_files_checksum='no_gradle_files'
  fi
  if [[ -f "$cache_dir/$gradle_files_checksum" ]]; then # cached
    commands=$(cat "$cache_dir/$gradle_files_checksum")
  else # not cached
    readarray -t words < <(($gradle_cmd --console=plain --quiet --offline tasks 2>/dev/null |
               grep -E '^[a-zA-Z0-9_-]+ - ' |
               awk '{print $1}')) || return
    for word in "${words[@]}"; do
      commands+="$(printf '%q' "$word") "
    done
    if [[ -n "$commands" ]]; then
      echo "$commands" > "$cache_dir/$gradle_files_checksum"
    fi
  fi
  if [[ -n "$commands" ]]; then
    while read -r comp; do
      COMPREPLY+=("$comp")
    done < <(compgen -W "$commands" -- "$cur")
  fi
  # COMPREPLY=( $(compgen -W "$commands" -- "$cur") )
  # COMPREPLY=( $(compgen -W "${commands[@]}" -- "$cur") )
}
complete -F _gradle gradle
complete -F _gradle gradlew
complete -F _gradle ./gradlew
