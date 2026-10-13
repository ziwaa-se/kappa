#!/usr/bin/env python3
"""sanitize.py — copy the records of a finished run into an example folder, without local paths, user names or
e-mail addresses. Used to publish the kit's examples; run it yourself.

Usage: python3 examples/tools/sanitize.py <project> <dest>/results [--allow-email noreply.github.com]

Copies verification/ records, audits and the report, the pv_work Lean files of the results (not PVTools.lean, not
probes), the records of earlier revisions (archived audits and reports, superseded Lean files, the records before each revision), the driver's log, the driver's session summaries (cost, turns, models; not the full JSON), and a token report from
pv_usage.py. In every text file the project path becomes `<project>`, the home folder `~` and the user name
`<user>`. Stops without writing anything if an e-mail address remains that is not allowed.
"""
import argparse
import datetime
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

EMAIL = re.compile(r"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}")
COPY = ["verification/RESULTS.json", "verification/PAPER_VERIFICATION.md", "verification/BLOCKERS.md",
        "verification/EXTERNAL_TOOLS.md", "verification/AUDIT.md", "verification/INVENTORY.md",
        "verification/DOC_ERRATA.md"]
TREES = [("verification/audits", "*.md"), ("verification/report", "*.md"), ("verification/report/work", "factcheck*.md"),
         ("verification/report/work", "AUTHOR_REPORT_v1.md"),
         # records of earlier revisions: archived audits, earlier reports and the superseded Lean files
         ("verification/audits", "rev*/*.md"), ("verification/report_archive", "*/*.md"),
         ("verification/report_archive", "*/work/factcheck*.md"), ("pv_work/superseded", "rev*/*.lean"),
         ("pv_work/superseded", "rev*/README.md"),
         # the driver's own log (session start times, usage-limit waits, the stop reason)
         ("pv_work/logs/drive", "driver_*.out"),
         # the records as they stood before each revision (kept by /pv-revise as a snapshot)
         ("verification/snapshots", "*before-revision*/verification/RESULTS.json"),
         ("verification/snapshots", "*before-revision*/verification/BLOCKERS.md")]


def clean(text, project, home, user):
    for p in sorted({str(project), os.path.realpath(str(project))}, key=len, reverse=True):
        text = text.replace(p, "<project>")
    text = text.replace(str(home), "~")
    return re.sub(rf"\b{re.escape(user)}\b", "<user>", text) if user else text


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("project")
    ap.add_argument("dest")
    ap.add_argument("--allow-email", action="append", default=["users.noreply.github.com"])
    ap.add_argument("--user", default=os.environ.get("USER", ""))
    a = ap.parse_args()
    proj, dest = Path(a.project).absolute(), Path(a.dest)
    home = Path.home()
    files = {}
    for rel in COPY:
        if (proj / rel).exists():
            files[rel] = (proj / rel).read_text(errors="replace")
    for d, pat in TREES:
        for f in sorted((proj / d).glob(pat)):
            if f.is_file():
                files[str(f.relative_to(proj))] = f.read_text(errors="replace")
    for f in sorted((proj / "pv_work").glob("*.lean")):
        if f.name != "PVTools.lean":
            files[f"pv_work/{f.name}"] = f.read_text(errors="replace")
    sessions = []
    for f in sorted(list((proj / "pv_work/logs/drive").glob("session_*.json")) + list((proj / "bench_logs").glob("session_*.json"))):
        try:
            d = json.loads(f.read_text())
        except ValueError:
            continue
        sessions.append({"file": f.name, "total_cost_usd": d.get("total_cost_usd"), "num_turns": d.get("num_turns"),
                         "is_error": d.get("is_error"), "terminal_reason": d.get("terminal_reason"),
                         "models": sorted((d.get("modelUsage") or {}).keys()),
                         "started": (datetime.datetime.fromtimestamp(f.stat().st_birthtime).isoformat(timespec="seconds")
                                     if hasattr(f.stat(), "st_birthtime") else None),
                         "ended": datetime.datetime.fromtimestamp(f.stat().st_mtime).isoformat(timespec="seconds")})
    files["sessions.json"] = json.dumps(sessions, indent=1) + "\n"
    usage = subprocess.run([sys.executable, str(proj / "scripts/pv_usage.py"), "--project", str(proj)],
                           stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True)
    files["usage.md"] = usage.stdout
    out, bad = {}, []
    for rel, text in files.items():
        t = clean(text, proj, home, a.user)
        for m in EMAIL.findall(t):
            if not any(m.endswith(x) for x in a.allow_email):
                bad.append(f"{rel}: {m}")
        out[rel] = t
    if bad:
        print("refused: e-mail addresses remain (remove them or pass --allow-email):")
        for b in bad[:20]:
            print("   " + b)
        return 1
    for rel, t in out.items():
        p = dest / rel
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(t)
    left = [rel for rel, t in out.items() if "/Users/" in t or "/home/" in t]
    print(f"wrote {len(out)} files to {dest}; files still containing an absolute path: {left or 'none'}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
