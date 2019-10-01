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
        is_in_svn_repo || return
        svn status |
            filter_out_directories |
            fzf-down -m --nth -1 \
                     --preview '(svn diff -- {-1} | colordiff | sed 1,5d; bat {-1} 2> /dev/null || cat {-1}) | head -500' |
            cut -c9-
    }

    # Svn branch
    # Fuzzy searches for branch
    function sb() {
        is_in_svn_repo || return
        local url="$(svn info --show-item repos-root-url)"
        local header='Enter:  Relative path
Ctrl-H: Full URL'
        svn ls "$url"/branches |
            { while read line; do urlencode "${line%/}"; echo; done } |
            fzf-down --bind "ctrl-h:execute(printf '%s%s\n' '$url' {})+abort" \
                --header "$header" |
            {
                # Could technically replace this with a single call to read, but
                # this is reusable to commands that *do* allow for multiple returns
                while read line; do
                    if [[ "$line" = "$url"* ]]; then
                        printf '%s' "$line"
                    else
                        printf '^/branches/%s' "$line"
                    fi
                done
            }
    }

    # Svn revision
    # Fuzzy searches for a revision(s)
    function sr() {
        is_in_svn_repo || return
        log_file="$(mktemp)"
        svn log --incremental |
            tee "$log_file" |
            _svn_short_log |
            fzf-down --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
                     --header 'Press CTRL-S to toggle sort' \
                     --preview "svn_find_revision -v rev=\$(grep -oE ^r[0-9]+ <<< {}) ${log_file} | head -"$LINES \
                     --preview-window=down:50% \
                     --height 70% |
            sed -E 's/^r([0-9]+) .*/\1/'
        rm "$log_file"
    }

    bind '"\er": redraw-current-line'
    bind '"\es\ef": "$(sf)\e\C-e\er"'
    bind '"\es\eb": "$(sb)\e\C-e\er"'
    bind '"\es\er": "$(sr)\e\C-e\er"'

fi
