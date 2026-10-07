#!/usr/bin/env python3
"""pv_snapshot.py — save and restore checkpoints of the verification state (no git needed).

Usage (from the project root):
  python3 scripts/pv_snapshot.py save [--label NAME]   copy verification/ and pv_work/ text files into
                                                        verification/snapshots/<timestamp>[-NAME]/
  python3 scripts/pv_snapshot.py list                  list snapshots
  python3 scripts/pv_snapshot.py restore NAME [--dest DIR] [--force]
                                                        restore a snapshot (default: into restored_NAME/;
                                                        never overwrites a differing file without --force)
  python3 scripts/pv_snapshot.py hash FILE...          print sha256 of files (for audit records)
  python3 scripts/pv_snapshot.py baseline [--new-version]
                                                        (v1.3) copy source/ to verification/source_baseline/ at
                                                        /pv-setup; never overwrites. With --new-version (/pv-revise,
                                                        after every change is registered): the old baseline is kept as
                                                        verification/source_baseline_v<k>/ and a new one is made

Snapshots store .lean/.md/.json/.log/.txt/.py files with a sha256 manifest. Compiled .olean files are
not stored; rebuild them with scripts/pv_lean.sh build in dependency order.
"""
import hashlib
import json
import shutil
import sys
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SNAPS = ROOT / "verification" / "snapshots"
INCLUDE_DIRS = ["verification", "pv_work"]
SUFFIXES = {".lean", ".md", ".json", ".log", ".txt", ".py", ".sh", ".tex", ".bib", ".sty", ".cls", ".bbl", ".aux"}


def sha(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def files():
    for d in INCLUDE_DIRS:
        base = ROOT / d
        if not base.exists():
            continue
        for p in base.rglob("*"):
            if p.is_file() and p.suffix in SUFFIXES and SNAPS not in p.parents:
                yield p


def save(label):
    name = datetime.now().strftime("%Y%m%d-%H%M%S") + (f"-{label}" if label else "")
    dest = SNAPS / name
    k = 2
    while dest.exists():
        dest = SNAPS / f"{name}-{k}"
        k += 1
    manifest = {}
    for p in files():
        rel = p.relative_to(ROOT)
        out = dest / rel
        out.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(p, out)
        manifest[str(rel)] = sha(p)
    (dest / "manifest.json").write_text(json.dumps(manifest, indent=1, sort_keys=True))
    print(f"saved {len(manifest)} files to {dest.relative_to(ROOT)}")


def list_snaps():
    if not SNAPS.exists():
        print("no snapshots")
        return
    for d in sorted(SNAPS.iterdir()):
        if not d.is_dir():
            continue
        m = d / "manifest.json"
        n = len(json.loads(m.read_text())) if m.exists() else 0
        print(f"{d.name}\t{n} files")


def restore(name, dest, force):
    src = SNAPS / name
    if not (src / "manifest.json").exists():
        sys.exit(f"no snapshot named {name!r}; run: python3 scripts/pv_snapshot.py list")
    manifest = json.loads((src / "manifest.json").read_text())
    dest = Path(dest) if dest else ROOT / f"restored_{name}"
    bad, done, skipped = [], 0, 0
    for rel, digest in manifest.items():
        s = src / rel
        if sha(s) != digest:
            bad.append(rel)
            continue
        t = dest / rel
        if t.exists() and sha(t) != digest and not force:
            skipped += 1
            print(f"SKIP (differs; use --force): {t}")
            continue
        t.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(s, t)
        done += 1
    print(f"restored {done} files to {dest}; skipped {skipped}; hash mismatches in snapshot: {len(bad)}")
    for b in bad:
        print("CORRUPT", b)


def baseline(new_version):
    """The unchanged copy of the manuscript that /pv-revise compares against. It is created, or archived and
    re-created, but never modified or overwritten (POLICY.md §4)."""
    src, base = ROOT / "source", ROOT / "verification" / "source_baseline"
    if not src.is_dir():
        sys.exit("no source/ directory")
    if base.exists():
        if not new_version:
            sys.exit("verification/source_baseline/ already exists and is never overwritten. After a revision is "
                     "fully registered (/pv-revise step 7), use: baseline --new-version")
        k = 1   # the archived baselines are numbered in order: v1 is the original manuscript
        while (ROOT / "verification" / f"source_baseline_v{k}").exists():
            k += 1
        base.rename(ROOT / "verification" / f"source_baseline_v{k}")
        print(f"kept the old baseline as verification/source_baseline_v{k}/")
    elif new_version:
        print("no earlier baseline to keep; creating the first one")
    shutil.copytree(src, base, ignore=shutil.ignore_patterns(".DS_Store"))
    n = sum(1 for p in base.rglob("*") if p.is_file())
    print(f"created verification/source_baseline/ from source/ ({n} files)")


def main():
    a = sys.argv[1:]
    if not a:
        print(__doc__)
        sys.exit(2)
    cmd = a[0]

    def opt(flag):
        if flag not in a:
            return None
        i = a.index(flag)
        if i + 1 >= len(a):
            sys.exit(f"{flag} needs a value")
        return a[i + 1]

    if cmd == "save":
        save(opt("--label") or "")
    elif cmd == "list":
        list_snaps()
    elif cmd == "restore":
        if len(a) < 2:
            sys.exit("restore needs a snapshot name; run: python3 scripts/pv_snapshot.py list")
        restore(a[1], opt("--dest"), "--force" in a)
    elif cmd == "baseline":
        baseline("--new-version" in a)
    elif cmd == "hash":
        for f in a[1:]:
            if not Path(f).is_file():
                print(f"MISSING  {f}")
                continue
            print(f"{sha(f)}  {f}")
    else:
        print(__doc__)
        sys.exit(2)


if __name__ == "__main__":
    main()
