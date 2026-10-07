#!/usr/bin/env python3
"""projects.py — list the paper projects under <base>/papers/: which paper each one checks, and where it stands.

Usage: python3 autosetup/projects.py <base>            all projects
       python3 autosetup/projects.py <base> --one DIR  one project
"""
import json
import re
import subprocess
import sys
from pathlib import Path


def title_from_tex(p):
    try:
        m = re.search(r"\\title\s*(?:\[[^\]]*\])?\s*\{((?:[^{}]|\{[^{}]*\})*)\}", p.read_text(errors="replace"))
        return re.sub(r"\s+", " ", m.group(1)).strip() if m else ""
    except Exception:
        return ""


def info(proj):
    proj = Path(proj)
    out = {"folder": str(proj), "name": proj.name, "title": "", "main": "", "status": "not set up yet (no /pv-setup)",
           "updated": "", "source": "", "kit": (proj / "KIT_VERSION").read_text().strip() if (proj / "KIT_VERSION").exists() else "?"}
    state = proj / "verification" / "RESULTS.json"
    data = {}
    if state.exists():
        try:
            data = json.loads(state.read_text())
        except Exception:
            out["status"] = "RESULTS.json unreadable"
    paper = data.get("paper", {}) or {}
    set_up = bool(data.get("results"))
    # before /pv-setup, paper.main_tex is only the template's placeholder
    out["main"] = paper.get("main_tex", "") if set_up and (proj / paper.get("main_tex", "-")).is_file() else ""
    out["title"] = paper.get("title", "") if set_up else ""
    if not out["title"] or not out["main"]:
        mains = [p for p in (proj / "source").rglob("*.tex") if "\\documentclass" in p.read_text(errors="replace")[:5000]] \
            if (proj / "source").is_dir() else []
        out["title"] = out["title"] or (title_from_tex(mains[0]) if mains else "")
        out["main"] = out["main"] or (str(mains[0].relative_to(proj)) if mains else "(no paper in source/ yet)")
    res = [r for r in data.get("results", []) if isinstance(r, dict)]
    if res:
        c = {v: sum(1 for r in res if r.get("verdict") == v) for v in ["UNCONDITIONAL", "CONDITIONAL", "ISSUE", "UNFINISHED"]}
        running = any(r.get("verdict") == "UNFINISHED" and r.get("stage") not in ("NOT_STARTED", "INVENTORIED", "STOPPED")
                      for r in res)
        out["status"] = (f"{len(res)} results: {c['UNCONDITIONAL']} unconditional, {c['CONDITIONAL']} conditional, "
                         f"{c['ISSUE']} issue, {c['UNFINISHED']} unfinished" + (" (a run is under way or was interrupted)" if running else ""))
        out["updated"] = max((r.get("updated", "") for r in res), default="")
    if (proj / "scripts" / "pv_status.py").exists() and (proj / "verification" / "source_baseline").is_dir():
        p = subprocess.run([sys.executable, "scripts/pv_status.py", "source-check"], cwd=str(proj),
                           stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True)
        out["source"] = (p.stdout.splitlines() or [""])[0].replace("SOURCE ", "")[:120]
    return out


def show(i):
    print(f"- {i['name']}  ({i['folder']})")
    print(f"    paper:   {i['title'] or '(title unknown)'}   main file: {i['main']}")
    print(f"    status:  {i['status']}" + (f"; last update {i['updated']}" if i["updated"] else ""))
    if i["source"]:
        print(f"    source/: {i['source']}")
    print(f"    kit:     {i['kit']}")


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    base = Path(sys.argv[1])
    if "--one" in sys.argv:
        show(info(sys.argv[sys.argv.index("--one") + 1]))
        return
    projs = sorted(p for p in (base / "papers").glob("*-check") if p.is_dir()) if (base / "papers").is_dir() else []
    if not projs:
        print("No paper projects yet.")
        return
    print(f"{len(projs)} paper project(s) in {base / 'papers'}:")
    for p in projs:
        show(info(p))


if __name__ == "__main__":
    main()
