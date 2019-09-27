if is_available svn; then

    # SVN shortcuts
    function svndiff()
    {
        svn diff "$@" | colordiff | less -RX
    }

    function svnwdiff()
    {
        svn diff --diff-cmd="/Users/harrisonmccullough/.dotfiles/bin/svnwdiffhelper" "$@" | less -RX
    }

    function svnpraise()
    {
        svn praise "$@" | cat -n | less
    }

    function svncommitupdate()
    {
        svn commit "$@" && svn update "$(svnroot)"
    }

    function svnroot()
    {
        if [[ $# -gt 1 ]]; then
            echo "Usage: svnroot [DIR]"
            return 1
        fi

        dir="$1"
        dir="${dir:=.}"

        svn info "$dir" | sed -n 's/^Working Copy Root Path: \(.*\)/\1/p'
    }

    function svnhelp()
    {
        svn help "$@" | less
    }

    alias s='svn'
    alias ss='svn st'
    alias sd='svndiff'
    alias sdw='svnwdiff'
    alias swd='svnwdiff'
    alias sp='svnpraise'
    alias sr='svn revert'
    alias sci='svncommitupdate'
    alias sup='svn update $(svnroot)'
    alias shelp='svnhelp'
    alias svnblame=svnpraise

fi
