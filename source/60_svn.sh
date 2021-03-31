#!/usr/bin/env bash

export __USE_SVN=false
if is_available svn && [[ "$__USE_SVN" = "true" ]]; then

    # SVN shortcuts
    if is_available delta; then
        function svndiff()
        {
            (set -o pipefail; svn diff "$@" | svn_strip_diff_header | delta)
        }
    else
        function svndiff()
        {
            (set -o pipefail; svn diff "$@" | colordiff | less -RX)
        }
    fi

    function svnwdiff()
    {
        (set -o pipefail; svn diff --diff-cmd="/Users/harrisonmccullough/.dotfiles/bin/svnwdiffhelper" "$@" | less -RX)
    }

    function svnpraise()
    {
        (set -o pipefail; svn praise "$@" | cat -n | less)
    }

    function svncommitupdate()
    {
        (set -o pipefail; svn commit "$@" && svn update "$(svnroot)")
    }

    function svnroot()
    {
        # https://stackoverflow.com/a/1242377/7343786

        dir="$(realpath "$(pwd)")"
        while [[ ! -d "${dir}/.svn" ]] && [[ "$dir" != "/" ]]; do
            dir="$(realpath "$dir"/..)"
        done
        if [[ -d "${dir}/.svn" ]]; then
            echo "$dir"
        else
            echo "No .svn directory found in $(pwd) or any parents." >&2
            return 1
        fi
    }

    function svnhelp()
    {
        (set -o pipefail; svn help "$@" | less)
    }

    function svnlog()
    {
        (set -o pipefail; svn log "$@" | less)
    }

    function svn_short_log() {
        (set -o pipefail; svn log "$@" | _svn_short_log)
    }

    function svn_list_changelists() {
        svn status | grep "^\-\-\- Changelist"        
    }

    alias s='svn'
    alias ss='svn st'
    alias sd='svndiff'
    alias svd='svndiff'
    alias svdw='svnwdiff'
    alias swd='svnwdiff'
    alias sp='svnpraise'
    alias srev='svn revert'
    alias sci='svncommitupdate'
    alias sup='svn update $(svnroot)'
    alias shelp='svnhelp'
    alias svnblame=svnpraise
    alias slo='svnlog'
    alias slog='svnlog'


    complete -f ss
fi
