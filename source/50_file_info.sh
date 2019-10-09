function max_line_length() {
    awk '{print length}' "$@" | sort -nr | head -1
}

function lines() {
    wc -l "$@" | awk '{print $1}'
}

function words() {
    wc -w "$@" | awk '{print $1}'
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
    echo $(printf "%.${scale}f" "$result")
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

function is_natural_num() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: is_natural_num STR"
        return 1
    fi

    [[ "$1" =~ [1-9][0-9]* ]]
}

function get_lines() {
    if [[ $# -lt 1 ]] || [[ $# -gt 2 ]]; then
        echo "Usage: get_lines START [END]"
        echo "  Example: cat file.txt | get_lines 5 15"
        return 1
    fi

    start="$1"
    end="$2"

    if ! is_natural_num "$start"; then
        echo "Error get_lines: START must be a natural number"
        echo "  (greater than 0)"
        return 1
    fi

    if [[ "$end" ]] && ! is_natural_num "$end"; then
        echo "Error get_lines: END must be a natural number"
        echo "  (greater than 0)"
        return 1
    fi

    if [[ "$end" ]] && [[ "$end" -lt "$start" ]]; then
        echo "Error: end is less than start"
        echo "  ${end} < ${start}"
        return 1
    fi

    if [[ "$end" ]]; then
        sed -n "${start},${end} p"
    else
        tail -n+"$start"
        # sed "1,${start}d"
    fi
}
