#!/usr/bin/env bash

# IP addresses
alias wanip="dig +short myip.opendns.com @resolver1.opendns.com"
alias whois="whois -h whois-servers.net"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache"

# View HTTP traffic
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

if is_available ping; then
    # Ping the specified server (or the default 8.8.8.8) and say "ping"
    # through the speaker every time a ping is successful. Based on an
    # idea from @gnarf.
    function pingtest() {
        local c
        for c in say spd-say; do [[ "$(which $c)" ]] && break; done
        ping "${1:-8.8.8.8}" | perl -pe '/bytes from/ && `'$c' ping`'
    }
fi

if is_available ssh; then
    # Update ssh config file
    function update_ssh() {
        tmp_file="$(mktemp)"
        ssh_dir=~/.ssh
        orig_file="$ssh_dir"/config
        backup_dir="$ssh_dir"/backup-configs
        mkdir -p "$backup_dir"
        backup_orig_file="${backup_dir}/config_$(date +%Y-%m-%d_%H-%M-%S)"
        if [[ -f "$orig_file" ]]; then
            echo cp "$orig_file" "$backup_orig_file"
            command cp -i "$orig_file" "$backup_orig_file" || {
                >&2 echo "Could not back up config file"
                return 1
            }
        fi
        files=( ~/.ssh/configs/* )
        num_files="${#files[@]}"
        max_index=$((num_files - 1))
        for index in $(seq "$max_index" -1 0); do
            file="${files[$index]}"
            [[ "$file" = *~ ]] && continue # Skip backups
            (
                echo "# $(basename "$file")"
                cat "$file"
                echo
            ) >> "$tmp_file"
        done
        [[ -s "$tmp_file" ]] && command mv "$tmp_file" "$orig_file"
    }
fi

if is_available curl; then
    function myip() {
        if [[ $# -ne 0 ]]; then
            echo "Usage: myip"
            return 1
        fi
        curl ifconfig.me -s && echo
    }
elif is_available dig; then
    function myip() {
        if [[ $# -ne 0 ]]; then
            echo "Usage: myip"
            return 1
        fi
        dig +short myip.opendns.com @resolver1.opendns.com
    }
fi

if is_available ifconfig; then
    function mylocalip() {
        ifconfig | grep -E '(192.168.|10.0.[01])' | awk '{print $2}' | head -n1
    }
fi

if is_osx; then
    if is_available rg; then
        function listening() {
            if [ $# -eq 0 ]; then
                sudo lsof -iTCP -sTCP:LISTEN -n -P
            elif [ $# -eq 1 ]; then
                sudo lsof -iTCP -sTCP:LISTEN -n -P | rg "$1"
            else
                echo "Usage: listening [pattern]"
                return 1
            fi
        }
    else
        function listening() {
            if [ $# -eq 0 ]; then
                sudo lsof -iTCP -sTCP:LISTEN -n -P
            elif [ $# -eq 1 ]; then
                sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color "$1"
            else
                echo "Usage: listening [pattern]"
                return 1
            fi
        }
    fi
fi
