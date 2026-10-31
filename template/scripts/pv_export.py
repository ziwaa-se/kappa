#!/usr/bin/env python3
"""pv_export.py — the finished Lean files of this check as a standalone Lean project (kit v1.5).

Usage (from the project root):
  python3 scripts/pv_export.py [--out DIR] [--force] [--pins DIR]
      --out DIR   where to write the project (default: export/lean)
      --force     replace DIR if it exists
      --pins DIR  take lean-toolchain and lake-manifest.json from DIR instead of the project root

The exported folder is a Lake project that anyone can build from scratch with the pinned Lean and Mathlib, without
the kit and without a language model:

  lake exe cache get          downloads Mathlib's prebuilt files (once, a few GB)
  lake build                  compiles every exported theorem
  lake env lean Axioms.lean   prints the axioms each main theorem uses (only propext, Classical.choice, Quot.sound)

It contains the Lean file of the main theorem of every result with a verdict other than UNFINISHED, the Lean files
named as evidence in BLOCKERS.md (counterexamples), everything they import from pv_work/, unchanged, and a README
with the verdict and Lean theorem of each result. SHA256SUMS lists the checksum of every copied file. Conditions
stay what they are in the check: named hypotheses of the theorems.
"""
import argparse
import hashlib
import json
import re
import shutil
import sys
from datetime import datetime
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import pv_status as S  # noqa: E402
from pv_graph import kit_version  # noqa: E402

WORK = S.ROOT / "pv_work"
RESERVED = {"Mathlib", "Aesop", "Batteries", "Qq", "Plausible", "ProofWidgets", "LeanSearchClient", "ImportGraph",
            "Cli", "Lean", "Lake", "Std", "Init", "Axioms"}


def imports(f):
    """Module names imported by a Lean file (the header's `import` lines)."""
    out = []
    for line in f.read_text(errors="replace").splitlines():
        s = line.split("--")[0].strip()
        if s.startswith("import "):
            out.extend(s[len("import "):].split())
        elif s and not s.startswith(("/-", "-/", "prelude")) and out:
            break
    return out


def closure(files):
    """The given pv_work files and every pv_work module they import, in dependency order."""
    order, seen = [], set()

    def visit(name, stack=()):
        if name in seen or name in stack:
            return
        f = WORK / f"{name}.lean"
        if not f.is_file():
            return
        for m in imports(f):
            visit(m, stack + (name,))
        seen.add(name)
        order.append(name)

    for f in files:
        visit(f)
    return order


def has_sorry(f):
    text = re.sub(r"/-.*?-/", "", f.read_text(errors="replace"), flags=re.S)
    return any(re.search(r"(^|[^A-Za-z0-9_.'])sorry([^A-Za-z0-9_']|$)", l.split("--")[0]) for l in text.splitlines())


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def main_module(r):
    lm = (r.get("lean_main") or "").split()
    if not lm:
        return None, None
    path = lm[0].split(":")[0]
    if not path.startswith("pv_work/") or "/" in path[len("pv_work/"):] or not (S.ROOT / path).is_file():
        return None, None
    return Path(path).stem, lm[-1] if len(lm) > 1 else None


def readme(data, rows, conds, mods, warn, rev, toolchain):
    paper = data.get("paper", {}) or {}
    title = paper.get("title") or "untitled paper"
    L = [f"# Lean proofs: {title}", "",
         f"Exported by KAPPA {kit_version()} on {datetime.now():%Y-%m-%d %H:%M} from the project's `pv_work/`. The "
         f"{len(mods)} Lean files in `lean/` are copied unchanged; `SHA256SUMS` lists their checksums.", "",
         "## Build", "",
         f"Lean `{toolchain}`, Mathlib `{rev}` (pinned in `lean-toolchain` and `lake-manifest.json`). With "
         "[elan](https://github.com/leanprover/elan) installed:", "", "```bash", "lake exe cache get",
         "lake build", "lake env lean Axioms.lean", "```", "",
         "The first command downloads Mathlib's prebuilt files (a few GB, once). `lake build` compiles every file; "
         "`Axioms.lean` prints the axioms that each main theorem uses, which should be only `propext`, "
         "`Classical.choice` and `Quot.sound`.", "", "## Results", "",
         "| No. | Result | Verdict | Lean theorem | File |", "|---|---|---|---|---|"]
    for r, mod, name in rows:
        what = f"{r.get('kind') or 'Result'} ({r['id']})" + (f": {r['title']}" if r.get("title") else "")
        L.append(f"| {S.cell(r.get('pdf_number'))} | {S.cell(what)} | {S.EN.get(r.get('verdict'), r.get('verdict'))} "
                 f"| {'`' + S.cell(name) + '`' if name else 'not recorded (see the notes)'} | `lean/{mod}.lean` |")
    L += ["", "*Verified conditionally* means that the theorem takes the conditions below as hypotheses; the proof "
          "from them is checked, the conditions themselves are not. For a result with an *issue*, the file is the "
          "part of the paper's argument that could be checked (with the failing step as an explicit hypothesis) or "
          "a counterexample; see the check's report for what fails."]
    if conds:
        L += ["", "## Conditions", "", "| Condition | Lean | Meaning |", "|---|---|---|"]
        for t in conds:
            lean = re.sub(r"^pv_work/", "lean/", str(t.get("lean") or ""))
            L.append(f"| `{S.cell(t.get('id'))}` | `{S.cell(lean)}` | {S.cell(t.get('meaning'))} |")
    if warn:
        L += ["", "## Notes", ""] + [f"- {w}" for w in warn]
    L += ["", "Whether each Lean statement says what the paper says was reviewed during the check, not proved; read "
          "the statements (`*Stmt.lean`) next to the paper.", ""]
    return "\n".join(L)


def main():
    ap = argparse.ArgumentParser(description="Export the finished Lean files as a standalone Lean project.")
    ap.add_argument("--out", default="export/lean")
    ap.add_argument("--force", action="store_true")
    ap.add_argument("--pins", default="")
    a = ap.parse_args()
    data = S.load()
    out = Path(a.out)
    if not out.is_absolute():
        out = S.ROOT / out
    pins = Path(a.pins).resolve() if a.pins else S.ROOT
    for f in ("lean-toolchain", "lake-manifest.json"):
        if not (pins / f).is_file():
            sys.exit(f"missing {pins / f}: run this in the project root, or give --pins <dir with {f}>")
    if out.exists():
        if not a.force:
            sys.exit(f"{out} exists; use --force to replace it")
        if not (out / "SHA256SUMS").exists() and any(out.iterdir()):
            sys.exit(f"{out} is not an earlier export (no SHA256SUMS); remove it yourself")
        shutil.rmtree(str(out))

    res = [r for r in data.get("results", []) if isinstance(r, dict) and r.get("id")]
    rows, roots, warn = [], [], []
    for r in res:
        if r.get("verdict", "UNFINISHED") == "UNFINISHED":
            continue
        mod, name = main_module(r)
        if not mod:
            warn.append(f"{r['id']}: no Lean file of its main theorem in pv_work/ (lean_main: "
                        f"{r.get('lean_main') or 'empty'}); not exported.")
            continue
        err, _ = S.lean_main_check(r["lean_main"])
        if err:
            warn.append(f"{r['id']}: {err}; the file is exported, the theorem is left out of Axioms.lean.")
            name = None
        rows.append((r, mod, name))
        roots.append(mod)
    blockers = S.BLOCKERS.read_text(errors="replace") if S.BLOCKERS.exists() else ""
    for m in re.findall(r"pv_work/([A-Za-z][A-Za-z0-9_]*)\.lean", blockers):
        if (WORK / f"{m}.lean").is_file() and m not in roots:
            roots.append(m)
    mods = closure(roots)
    clash = [m for m in mods if m.split(".")[0] in RESERVED]
    if clash:
        sys.exit(f"these module names clash with Lean or Mathlib modules: {', '.join(clash)}")
    if not mods:
        sys.exit("nothing to export: no result has a verdict with a Lean file yet")
    for m in mods:
        if has_sorry(WORK / f"{m}.lean"):
            warn.append(f"`lean/{m}.lean` contains `sorry`: it compiles with a warning, and theorems that use it "
                        "are not proved.")

    manifest = json.loads((pins / "lake-manifest.json").read_text())
    rev = next((p.get("rev", "") for p in manifest.get("packages", []) if p.get("name") == "mathlib"), "")
    toolchain = (pins / "lean-toolchain").read_text().strip()
    (out / "lean").mkdir(parents=True)
    for f in ("lean-toolchain", "lake-manifest.json"):
        shutil.copy2(str(pins / f), str(out / f))
    (out / "lakefile.toml").write_text(
        f'name = "{manifest.get("name") or "proofcheck"}"\nversion = "0.1.0"\ndefaultTargets = ["Paper"]\n\n'
        f'[[require]]\nname = "mathlib"\ngit = "https://github.com/leanprover-community/mathlib4.git"\n'
        f'rev = "{rev}"\n\n[[lean_lib]]\nname = "Paper"\nsrcDir = "lean"\n'
        f'roots = [{", ".join(json.dumps(m) for m in mods)}]\n')
    sums = []
    for m in mods:
        shutil.copy2(str(WORK / f"{m}.lean"), str(out / "lean" / f"{m}.lean"))
        sums.append(f"{sha(out / 'lean' / f'{m}.lean')}  lean/{m}.lean")
    named = [(r, mod, name) for r, mod, name in rows if name]
    (out / "Axioms.lean").write_text(
        "".join(f"import {m}\n" for m in dict.fromkeys(mod for _, mod, _ in named)) + "\n" +
        "".join(f"-- {r.get('kind', '')} {r.get('pdf_number', '')} ({r['id']}): {S.EN.get(r.get('verdict'))}\n"
                f"#print axioms {name}\n" for r, mod, name in named))
    (out / "SHA256SUMS").write_text("\n".join(sums) + "\n")
    tools = {t.get("id"): t for t in data.get("external_tools", []) if isinstance(t, dict)}
    used = [c for r, _, _ in rows for c in S.as_list(r.get("conditions"))]
    conds = [tools[c] for c in dict.fromkeys(used) if c in tools]
    (out / "README.md").write_text(readme(data, rows, conds, mods, warn, rev, toolchain))
    (out / ".gitignore").write_text(".lake/\n")
    try:
        shown = out.relative_to(S.ROOT)
    except ValueError:
        shown = out
    print(f"EXPORT {shown}: {len(rows)} results, {len(mods)} Lean files; build with "
          f"'lake exe cache get && lake build' inside it")
    for w in warn:
        print("NOTE " + w)


if __name__ == "__main__":
    main()
