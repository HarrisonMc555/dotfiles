#!/usr/bin/env bash
#
# git-loc-ratio.sh
#
# For each author (or only the authors you name), compute:
#
#     ratio = lines of code changed / lines of commit message
#
# over the whole history or a given revision range.
#
# Author identity honours .mailmap (%aN / %aE). Authors are grouped by e-mail.
# See also: git-loc-ratio-commits.sh (ranks individual commits).

set -eo pipefail

usage() {
  cat <<'EOF'
Usage: git-loc-ratio.sh [options] [RANGE] [-- PATH...]

Calculates "lines of code per line of commit message" per author.

Selection:
  -u, --user TEXT       Only include authors whose "Name <email>" contains TEXT
                        (case-insensitive substring, like `git log --author`).
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
                        after a bare `--` is also treated as a path.

Excluding commits:
  -x, --exclude COMMIT  Ignore this commit (anything `git rev-parse` accepts:
                        hash, abbreviation, tag, HEAD~3, ...). Repeatable.
  -X, --exclude-file FILE
                        Ignore every commit listed in FILE (one hash per line;
                        blank lines and '#' comments allowed). Repeatable.
      --no-ignore-revs-file
                        By default, commits listed in the file(s) configured via
                        `blame.ignoreRevsFile` are ignored. This disables that
                        (-x and -X still apply).

Counting:
      --added-only      Count only added lines (default: added + deleted)
      --count-blank     Count blank lines inside commit messages
                        (default: only non-blank message lines are counted)
      --include-merges  Include merge commits (default: excluded)

Output:
  -A, --ascending       Lowest ratio first (default: highest first)
      --csv             Emit CSV instead of an aligned table
  -h, --help            Show this help

Notes:
  * "Lines of code" comes from `git log --numstat`; binary files are ignored.
  * "Message lines" = subject + body lines of each commit message.
  * Output is sorted by ratio with a TOTAL row at the bottom.
  * With paths, only commits touching those paths are included, and only the
    changed lines inside those paths count. A commit's full message still
    counts, even if the commit also touched files outside the paths.
  * Paths accept git pathspec syntax, e.g. 'src/', 'README.md', '*.py',
    ':(exclude)vendor' (to exclude, also add a positive path such as '.').
  * Ignored commits are skipped individually; their neighbours are unaffected.
  * A relative blame.ignoreRevsFile is looked up relative to -C (or cwd) first,
    then the repository's top-level directory.

Examples:
  git-loc-ratio.sh
  git-loc-ratio.sh -u alice -u "bob@example"
  git-loc-ratio.sh -r v2.0..v2.1
  git-loc-ratio.sh --since "2025-01-01" --until "2025-06-30" --added-only
  git-loc-ratio.sh -P src/ -P docs/README.md
  git-loc-ratio.sh -x 1a2b3c4 -X noisy-commits.txt
  git-loc-ratio.sh --no-ignore-revs-file --ascending
  git-loc-ratio.sh -C ~/src/project -a --csv
EOF
}

die() { echo "error: $*" >&2; exit 1; }

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
csv=0
ascending=0
user_regex=0
use_ignore_cfg=1

while [ $# -gt 0 ]; do
  case "$1" in
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
    --csv)            csv=1; shift ;;
    -h|--help)        usage; exit 0 ;;
    -*)               die "unknown option: $1 (try --help)" ;;
    *)                [ -z "$range" ] || die "multiple ranges given"; range="$1"; shift ;;
  esac
done

git -C "$repo" rev-parse --git-dir >/dev/null 2>&1 || die "'$repo' is not a git repository"

# ---------------------------------------------------------------------------
# Build the list of commits to ignore (one lowercase hex hash/prefix per line).
# ---------------------------------------------------------------------------
ignore_tmp=$(mktemp "${TMPDIR:-/tmp}/git-loc-ratio.XXXXXX")
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
# Build the git log command.
# ---------------------------------------------------------------------------
log_args=(log '--format=%x01%H%x1f%aN%x1f%aE%x1f%B%x02' --numstat --use-mailmap)
[ "$include_merges" -eq 1 ] || log_args+=(--no-merges)
[ -z "$since" ]  || log_args+=(--since="$since")
[ -z "$until_" ] || log_args+=(--until="$until_")
[ "$all" -eq 0 ] || log_args+=(--all)

# Author filtering is done by git itself (multiple --author options are OR'd).
if [ ${#users[@]} -gt 0 ]; then
  if [ "$user_regex" -eq 1 ]; then
    log_args+=(--regexp-ignore-case --extended-regexp)
  else
    log_args+=(--regexp-ignore-case --fixed-strings)
  fi
  for u in "${users[@]}"; do log_args+=(--author="$u"); done
fi

[ -z "$range" ]  || log_args+=("$range")
[ ${#paths[@]} -eq 0 ] || log_args+=(-- "${paths[@]}")

# Pass 1: aggregate per author. Emits TSV: ratio, name, email, commits, loc, msg_lines
rows=$(
  git -C "$repo" "${log_args[@]}" | awk \
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

  function flush(   key) {
    if (!have) return
    have = 0
    if (ignored(chash)) return
    key = tolower(cemail)
    if (!(key in name)) name[key] = cname
    commits[key]++
    loc[key]  += cloc
    msg[key]  += cmsg
  }

  {
    line = $0

    if (!in_msg) {
      if (substr(line, 1, 1) == "\001") {
        # Start of a commit: \001 hash \037 name \037 email \037 first message line
        flush()
        have = 1; cloc = 0; cmsg = 0; pend = 0; in_msg = 1
        line = substr(line, 2)
        p = index(line, "\037"); chash  = substr(line, 1, p - 1); line = substr(line, p + 1)
        p = index(line, "\037"); cname  = substr(line, 1, p - 1); line = substr(line, p + 1)
        p = index(line, "\037"); cemail = substr(line, 1, p - 1); line = substr(line, p + 1)
      } else {
        # numstat line: added <TAB> deleted <TAB> path   ("-" for binary files)
        split(line, f, "\t")
        if (f[1] ~ /^[0-9]+$/ && f[2] ~ /^[0-9]+$/)
          cloc += f[1] + (added_only ? 0 : f[2])
        next
      }
    }

    # We are inside a commit message.
    e = index(line, "\002")
    if (e) { in_msg = 0; txt = substr(line, 1, e - 1); has = (e > 1) }
    else   { txt = line; has = 1 }

    if (has) {
      if (txt ~ /[^[:space:]]/) { cmsg += pend + 1; pend = 0 }
      else if (count_blank)     { pend++ }   # trailing blanks never get added
    }
  }

  END {
    flush()
    for (k in commits) {
      r = (msg[k] > 0) ? loc[k] / msg[k] : 0
      printf "%.4f\t%s\t%s\t%d\t%d\t%d\n", r, name[k], k, commits[k], loc[k], msg[k]
    }
  }
')

if [ -z "$rows" ]; then
  echo "No matching commits found." >&2
  exit 0
fi

sort_args=(-t$'\t' -k1,1gr)
[ "$ascending" -eq 0 ] || sort_args=(-t$'\t' -k1,1g)

# Pass 2: sort by ratio, add header + TOTAL, and format.
printf '%s\n' "$rows" | sort "${sort_args[@]}" | awk -F'\t' -v csv="$csv" '
  function q(s) { gsub(/"/, "\"\"", s); return "\"" s "\"" }
  function add(a, b, c, d, e, f) {
    n++
    R[n,1] = a; R[n,2] = b; R[n,3] = c; R[n,4] = d; R[n,5] = e; R[n,6] = f
    for (i = 1; i <= 6; i++) if (length(R[n,i]) > W[i]) W[i] = length(R[n,i])
  }
  BEGIN {
    add("Author", "Email", "Commits", "LOC", "MsgLines", "LOC/MsgLine")
  }
  {
    tc += $4; tl += $5; tm += $6
    add($2, $3, $4, $5, $6, sprintf("%.2f", $1))
  }
  END {
    add("TOTAL", "", tc, tl, tm, sprintf("%.2f", tm > 0 ? tl / tm : 0))
    for (r = 1; r <= n; r++) {
      if (csv) {
        printf "%s,%s,%s,%s,%s,%s\n", q(R[r,1]), q(R[r,2]), R[r,3], R[r,4], R[r,5], R[r,6]
      } else {
        printf "%-*s  %-*s  %*s  %*s  %*s  %*s\n",
          W[1], R[r,1], W[2], R[r,2], W[3], R[r,3], W[4], R[r,4], W[5], R[r,5], W[6], R[r,6]
        if (r == 1 || r == n - 1) {
          sep = ""; tot = W[1] + W[2] + W[3] + W[4] + W[5] + W[6] + 10
          for (j = 0; j < tot; j++) sep = sep "-"
          print sep
        }
      }
    }
  }
'
