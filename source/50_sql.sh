#!/usr/bin/env bash

# From sqlparse Homebrew package
if is_available sqlformat; then
    function format_sql() {
        if [[ $# -gt 1 ]]; then
            >&2 echo "Usage: format_sql [FILE]"
            return 1
        fi

        # The format ${var:-mydefaultvalue} will expand to the value of the $var
        # variable if it is non-empty or the literal "mydefaultvalue" if it is
        # empty. We want the default to be a literal "-", so we add _another_
        # dash. The first dash is the Bash syntax, the second dash is the string
        # we want to use as the default value.

        file="${1:--}"
        sqlformat --reindent --keywords upper --identifiers lower "$file"
    }
fi
