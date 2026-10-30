#!/usr/bin/env bash
#
# ports.sh - list TCP/UDP sockets on macOS together with the owning process.
#
# Why netstat + ps instead of lsof: `netstat -anv` is fast and includes the
# owning PID of each socket; one `ps` call maps PIDs to user / command.
# Compatible with the bash 3.2 that ships with macOS.

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ports.sh [OPTIONS] [--] [SEARCH]

List TCP and UDP sockets together with the owning process.

Options:
  -c, --csv     CSV output instead of an aligned table
  -x, --extra   Also include the extra netstat -v columns (queue sizes, byte
                counts, buffer sizes, flags, ...). Combine with --csv and a
                tool like `qsv select` to keep just the fields you want.
  -h, --help    Show this help

SEARCH (optional):
  all digits (8080, 443, 1234)  exact match on local port, foreign port or PID
  anything else                 case-insensitive substring match against the
                                displayed columns (e.g. node, 127.0.0.1,
                                LISTEN, tcp6, root, /opt/homebrew)

Default columns:
  PROTO LOCAL_ADDRESS LOCAL_PORT FOREIGN_ADDRESS FOREIGN_PORT STATE PID USER
  PROCESS COMMAND
  (PROCESS is the executable's name; COMMAND is its full path. Sockets with
  no owning process, such as TIME_WAIT, show "-".)

Extra columns (--extra) are whatever else netstat -v prints on your macOS
version, inserted before COMMAND. netstat's own "state" column (a hex flag
field) is named SO_STATE to avoid clashing with the TCP STATE.
EOF
}

csv=0
extra=0
while (( $# )); do
  case "$1" in
    -h|--help)  usage; exit 0 ;;
    -c|--csv)   csv=1 ;;
    -x|--extra) extra=1 ;;
    -cx|-xc)    csv=1; extra=1 ;;
    --)         shift; break ;;
    -*)         echo "ports.sh: unknown option: $1 (try --help)" >&2; exit 2 ;;
    *)          break ;;
  esac
  shift
done

if (( $# > 1 )); then
  echo "ports.sh: expected at most one SEARCH argument (try --help)" >&2
  exit 2
fi
search="${1:-}"

get_procs()   { ps -axo pid=,uid=,user=,comm=; }
get_sockets() { netstat -anv -p tcp; netstat -anv -p udp; }

# Output: a header line, then one tab-separated line per socket.
rows=$(
  SEARCH="$search" EXTRA="$extra" awk -v OFS='\t' '
    # Split "addr.port" at the LAST dot (works for 1.2.3.4.80, *.80, ::1.80,
    # fe80::1%lo0.80, and *.*). Results are left in globals addr / port.
    function split_addr(s,    n) {
      n = match(s, /\.[^.]*$/)
      if (n) { addr = substr(s, 1, n - 1); port = substr(s, n + 1) }
      else   { addr = s; port = "-" }
    }

    # ps truncates long user names, so for names of 8+ characters ask `id`
    # for the real one (cached per uid); fall back to what ps printed.
    function uname(u, fallback,    c, nm) {
      if (u in unames) return unames[u]
      nm = ""
      if (length(fallback) >= 8 && u ~ /^[0-9]+$/) {
        c = "id -un " u " 2>/dev/null"
        if ((c | getline nm) <= 0) nm = ""
        close(c)
      }
      unames[u] = (nm != "") ? nm : fallback
      return unames[u]
    }

    # Value of header column j in the current netstat data row. Columns before
    # the process column are read from the left; the process column and
    # everything after it from the right, because a process name can contain
    # spaces ("Google Chrome H:1234") and would shift fields from the left.
    function field(j) {
      if (j < pcol) return $j
      return $(NF - (ncols - j))
    }

    # RXBYTES, RECV_Q, ... ; netstat "state" (hex) -> SO_STATE
    function colname(s) {
      s = toupper(s); gsub(/-/, "_", s)
      if (s == "STATE") s = "SO_STATE"
      return s
    }

    BEGIN {
      term = ENVIRON["SEARCH"]
      extra = (ENVIRON["EXTRA"] == "1")
      hdr_done = 0; failed = 0; pcol = 0
    }

    # 1st input (ps): "pid uid user /full/path/to/command"
    FNR == NR {
      q = $1; puid[q] = $2; pusr[q] = $3
      sub(/^ *[0-9]+ +[0-9]+ +[^ ]+ +/, "")
      ppath[q] = $0
      sub(/.*\//, "")
      pname[q] = $0
      next
    }

    # netstat header line. Header words "Local Address" / "Foreign Address"
    # are single columns. Older macOS has a "pid" column, newer has
    # "process:pid". The tcp and udp sections have different headers, so this
    # is re-evaluated for each section.
    /^Proto/ {
      ncols = 0; pcol = 0
      for (k in colidx) delete colidx[k]
      for (i = 1; i <= NF; i++) {
        nm = $i
        if ((nm == "Local" || nm == "Foreign") && $(i + 1) == "Address") {
          nm = nm " Address"; i++
        }
        ncols++
        colidx[nm] = ncols
        colat[ncols] = nm
        if (nm == "pid" || nm == "process:pid") pcol = ncols
      }
      if (!pcol || !("Local Address" in colidx) || !("Foreign Address" in colidx)) {
        print "ports.sh: unrecognised netstat -v header:" > "/dev/stderr"
        print $0 > "/dev/stderr"
        failed = 1
        exit 2
      }
      if (!hdr_done) {
        h = "PROTO" OFS "LOCAL_ADDRESS" OFS "LOCAL_PORT" OFS "FOREIGN_ADDRESS" \
            OFS "FOREIGN_PORT" OFS "STATE" OFS "PID" OFS "USER" OFS "PROCESS"
        nextra = 0
        if (extra) {
          for (i = 1; i <= ncols; i++) {
            nm = colat[i]
            if (nm == "Proto" || nm == "Local Address" || nm == "Foreign Address" \
                || nm == "(state)" || i == pcol) continue
            nextra++; xkey[nextra] = nm; h = h OFS colname(nm)
          }
        }
        print h OFS "COMMAND"
        hdr_done = 1
      }
      next
    }

    /^(tcp|udp)/ {
      split_addr(field(colidx["Local Address"]));   la = addr; lp = port
      split_addr(field(colidx["Foreign Address"])); ra = addr; rp = port
      st = ("(state)" in colidx) ? field(colidx["(state)"]) : "-"

      tok = field(pcol)                  # "1234" or "jetbrains-toolbo:72175"
      sub(/.*:/, "", tok)
      p = tok + 0
      if (p > 0) {
        pid  = p
        name = (p in pname) ? pname[p] : "?"
        path = (p in ppath) ? ppath[p] : "-"
        user = (p in puid)  ? uname(puid[p], pusr[p]) : "?"
      } else {                           # e.g. TIME_WAIT: no owning process
        pid = name = user = path = "-"
      }

      line = $1 OFS la OFS lp OFS ra OFS rp OFS st OFS pid OFS user OFS name
      for (k = 1; k <= nextra; k++) {
        j = (xkey[k] in colidx) ? colidx[xkey[k]] : 0
        line = line OFS (j ? field(j) : "-")
      }
      line = line OFS path

      if (term != "") {
        if (term ~ /^[0-9]+$/) {
          if (lp != term && rp != term && pid != term) next
        } else if (index(tolower(line), tolower(term)) == 0) {
          next
        }
      }
      print line
    }

    END {
      if (failed) exit 2
      if (!hdr_done) {
        print "ports.sh: no usable output from netstat -anv" > "/dev/stderr"
        exit 2
      }
    }
  ' <(get_procs) <(get_sockets)
)

# Only the header line came back => nothing matched.
if [[ "$rows" != *$'\n'* ]]; then
  echo "No matching sockets${search:+ for '$search'}." >&2
  exit 1
fi
header=${rows%%$'\n'*}
body=${rows#*$'\n'}

emit() {
  printf '%s\n' "$header"
  # Sort by local port (numeric), then protocol, then local address.
  printf '%s\n' "$body" | LC_ALL=C sort -t $'\t' -k3,3n -k1,1 -k2,2
}

if (( csv )); then
  emit | awk -F $'\t' '
    function q(s) {
      if (s ~ /[",]/) { gsub(/"/, "\"\"", s); s = "\"" s "\"" }
      return s
    }
    { out = q($1); for (i = 2; i <= NF; i++) out = out "," q($i); print out }'
else
  emit | column -t -s $'\t'
fi
