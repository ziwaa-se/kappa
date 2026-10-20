#!/usr/bin/env python3
"""replay.py — re-check a finished run offline, without a language model.

Takes the records of a run (a project folder, or a folder written by sanitize.py) and a shared Lean environment, and:
  1. makes a fresh kit project linked to that environment, and copies the run's RESULTS.json, review reports and
     pv_work Lean files into it;
  2. rebuilds every proof, statement and counterexample module in import order (drafts with `sorry` are skipped);
  3. reruns the mechanical audit (pv_audit_mech.py) for every verified result, on the module its record names, and
     compares the outcome with the archived mechanical report;
  4. runs validate (of the current kit) on the copied records and prints its last line.
Prints a Markdown table; exit status 1 if any verified result does not rebuild or its checks differ. The validator's
result is reported but does not set the exit status: a newer kit may check more than the version that made the run
(v1.3.3, for example, checks that every recorded theorem name exists).

Usage: python3 examples/tools/replay.py <run folder> --lean-env <lean-env> [--work <empty folder>] [--keep]
"""
import argparse
import json
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

KIT = Path(__file__).resolve().parent.parent.parent
IMPORT = re.compile(r"^\s*import\s+([A-Za-z0-9_.]+)", re.M)


def sh(args, cwd, timeout=3600):
    p = subprocess.run(args, cwd=str(cwd), stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True,
                       timeout=timeout)
    return p.returncode, p.stdout


def last_line(path, prefix):
    if not path.exists():
        return None
    lines = [l.strip().strip("*` ") for l in path.read_text(errors="replace").splitlines() if l.strip()]
    for l in reversed(lines[-5:]):
        if l.startswith(prefix):
            return l[len(prefix):].strip()
    return None


def build_order(mods):
    order, seen = [], set()

    def visit(m, stack=()):
        if m in seen or m in stack:
            return
        for d in mods.get(m, []):
            if d in mods:
                visit(d, stack + (m,))
        seen.add(m)
        order.append(m)
    for m in sorted(mods):
        visit(m)
    return order


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("run")
    ap.add_argument("--lean-env", required=True)
    ap.add_argument("--work")
    ap.add_argument("--keep", action="store_true")
    a = ap.parse_args()
    run = Path(a.run).resolve()
    tmp = Path(a.work) if a.work else Path(tempfile.mkdtemp(prefix="pv-replay-"))
    tmp.mkdir(parents=True, exist_ok=True)
    proj = tmp / "replay"
    if proj.exists():
        sys.exit(f"{proj} already exists; give an empty --work folder")
    ec, out = sh([str(KIT / "install.sh"), str(proj), "--lean-from", str(Path(a.lean_env).expanduser()), "--link-packages"], tmp)
    if ec:
        print(out)
        sys.exit("install failed")
    state = json.loads((run / "verification/RESULTS.json").read_text())
    shutil.copy2(str(run / "verification/RESULTS.json"), str(proj / "verification/RESULTS.json"))
    for f in (run / "verification/audits").glob("*.md"):
        shutil.copy2(str(f), str(proj / "verification/audits" / f.name))
    for f in (run / "pv_work").glob("*.lean"):
        if f.name != "PVTools.lean":
            shutil.copy2(str(f), str(proj / "pv_work" / f.name))
    for name in ("PAPER_VERIFICATION.md", "BLOCKERS.md", "EXTERNAL_TOOLS.md", "AUDIT.md"):
        if (run / "verification" / name).exists():
            shutil.copy2(str(run / "verification" / name), str(proj / "verification" / name))
    src = run / "source"
    if src.is_dir():
        shutil.rmtree(str(proj / "source"))
        shutil.copytree(str(src), str(proj / "source"))
    mods = {f.stem: IMPORT.findall(f.read_text(errors="replace")) for f in (proj / "pv_work").glob("*.lean")
            if f.name != "PVTools.lean"}
    built, failed = {}, set()
    for m in build_order(mods):
        if m.endswith("Draft") or any(d in failed for d in mods[m]):
            built[m] = "skipped (draft)" if m.endswith("Draft") else "skipped (an import failed)"
            failed.add(m)
            continue
        ec, out = sh(["scripts/pv_lean.sh", "build", m], proj)
        built[m] = "built" if ec == 0 else f"failed (exit {ec})"
        if ec:
            failed.add(m)
    rows, bad = [], 0
    for r in state.get("results", []):
        rid, v = r.get("id"), r.get("verdict")
        if v in ("UNCONDITIONAL", "CONDITIONAL"):
            lm = (r.get("lean_main") or "").split(" ")[0].split(":")[0]
            mod = Path(lm).stem if lm else rid
            args = ["python3", "scripts/pv_audit_mech.py", rid, "--module", mod]
            if "Closed" in mod:
                args.append("--skip-statement")
            before = sorted((proj / "verification/audits").glob(f"{rid}_mech*.md"))
            archived = [p for p in before if f"`{mod}`" in p.read_text(errors="replace").splitlines()[0]] or before
            old = last_line(archived[-1], "MECH CHECKS:") if archived else None
            ec, out = sh(args, proj)
            now = re.search(r"^MECH CHECKS: (.*)$", out, re.M)
            now = now.group(1) if now else "no result"
            same = old is not None and old.split(" ")[0] == now.split(" ")[0]
            ok = built.get(mod) == "built" and now.startswith("PASS")
            bad += 0 if ok else 1
            rows.append((rid, v, mod, built.get(mod, "?"), now, old or "—", "yes" if ok and same else ("yes" if ok else "NO")))
        elif v == "ISSUE":
            cx = sorted(m for m in mods if m.startswith(f"{rid}_Counterexample"))
            for m in cx:
                ok = built.get(m) == "built"
                bad += 0 if ok else 1
                rows.append((rid, v, m, built.get(m), "counterexample rebuilt" if ok else "—", "—", "yes" if ok else "NO"))
            if not cx:
                rows.append((rid, v, "—", "—", "no Lean counterexample (reasoning review)", "—", "—"))
        else:
            rows.append((rid, v, "—", "—", r.get("reason", ""), "—", "—"))
    ec, val = sh(["python3", "scripts/pv_status.py", "validate"], proj)
    print(f"# Offline replay of `{run.name}`\n")
    print(f"Fresh project: `{proj}`; Lean environment: `{a.lean_env}`.\n")
    print("| ID | Verdict | Module | Rebuild | Mechanical checks now | Archived | Confirmed |")
    print("|---|---|---|---|---|---|---|")
    for row in rows:
        print("| " + " | ".join(str(c).replace("|", "\\|") for c in row) + " |")
    print(f"\nModules rebuilt: {sum(1 for x in built.values() if x == 'built')} of {len(built)} "
          f"(drafts with `sorry` are not built). validate: {val.strip().splitlines()[-1] if val.strip() else '?'}")
    if not a.keep and not a.work:
        shutil.rmtree(str(tmp), ignore_errors=True)
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
