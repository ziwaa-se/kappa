#!/usr/bin/env python3
"""import_legacy.py — bring the Lean material of an earlier check (one NOT made with this kit) into a kit project,
so that a re-check can reuse it (kit v1.3.1, docs/MANUAL.md "Importing an earlier check"). Run it yourself, outside
Claude Code; it changes .claude/settings.json only with --write-settings.

Usage:
  python3 autosetup/import_legacy.py <project> <legacy_lean_root> [--label prev-2026-09]
         [--verdicts verdicts.tsv] [--no-build] [--write-settings]
  python3 autosetup/import_legacy.py <project> --build-only

  <legacy_lean_root>  the folder that is the root of the earlier Lean modules (a file Paper/Foo.lean there is the
                      module `Paper.Foo`). Every .lean file below it is copied to pv_work/ under the same relative
                      path, so that module names, and therefore the imports between the modules, stay the same
  --verdicts FILE     tab-separated lines `<kit ID>\t<earlier verdict>\t<note>`: written into each result's history
                      with the --label as revision (for the report's before/after table; never evidence)
  --no-build          copy only (rebuild later with this script and --build-only)
  --build-only        rebuild the copied modules again
  --write-settings    add deny rules for the copied folders to .claude/settings.json (a backup is kept)

What it does:
  1. copies the modules (refusing any name that clashes with a kit module or an existing file);
  2. rebuilds them in import order with the project's Lean (`lake env lean -R pv_work -o …`), skipping modules whose
     imports failed; a module that compiles with `sorry` is recorded as such;
  3. makes the copies read-only (chmod a-w) and prints, or writes, deny rules for them;
  4. records the earlier verdicts in history (--verdicts);
  5. creates verification/REVISION_BRIEF.md from the template if it does not exist, and fills in what it did.
Log: pv_work/logs/import_legacy.log
"""
import argparse
import json
import os
import re
import shutil
import stat
import subprocess
import sys
from datetime import datetime
from pathlib import Path

KIT_MODULES = {"PVTools"}
IMPORT = re.compile(r"^\s*import\s+([A-Za-z0-9_.]+(?:\s+[A-Za-z0-9_.]+)*)", re.M)


def now():
    return datetime.now().strftime("%Y-%m-%d %H:%M")


def module_name(rel):
    return str(Path(rel).with_suffix("")).replace(os.sep, ".")


def imports(text):
    out = []
    for m in IMPORT.finditer(re.sub(r"/-.*?-/", "", text, flags=re.S)):
        out.extend(m.group(1).split())
    return out


def build_order(mods):
    """Topological order of {module: [imported modules]} restricted to the given modules."""
    order, state = [], {}

    def visit(m, path):
        if state.get(m) == 2:
            return
        if state.get(m) == 1:
            raise SystemExit("import cycle: " + " -> ".join(path + [m]))
        state[m] = 1
        for d in mods[m]:
            if d in mods:
                visit(d, path + [m])
        state[m] = 2
        order.append(m)
    for m in sorted(mods):
        visit(m, [])
    return order


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("project")
    ap.add_argument("legacy", nargs="?")
    ap.add_argument("--label", default="legacy")
    ap.add_argument("--verdicts")
    ap.add_argument("--no-build", action="store_true")
    ap.add_argument("--build-only", action="store_true")
    ap.add_argument("--write-settings", action="store_true")
    a = ap.parse_args()
    proj = Path(a.project).resolve()
    work = proj / "pv_work"
    state_f = proj / "verification" / "RESULTS.json"
    if not state_f.exists():
        sys.exit(f"{proj} is not a kit project (no verification/RESULTS.json)")
    logs = work / "logs"
    logs.mkdir(parents=True, exist_ok=True)
    log = open(str(logs / "import_legacy.log"), "a")
    say = lambda s: (print(s), log.write(s + "\n"))
    manifest_f = work / "logs" / "import_legacy_manifest.json"
    if a.build_only:
        manifest = json.loads(manifest_f.read_text())
    else:
        if not a.legacy:
            sys.exit("give the folder of the earlier Lean modules")
        src = Path(a.legacy).resolve()
        files = sorted(p for p in src.rglob("*.lean") if ".lake" not in p.parts and "lake-packages" not in p.parts)
        if not files:
            sys.exit(f"no .lean files under {src}")
        rels = [str(p.relative_to(src)) for p in files]
        clash = [r for r in rels if module_name(r) in KIT_MODULES or (work / r).exists()]
        if clash:
            sys.exit("refused: these modules would overwrite or shadow files of this project: " + ", ".join(clash[:10]))
        say(f"[{now()}] importing {len(files)} modules from {src}")
        for p, r in zip(files, rels):
            dest = work / r
            dest.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(str(p), str(dest))
        tops = sorted({Path(r).parts[0] for r in rels})
        manifest = {"source": str(src), "label": a.label, "date": now(), "files": rels, "top": tops, "built": {}}
    mods = {module_name(r): imports((work / r).read_text(errors="replace")) for r in manifest["files"]}
    rel_of = {module_name(r): r for r in manifest["files"]}
    if not a.no_build:
        failed = set()
        for m in build_order(mods):
            r = rel_of[m]
            f, olean = work / r, (work / r).with_suffix(".olean")
            if any(d in failed for d in mods[m] if d in mods):
                manifest["built"][m] = "skipped (an import failed)"
                failed.add(m)
                continue
            for p in (f, olean):
                if p.exists():
                    p.chmod(p.stat().st_mode | stat.S_IWUSR)
            env = dict(os.environ, LEAN_PATH=f"{work}{os.pathsep}{os.environ.get('LEAN_PATH', '')}")
            p = subprocess.run(["lake", "env", "lean", "-R", str(work), "-o", str(olean), str(f)], cwd=str(proj), env=env,
                               stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True)
            errors = p.returncode != 0 or ": error" in p.stdout
            if errors:
                failed.add(m)
                if olean.exists():
                    olean.unlink()
                manifest["built"][m] = "failed"
                log.write(f"--- {m}\n{p.stdout[-2000:]}\n")
            else:
                manifest["built"][m] = "built, uses sorry" if "declaration uses 'sorry'" in p.stdout else "built"
        n_ok = sum(1 for v in manifest["built"].values() if v.startswith("built"))
        say(f"rebuilt {n_ok} of {len(mods)} modules; failed or skipped: {len(mods) - n_ok} (details in the log)")
    for r in manifest["files"]:
        for p in ((work / r), (work / r).with_suffix(".olean")):
            if p.exists():
                p.chmod(p.stat().st_mode & ~(stat.S_IWUSR | stat.S_IWGRP | stat.S_IWOTH))
    manifest_f.write_text(json.dumps(manifest, indent=2) + "\n")
    rules = [f"{k}(pv_work/{t}/**)" if (work / t).is_dir() else f"{k}(pv_work/{t})"
             for t in manifest["top"] for k in ("Edit", "Write")]
    settings = proj / ".claude" / "settings.json"
    if a.write_settings and settings.exists():
        d = json.loads(settings.read_text())
        shutil.copy2(str(settings), str(settings) + f".before-import-{datetime.now():%Y%m%d-%H%M%S}")
        deny = d.setdefault("permissions", {}).setdefault("deny", [])
        deny.extend(r for r in rules if r not in deny)
        settings.write_text(json.dumps(d, indent=2) + "\n")
        say(f"added {len(rules)} deny rules to .claude/settings.json (backup kept next to it)")
    else:
        say("protect the copies from edits by adding these deny rules to .claude/settings.json (or rerun with --write-settings):")
        for r in rules:
            say("    " + r)
    if a.verdicts:
        data = json.loads(state_f.read_text())
        byid = {r.get("id"): r for r in data.get("results", []) if isinstance(r, dict)}
        n = 0
        for line in Path(a.verdicts).read_text().splitlines():
            parts = line.rstrip("\n").split("\t")
            if len(parts) < 2 or parts[0].startswith("#"):
                continue
            rid, verdict, note = parts[0], parts[1], parts[2] if len(parts) > 2 else ""
            if rid not in byid:
                say(f"WARNING: no result {rid} in RESULTS.json (run /pv-setup first); skipped")
                continue
            byid[rid].setdefault("history", []).append({"revision": manifest["label"], "verdict": verdict,
                                                        "note": note, "date": now(), "source": "earlier check, imported"})
            n += 1
        state_f.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n")
        say(f"recorded {n} earlier verdicts in history (revision {manifest['label']})")
    brief = proj / "verification" / "REVISION_BRIEF.md"
    tpl = proj / "verification" / "report" / "templates" / "REVISION_BRIEF.md"
    if not brief.exists() and tpl.exists():
        shutil.copy2(str(tpl), str(brief))
    if brief.exists():
        built = manifest.get("built", {})
        with open(str(brief), "a") as fh:
            fh.write(f"\n## Import of {manifest['date']} (autosetup/import_legacy.py)\n\n"
                     f"- From `{manifest['source']}`, label `{manifest['label']}`: {len(manifest['files'])} modules under "
                     f"`pv_work/` ({', '.join('`' + t + '`' for t in manifest['top'])}), read-only.\n"
                     f"- Rebuilt: {sum(1 for v in built.values() if v == 'built')}; with `sorry`: "
                     f"{sum(1 for v in built.values() if v == 'built, uses sorry')}; failed or skipped: "
                     f"{sum(1 for v in built.values() if not v.startswith('built'))} (`pv_work/logs/import_legacy.log`).\n")
        say(f"updated {brief.relative_to(proj)}: fill in sections 1, 2 and 4 before starting the check")
    return 0


if __name__ == "__main__":
    sys.exit(main())
