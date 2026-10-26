#!/usr/bin/env python3
"""grade_lean.py <baseline folder> [--lean-env <Lean environment>] — the mechanical part of the baseline grading (BASELINE_PROTOCOL.md, "Evidence").

Chat arm (the folder has message.txt): the ```lean code blocks of the reply in session.json are saved as
lean_blocks/block_<k>.lean (with `import Mathlib` added when a block has no import). Agent arm: every .lean file the
agent wrote (outside .lake/). Each file is compiled at the pinned versions with `lake env lean` in a scratch copy that
appends `#print axioms <name>` for every theorem and lemma it declares. The result is written to lean_check.md and
lean_check.json in the folder: per file, whether it compiles, the number of errors, whether `sorry` occurs, and per
theorem its axioms (standard = only propext, Classical.choice, Quot.sound).
"""
import json
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

STANDARD = {"propext", "Classical.choice", "Quot.sound"}
LEANENV = Path(sys.argv[sys.argv.index("--lean-env") + 1]).expanduser() if "--lean-env" in sys.argv else \
    Path.home() / "Downloads/kit-example-runs/lean-env"
TEMPLATE = LEANENV      # lakefile.toml, lake-manifest.json and lean-toolchain of the pinned environment


def scratch_project():
    d = Path(tempfile.mkdtemp(prefix="grade-lean-"))
    for f in ("lakefile.toml", "lake-manifest.json", "lean-toolchain"):
        shutil.copy(TEMPLATE / f, d / f)
    (d / ".lake").mkdir()
    (d / ".lake/packages").symlink_to(LEANENV / ".lake/packages")
    return d


def decls(text):
    names = []
    ns = []
    for line in text.splitlines():
        m = re.match(r"\s*namespace\s+(\S+)", line)
        if m:
            ns.append(m.group(1))
        m = re.match(r"\s*end\s+(\S+)", line)
        if m and ns and ns[-1] == m.group(1):
            ns.pop()
        m = re.match(r"\s*(?:@\[[^\]]*\]\s*)?(?:private\s+|protected\s+)?(?:theorem|lemma)\s+([^\s:({\[]+)", line)
        if m:
            names.append(".".join(ns + [m.group(1)]))
    return names


def check(project, path, text):
    names = decls(text)
    body = text if re.search(r"^\s*import\s", text, flags=re.M) else "import Mathlib\n\n" + text
    body += "\n" + "".join(f"\n#print axioms {n}" for n in names) + "\n"
    f = project / "Check.lean"
    f.write_text(body)
    p = subprocess.run(["lake", "env", "lean", "Check.lean"], cwd=project, stdout=subprocess.PIPE,
                       stderr=subprocess.STDOUT, universal_newlines=True, timeout=1800)
    out = p.stdout
    errors = len(re.findall(r"^\S+:\d+:\d+: error", out, flags=re.M))
    axioms = {}
    for m in re.finditer(r"'([^']+)' depends on axioms: \[([^\]]*)\]", out):
        axioms[m.group(1)] = sorted(a.strip() for a in m.group(2).split(",") if a.strip())
    for m in re.finditer(r"'([^']+)' does not depend on any axioms", out):
        axioms[m.group(1)] = []
    return {"file": str(path), "compiles": p.returncode == 0 and errors == 0, "errors": errors,
            "sorry": bool(re.search(r"\bsorry\b", text)) or "declaration uses 'sorry'" in out,
            "theorems": {n: axioms.get(n) for n in names}, "first_error": next(
                (l for l in out.splitlines() if ": error" in l), "")[:300]}


def main():
    folder = Path(sys.argv[1]).expanduser()
    files = []
    if (folder / "lean_blocks").is_dir() and not (folder / "message.txt").exists():
        files = sorted((folder / "lean_blocks").glob("*.lean"))      # replication package: blocks already saved
    elif (folder / "message.txt").exists():
        reply = json.loads((folder / "session.json").read_text()).get("result") or ""
        blocks = re.findall(r"```(?:lean4?|Lean)\s*\n(.*?)```", reply, flags=re.S)
        bd = folder / "lean_blocks"
        bd.mkdir(exist_ok=True)
        for k, b in enumerate(blocks, 1):
            p = bd / f"block_{k:02d}.lean"
            p.write_text(b)
            files.append(p)
    else:
        files = sorted(p for p in folder.rglob("*.lean") if ".lake" not in p.parts and "lean_blocks" not in p.parts)
    project = scratch_project()
    rows = []
    try:
        for p in files:
            rows.append(check(project, p.relative_to(folder), p.read_text(errors="replace")))
            r = rows[-1]
            print(f"{r['file']}: {'compiles' if r['compiles'] else 'FAILS'} errors={r['errors']} sorry={r['sorry']} "
                  f"theorems={len(r['theorems'])}", flush=True)
    finally:
        shutil.rmtree(project, ignore_errors=True)
    (folder / "lean_check.json").write_text(json.dumps(rows, indent=1) + "\n")
    lines = ["| File | Compiles | Errors | sorry | Theorems: axioms |", "|---|---|---|---|---|"]
    for r in rows:
        th = "; ".join(f"`{n}`: " + ("not printed" if a is None else ("standard" if set(a) <= STANDARD else
                                                                       ", ".join(a))) for n, a in r["theorems"].items())
        lines.append(f"| {r['file']} | {'yes' if r['compiles'] else 'no'} | {r['errors']} | {'yes' if r['sorry'] else 'no'} | {th} |")
    ok = sum(1 for r in rows if r["compiles"] and not r["sorry"])
    lines.append(f"\n{len(rows)} files; {ok} compile without sorry.")
    (folder / "lean_check.md").write_text("\n".join(lines) + "\n")
    print(lines[-1])


if __name__ == "__main__":
    main()
