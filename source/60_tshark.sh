#!/usr/bin/env bash

if is_available tshark; then
    function tshark_csv_time() {
        tshark -2 -E separator=, -E quote=d -t ad -T fields -e _ws.col.Time "$@"
    }

    complete -F _tshark tshark_csv_time
fi
