if is_available svn && is_available fzf; then

    function is_in_svn_repo() {
        svn info > /dev/null 2>&1
    }

    function fzf-down() {
        fzf --height 50% "$@" --border
    }

    function filter_out_directories() {
        while read line; do
            file="./${line:8}"
            [[ ! -d "$file" ]] && echo "$line"
        done
    }

    # Svn file
    # Fuzzy searches for modified or untracked file(s)
    function sf() {
        pwd
        is_in_svn_repo || return
        svn status |
            filter_out_directories |
            fzf-down -m --ansi --nth -1 \
                     --preview '(svn diff -- {-1} | colordiff | sed 1,5d; bat {-1} 2> /dev/null || cat {-1}) | head -500' |
            cut -c9-
    }

    # Svn branch
    # Fuzzy searches for branch
    function sb() {
        is_in_svn_repo || return
        local url="$(svn info --show-item repos-root-url)"
        svn ls "$url"/branches |
            { while read line; do urlencode "$line"; echo; done } |
            fzf-down |
            sed "s_^_${url}/branches/_"
    }

    # Svn revision
    # Fuzzy searches for a revision(s)
    function sr() {
        is_in_svn_repo || return
        svn_short_log --incremental |
            fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
                     --header 'Press CTRL-S to toggle sort' \
                     --preview 'sed -E "s/^r([0-9]+) .*/\1/" <<< {} | xargs svn log -v -r | head -'$LINES |
            sed -E 's/^r([0-9]+) .*/\1/'
    }

    bind '"\er": redraw-current-line'
    bind '"\es\ef": "$(sf)\e\C-e\er"'
    bind '"\es\eb": "$(sb)\e\C-e\er"'
    bind '"\es\er": "$(sr)\e\C-e\er"'

fi
