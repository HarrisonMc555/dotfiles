#!/usr/bin/env bash
#
# git-loc-ratio-commits.sh
#
# Rank individual commits by:
#
#     ratio = lines of code changed / lines of commit message
#
# and show the first N, highest ratio first (or lowest first with
# --ascending). For each commit it prints the ratio, the commit header and
# message, and the numstat results (optionally followed by the full diff).
#
# Companion to git-loc-ratio.sh (which aggregates per author). Same filters.

set -eo pipefail

DEFAULT_TOP=20

usage() {
  cat <<EOF
Usage: git-loc-ratio-commits.sh [options] [RANGE] [-- PATH...]

Shows commits ranked by "lines of code per line of commit message".
Each commit is shown with its ratio, header, message and numstat.

Selection:
  -n, --top N           Show the first N commits (default: $DEFAULT_TOP; 0 = all)
  -u, --user TEXT       Only include authors whose "Name <email>" contains TEXT
                        (case-insensitive substring, like \`git log --author\`).
                        Repeatable; any match is included.
      --user-regex      Treat each --user value as an extended regular
                        expression instead of a plain substring.
  -r, --range RANGE     Any git revision range, e.g. v1.0..HEAD, main~50..main,
                        abc123..def456. A bare positional RANGE works too.
      --since DATE      Only commits after DATE  (e.g. "2025-01-01", "3 months ago")
      --until DATE      Only commits before DATE
  -a, --all             Walk all refs (branches, tags), not just HEAD
  -C, --repo DIR        Run against the repository in DIR (default: cwd)
  -P, --path PATH       Limit to a file or directory (git pathspec, relative to
                        the repo dir given by -C, or cwd). Repeatable. Anything
                        after a bare \`--\` is also treated as a path.

Excluding commits:
  -x, --exclude COMMIT  Ignore this commit (anything \`git rev-parse\` accepts:
                        hash, abbreviation, tag, HEAD~3, ...). Repeatable.
  -X, --exclude-file FILE
                        Ignore every commit listed in FILE (one hash per line;
                        blank lines and '#' comments allowed). Repeatable.
      --no-ignore-revs-file
                        By default, commits listed in the file(s) configured via
                        \`blame.ignoreRevsFile\` are ignored. This disables that
                        (-x and -X still apply).

Counting:
      --added-only      Count only added lines (default: added + deleted)
      --count-blank     Count blank lines inside commit messages
                        (default: only non-blank message lines are counted)
      --include-merges  Include merge commits (default: excluded)

Output:
  -A, --ascending       Lowest ratio first (default: highest first)
  -p, --patch           Also show the full diff for each commit (default: off)
  -h, --help            Show this help

Notes:
  * "Lines of code" comes from numstat; binary files are ignored.
  * "Message lines" = subject + body lines of the commit message.
  * With paths, only commits touching those paths are considered, and only
    the changed lines inside those paths count (numstat/diff are limited too).
    A commit's full message still counts.
  * Ties are broken by more lines of code first (fewer first with --ascending).
  * Commits with no countable changes (e.g. merges) have ratio 0, so they sort
    first with --ascending.
  * Ignored commits are skipped individually; their neighbours are unaffected.
  * A relative blame.ignoreRevsFile is looked up relative to -C (or cwd) first,
    then the repository's top-level directory.
  * Output goes to stdout without a pager; pipe to \`less -R\` if you like.

Examples:
  git-loc-ratio-commits.sh
  git-loc-ratio-commits.sh -n 5 -p
  git-loc-ratio-commits.sh -u alice -r v2.0..v2.1
  git-loc-ratio-commits.sh --since "2025-01-01" --added-only -n 50
  git-loc-ratio-commits.sh -P src/ -P ':(exclude)src/vendor' -n 10
  git-loc-ratio-commits.sh -x 1a2b3c4 -X noisy-commits.txt
  git-loc-ratio-commits.sh --no-ignore-revs-file --ascending -n 10
  git-loc-ratio-commits.sh -C ~/src/project -a -- '*.py'
EOF
}

die() { echo "error: $*" >&2; exit 1; }

top=$DEFAULT_TOP
users=()
paths=()
exclude_commits=()
exclude_files=()
range=""
since=""
until_=""
all=0
repo="."
added_only=0
count_blank=0
include_merges=0
patch=0
ascending=0
user_regex=0
use_ignore_cfg=1

while [ $# -gt 0 ]; do
  case "$1" in
    -n|--top)         [ $# -ge 2 ] || die "$1 needs a value"; top="$2"; shift 2 ;;
    -u|--user)        [ $# -ge 2 ] || die "$1 needs a value"; users+=("$2"); shift 2 ;;
    --user-regex)     user_regex=1; shift ;;
    -r|--range)       [ $# -ge 2 ] || die "$1 needs a value"; range="$2"; shift 2 ;;
    --since)          [ $# -ge 2 ] || die "$1 needs a value"; since="$2"; shift 2 ;;
    --until)          [ $# -ge 2 ] || die "$1 needs a value"; until_="$2"; shift 2 ;;
    -P|--path)        [ $# -ge 2 ] || die "$1 needs a value"; paths+=("$2"); shift 2 ;;
    --)               shift; while [ $# -gt 0 ]; do paths+=("$1"); shift; done ;;
    -a|--all)         all=1; shift ;;
    -C|--repo)        [ $# -ge 2 ] || die "$1 needs a value"; repo="$2"; shift 2 ;;
    -x|--exclude)     [ $# -ge 2 ] || die "$1 needs a value"; exclude_commits+=("$2"); shift 2 ;;
    -X|--exclude-file) [ $# -ge 2 ] || die "$1 needs a value"; exclude_files+=("$2"); shift 2 ;;
    --no-ignore-revs-file) use_ignore_cfg=0; shift ;;
    --added-only)     added_only=1; shift ;;
    --count-blank)    count_blank=1; shift ;;
    --include-merges) include_merges=1; shift ;;
    -A|--ascending)   ascending=1; shift ;;
    -p|--patch)       patch=1; shift ;;
    -h|--help)        usage; exit 0 ;;
    -*)               die "unknown option: $1 (try --help)" ;;
    *)                [ -z "$range" ] || die "multiple ranges given"; range="$1"; shift ;;
  esac
done

case "$top" in
  ''|*[!0-9]*) die "--top must be a non-negative integer (got '$top')" ;;
esac

git -C "$repo" rev-parse --git-dir >/dev/null 2>&1 || die "'$repo' is not a git repository"

# ---------------------------------------------------------------------------
# Build the list of commits to ignore (one lowercase hex hash/prefix per line).
# ---------------------------------------------------------------------------
ignore_tmp=$(mktemp "${TMPDIR:-/tmp}/git-loc-ratio-commits.XXXXXX")
trap 'rm -f "$ignore_tmp"' EXIT

# Append the hashes found in a "ignore revs" style file (comments/blank ok).
add_hash_file() {
  sed -e 's/#.*$//' -e 's/[[:space:]]//g' "$1" \
    | tr 'A-F' 'a-f' \
    | grep -E '^[0-9a-f]{4,}$' >> "$ignore_tmp" || true
}

if [ "$use_ignore_cfg" -eq 1 ]; then
  cfg_files=()
  while IFS= read -r f; do
    if [ -z "$f" ]; then cfg_files=(); continue; fi   # empty value resets the list
    cfg_files+=("$f")
  done < <(git -C "$repo" config --get-all blame.ignoreRevsFile 2>/dev/null || true)

  toplevel=$(git -C "$repo" rev-parse --show-toplevel 2>/dev/null || true)
  for f in "${cfg_files[@]}"; do
    case "$f" in "~/"*) f="$HOME/${f#"~/"}" ;; esac
    resolved=""
    if [ "${f#/}" != "$f" ]; then
      [ ! -f "$f" ] || resolved="$f"
    elif [ -f "$repo/$f" ]; then
      resolved="$repo/$f"
    elif [ -n "$toplevel" ] && [ -f "$toplevel/$f" ]; then
      resolved="$toplevel/$f"
    fi
    if [ -n "$resolved" ]; then
      add_hash_file "$resolved"
    else
      echo "warning: blame.ignoreRevsFile '$f' not found; skipping it" >&2
    fi
  done
fi

for f in "${exclude_files[@]}"; do
  [ -f "$f" ] || die "exclude file not found: $f"
  add_hash_file "$f"
done

for c in "${exclude_commits[@]}"; do
  h=$(git -C "$repo" rev-parse --verify --quiet "$c^{commit}") || die "cannot resolve commit '$c'"
  printf '%s\n' "$h" >> "$ignore_tmp"
done

n_ignored=$(sort -u "$ignore_tmp" | wc -l | tr -d ' ')
[ "$n_ignored" -eq 0 ] || echo "Ignoring $n_ignored listed commit(s)." >&2

# ---------------------------------------------------------------------------
# Selection arguments for the ranking pass.
# ---------------------------------------------------------------------------
sel_args=(--use-mailmap)
[ "$include_merges" -eq 1 ] || sel_args+=(--no-merges)
[ -z "$since" ]  || sel_args+=(--since="$since")
[ -z "$until_" ] || sel_args+=(--until="$until_")
[ "$all" -eq 0 ] || sel_args+=(--all)

# Author filtering is done by git itself (multiple --author options are OR'd).
if [ ${#users[@]} -gt 0 ]; then
  if [ "$user_regex" -eq 1 ]; then
    sel_args+=(--regexp-ignore-case --extended-regexp)
  else
    sel_args+=(--regexp-ignore-case --fixed-strings)
  fi
  for u in "${users[@]}"; do sel_args+=(--author="$u"); done
fi

[ -z "$range" ]  || sel_args+=("$range")
[ ${#paths[@]} -eq 0 ] || sel_args+=(-- "${paths[@]}")

# Pass 1: compute the ratio for every matching commit.
# Emits TSV: ratio, loc, msg_lines, full_hash
ranked=$(
  git -C "$repo" log '--format=%x01%H%x1f%aN%x1f%aE%x1f%B%x02' --numstat "${sel_args[@]}" | awk \
    -v ignorefile="$ignore_tmp" \
    -v added_only="$added_only" \
    -v count_blank="$count_blank" '
  BEGIN {
    while ((getline h < ignorefile) > 0) {
      if (length(h) >= 40) ign[h] = 1
      else abbr[++nabbr] = h              # abbreviated hash: prefix match
    }
    close(ignorefile)
  }

  function ignored(h,   i) {
    if (h in ign) return 1
    for (i = 1; i <= nabbr; i++)
      if (substr(h, 1, length(abbr[i])) == abbr[i]) return 1
    return 0
  }

  function flush(   r) {
    if (!have) return
    have = 0
    if (ignored(chash)) return
    r = (cmsg > 0) ? cloc / cmsg : 0
    printf "%.6f\t%d\t%d\t%s\n", r, cloc, cmsg, chash
  }

  {
    line = $0

    if (!in_msg) {
      if (substr(line, 1, 1) == "\001") {
        # Start of a commit: \001 hash \037 name \037 email \037 first message line
        flush()
        have = 1; cloc = 0; cmsg = 0; pend = 0; in_msg = 1
        line = substr(line, 2)
        p = index(line, "\037"); chash = substr(line, 1, p - 1); line = substr(line, p + 1)
        p = index(line, "\037"); line = substr(line, p + 1)    # skip name
        p = index(line, "\037"); line = substr(line, p + 1)    # skip email
      } else {
        # numstat line: added <TAB> deleted <TAB> path   ("-" for binary files)
        split(line, f, "\t")
        if (f[1] ~ /^[0-9]+$/ && f[2] ~ /^[0-9]+$/)
          cloc += f[1] + (added_only ? 0 : f[2])
        next
      }
    }

    # Inside a commit message.
    e = index(line, "\002")
    if (e) { in_msg = 0; txt = substr(line, 1, e - 1); has = (e > 1) }
    else   { txt = line; has = 1 }

    if (has) {
      if (txt ~ /[^[:space:]]/) { cmsg += pend + 1; pend = 0 }
      else if (count_blank)     { pend++ }   # trailing blanks never get added
    }
  }

  END { flush() }
')

if [ -z "$ranked" ]; then
  echo "No matching commits found." >&2
  exit 0
fi

# Sort by ratio, tie-break on LOC, then keep the first N.
if [ "$ascending" -eq 1 ]; then
  sort_args=(-t$'\t' -k1,1g -k2,2n)
  order_label="lowest first"
else
  sort_args=(-t$'\t' -k1,1gr -k2,2nr)
  order_label="highest first"
fi

total=$(printf '%s\n' "$ranked" | wc -l | tr -d ' ')
selected=$(
  printf '%s\n' "$ranked" \
    | sort "${sort_args[@]}" \
    | awk -v n="$top" 'n == 0 || NR <= n'
)
shown=$(printf '%s\n' "$selected" | wc -l | tr -d ' ')

echo "Showing $shown of $total matching commits by LOC per message line ($order_label)"
echo

# Pass 2: display each selected commit using git show.
show_args=(--no-color --date=short --numstat
  '--format=commit %H%nAuthor: %aN <%aE>%nDate:   %ad%n%n%w(0,4,4)%B')
[ "$patch" -eq 0 ] || show_args+=(--patch)

path_args=()
[ ${#paths[@]} -eq 0 ] || path_args=(-- "${paths[@]}")

rank=0
while IFS=$'\t' read -r ratio loc msg hash; do
  rank=$((rank + 1))
  printf '#%d  ratio %.2f  (%s LOC / %s msg lines)\n' "$rank" "$ratio" "$loc" "$msg"
  git -C "$repo" --no-pager show "${show_args[@]}" "$hash" "${path_args[@]}" </dev/null
  echo
  echo "================================================================"
  echo
done <<< "$selected"
