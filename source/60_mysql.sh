#!/usr/bin/env bash

if is_available mycli; then
    function mycli() {
        args=()
        if [[ "$DB_PORT" ]]; then
            args+=("--port=$DB_PORT")
        fi
        if [[ "$DB_USER" ]]; then
            args+=("--user=$DB_USER")
        fi
        get_db_passwd
        if [[ "$DB_PASS" ]]; then
            args+=("--password=$DB_PASS")
        fi
        if [[ "$DB_HOME" ]] && [[ "$SERVER_NAME" ]]; then
            args+=("--socket=$DB_HOME/$SERVER_NAME-data/mysql.sock")
        fi

        # Add this here instead of ~/.my.cnf because mysqladmin chokes on it
        args+=("--defaults-file=~/.my.cnf.client")
        "$(which mycli)" "${args[@]}" "$@"
    }
fi
