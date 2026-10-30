#!/usr/bin/env bash
#
# ports.sh - list TCP/UDP sockets on macOS together with the owning process.
#
# Usage:
#   ports.sh            list everything
#   ports.sh SEARCH     only rows matching SEARCH
#
# SEARCH semantics:
#   - all digits (e.g. 8080, 443, 1234): exact match on local port,
#     foreign port or PID
#   - anything else (e.g. node, 127.0.0.1, LISTEN, tcp6, chrom): case-insensitive
#     substring match against the whole row
#
# Why netstat + ps instead of lsof: `netstat -anv` is fast and includes the
# PID of each socket; one `ps` call maps PIDs to process names.

set -euo pipefail

case "${1:-}" in
  -h|--help)
    sed -n '3,15p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
    ;;
esac

search="${1:-}"

get_procs()   { ps -axo pid=,comm=; }
get_sockets() { netstat -anv -p tcp; netstat -anv -p udp; }

rows=$(
  SEARCH="$search" awk -v OFS='\t' '
    # Split "addr.port" at the LAST dot (works for 1.2.3.4.80, *.80, ::1.80,
    # fe80::1%lo0.80, and *.*). Results are left in globals addr / port.
    function split_addr(s,    n) {
      n = match(s, /\.[^.]*$/)
      if (n) { addr = substr(s, 1, n - 1); port = substr(s, n + 1) }
      else   { addr = s; port = "-" }
    }

    BEGIN { term = ENVIRON["SEARCH"]; pidoff = -1; has_state = 0 }

    # 1st input (ps): "pid /full/path/to/command" -> cmd[pid] = basename
    FNR == NR {
      p = $1
      sub(/^ *[0-9]+ +/, "")
      sub(/.*\//, "")
      cmd[p] = $0
      next
    }

    # netstat header line: locate the pid column by counting from the END of
    # the line, since "Local Address" is two header words but one data field
    # (and a process name containing a space would shift fields from the left).
    # Older macOS has a "pid" column; newer has "process:pid" (name:pid).
    # Re-evaluated per section; the tcp and udp headers differ.
    /^Proto/ {
      hdr = $0; pidoff = -1; has_state = 0
      for (i = 1; i <= NF; i++) {
        if ($i == "pid" || $i == "process:pid") pidoff = NF - i
        if ($i == "(state)") has_state = 1
      }
      next
    }

    /^(tcp|udp)/ {
      if (pidoff < 0) {
        print "ports.sh: could not find a pid column in netstat -v header:" > "/dev/stderr"
        print hdr > "/dev/stderr"
        exit 2
      }
      split_addr($4); la = addr; lp = port
      split_addr($5); ra = addr; rp = port
      st = has_state ? $6 : "-"

      tok = $(NF - pidoff)          # "1234" or "jetbrains-toolbo:72175"
      sub(/.*:/, "", tok)
      p = tok + 0
      if (p > 0) { pid = p; name = (p in cmd) ? cmd[p] : "?" }
      else       { pid = "-"; name = "-" }      # e.g. TIME_WAIT: no owner

      line = $1 OFS la OFS lp OFS ra OFS rp OFS st OFS pid OFS name

      if (term != "") {
        if (term ~ /^[0-9]+$/) {
          if (lp != term && rp != term && pid != term) next
        } else if (index(tolower(line), tolower(term)) == 0) {
          next
        }
      }
      print line
    }
  ' <(get_procs) <(get_sockets)
)

if [[ -z "$rows" ]]; then
  echo "No matching sockets${search:+ for '$search'}." >&2
  exit 1
fi

{
  printf 'PROTO\tLOCAL ADDRESS\tL.PORT\tFOREIGN ADDRESS\tF.PORT\tSTATE\tPID\tPROCESS\n'
  # Sort by local port (numeric), then protocol, then local address.
  printf '%s\n' "$rows" | LC_ALL=C sort -t $'\t' -k3,3n -k1,1 -k2,2
} | column -t -s $'\t'
