#!/usr/bin/env bash
# shellcheck disable=SC2046 disable=SC2016

if is_available fzf; then

    [ -f ~/.fzf.bash ] && source ~/.fzf.bash

    # Export default options for preview scrolling
    export FZF_DEFAULT_OPTS="--bind '\
ctrl-v:page-down\
,alt-v:page-up\
,ctrl-f:preview-page-down\
,ctrl-u:preview-page-up\
,alt-j:preview-down\
,alt-k:preview-up\
' \
"
# --exact\

    # Setting fd as the default source for fzf
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude .svn'

    # To apply the command to CTRL-T as well
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

    # Preview file with Ctrl-T
    export FZF_CTRL_T_OPTS="--preview '(bat --style=numbers --color=always 2> /dev/null {} || highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

    export FZF_ALT_C_COMMAND="fd -t d ."

    # cdf - cd into the directory of the selected file
    function cdf() {
        local file
        local dir
        file=$(fzf +m -q "$1") && dir=$(dirname "$file") && histeval cd "$dir"
    }

    # fe [FUZZY PATTERN] - Open the selected file with the default editor
    #   - Bypass fuzzy finder if there's only one match (--select-1)
    #   - Exit if there's no match (--exit-0)
    function fe() {
        local files
        files=()
        while IFS=$'' read -r line; do files+=("$line"); done < <(ff --query="$1" --multi --select-1 --exit-0)
        echo "files = ${files[*]}"
        if [[ "${#files[@]}" -ne 0 ]]; then
            histeval $(visual_nowait_editor) "${files[@]}"
        fi
    }

    # Modified version where you can press
    #   - CTRL-O to open with `open` command,
    #   - CTRL-E or Enter key to open with the $EDITOR
    function fo() {
        local out file key
        IFS=$'\n' out=("$(ff --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
        key=$(head -1 <<< "${out[@]}")
        file=$(head -2 <<< "${out[@]}" | tail -1)
        [[ -z "$file" ]] && return
        if [[ "$key" = ctrl-o ]]; then
            open "$file"
        elif [[ "$key" = ctrl-e ]]; then
            histeval $(visual_nowait_editor) "$file"
        else
            echo "$file"
            # histeval $(visual_nowait_editor) "$file"
        fi
    }

    function fsr() {
        local files
        files=()
        while IFS=$'' read -r line; do files+=("$line"); done < <(ff --query="$1" --multi --select-1 --exit-0)
        if [[ "${#files[@]}" -ne 0 ]]; then
            histeval source "${files[@]}"
        fi
    }

    # Try bat, highlight, coderay, rougify in turn, then fall back to cat
    function ff() {
        # shellcheck disable=SC2016
        fzf --preview '[[ $(file --mime {}) =~ binary ]] &&
                 echo {} is a binary file ||
                 (bat --style=numbers --color=always {} ||
                  highlight -O ansi -l {} ||
                  coderay {} ||
                  rougify {} ||
                  cat {}) 2> /dev/null | head -500' "$@"
    }

    # fkill - kill processes - list only the ones you can kill. Modified the earlier script.
    function fkill() {
        local pid
        if [ "$UID" != "0" ]; then
            pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
        else
            pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
        fi

        if [ "x$pid" != "x" ]
        then
            echo "$pid" | xargs kill "-${1:-9}"
        fi
    }

    if is_available brew; then
        # Install (one or multiple) selected application(s)
        # using "brew search" as source input
        # mnemonic [B]rew [I]nstall [P]lugin
        function bip() {
            local packages
            packages=()
            while IFS=$'' read -r line; do packages+=("$line"); done < <(brew search | fzf -m)
            [[ "${#packages[@]}" -eq 0 ]] && return
            for package in "${packages[@]}"; do
                histeval brew install "$package"
            done
        }

        # Update (one or multiple) selected application(s)
        # mnemonic [B]rew [U]pdate [P]lugin
        function bup() {
            local packages
            packages=()
            while IFS=$'' read -r line; do packages+=("$line"); done < <(brew leaves | fzf -m)
            [[ "${#packages[@]}" -eq 0 ]] && return
            for package in "${packages[@]}"; do
                histeval brew upgrade "$package"
            done
        }
    fi

    function fif() {
        if [ $# -ne 1 ]; then
            >&2 echo "Need a string to search for!"
            return 1
        fi
        rg_search="rg --ignore-case --pretty --context 10 --colors 'match:bg:magenta' '$1'"
        file="$(rg --files-with-matches --no-messages "$1" |
            fzf --preview "(bat --style=numbers --color=always --pager='less -p \"$1\"' 2> /dev/null {} | $rg_search || highlight -O ansi -l {} 2> /dev/null | $rg_search || cat {} | $rg_search || tree -C {})")"
        histeval $(visual_nowait_editor) "$file"
    }
fi
