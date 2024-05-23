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
                     --preview 'file=$(echo {} | cut -c4-); { git diff --color=always -- "$file" | sed 1,4d; cat "$file"; } | head -500' |
            # Replace the renamed message with just the new file name. This must
            # be done before removing the status character so we know it's being
            # renamed. Only really relevant if a file has a ' -> ' in the file
            # name which is unlikely but possible. I'm using Perl here because
            # it has "lazy" regular expression matching.

            # Convert double-quoted strings.
            perl -pe 's|R(.) ".*?[^\\]" -> |R\1 |' |
            # Convert non-double-quoted strings.
            perl -pe 's|R(.) [^"].*? -> |R\1 |' |

            # Remove the characters that signify the status, i.e. untracked,
            # modified, added, renamed, etc.
            cut -c4- |
            # Git status --short is inconsistent with how it prints out
            # characters that need escaping. If a file is untracked, it will
            # _not_ escape spaces. If the file is already tracked, it _will_
            # escape spaces. To make it consistent, we'll unquote everything
            # that's quoted and re-quote it afterwards.

            # Unquote files quoted by double-quotes.
            sed 's/^"\(.*\)"$/\1/' |
            # Unescape any "inner" double quotes.
            sed 's/\\"/"/g' |

            # Check against printf %q to see if anything changed. If it has
            # changed, surruond in single quotes (and escape single quotes, the
            # only special character inside single quotes). If not, leave it
            # as-is.

            # The printf %q format specifier escapes any special characters for
            # the shell. If it matches what we have, then we don't need to do
            # any escaping. It's kind of annoying to have every file wrapped in
            # quotes when it doesn't need it.
            while read -r file; do
                if [[ $(printf '%q' "$file") = "$file" ]]; then
                    echo "$file"
                else
                    # Surround in single quotes, escape single quotes
                    # // means replace all
                    # \' matches on a literal single quote
                    # / means end match, begin replacement
                    # \' adds a literal single quote
                    # \\ adds a literal backslash
                    # \' adds a literal single quote
                    # \' adds another literal single quote
                    # This transforms this line:
                    # Harrison's cool file
                    # into this line:
                    # 'Harrison'\''s cool file'
                    echo "'${file//\'/\'\\\'\'}'"
                fi
            done
    }

    # Git branch
    # Fuzzy searches for branch(es)
    function gb() {
        __check_git_repo || return 1
        local out key branch
        if [[ "$#" -gt 0 ]]; then
            args=("$@")
        else
            args=("-a")
        fi
        mapfile -t out < <(git branch --color=always "${args[@]}" | grep -v '/HEAD\s' | sort |
            fzf-down --ansi --multi --tac --preview-window right:70% \
                     --expect=ctrl-o \
                     --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'"$LINES")
        key="${out[0]}"
        unset 'out[0]'
        for branch in "${out[@]}"; do
            branch=$(echo "$branch" | cut -c3- | cut -d' ' -f1)
            if [[ "$key" != ctrl-o ]]; then
                echo "${branch#remotes/*/}"
            else
                echo "$branch"
            fi
        done
    }

    # Git branch from master
    # Fuzzy searches for branch(es) whil previewing the differences from master
    # (or specified branch)
    function gbm() {
        __check_git_repo || return 1
        if [[ $# -gt 1 ]]; then
            >&2 echo "Usage: gbm [BRANCH]"
            return 1
        fi
        base="${1:-master}"
        local out key branch
        git branch -a --color=always | grep -v '/HEAD\s' | sort |
            fzf-down --ansi --multi --tac --preview-window right:70% \
                     --expect=ctrl-o \
                     --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" '"$base"'..$(sed s/^..// <<< {} | cut -d" " -f1) | head -'"$LINES" |
            tail -n+2 | # ignore key
            sed 's/^..//' |
            sed 's#^remotes/##'
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
