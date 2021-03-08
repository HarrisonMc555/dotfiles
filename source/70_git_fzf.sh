#!/usr/bin/env bash
# shellcheck disable=SC2016

if is_available git && is_available fzf; then

    function __check_git_repo() {
        if ! is_in_git_repo; then
            >&2 echo "Not in Git repository. Exiting."
            return 1
        fi
    }

    function is_in_git_repo() {
        git rev-parse HEAD > /dev/null 2>&1
    }

    function fzf-down() {
        fzf --height 50% "$@" --border
    }

    # Git file
    # Fuzzy searches for modified or untracked file(s)
    function gf() {
        __check_git_repo || return 1
        if [[ $# -gt 1 ]]; then
            >&2 echo "Usage: gf [PATH]"
            return 1
        fi
        if [[ "$1" ]] && [[ ! -e "$1" ]]; then
            >&2 echo "Argument must be a valid path"
            return 1
        fi
        git -c color.status=always status --short "$@" |
            fzf-down -m --ansi --nth 2..,.. \
                     --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
            cut -c4- |
            sed 's/.* -> //' |
            cat
    }

    # Git branch
    # Fuzzy searches for branch(es)
    function gb() {
        __check_git_repo || return 1
        if [[ $# -ne 0 ]]; then
            >&2 echo "gb does not accept any parameters"
            return 1
        fi
        local out key branch
        out=("$(git branch -a --color=always | grep -v '/HEAD\s' | sort |
            fzf-down --ansi --multi --tac --preview-window right:70% \
                     --expect=ctrl-o \
                     --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'"$LINES")")
        key=$(head -1 <<< "${out[@]}")
        # branch=$(head -2 <<< "${out[@]}" | tail -1 | sed 's/^..//' | cut -d' ' -f1 | sed 's#^remotes/##')
        branch=$(head -2 <<< "${out[@]}" | tail -1 | sed 's/^..//' | cut -d' ' -f1)
        if [[ "$key" != ctrl-o ]]; then
            branch="${branch#remotes/*/}"
        fi
        echo "$branch"
    }

    # Git tag
    # Fuzzy searches for tag(s)
    function gt() {
        __check_git_repo || return 1
        if [[ $# -ne 0 ]]; then
            >&2 echo "gt does not accept any parameters"
            return 1
        fi
        git tag --sort -version:refname |
            fzf-down --multi --preview-window right:70% \
                     --preview 'git show --color=always {} | head -'"$LINES"
    }

    # Git history (SHA)
    # Fuzzy searches for a commit SHA(s)
    function gh() {
        __check_git_repo || return 1
        files_str=""
        for file in "$@"; do
            [[ -f "$file" ]] && files_str+=" '$file'"
        done
        git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always "$@" |
            fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
                     --header 'Press CTRL-S to toggle sort' \
                     --preview "grep -o '[a-f0-9]\{7,\}' <<< {} | xargs -I % git show --oneline --color=always % -- $files_str | head -200" |
            grep -o "[a-f0-9]\{7,\}"
    }

    # Git history (SHA)
    # Fuzzy searches for a commit SHA(s) in reverse
    function ghr() {
        __check_git_repo || return 1
        files_str=""
        for file in "$@"; do
            [[ -f "$file" ]] && files_str+=" '$file'"
        done
        git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always "$@" |
            fzf-down --ansi --no-sort --reverse --tac --multi --bind 'ctrl-s:toggle-sort' \
                     --header 'Press CTRL-S to toggle sort' \
                     --preview "grep -o '[a-f0-9]\{7,\}' <<< {} | xargs -I % git show --oneline --color=always % -- $files_str | head -200" |
            grep -o "[a-f0-9]\{7,\}"
    }

    # Git remote
    # Fuzzy searches for a git remote
    function gr() {
        __check_git_repo || return 1
        if [[ $# -ne 0 ]]; then
            >&2 echo "gr does not accept any parameters"
            return 1
        fi
        git remote -v | awk '{print $1 "\t" $2}' | uniq |
            fzf-down --tac \
                     --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
            cut -d$'\t' -f1
    }

    bind '"\er": redraw-current-line'
    bind '"\C-g\C-f": "$(gf)\e\C-e\er"'
    bind '"\C-g\C-b": "$(gb)\e\C-e\er"'
    bind '"\C-g\C-t": "$(gt)\e\C-e\er"'
    bind '"\C-g\C-h": "$(gh)\e\C-e\er"'
    bind '"\C-g\C-r": "$(gr)\e\C-e\er"'

fi
