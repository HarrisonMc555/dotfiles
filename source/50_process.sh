# Processes

if is_available rg; then
    function psg() {
        ps aux |
            grep -v -e "grep $@" -e "grep -v -e \"'grep $@'\"" |
            grep $@ --color=always |
            sed -e 'G' |
            less
    }
else
    function psg() {
        ps aux |
            rg -v -e "rg $@" -e "rg -v -e \"'rg $@'\"" |
            rg $@ --color=always |
            sed -e 'G' |
            less
    }
fi

function ps_process_names() {
    ps aux | tail -n+2 | awk '{ s = ""; for (i = 11; i <= NF; i++) s = s $i " "; print s }'
}

export -f ps_process_names
