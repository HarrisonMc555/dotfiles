#!/usr/bin/env bash

if [[ $# -ne 2 ]]; then
    >&2 echo "Usage: $0 PDF_FILE_IN PDF_FILE_OUT"
    exit 1
fi

file_in="$1"
file_out="$2"

if [[ ! -f "$file_in" ]]; then
    >&2 echo "Could not find/read file: '${file_in}'."
    exit 1
fi

if [[ -f "$file_out" ]]; then
    file_out_bak="${file_out}.bak"
    echo "Backing up '${file_out}' to '${file_out_bak}."
    cp "$file_out" "$file_out_bak" || {
        >&2 echo "Could not back up. Quitting."
        exit 1
    }
fi

gs \
 -sOutputFile="$file_out" \
 -sDEVICE=pdfwrite \
 -sColorConversionStrategy=Gray \
 -dProcessColorModel=/DeviceGray \
 -dCompatibilityLevel=1.4 \
 -dNOPAUSE \
 -dBATCH \
 "$file_in"
