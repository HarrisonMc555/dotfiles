#!/usr/bin/env bash

case $# in
    1) cat;;
    2) cat "$2";;
    *)
        >&2 echo "Usage: graphql-query.sh URL [GRAPHQL_FILE]"
        exit 1
        ;;
esac |
    graphql-query-to-json.sh |
    curl -H 'Content-Type: application/json' -X POST "$1" -H "Content-Type: application/json" -d @-
