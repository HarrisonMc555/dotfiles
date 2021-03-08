#!/usr/bin/env bash

set -e

usage() {
    >&2 cat <<EOF
Usage: $0 BRANCHES_FILENAME BASE_BRANCH

Cherry picks all changes from a list of branches into the current branch.

BRANCHES_FILENAME   The name of a file that contains a list of branches to
                    cherry pick from, one branch name per line.
BASE_BRANCH         The name of the branch that all the listed branches started
                    from (e.g. master, develop, main, etc.). The commits that
                    each branch has since branching from the BASE_BRANCH are
                    cherry picked to the current branch.
EOF
}

die() {
    if [[ $# -gt 0 ]]; then
        >&2 echo "$@"
    fi
    exit 1
}

if [[ $# -ne 2 ]]; then
    usage
    exit 1
fi

branches_filename="$1"

[[ -r "$branches_filename" ]] ||
    die "Could not find readable file '${branches_filename}'"

base_branch="$2"

mapfile -t branches < "$branches_filename"

num_branches="${#branches[@]}"

if [[ "$num_branches" -eq 0 ]]; then
    echo "No branches found in file '${branches_filename}'. Exiting"
    exit
fi

for (( index=0; index < "$num_branches"; index++ )); do
    branch="${branches[$index]}"
    echo "$(tput smul)$branch$(tput rmul)"
    if ! git cherry-pick "${base_branch}..${branch}"; then
        if [[ "$index" -gt 0 ]]; then
            >&2 echo "Successfully cherry picked changes from ${index} branches."
        fi
        >&2 echo "Did not successfully cherry pick changes from branch '${branch}'"
        prompt="Overwrite '${branches_filename} with list of unprocessed branches?"
        if yesno "$prompt"; then
            backup_branches_filename="${branches_filename}.bak"
            echo "Backing up '${branches_filename}' to ${backup_branches_filename}"
            cp -i "$branches_filename" "$backup_branches_filename"
            true > "$branches_filename"
            for (( index++; index < "$num_branches"; index++ )); do
                branch="${branches[$index]}"
                echo "$branch" >> "$branches_filename"
            done
        fi
        exit 1
    fi
    echo
done

echo "Successfully cherry picked changes from all ${num_branches} branches"\
     "listed in '${branches_filename}' into branch"\
     "'$(git rev-parse --abbrev-ref HEAD)'."
