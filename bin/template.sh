#!/usr/bin/env bash

# This file is a starting point for user-friendly Bash scripts. You should
# modify this header comment, the 'usage' function, and the argument processing
# loop to reflect your script's purpose. Then, add the main script logic
# afterward.

# Required tools:
# - ...
required_tools=(
    # ...
)

function usage() {
    cat <<EOF
Usage: template.sh [-h|--help]
This is a placeholder usage string.
EOF
}

function die() {
    if [[ $# -gt 0 ]]; then
        >&2 echo "$*"
    fi
    exit 1
}

function die_with_usage() {
    if [[ $# -gt 0 ]]; then
        >&2 echo "$*"
        >&2 echo
    fi
    >&2 usage
    exit 1
}

__tput_smul="$(tput smul)"
__tput_rmul="$(tput rmul)"

function e_underline () {
    if [[ $# != 1 ]]; then
        echo "usage: e_underline <message>";
        return;
    fi;
    str="$1";
    echo -e "\n${__tput_smul}${str}${__tput_rmul}"
}

if [[ -t 1 ]]; then
    output_is_terminal=true
fi

function is_available () {
    if [[ $# -ne 1 ]]; then
        echo "Usage: is_available CMD"
        echo "CMD can be a binary, alias, function, or anything that can be executed as a command"
        return 1
    fi
    cmd="$1"
    command -v "$cmd" &> /dev/null
}

unavailable_tools=()
for required_tool in "${required_tools[@]}"; do
    if ! is_available "$required_tool"; then
        unavailable_tools+=("$required_tool")
    fi
done

if [[ "${#unavailable_tools[@]}" -gt 0 ]]; then
    die "Missing required tools: ${unavailable_tools[*]}"
fi

positional_args=()
double_dash=false
args=("$@")
for ((i = 0; i < $#; i++)); do
    arg="${args[$i]}"
    if [[ "$double_dash" = true ]]; then
       positional_args+=("$arg")
       continue
    fi
    case "$arg" in
        -h|--help)
            usage
            exit
            ;;
        # -i|--input)
        #     ((i++))
        #     input="${args[$i]}"
        #     ;;
        --)
            double_dash=true
            ;;
        -*)
            >&2 echo "Unrecognized flag '$arg'"
            exit 1
            ;;
        *)
            positional_args+=("$arg")
            ;;
    esac
done
