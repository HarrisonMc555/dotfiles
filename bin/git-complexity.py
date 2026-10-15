#!/usr/bin/env python3
"""
git-complexity.py

Estimate code complexity per Git commit, then divide by the length of the
commit message:

    ratio = complexity / (1 + message_lines)            (default, "plus1")
    ratio = complexity / (1 + ln(max(message_lines,1))) ("log")

Complexity comes from `lizard` (cyclomatic complexity per function), computed
on the before/after versions of only the files each commit touched.  Functions
are matched between the two versions (same name+signature, then identical body
ignoring the name, then similar body), so renaming or moving a function does
not count as a change in complexity.

Subcommands:
  commits    rank individual commits by ratio
  aggregate  sum commits into groups (author, month, year) and rank the groups

Companion to git-loc-ratio.sh / git-loc-ratio-commits.sh (plain LOC).

Requires: Python 3.8+, git, `pip install lizard`.  Optional: `scc` on PATH.
"""

import argparse
import csv
import difflib
import hashlib
import json
import math
import os
import re
import shutil
import subprocess
import sys
import tempfile
from collections import defaultdict, namedtuple
from multiprocessing import Pool

try:
    import lizard
except ImportError:
    sys.exit(
        "error: the 'lizard' Python package is required but not installed.\n"
        "       Install it with:  pip install lizard"
    )

ZERO_SHA = "0" * 40
SKIP_MODES = {"160000", "120000"}  # submodules, symlinks

Func = namedtuple("Func", "long_name ccn fp norm")

METRICS = {
    "ccn-net": "ccn_net",      # signed: complexity after - before
    "ccn-churn": "ccn_churn",  # unsigned: complexity added + removed + changed
    "loc": "loc",              # added + deleted lines (git numstat), same files
    "scc-net": "scc_net",      # signed: scc complexity after - before
}


def die(msg):
    print("error: " + msg, file=sys.stderr)
    sys.exit(1)


# ---------------------------------------------------------------------------
# Git helpers
# ---------------------------------------------------------------------------

def git(repo, *args, check=True):
    r = subprocess.run(
        ["git", "-c", "core.quotePath=false", "-C", repo, *args],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE,
        encoding="utf-8", errors="replace",
    )
    if check and r.returncode != 0:
        die("git %s failed: %s" % (" ".join(args[:2]), r.stderr.strip()))
    return r


class BlobReader:
    """Persistent `git cat-file --batch` process."""

    def __init__(self, repo):
        self.p = subprocess.Popen(
            ["git", "-C", repo, "cat-file", "--batch"],
            stdin=subprocess.PIPE, stdout=subprocess.PIPE,
        )

    def read(self, sha):
        self.p.stdin.write(sha.encode() + b"\n")
        self.p.stdin.flush()
        header = self.p.stdout.readline().split()
        if len(header) < 3 or header[1] == b"missing":
            return None
        size = int(header[2])
        data = self.p.stdout.read(size)
        self.p.stdout.read(1)  # trailing newline
        return data


# ---------------------------------------------------------------------------
# Ignore list (same behaviour as the earlier scripts)
# ---------------------------------------------------------------------------

def read_hash_file(path):
    out = []
    with open(path, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            h = re.sub(r"#.*$", "", line)
            h = re.sub(r"\s+", "", h).lower()
            if re.fullmatch(r"[0-9a-f]{4,}", h):
                out.append(h)
    return out


def build_ignore_list(args):
    hashes = []
    repo = args.repo
    if not args.no_ignore_revs_file:
        cfg = git(repo, "config", "--get-all", "blame.ignoreRevsFile", check=False)
        files = []
        for f in cfg.stdout.splitlines():
            if f == "":
                files = []
            else:
                files.append(f)
        top = git(repo, "rev-parse", "--show-toplevel", check=False).stdout.strip()
        for f in files:
            if f.startswith("~/"):
                f = os.path.join(os.path.expanduser("~"), f[2:])
            cands = [f] if os.path.isabs(f) else [os.path.join(repo, f), os.path.join(top, f)]
            found = next((c for c in cands if os.path.isfile(c)), None)
            if found:
                hashes += read_hash_file(found)
            else:
                print("warning: blame.ignoreRevsFile '%s' not found; skipping it" % f,
                      file=sys.stderr)
    for f in args.exclude_file or []:
        if not os.path.isfile(f):
            die("exclude file not found: " + f)
        hashes += read_hash_file(f)
    for c in args.exclude or []:
        r = git(repo, "rev-parse", "--verify", "--quiet", c + "^{commit}", check=False)
        if r.returncode != 0:
            die("cannot resolve commit '%s'" % c)
        hashes.append(r.stdout.strip())
    full = {h for h in hashes if len(h) >= 40}
    prefixes = sorted({h for h in hashes if len(h) < 40})
    return full, prefixes


def is_ignored(h, full, prefixes):
    return h in full or any(h.startswith(p) for p in prefixes)


# ---------------------------------------------------------------------------
# Selecting commits
# ---------------------------------------------------------------------------

def msg_line_count(msg, count_blank):
    lines = msg.split("\n")
    while lines and not lines[-1].strip():
        lines.pop()
    if count_blank:
        return len(lines)
    return sum(1 for l in lines if l.strip())


def final_path(p):
    """Resolve git's numstat rename notation to the new path."""
    if " => " not in p:
        return p
    q = re.sub(r"\{[^{}]* => ([^{}]*)\}", r"\1", p)
    if q != p:
        return q.replace("//", "/")
    return p.split(" => ")[-1]


def collect_commits(args, exts):
    """Run one `git log` and return a list of commit dicts."""
    full, prefixes = build_ignore_list(args)
    n_ign = len(full) + len(prefixes)
    if n_ign:
        print("Ignoring %d listed commit(s)." % n_ign, file=sys.stderr)

    cmd = ["log", "--use-mailmap", "-M", "--raw", "--numstat", "--no-abbrev",
           "--format=%x01%H%x1f%aN%x1f%aE%x1f%aI%x1f%B%x02"]
    if args.include_merges:
        cmd.append("--diff-merges=first-parent")
    else:
        cmd.append("--no-merges")
    if args.since:
        cmd.append("--since=" + args.since)
    if args.until:
        cmd.append("--until=" + args.until)
    if args.all:
        cmd.append("--all")
    if args.user:
        cmd += ["--regexp-ignore-case",
                "--extended-regexp" if args.user_regex else "--fixed-strings"]
        cmd += ["--author=" + u for u in args.user]
    if args.range:
        cmd.append(args.range)
    if args.paths:
        cmd += ["--"] + args.paths

    out = git(args.repo, *cmd).stdout
    commits = []
    for chunk in out.split("\x01")[1:]:
        head, _, rest = chunk.partition("\x02")
        h, name, email, date, msg = head.split("\x1f", 4)
        if is_ignored(h, full, prefixes):
            continue
        entries, loc = [], 0
        for line in rest.split("\n"):
            if line.startswith(":"):
                parts = line.split("\t")
                meta = parts[0][1:].split()
                if len(meta) < 5:
                    continue
                omode, nmode, osha, nsha, status = meta[:5]
                paths = parts[1:]
                npath = paths[-1]
                opath = paths[0]
                if omode in SKIP_MODES or nmode in SKIP_MODES:
                    continue
                if not npath.lower().endswith(exts):
                    continue
                osha = None if osha == ZERO_SHA else osha
                nsha = None if nsha == ZERO_SHA else nsha
                if osha == nsha:
                    continue  # pure rename / mode change: nothing to analyze
                entries.append((osha, nsha, opath, npath))
            elif "\t" in line:
                a, d, p = line.split("\t", 2)
                if a.isdigit() and d.isdigit() and final_path(p).lower().endswith(exts):
                    loc += int(a) + int(d)
        if not entries and not args.include_nonsource:
            continue
        commits.append({
            "hash": h, "name": name, "email": email, "date": date,
            "msg_lines": msg_line_count(msg, args.count_blank),
            "entries": entries, "loc": loc,
        })
    return commits


# ---------------------------------------------------------------------------
# Complexity analysis (runs in worker processes)
# ---------------------------------------------------------------------------

_W = {}  # per-process state
_WS = re.compile(r"\s+")
_COMMENTS = re.compile(r"//[^\n]*|/\*.*?\*/", re.DOTALL)


def _init_worker(repo, scc_path, max_blob, sim_threshold):
    _W.update(reader=BlobReader(repo), scc=scc_path, max_blob=max_blob,
              sim=sim_threshold, cache={}, tmp=tempfile.mkdtemp(prefix="gitcx-"))


def _analyze(path, data):
    code = data.decode("utf-8", errors="replace")
    try:
        info = lizard.analyze_file.analyze_source_code(path, code)
    except Exception:
        return []
    lines = code.splitlines()
    out = []
    for f in info.function_list:
        body = "\n".join(lines[f.start_line - 1:f.end_line])
        body = _COMMENTS.sub("", body)
        short = f.name.split("::")[-1]
        if short:
            # Blank out the function's own name so a pure rename keeps the
            # same fingerprint (recursive calls included).
            body = re.sub(r"(?<![\w$])" + re.escape(short) + r"(?![\w$])", "\0", body)
        norm = _WS.sub("", body)
        fp = hashlib.blake2b(norm.encode("utf-8", "replace"), digest_size=8).digest()
        out.append(Func(f.long_name, f.cyclomatic_complexity, fp, norm))
    return out


def _funcs(sha, path):
    key = (sha, os.path.splitext(path)[1].lower())
    cache = _W["cache"]
    if key in cache:
        return cache[key]
    data = _W["reader"].read(sha)
    funcs = [] if data is None or len(data) > _W["max_blob"] else _analyze(path, data)
    if len(cache) > 20000:
        cache.clear()
    cache[key] = funcs
    return funcs


def compare_functions(old, new, sim_threshold):
    """
    old/new: lists of (file_key, Func).
    Returns (net, churn, n_added, n_removed, n_modified).

    net   = sum(new ccn) - sum(old ccn); independent of how functions are
            matched, so renames/moves cancel exactly.
    churn = sum over matched pairs of |delta ccn| + ccn of unmatched new
            + ccn of unmatched old; matching decides whether a rename counts
            as zero churn (identical/similar body) or as remove + add.
    """
    used_o = [False] * len(old)
    used_n = [False] * len(new)
    pairs = []

    def pair_by(keyfn):
        buckets = defaultdict(list)
        for i, (fk, f) in enumerate(old):
            if not used_o[i]:
                buckets[keyfn(fk, f)].append(i)
        for j, (fk, f) in enumerate(new):
            if used_n[j]:
                continue
            b = buckets.get(keyfn(fk, f))
            if b:
                i = b.pop(0)
                used_o[i] = used_n[j] = True
                pairs.append((i, j))

    pair_by(lambda fk, f: (fk, f.long_name))   # same file, same name+signature
    pair_by(lambda fk, f: f.fp)                # identical body: rename or move

    # Similar body (renamed + edited, or signature changed).
    rest_o = [i for i in range(len(old)) if not used_o[i]]
    rest_n = [j for j in range(len(new)) if not used_n[j]]
    if sim_threshold < 1.0 and rest_o and rest_n and len(rest_o) * len(rest_n) <= 4000:
        for j in rest_n:
            b = new[j][1].norm
            if not b or len(b) > 8000:
                continue
            best, best_r = None, sim_threshold
            for i in rest_o:
                if used_o[i]:
                    continue
                a = old[i][1].norm
                if not a or len(a) > 8000:
                    continue
                sm = difflib.SequenceMatcher(None, a, b, autojunk=False)
                if sm.real_quick_ratio() < best_r or sm.quick_ratio() < best_r:
                    continue
                r = sm.ratio()
                if r >= best_r:
                    best, best_r = i, r
            if best is not None:
                used_o[best] = used_n[j] = True
                pairs.append((best, j))

    net = sum(f.ccn for _, f in new) - sum(f.ccn for _, f in old)
    churn = n_mod = 0
    for i, j in pairs:
        d = abs(new[j][1].ccn - old[i][1].ccn)
        churn += d
        if old[i][1].fp != new[j][1].fp:
            n_mod += 1
    added = [new[j][1] for j in range(len(new)) if not used_n[j]]
    removed = [old[i][1] for i in range(len(old)) if not used_o[i]]
    churn += sum(f.ccn for f in added) + sum(f.ccn for f in removed)
    return net, churn, len(added), len(removed), n_mod


def _scc_net(entries):
    """scc complexity (after - before) for one commit's files; one scc call."""
    tmp = _W["tmp"]
    for f in os.listdir(tmp):
        os.remove(os.path.join(tmp, f))
    for k, (osha, nsha, opath, npath) in enumerate(entries):
        ext = os.path.splitext(npath)[1]
        for prefix, sha in (("o", osha), ("n", nsha)):
            if sha:
                data = _W["reader"].read(sha)
                if data is not None:
                    with open(os.path.join(tmp, "%s_%d%s" % (prefix, k, ext)), "wb") as fh:
                        fh.write(data)
    r = subprocess.run(
        [_W["scc"], "--by-file", "-f", "json", "--no-cocomo", "--no-gitignore",
         "--no-ignore", tmp],
        stdout=subprocess.PIPE, stderr=subprocess.DEVNULL,
    )
    if r.returncode != 0:
        return None
    total = 0
    try:
        for lang in json.loads(r.stdout):
            for f in lang.get("Files", []):
                c = f.get("Complexity", 0)
                total += c if f["Filename"].startswith("n_") else -c
    except (ValueError, KeyError):
        return None
    return total


def _process_commit(c):
    old, new = [], []
    for osha, nsha, opath, npath in c["entries"]:
        if osha:
            old += [(npath, f) for f in _funcs(osha, opath)]
        if nsha:
            new += [(npath, f) for f in _funcs(nsha, npath)]
    net, churn, add, rem, mod = compare_functions(old, new, _W["sim"])
    res = {"ccn_net": net, "ccn_churn": churn, "funcs_added": add,
           "funcs_removed": rem, "funcs_modified": mod,
           "loc": c["loc"], "scc_net": None}
    if _W["scc"] and c["entries"]:
        res["scc_net"] = _scc_net(c["entries"])
    elif _W["scc"]:
        res["scc_net"] = 0
    return c["hash"], res


def _process_chunk(chunk):
    return [_process_commit(c) for c in chunk]


def analyze_commits(commits, args, scc_path):
    init = (args.repo, scc_path, args.max_blob_kb * 1024, args.rename_similarity)
    results = {}
    total = len(commits)
    jobs = max(1, args.jobs)

    def progress(done):
        if total >= 200:
            print("\rAnalyzed %d/%d commits" % (done, total), end="", file=sys.stderr)

    if jobs == 1 or total < 50:
        _init_worker(*init)
        for i, c in enumerate(commits, 1):
            h, r = _process_commit(c)
            results[h] = r
            if i % 100 == 0:
                progress(i)
    else:
        # Contiguous chunks: a commit's "before" blob is usually its parent's
        # "after" blob, so neighbouring commits share the per-worker cache.
        size = max(10, min(100, total // (jobs * 4) or 1))
        chunks = [commits[i:i + size] for i in range(0, total, size)]
        with Pool(jobs, initializer=_init_worker, initargs=init) as pool:
            done = 0
            for out in pool.imap_unordered(_process_chunk, chunks):
                for h, r in out:
                    results[h] = r
                done += len(out)
                progress(done)
    if total >= 200:
        print(file=sys.stderr)
    for c in commits:
        c["res"] = results[c["hash"]]


# ---------------------------------------------------------------------------
# Ratios
# ---------------------------------------------------------------------------

def denominator(n, mode):
    if mode == "plus1":
        return 1.0 + n
    if mode == "log":
        return 1.0 + math.log(max(n, 1))
    return float(n)  # raw


def safe_div(a, b):
    return a / b if b > 0 else 0.0


def ratio_modes(args):
    return ["plus1", "log"] if args.ratio == "both" else [args.ratio]


def fmt_signed(v):
    return "n/a" if v is None else "%+d" % v


# ---------------------------------------------------------------------------
# Output: commits
# ---------------------------------------------------------------------------

def cmd_commits(args, commits, metric_key, have_scc):
    modes = ratio_modes(args)
    rows = []
    for c in commits:
        m = c["res"][metric_key]
        if m is None:
            m = 0
        ratios = [safe_div(m, denominator(c["msg_lines"], md)) for md in modes]
        rows.append((ratios, c))
    # Sort by primary ratio, tie-break on churn magnitude.
    rows.sort(key=lambda r: (r[0][0], abs(r[1]["res"][metric_key] or 0)),
              reverse=not args.ascending)
    total = len(rows)
    if args.top:
        rows = rows[:args.top]

    if args.csv:
        w = csv.writer(sys.stdout)
        head = ["rank", "hash", "author", "email", "date", "msg_lines", "ccn_net",
                "ccn_churn", "loc", "scc_net", "funcs_added", "funcs_removed",
                "funcs_modified"] + ["ratio_" + md for md in modes]
        w.writerow(head)
        for rank, (ratios, c) in enumerate(rows, 1):
            r = c["res"]
            w.writerow([rank, c["hash"], c["name"], c["email"], c["date"], c["msg_lines"],
                        r["ccn_net"], r["ccn_churn"], r["loc"],
                        "" if r["scc_net"] is None else r["scc_net"],
                        r["funcs_added"], r["funcs_removed"], r["funcs_modified"]]
                       + ["%.4f" % x for x in ratios])
        return

    order = "lowest first" if args.ascending else "highest first"
    print("Showing %d of %d commits by %s per message line (%s)\n"
          % (len(rows), total, args.metric, order))

    show = ["show", "--no-color", "--date=short", "--numstat",
            "--format=commit %H%nAuthor: %aN <%aE>%nDate:   %ad%n%n%w(0,4,4)%B"]
    if args.patch:
        show.append("--patch")
    tail = ["--"] + args.paths if args.paths else []

    for rank, (ratios, c) in enumerate(rows, 1):
        r = c["res"]
        rtxt = "  ".join("%s %.2f" % (md, x) for md, x in zip(modes, ratios))
        line = "#%d  ratio[%s]  msg lines %d  |  ccn-net %+d  ccn-churn %d  loc %d" % (
            rank, rtxt, c["msg_lines"], r["ccn_net"], r["ccn_churn"], r["loc"])
        if have_scc:
            line += "  scc-net %s" % fmt_signed(r["scc_net"])
        line += "  |  funcs +%d -%d ~%d" % (
            r["funcs_added"], r["funcs_removed"], r["funcs_modified"])
        print(line)
        sys.stdout.flush()
        subprocess.run(["git", "--no-pager", "-C", args.repo, *show, c["hash"], *tail],
                       stdin=subprocess.DEVNULL)
        print("\n" + "=" * 64 + "\n")


# ---------------------------------------------------------------------------
# Output: aggregate
# ---------------------------------------------------------------------------

def group_key(c, by):
    if by == "author":
        return c["email"].lower(), c["name"]
    if by == "month":
        return c["date"][:7], c["date"][:7]
    return c["date"][:4], c["date"][:4]  # year


def cmd_aggregate(args, commits, metric_key, have_scc):
    modes = ratio_modes(args)
    groups = {}
    for c in commits:
        key, label = group_key(c, args.by)
        g = groups.setdefault(key, {
            "label": label, "key": key, "commits": 0, "msg": 0, "ccn_net": 0,
            "ccn_churn": 0, "loc": 0, "scc_net": 0,
            "den": {md: 0.0 for md in modes}, "metric": 0})
        r = c["res"]
        g["commits"] += 1
        g["msg"] += c["msg_lines"]
        for k in ("ccn_net", "ccn_churn", "loc"):
            g[k] += r[k]
        g["scc_net"] += r["scc_net"] or 0
        g["metric"] += r[metric_key] or 0
        for md in modes:
            g["den"][md] += denominator(c["msg_lines"], md)

    rows = list(groups.values())
    for g in rows:
        g["ratios"] = [safe_div(g["metric"], g["den"][md]) for md in modes]

    sort_by = args.sort or ("ratio" if args.by == "author" else "key")
    if sort_by == "key":
        rows.sort(key=lambda g: g["key"])  # chronological
    else:
        rows.sort(key=lambda g: g["ratios"][0], reverse=not args.ascending)

    tot = {"label": "TOTAL", "key": "", "commits": 0, "msg": 0, "ccn_net": 0,
           "ccn_churn": 0, "loc": 0, "scc_net": 0, "metric": 0,
           "den": {md: 0.0 for md in modes}}
    for g in groups.values():
        for k in ("commits", "msg", "ccn_net", "ccn_churn", "loc", "scc_net", "metric"):
            tot[k] += g[k]
        for md in modes:
            tot["den"][md] += g["den"][md]
    tot["ratios"] = [safe_div(tot["metric"], tot["den"][md]) for md in modes]

    head = ["Author" if args.by == "author" else args.by.capitalize()]
    if args.by == "author":
        head.append("Email")
    head += ["Commits", "MsgLines", "CCN-net", "CCN-churn", "LOC"]
    if have_scc:
        head.append("SCC-net")
    head += ["%s/%s" % (args.metric, md) for md in modes]

    def row_of(g):
        cells = [g["label"]]
        if args.by == "author":
            cells.append(g["key"])
        cells += [g["commits"], g["msg"], "%+d" % g["ccn_net"], g["ccn_churn"], g["loc"]]
        if have_scc:
            cells.append("%+d" % g["scc_net"])
        cells += ["%.2f" % x for x in g["ratios"]]
        return [str(x) for x in cells]

    table = [head] + [row_of(g) for g in rows] + [row_of(tot)]

    if args.csv:
        w = csv.writer(sys.stdout)
        for r in table:
            w.writerow(r)
        return

    widths = [max(len(r[i]) for r in table) for i in range(len(head))]
    left = 2 if args.by == "author" else 1  # leading text columns are left-aligned

    def fmt(r):
        return "  ".join(r[i].ljust(widths[i]) if i < left else r[i].rjust(widths[i])
                         for i in range(len(r)))

    sep = "-" * (sum(widths) + 2 * (len(widths) - 1))
    print(fmt(table[0]))
    print(sep)
    for r in table[1:-1]:
        print(fmt(r))
    print(sep)
    print(fmt(table[-1]))
    print("\nratio = sum(%s) / sum(per-commit denominator); plus1 = 1 + msg lines, "
          "log = 1 + ln(msg lines)." % args.metric)


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def build_parser():
    common = argparse.ArgumentParser(add_help=False)
    g = common.add_argument_group("Selection")
    g.add_argument("range", nargs="?", help="git revision range, e.g. v1.0..HEAD")
    g.add_argument("-r", "--range", dest="range_opt", metavar="RANGE",
                   help="same as the positional RANGE")
    g.add_argument("-u", "--user", action="append", metavar="TEXT",
                   help="only authors whose 'Name <email>' contains TEXT "
                        "(case-insensitive; repeatable)")
    g.add_argument("--user-regex", action="store_true",
                   help="treat --user values as extended regular expressions")
    g.add_argument("--since", metavar="DATE")
    g.add_argument("--until", metavar="DATE")
    g.add_argument("-a", "--all", action="store_true", help="walk all refs")
    g.add_argument("-C", "--repo", default=".", metavar="DIR",
                   help="repository directory (default: cwd)")
    g.add_argument("-P", "--path", action="append", dest="paths", default=[],
                   metavar="PATH", help="limit to a pathspec (repeatable); "
                   "anything after a bare `--` is also a path")
    g.add_argument("--ext", action="append", metavar=".EXT",
                   help="source file extension to analyze (repeatable; default: .java)")

    g = common.add_argument_group("Excluding commits")
    g.add_argument("-x", "--exclude", action="append", metavar="COMMIT")
    g.add_argument("-X", "--exclude-file", action="append", metavar="FILE")
    g.add_argument("--no-ignore-revs-file", action="store_true",
                   help="do not honour blame.ignoreRevsFile")
    g.add_argument("--include-merges", action="store_true",
                   help="include merge commits (diffed against first parent)")
    g.add_argument("--include-nonsource", action="store_true",
                   help="also count commits that touch no analyzed source files")

    g = common.add_argument_group("Counting")
    g.add_argument("--metric", choices=list(METRICS), default="ccn-net",
                   help="numerator of the ratio (default: ccn-net)")
    g.add_argument("--ratio", choices=["plus1", "log", "raw", "both"], default="plus1",
                   help="message-length denominator: plus1 = 1+lines, log = "
                        "1+ln(lines), raw = lines, both = plus1 and log columns")
    g.add_argument("--count-blank", action="store_true",
                   help="count blank lines inside commit messages")
    g.add_argument("--rename-similarity", type=float, default=0.8, metavar="0-1",
                   help="body similarity needed to treat an unmatched removed/added "
                        "function pair as the same function (default 0.8; 1 disables)")
    g.add_argument("--max-blob-kb", type=int, default=1024, metavar="KB",
                   help="skip files larger than this, e.g. generated code (default 1024)")
    g.add_argument("--no-scc", action="store_true", help="do not use scc even if installed")
    g.add_argument("-j", "--jobs", type=int, default=min(8, os.cpu_count() or 1))

    g = common.add_argument_group("Output")
    g.add_argument("-A", "--ascending", action="store_true", help="lowest first")
    g.add_argument("--csv", action="store_true")

    p = argparse.ArgumentParser(
        description="Estimate complexity per Git commit relative to commit-message length.",
        epilog="Usage: git-complexity.py {commits,aggregate} [options] [RANGE] [-- PATH...]")
    sub = p.add_subparsers(dest="cmd", required=True)

    c = sub.add_parser("commits", parents=[common], help="rank individual commits")
    c.add_argument("-n", "--top", type=int, default=20,
                   help="show the first N commits (default 20; 0 = all)")
    c.add_argument("-p", "--patch", action="store_true", help="also show each diff")

    a = sub.add_parser("aggregate", parents=[common], help="aggregate commits into groups")
    a.add_argument("--by", choices=["author", "month", "year"], default="author")
    a.add_argument("--sort", choices=["ratio", "key"],
                   help="default: ratio for author, key (chronological) for month/year")
    return p


def main():
    argv = sys.argv[1:]
    paths_after = []
    if "--" in argv:
        i = argv.index("--")
        argv, paths_after = argv[:i], argv[i + 1:]
    args = build_parser().parse_args(argv)
    args.paths = list(args.paths) + paths_after
    if args.range and args.range_opt:
        die("multiple ranges given")
    args.range = args.range or args.range_opt
    if args.cmd == "commits" and args.top < 0:
        die("--top must be non-negative")
    if not 0 < args.rename_similarity <= 1:
        die("--rename-similarity must be in (0, 1]")

    exts = tuple(e.lower() if e.startswith(".") else "." + e.lower()
                 for e in (args.ext or [".java"]))
    for e in exts:
        try:
            from lizard_languages import get_reader_for
            if get_reader_for("x" + e) is None:
                die("lizard does not support files ending in '%s'" % e)
        except ImportError:
            break

    if git(args.repo, "rev-parse", "--git-dir", check=False).returncode != 0:
        die("'%s' is not a git repository" % args.repo)

    scc_path = None if args.no_scc else shutil.which("scc")
    if args.metric == "scc-net" and not scc_path:
        die("--metric scc-net needs `scc` on PATH (and not --no-scc)")
    have_scc = scc_path is not None
    if have_scc:
        print("Using scc: " + scc_path, file=sys.stderr)

    commits = collect_commits(args, exts)
    if not commits:
        print("No matching commits found.", file=sys.stderr)
        return
    analyze_commits(commits, args, scc_path)

    metric_key = METRICS[args.metric]
    if args.cmd == "commits":
        cmd_commits(args, commits, metric_key, have_scc)
    else:
        cmd_aggregate(args, commits, metric_key, have_scc)


if __name__ == "__main__":
    try:
        main()
    except BrokenPipeError:
        sys.stderr.close()  # e.g. piped into `head`
        sys.exit(0)
