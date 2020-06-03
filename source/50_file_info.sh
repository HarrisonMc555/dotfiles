#!/usr/bin/env bash

function max_line_length() {
    awk '{print length}' "$@" | sort -nr | head -1
}

function lines() {
    if [[ $# -ne 1 ]]; then
       >&2 echo "Usage: lines FILES"
       return 1
    fi
    file="$1"
    if ! [[ -f "$file" ]]; then
       >&2 echo "File '$file' not found."
       return 1
    fi
    wc -l "$file" | awk '{print $1}'
}

function words() {
    if [[ $# -ne 1 ]]; then
       >&2 echo "Usage: lines FILES"
       return 1
    fi
    file="$1"
    if ! [[ -f "$file" ]]; then
       >&2 echo "File '$file' not found."
       return 1
    fi
    wc -w "$file" | awk '{print $1}'
}

function diff_percentage() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: diff_percentage FILE1 FILE2"
        return 1
    fi

    if [[ ! -f "$1" ]] || [[ ! -r "$1" ]] || \
           [[ ! -f "$2" ]] || [[ ! -r "$2" ]]; then
        echo "Both arguments must be readable files"
        return 1
    fi

    num_diff_lines=$(num-diff-lines "$1" "$2")
    file1_lines=$(lines "$1")
    file2_lines=$(lines "$2")
    max_lines="$file1_lines"
    if [[ "$file2_lines" -gt "$max_lines" ]]; then
        max_lines="$file2_lines"
    fi
    math="100 * ${num_diff_lines} / ${max_lines}"
    ratio=$(round "$math" 1)
    # ratio=$(echo "scale=1; 100 * ${num_diff_lines} / ${max_lines}" | bc)

    echo "diff_percentage for $1 and $2:"
    echo "${ratio}% different"
    echo "${num_diff_lines} / ${max_lines} lines are different"
}

function round() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: round (VALUE|MATH) SCALE"
        return 1
    fi

    scale="$2"
    value=$(echo "scale=$((scale + 1)); $1" | bc)
    result=$(echo "scale=${scale}; "\
                  "(((10^${scale})*${value})+0.5)/(10^${scale})" | bc)
    printf "%.${scale}f" "$result"
}

function num_diff_lines() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: num_diff_lines FILE1 FILE2"
        return 1
    fi

    # The diff command lists the file names as the first two lines and the
    # region line numbers with @ symbols
    diff -U0 "$1" "$2" | tail -n+3 | grep -cv '^@'
}

function csv_headers() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: csvheaders FILE [FILE]*"
        return 1
    fi

    eachfile "$@" -- head -n1 | tr ',' ' ' | space2lines
}

function nth_after_match()
{
    if [[ $# -lt 2 ]]; then
        echo "Usage: nth_after_match PATTERN COUNT [FILE]"
        return 1
    fi
    pattern="$1"
    count="$2"
    shift; shift;
    awk "c&&!--c; /$pattern/{c=$count}" "$@"
}
