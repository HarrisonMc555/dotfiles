#!/usr/bin/env bash

case $# in
    0) cat;;
    1) cat "$1";;
    *)
        >&2 echo "Usage: graphql-query-to-json.sh [GRAPHQL_FILE]"
        exit 1
        ;;
esac | node -e "
const fs = require('node:fs');
try {
  query = fs.readFileSync(process.stdin.fd, 'utf8');
  console.log(JSON.stringify({query}));
} catch (err) {
  console.error(err);
}
"
