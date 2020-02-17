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
        orig_file=~/.ssh/config
        backup_orig_file="$orig_file.bak"
        if [[ -f "$orig_file" ]]; then
            # if [[ -f "$backup_orig_file" ]]; then
            #     cat "$backup_orig_file" >> "$tmp_file"
            # else
            #     cat "$orig_file" >> "$tmp_file"
            # fi
            echo cp "$orig_file" "$backup_orig_file"
            cp "$orig_file" "$backup_orig_file"
        fi
        for f in ~/.ssh/configs/*; do
            [[ "$f" = *~ ]] && continue # Skip backups
            (
                echo "# $(basename "$f")"
                cat "$f"
                echo
            ) >> "$tmp_file"
        done
        [[ -s "$tmp_file" ]] && mv "$tmp_file" "$orig_file"
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
