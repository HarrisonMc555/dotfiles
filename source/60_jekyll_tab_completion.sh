#!/usr/bin/env bash

_jekyll_commands()
{
    local commands="serve build"
    COMPREPLY=( $(compgen -W "${commands}" -- ${current}) )
}


_jekyll_cmd_serve()
{
    local options="--config --future"
    COMPREPLY=( $(compgen -W "${options}" -- ${current}) )
}


_jekyll() 
{
    local current commands items cmd i
    COMPREPLY=()
    current="${COMP_WORDS[COMP_CWORD]}"

    # searching for the command
    # (first non-option argument)
    for ((i=1; $i<=$COMP_CWORD; i++)); do
        if [[ ${COMP_WORDS[i]} != -* ]]; then
            cmd="${COMP_WORDS[i]}"
            break
        fi
    done

    if [ "$(type -t "_jekyll_cmd_$cmd")" = function ]; then
	    "_jekyll_cmd_$cmd"
	    return 0
	fi

    if [ -z "$cmd" ] || [ $COMP_CWORD -eq $i ]; then
        _jekyll_commands
    fi
}


complete -F _jekyll jekyll
