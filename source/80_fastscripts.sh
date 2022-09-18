#!/usr/bin/env bash

if is_osx; then
    switch_ide() {
        launch_dir=~/Library/Scripts/Launch
        if [[ ! -d "$launch_dir" ]]; then
            >&2 echo "No launch directory found: ${launch_dir}"
        fi
        if [[ $# -ne 1 ]]; then
            >&2 echo "Usage: switch_ide (idea|vscode|...)"
            return 1
        fi
        ide="$1"
        ide_file="${launch_dir}/${ide}.sh"
        if [[ ! -f "$ide_file" ]]; then
            >&2 echo "No IDE file found: $(readlink -f "$ide_file")"
            return 1
        fi
        command cp -f "$ide_file" "${launch_dir}/ide.sh"
    }
fi
