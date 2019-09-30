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
'"

    # Setting fd as the default source for fzf
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude .svn'

    # To apply the command to CTRL-T as well
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

    # Preview file with Ctrl-T
    export FZF_CTRL_T_OPTS="--preview '(bat --style=numbers --color=always 2> /dev/null {} || highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

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
        local files e
        IFS=$'\n' files=($(ff --query="$1" --multi --select-1 --exit-0))
        if [[ -n "$files" ]]; then
            # e=${VISUAL:-$EDITOR}
            # e=${e:-vim}
            e="emacsclient -a '' -n"
            histeval $e "${files[@]}"
        fi
    }

    # Modified version where you can press
    #   - CTRL-O to open with `open` command,
    #   - CTRL-E or Enter key to open with the $EDITOR
    function fo() {
        local out file key e
        IFS=$'\n' out=("$(ff --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
        key=$(head -1 <<< "$out")
        file=$(head -2 <<< "$out" | tail -1)
        if [ -n "$file" ]; then
            # e=${VISUAL:-$EDITOR}
            # e=${e:-vim}
            e="emacsclient -a '' -n"
            echo $e
            [ "$key" = ctrl-o ] && open "$file" || histeval $e "$file"
        fi
    }

    function fsr() {
        local files e
        IFS=$'\n' files=($(ff --query="$1" --multi --select-1 --exit-0))
        if [[ -n "$files" ]]; then
            histeval source "${files[@]}"
        fi
    }

    # Try bat, highlight, coderay, rougify in turn, then fall back to cat
    function ff() {
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
            echo $pid | xargs kill -${1:-9}
        fi
    }

    if is_available brew; then
        # Install (one or multiple) selected application(s)
        # using "brew search" as source input
        # mnemonic [B]rew [I]nstall [P]lugin
        function bip() {
            local inst=$(brew search | fzf -m)

            if [[ $inst ]]; then
                for prog in $(echo $inst); do
                    histeval brew install $prog
                done
            fi
        }

        # Update (one or multiple) selected application(s)
        # mnemonic [B]rew [U]pdate [P]lugin
        function bup() {
            local upd=$(brew leaves | fzf -m)

            if [[ $upd ]]; then
                for prog in $(echo $upd); do
                    histeval brew upgrade $prog
                done
            fi
        }
    fi

fi
