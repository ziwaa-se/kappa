#!/usr/bin/env python3
"""make_tables.py — regenerate the result tables of the paper from the archived run records, without a language model.

Usage: python3 make_tables.py <examples folder> [--kit <kit folder>]

<examples folder> holds one folder per case study, each with `answer_key.json` and `results/` (a run record copied by
the kit's examples/tools/sanitize.py). For each case and each round of checking, the script prints the score against
the answer key (examples/tools/score.py), the cost reported by Claude Code (sum over the driver's sessions), the
active running time (each session from its start in the driver's log to its end; waits for usage limits and pauses
between drivers are excluded) and the counts of problems found by the fact check of each report.

A round of checking ends when a revised version is registered (the 'before-revision' snapshot of /pv-revise).
"""
import datetime as dt
import json
import re
import subprocess
import sys
from pathlib import Path


def sessions(res):
    """[(k, cost, end time)] of the run's sessions."""
    out = []
    for s in json.loads((res / "sessions.json").read_text()):
        k = int(re.search(r"session_(\d+)", s["file"]).group(1))
        out.append((k, s.get("total_cost_usd") or 0.0, dt.datetime.fromisoformat(s["ended"]) if s.get("ended") else None))
    return sorted(out)


def created(res):
    """{k: start time} from the creation time of each session's output file, where sanitize.py recorded it."""
    out = {}
    for s in json.loads((res / "sessions.json").read_text()):
        if s.get("started"):
            out[int(re.search(r"session_(\d+)", s["file"]).group(1))] = dt.datetime.fromisoformat(s["started"])
    return out


def starts(res):
    """{k: start time} from the driver logs, '[HH:MM] session k' lines; dates from the log names, with rollover."""
    st = {}
    for f in sorted((res / "pv_work/logs/drive").glob("driver_*.out")):
        day = dt.datetime.strptime(re.search(r"driver_(\d{8})-", f.name).group(1), "%Y%m%d")
        prev = None
        for line in f.read_text(errors="replace").splitlines():
            m = re.match(r"\[(\d\d):(\d\d)\] session (\d+)", line)
            if not m:
                m2 = re.match(r"\[(\d\d):(\d\d)\]", line)
                if m2:
                    t = day.replace(hour=int(m2.group(1)), minute=int(m2.group(2)))
                    if prev and t < prev:
                        day += dt.timedelta(days=1)
                    prev = day.replace(hour=int(m2.group(1)), minute=int(m2.group(2)))
                continue
            t = day.replace(hour=int(m.group(1)), minute=int(m.group(2)))
            if prev and t < prev:
                day += dt.timedelta(days=1)
                t += dt.timedelta(days=1)
            prev = t
            st[int(m.group(3))] = t
    return st


def rounds(res):
    """[(first k, last k)] of the rounds of checking. A new round starts with the first session that ended after a
    revision was registered (the time of each 'before-revision' snapshot that /pv-revise keeps)."""
    cuts = sorted(dt.datetime.strptime(p.name[:15], "%Y%m%d-%H%M%S")
                  for p in (res / "verification/snapshots").glob("*before-revision*"))
    ss = sessions(res)
    out = []
    for k, _, end in ss:
        i = sum(1 for c in cuts if end and end > c)
        while len(out) <= i:
            out.append([k, k])
        out[i][1] = k
    return [tuple(r) for r in out]


def round_stats(res, a, b):
    ss, st, cr = sessions(res), starts(res), created(res)
    cost, minutes, prev_end = 0.0, 0.0, None
    for k, c, end in ss:
        if a <= k <= b:
            cost += c
            begin = cr.get(k) or st.get(k, prev_end)
            if begin and end:
                minutes += max(0.0, (end - begin).total_seconds() / 60)
        prev_end = end
    return cost, minutes


def factchecks(res):
    """Counts of each report's fact check: the archived ones first, then the current one."""
    found = sorted((res / "verification/report_archive").glob("*/work/factcheck*.md")) + \
        sorted((res / "verification/report/work").glob("factcheck*.md"))
    out = []
    for f in found:
        m = re.search(r"Major\D*(\d+)\D+Moderate\D*(\d+)\D+Minor\D*(\d+)", f.read_text(errors="replace"))
        if m:
            out.append(tuple(int(x) for x in m.groups()))
    return out


def main():
    a = sys.argv[1:]
    if not a:
        print(__doc__)
        return 2
    root = Path(a[0])
    kit = Path(a[a.index("--kit") + 1]) if "--kit" in a else Path(__file__).resolve().parent.parent
    score = kit / "examples/tools/score.py"
    print("| Case | Round | Score against the key | Cost (USD) | Active minutes | Fact check (major/moderate/minor) |")
    print("|---|---|---|---:|---:|---|")
    for case in sorted(p for p in root.iterdir() if (p / "results/sessions.json").exists()):
        res = case / "results"
        # Round 1 is scored on the records kept before the revision (if there was one), later rounds on the final
        # records against answer_key_round2.json (if the case has one).
        snaps = sorted((res / "verification/snapshots").glob("*before-revision*/verification/RESULTS.json"))
        targets = [snaps[0].parent.parent if snaps else res] + ([res] if snaps else [])
        keys = [case / "answer_key.json", case / "answer_key_round2.json"]
        fcs = factchecks(res)
        for i, (k0, k1) in enumerate(rounds(res)):
            sc = "—"
            if i < len(targets) and keys[min(i, 1)].exists():
                p = subprocess.run([sys.executable, str(score), str(targets[i]), str(keys[min(i, 1)])],
                                   stdout=subprocess.PIPE, universal_newlines=True)
                sc = p.stdout.strip().splitlines()[-1] if p.stdout.strip() else "?"
            cost, minutes = round_stats(res, k0, k1)
            fc = "/".join(map(str, fcs[i])) if i < len(fcs) else "—"
            print(f"| {case.name} | {i + 1} | {sc} | {cost:.2f} | {minutes:.0f} | {fc} |")
    return 0


if __name__ == "__main__":
    sys.exit(main())
