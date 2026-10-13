#!/usr/bin/env python3
"""pv_settings.py — the project's suggested permission file (kit v1.3.1).

Claude Code matches a Bash permission rule against the command exactly as written, so `Bash(scripts/pv_lean.sh *)`
does not allow `/abs/project/scripts/pv_lean.sh …`, `./scripts/pv_lean.sh …` or `bash scripts/pv_lean.sh …`.
Agents write all of these. This script adds those spellings of every kit-script rule, for this project's own path,
to .claude/settings.example.json. install.sh runs it; run it again after moving the project folder.

Usage (from the project root):
  python3 scripts/pv_settings.py expand              rewrite .claude/settings.example.json for this folder
  python3 scripts/pv_settings.py check               what .claude/settings.json lacks compared with the example
                                                      (allow and deny rules, hooks); exit 1 if anything is missing
  options: --root DIR (project folder), --base FILE (rules to expand), --out FILE (write here instead)
Nothing here ever changes .claude/settings.json: copying the suggestions there is the user's decision
(docs/MANUAL.md, section 2, step 4).
"""
import argparse
import json
import os
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
KIT_RULE = re.compile(r"^Bash\((python3 )?scripts/([A-Za-z0-9_.-]+) \*\)$")


def is_variant(rule):
    """A spelling added by `expand` (it is recomputed, never kept from an older expansion)."""
    m = re.fullmatch(r"Bash\((.*)\)", rule)
    if not m:
        return False
    body = m.group(1)
    return bool(re.match(r"(python3 |bash )?(\./|\"?/)[^ ]*scripts/", body) or body.startswith("bash scripts/"))


def roots(root):
    """The project path as given, as resolved (macOS: /var vs /private/var), and as the shell spells it ($PWD)."""
    out = [str(root)]
    real = os.path.realpath(str(root))
    pwd = os.environ.get("PWD", "")
    for r in (pwd if pwd and os.path.realpath(pwd) == real else "", real):
        if r and r not in out:
            out.append(r)
    return sorted(out, key=lambda r: (len(r), r))   # the same file whichever spelling was given


def variants(rule, root):
    m = KIT_RULE.match(rule)
    if not m:
        return []
    py, script = m.group(1) or "", m.group(2)
    out = [f"Bash({py}./scripts/{script} *)"]
    if not py:
        out.append(f"Bash(bash scripts/{script} *)")
    for r in roots(root):
        p = f"{r}/scripts/{script}"
        forms = [p, f'"{p}"'] if " " in p else [p]
        for f in forms:
            out.append(f"Bash({py}{f} *)")
            if not py:
                out.append(f"Bash(bash {f} *)")
    return out


def library_dir(root):
    """The resolved folder of the Lean packages when it lies outside the project (a linked install), else None."""
    pk = Path(root) / ".lake" / "packages"
    if not pk.exists():
        return None
    real = Path(os.path.realpath(str(pk)))
    proj = Path(os.path.realpath(str(root)))
    return None if real == proj or proj in real.parents else real


def expand(base, root):
    d = json.loads(Path(base).read_text())
    perms = d.setdefault("permissions", {})
    allow = [r for r in perms.get("allow", []) if not is_variant(r)]
    extra = []
    for r in allow:
        for v in variants(r, root):
            if v not in allow and v not in extra:
                extra.append(v)
    perms["allow"] = allow + extra
    # v1.3.1: agents search the Mathlib sources for "is X in Mathlib?" evidence. With linked packages they lie
    # outside the project, so reading them needs an additional directory; editing them stays forbidden.
    perms["deny"] = [r for r in perms.get("deny", []) if not re.match(r"(Edit|Write)\(//", r)]
    perms.pop("additionalDirectories", None)
    lib = library_dir(root)
    if lib:
        perms["additionalDirectories"] = [str(lib)]
        perms["deny"] += [f"Edit(/{lib}/**)", f"Write(/{lib}/**)"]
    return d


def check(settings, example):
    try:
        cur = json.loads(Path(settings).read_text())
    except FileNotFoundError:
        print(f"no {settings}: copy {example} there after reading docs/MANUAL.md, section 2, step 4")
        return 1
    new = json.loads(Path(example).read_text())
    missing = 0
    if new.get("permissions", {}).get("additionalDirectories") and \
            cur.get("permissions", {}).get("additionalDirectories") != new["permissions"]["additionalDirectories"]:
        print(f"suggested additionalDirectories (read access to the linked Lean packages) missing from {settings}:")
        print("    " + ", ".join(new["permissions"]["additionalDirectories"]))
        missing += 1
    for key in ("allow", "deny"):
        have = set(cur.get("permissions", {}).get(key, []))
        miss = [r for r in new.get("permissions", {}).get(key, []) if r not in have]
        if miss:
            print(f"suggested {key} rules missing from {settings}:")
            for r in miss:
                print("    " + r)
            missing += len(miss)
    if new.get("hooks") and cur.get("hooks") != new.get("hooks"):
        print(f"the hooks in {settings} differ from the suggested ones (they enforce role ownership of files; "
              f"docs/MANUAL.md, section 2, step 4)")
        missing += 1
    print("settings.json has every suggested rule" if not missing else
          "Add them yourself if you agree, or copy settings.example.json over settings.json.")
    return 1 if missing else 0


def main():
    ap = argparse.ArgumentParser(description="the project's suggested permission file")
    ap.add_argument("cmd", choices=["expand", "check"])
    ap.add_argument("--root", default=str(ROOT))
    ap.add_argument("--base", default=None)
    ap.add_argument("--out", default=None)
    a = ap.parse_args()
    root = Path(a.root).absolute()
    example = root / ".claude" / "settings.example.json"
    if a.cmd == "expand":
        d = expand(a.base or example, root)
        out = Path(a.out) if a.out else example
        out.write_text(json.dumps(d, indent=2) + "\n")
        print(f"wrote {out} ({len(d['permissions']['allow'])} allow rules, for {root})")
        return 0
    return check(root / ".claude" / "settings.json", example)


if __name__ == "__main__":
    sys.exit(main())
