#!/usr/bin/env bash
# shellcheck disable=SC1087

if is_available git; then

    if is_osx; then
        # When using Git with large projects on MacOS I will occasionally get a
        # "too many open files" error. Increasing the maximum number of open
        # files fixes this error.

        # Since making this change, I've changed the maximum open files with
        # launchctl, and now the starting default soft limit is 64000 and the
        # starting default hard limit is unlimited.

        # ulimit -n 1024

        :
    fi

    # Completions for git aliases
    function _git_diverge() { __git_complete_refs; }
    function _git_subject() { _git_show; }
    function _git_body() { _git_show; }
    function _git_message() { _git_show; }
    function _git_rebase_continue_no_edit() { _git_rebase; }
    function _git_merge_continue_no_edit() { _git_merge; }
    function _git_hash() { _git_log; }
    function _git_full_hash() { _git_log; }
    function _git_merge_check() { __gitcomp_nl "$(__git_refs)"; }
    function _git_ol() { _git_log; }
    function _git_ol_vanilla() { _git_log; }
    function _git_olns() { _git_log; }
    function _git_lp() { _git_log; }
    function _git_compare() { __git_complete_refs; }
    function _git_ahead_behind() { __git_complete_refs; }
    function _git_log_author_date() { _git_log; }
    function _git_b() { _git_branch; }
    function _git_stsw() { __git_complete_refs; }
    function _git_update_branches() { __git_complete_refs; }
    function _git_exists() { __git_complete_refs; }
    function _git_rename_branch() { __git_complete_refs; }
    function _git_rename_upstream() { __git_complete_refs; }
    function _git_mass_cherry_pick() { __git_complete_refs; }
    function _git_find_merge() { __git_complete_refs; }
    function _git_show_merge() { __git_complete_refs; }
    function _git_logns() { _git_log; }
    function _git_stash_list() { _git_log; }
    function _git_stash_dates() { _git_log; }
    function _git_pull_request() { _git_log; }
    # function _git_alias() { __git_main; }

    # Git shortcuts

    alias gcm="git commit -m"
    alias gcam="git commit -a -m"

    # On Ubuntu, completions are lazy-loaded. This is normally good, but the
    # __git_complete function is _also_ lazy loaded, which we would like to use
    # now. Use the _completion_loader function to force loading of the Git
    # completion script and provide the __git_complete function.
    if is_ubuntu; then
        _completion_loader git
    fi
    # If, even after trying that, the __git_complete function is _still_
    # unavailable, then don't try to define Git completions. Since I would like
    # to define the completions inline with the definition of each function,
    # define a helper function that defaults to a no-op if the __git_complete
    # function is unavailable.
    if is_available __git_complete; then
        __my_git_complete() {
            __git_complete "$@"
        }
    else
        __my_git_complete() {
            # No op
            :
        }
    fi

    alias g='git'
    function ga() { git add "${@:-.}"; } # Add all files by default
    __my_git_complete ga git_add
    function gap() { git add -p "${@:-.}"; } # Add all files by default
    __my_git_complete gap git_add
    function grp() { git restore --patch "${@:-.}"; } # Restore all files by default
    __my_git_complete grp git_restore
    function grps() { git restore --patch --staged "${@:-.}"; } # Restore all files by default
    __my_git_complete grps git_restore
    alias gp='git push -u'
    __my_git_complete gp git_push
    # alias gpup='gp --set-upstream origin $(gbs)'
    # alias gpa='gp --all'
    alias gu='git pull --prune'
    __my_git_complete gu git_pull
    alias gl='git log'
    __my_git_complete gl git_log
    alias gg='git lg'
    __my_git_complete gg git_log
    # alias gg='gl --decorate --oneline --graph --date-order --all'
    alias gs='git status'
    __my_git_complete gs git_status
    # alias gst='gs'
    alias gd='git diff'
    __my_git_complete gd git_diff
    alias gdd='git dd'
    __my_git_complete gdd git_diff
    alias gddc='git ddc'
    __my_git_complete gddc git_diff
    alias wdiff="git diff --no-index --word-diff"
    __my_git_complete wdiff git_diff
    alias gdn='git diff --no-index'
    __my_git_complete gdn git_diff
    alias gdw='gd --word-diff'
    __my_git_complete gdw git_diff
    alias gdc='gd --cached'
    __my_git_complete gdc git_diff
    alias gds='git ds'
    __my_git_complete gds git_diff
    alias gdcs='git -c delta.side-by-side=true diff --cached'
    __my_git_complete gdcs git_diff
    alias gdsc='git -c delta.side-by-side=true diff --cached'
    __my_git_complete gdsc git_diff
    # alias gm='git commit -m'
    # alias gma='git commit -am'
    alias gam='git commit --amend -m'
    # alias gb='git branch'
    # alias gba='git branch -a'
    alias gc='git commit'
    __my_git_complete gc git_commit
    # function gc() { git checkout "${@:-master}"; } # Checkout master by default
    # alias gco='gc'
    # alias gcb='gc -b'
    # alias gbc='gc -b' # Dyslexia
    alias grem='git remote'
    __my_git_complete grem git_remote
    alias grv='grem -v'
    __my_git_complete grv git_remote
    # #alias gra='git remote add'
    # alias grr='git remote rm'
    # alias gcl='git clone'

    # Current branch or SHA if detached.
    function gbs() {
        git branch |
            perl -ne '/^\* (?:\(detached from (.*)\)|(.*))/ && print "$1$2"'
    }

    # Rebase topic branch onto origin parent branch and update local parent branch
    # to match origin parent branch
    # function grbo() {
    #   local parent topic parent_sha origin_sha
    #   parent=$1
    #   topic=$2
    #   [[ ! "$parent" ]] && _grbo_err "Missing parent branch." && return 1
    #   parent_sha=$(git rev-parse $parent 2>/dev/null)
    #   [[ $? != 0 ]] && _grbo_err "Invalid parent branch: $parent" && return 1
    #   origin_sha=$(git ls-remote origin $parent | awk '{print $1}')
    #   [[ ! "$origin_sha" ]] && _grbo_err "Invalid origin parent branch: origin/$parent" && return 1
    #   [[ "$parent_sha" == "$origin_sha" ]] && echo "Same SHA for parent and origin/parent. Nothing to do!" && return
    #   if [[ "$topic" ]]; then
    #     git rev-parse "$topic" >/dev/null 2>&1
    #     [[ $? != 0 ]] && _grbo_err "Invalid topic branch: $topic" && return 1
    #   else
    #     topic="$(git rev-parse --abbrev-ref HEAD)"
    #   fi
    #   [[ "$topic" == "HEAD" ]] && _grbo_err "Missing or invalid topic branch." && return 1
    #   [[ "$topic" == "$parent" ]] && _grbo_err "Topic and parent branch must be different!" && return 1
    #   read -n 1 -r -p "About to rebase $topic onto origin/$parent. Are you sure? [y/N] "
    #   if [[ $REPLY =~ ^[Yy]$ ]]; then
    #     echo
    #     git fetch &&
    #     git rebase --onto origin/$parent $parent "$topic" &&
    #     git branch -f $parent origin/$parent
    #   else
    #     echo "Aborted by user."
    #   fi
    # }
    # function _grbo_err() {
    #   echo "Error: $@"
    #   echo "Usage: grbo parent-branch [topic-branch]"
    # }

    # open all changed files (that still actually exist) in the editor
    # function gedit() {
    #     if [[ $# -lt 1 ]] || [[ $# -gt 2 ]]; then
    #         echo "Usage: gedit FROM [UNTIL]"
    #         return 1
    #     fi
    #     local files
    #     while IFS=$'\n' read -r file; do files+="$file"; done < <(git diff --name-status "$@" | grep -v '^D' | cut -f2 | sort | uniq)
    #     echo "Opening files modified $([[ "$2" ]] && echo "between $1 and $2" || echo "since $1")"
    #     $(visual_nowait_editor) "${files[@]}"
    # }

    # # add a github remote by github username
    # function gra() {
    #   if (( "${#@}" != 1 )); then
    #     echo "Usage: gra githubuser"
    #     return 1;
    #   fi
    #   local repo=$(gr show -n origin | perl -ne '/Fetch URL: .*github\.com[:\/].*\/(.*)/ && print $1')
    #   gr add "$1" "git://github.com/$1/$repo"
    # }

    # # GitHub URL for current repo.
    # function gurl() {
    #   local remotename="${@:-origin}"
    #   local remote="$(git remote -v | awk '/^'"$remotename"'.*\(push\)$/ {print $2}')"
    #   [[ "$remote" ]] || return
    #   local host="$(echo "$remote" | perl -pe 's/.*@//;s/:.*//')"
    #   local user_repo="$(echo "$remote" | perl -pe 's/.*://;s/\.git$//')"
    #   echo "https://$host/$user_repo"
    # }
    # # GitHub URL for current repo, including current branch + path.
    # alias gurlp='echo $(gurl)/tree/$(gbs)/$(git rev-parse --show-prefix)'

    # git log with per-commit cmd-clickable GitHub URLs (iTerm)
#     function gitfiles() {
#         git log "$@" --name-status --color | awk "$(cat <<AWK
#     /^.*commit [0-9a-f]{40}/ {sha=substr(\$2,1,7)}
#     /^[MA]\t/ {printf "%s\t$(gurl)/blob/%s/%s\n", \$1, sha, \$2; next}
#     /.*/ {print \$0}
# AWK
#   )" | less -F
#     }

    # # open last commit in GitHub, in the browser.
    # function gfu() {
    #   local n="${@:-1}"
    #   n=$((n-1))
    #   git web--browse  $(git log -n 1 --skip=$n --pretty=oneline | awk "{printf \"$(gurl)/commit/%s\", substr(\$1,1,7)}")
    # }
    # # open current branch + path in GitHub, in the browser.
    # alias gpu='git web--browse $(gurlp)'

    # Just the last few commits, please!
    # shellcheck disable=SC2139
    # for n in {1..5}; do alias gf$n="gf -n $n"; done

    # function gj() { git-jump "${@:-next}"; }
    # alias gj-='gj prev'

    # Combine diff --name-status and --stat
    function gstat() {
        local file mode modes color lines range code line_regex
        local file_len graph_len e r c
        range="${1:-HEAD~}"
        echo "Diff name-status & stat for range: $range"
        IFS=$'\n'

        mapfile -t lines < <(git diff --name-status "$range")
        code=$?; [[ $code != 0 ]] && return $code
        declare -A modes
        for line in "${lines[@]}"; do
            file="$(echo "$line" | cut -f2)"
            mode=$(echo "$line" | cut -f1)
            modes["$file"]=$mode
        done

        file_len=0
        mapfile -t lines < <(git diff -M --stat --stat-width=999 "$range")
        # shellcheck disable=SC2016
        line_regex='s/\s*([^|]+?)\s*\|.*/$1/'
        for line in "${lines[@]}"; do
            file="$(echo "$line" | perl -pe "$line_regex")"
            (( ${#file} > file_len )) && file_len=${#file}
        done
        graph_len=$((COLUMNS-file_len-10))
        (( graph_len <= 0 )) && graph_len=1

        mapfile -t lines < <(
            git diff -M --stat --stat-width=999 \
                --stat-name-width="$file_len" \
                --stat-graph-width=$graph_len --color "$range")
        e=$(echo -e "\033")
        r="$e[0m"
        declare -A c=([M]="1;33" [D]="1;31" [A]="1;32" [R]="1;34")
        for line in "${lines[@]}"; do
            file="$(echo "$line" | perl -pe "$line_regex")"
            if [[ "$file" =~ \{.+\=\>.+\} ]]; then
                mode=R
                line="$(echo "$line" | perl -pe "s/(^|=>|\})/$r$e[${c[R]}m\$1$r$e[${c[A]}m/g")"
                line="$(echo "$line" | perl -pe "s/(\{)/$r$e[${c[R]}m\$1$r$e[${c[D]}m/")"
            else
                mode=${modes["$file"]}
                color=0; [[ "$mode" ]] && color=${c[$mode]}
                line="$e[${color}m$line"
            fi
            echo "${line/|/${e}[0m${mode} |/}"
        done
        unset IFS
    }

    # # OSX-specific Git shortcuts
    # if is_osx; then
    #   alias gdk='git ksdiff'
    #   alias gdkc='gdk --cached'
    #   function gt() {
    #     local path repo
    #     {
    #       pushd "${1:-$PWD}"
    #       path="$PWD"
    #       repo="$(git rev-parse --show-toplevel)"
    #       popd
    #     } >/dev/null 2>&1
    #     if [[ -e "$repo" ]]; then
    #       echo "Opening git repo $repo."
    #       gittower "$repo"
    #     else
    #       echo "Error: $path is not a git repo."
    #     fi
    #   }
    # fi

    function gcd() {
        if [[ $# -ne 0 ]]; then
            echo "Usage: gcd"
            return 1
        fi
        cd "$(git rev-parse --show-toplevel)" || return 1
    }
    alias gitroot=gcd

    if is_available bat; then
        function glog() {
            git log --color=never "$@" | bat -p --pager='less -RFX' -l gitlog
        }
    fi

    # Commits present on current branch and NOT on specified other branch
    function gbc() {
        if [[ $# -ne 1 ]]; then
            >&2 echo "Usage: gbc BRANCH"
            return 1
        fi

        local branch="$1"
        if ! branch-exists "$branch"; then
            >&2 echo "Branch '$branch' does not exist"
            return 1
        fi

        git log --graph \
            --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' \
            --abbrev-commit --date=relative \
            "$branch..$(git rev-parse --abbrev-ref HEAD)"
    }
    __git_complete gbc __git_complete_refs

    # Commits present on specified other branch and NOT on current branch
    function gbbc() {
        if [[ $# -ne 1 ]]; then
            >&2 echo "Usage: gbbc BRANCH"
            return 1
        fi

        local branch="$1"
        if ! branch-exists "$branch"; then
            >&2 echo "Branch '$branch' does not exist"
            return 1
        fi

        git log --graph \
            --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' \
            --abbrev-commit --date=relative \
            "$(git rev-parse --abbrev-ref HEAD)..$branch"
    }
    __git_complete gbbc __git_complete_refs

    function branch-exists() {
        if [[ $# -ne 1 ]]; then
            >&2 echo "Usage: branch-exists BRANCH"
            return 1
        fi

        local branch="$1"
        [[ "$(git branch --list "$branch")" ]]
    }

    function git-delete-gone-branches() {
        # shellcheck disable=SC2016
        local awk_cmd='$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'
        git fetch -p &&
            for branch in $(git for-each-ref --format \
                            '%(refname) %(upstream:track)' refs/heads |
                                awk "$awk_cmd"); do
                git branch -d "$branch";
            done
    }

    function git-delete-gone-branches-no-fetch() {
        # shellcheck disable=SC2016
        local awk_cmd='$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'
        for branch in $(git for-each-ref --format \
                            '%(refname) %(upstream:track)' refs/heads |
                            awk "$awk_cmd"); do
            git branch -d "$branch";
        done
    }

    if is_osx; then
        function magit() {
            emacsclient -n -a "" -e "(call-interactively #'magit-status)" \
                        >/dev/null
            ~/Library/Scripts/Launch/emacs.sh
        }
    else
        function magit() {
            emacsclient -n -a "" -e "(call-interactively #'magit-status)" \
                        >/dev/null
        }
    fi

    # This is complex because we want to delegate to the completion for Git
    # itself without ending up with an infinite loop (which happens if you try
    # to just delegate to _git).
    _git_alias() {
        if [[ "$COMP_CWORD" -lt 2 ]]; then
            return
        fi
        local old_comp_line_length new_comp_line_length
        COMP_WORDS=(git "${COMP_WORDS[@]:2}")
        ((COMP_CWORD -= 1))
        old_comp_line_length=${#COMP_LINE}
        if [[ "$COMP_LINE" =~ ^[^[:blank:]]+[[:blank:]]+[^[:blank:]]+[[:blank:]]+(.*)$ ]]; then
            COMP_LINE="git ${BASH_REMATCH[1]}"
        fi
        new_comp_line_length=${#COMP_LINE}
        (( COMP_POINT += new_comp_line_length - old_comp_line_length ))

        __git_wrap__git_main "$@"

        # git alias blah
        #            ^
        # 01234567890123
        # 0         1
        # point:  11
        # length: 13
        #
        # git blah
        #      ^
        # 01234567
        # point:  5
        # length: 7
        #
        # point = point - (old length) + (new length)
        # point = 11 - 13 + 7
        # point = -2 + 7
        # point = 5
    }

    function git-absolute-path () {
        if [[ $# -ne 1 ]]; then
            >&2 echo "Usage: git-absolute-path FILE"
            return 1
        fi
        file="$1"
        if [[ ! -f "$file" ]]; then
            >&2 echo "File \"$file\" not found"
            return 1
        fi
        abs_path=$(realpath "$file") || return 1
        git_dir=$(git rev-parse --show-toplevel) || return 1
        if [[ ! -d "$git_dir" ]]; then
            >&2 echo "Could not find "
            return 1
        fi
        abs_git_dir=$(realpath "$git_dir") || return 1
        if [[ ! "$abs_path" = "$abs_git_dir"* ]]; then
            >&2 echo "File \"$file\" is not in current Git repository \"$git_dir\""
            return 1
        fi
        echo "${abs_path/${abs_git_dir}\//}"
    }
fi
