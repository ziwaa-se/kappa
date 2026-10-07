#!/usr/bin/env python3
"""check_paper.py — is everything the kit needs in <project>/source/? Reads only.

Usage: python3 autosetup/check_paper.py <project>

Checks: one main .tex file (with \\documentclass); every \\input / \\include / \\subfile it uses (recursively);
bibliography files (.bib, or a .bbl); the compiled PDF and .aux (the .aux gives exact theorem numbers);
local style files. Exit code 0 when nothing essential is missing.
"""
import re
import sys
from pathlib import Path

INC = re.compile(r"\\(?:input|include|subfile)\s*\{([^}]+)\}")
BIB = re.compile(r"\\(?:bibliography|addbibresource)\s*(?:\[[^\]]*\])?\s*\{([^}]+)\}")
PKG = re.compile(r"\\(?:usepackage|RequirePackage)\s*(?:\[[^\]]*\])?\s*\{([^}]+)\}")
CLS = re.compile(r"\\documentclass\s*(?:\[[^\]]*\])?\s*\{([^}]+)\}")


def strip_comments(t):
    return re.sub(r"(?<!\\)%.*", "", t)


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    src = Path(sys.argv[1]) / "source"
    if not src.is_dir():
        sys.exit(f"no folder {src}")
    files = [p for p in src.rglob("*") if p.is_file() and p.name not in (".DS_Store", "README.md")]
    texs = [p for p in files if p.suffix == ".tex"]
    mains = [p for p in texs if CLS.search(strip_comments(p.read_text(errors="replace")))]
    ok, notes = True, []
    print(f"== {src}: {len(files)} files")
    if not files:
        print("EMPTY: no paper files yet. Copy the paper's folder contents into source/ (keep sub-folders).")
        sys.exit(1)
    if not mains:
        print("MISSING: no main .tex file (one with \\documentclass)")
        sys.exit(1)
    if len(mains) > 1:
        print("SEVERAL main files: " + ", ".join(str(m.relative_to(src)) for m in mains) +
              " (tell Claude which one is the paper; drafts and old versions are better left out of source/)")
    main_tex = mains[0]
    text = strip_comments(main_tex.read_text(errors="replace"))
    t = re.search(r"\\title\s*(?:\[[^\]]*\])?\s*\{((?:[^{}]|\{[^{}]*\})*)\}", text)
    title = re.sub(r"\s+", " ", t.group(1)).strip() if t else "(no \\title found)"
    print(f"main file: source/{main_tex.relative_to(src)}")
    print("title:     " + title)
    # inputs, recursively, relative to the main file's folder (LaTeX's default)
    root, seen, missing, queue = main_tex.parent, set(), [], [main_tex]
    bibs, pkgs = set(), set()
    while queue:
        f = queue.pop()
        if f in seen:
            continue
        seen.add(f)
        body = strip_comments(f.read_text(errors="replace"))
        for m in INC.finditer(body):
            name = m.group(1).strip()
            cand = [root / name, root / (name + ".tex")]
            hit = next((c for c in cand if c.is_file()), None)
            if hit:
                queue.append(hit)
            else:
                missing.append(f"{name} (used in {f.relative_to(src)})")
        for m in BIB.finditer(body):
            bibs |= {b.strip() for b in m.group(1).split(",") if b.strip()}
        for m in PKG.finditer(body):
            pkgs |= {p.strip() for p in m.group(1).split(",") if p.strip()}
    print(f"inputs:    {len(seen) - 1} file(s) found" + (f"; MISSING: {', '.join(missing)}" if missing else ""))
    if missing:
        ok = False
    for b in sorted(bibs):
        have = (root / (b if b.endswith(".bib") else b + ".bib")).is_file()
        bbl = (root / (main_tex.stem + ".bbl")).is_file()
        if have:
            print(f"bib:       {b} found")
        elif bbl:
            print(f"bib:       {b} not found, but {main_tex.stem}.bbl is there (enough)")
        else:
            print(f"bib:       {b} MISSING (and no {main_tex.stem}.bbl) — cited works will be unknown to the check")
            notes.append("bibliography missing")
    local_sty = sorted(p.name for p in files if p.suffix in (".sty", ".cls"))
    if local_sty:
        print(f"styles:    {', '.join(local_sty)}")
    custom = sorted(p for p in pkgs if not re.match(r"^(ams|graphicx|hyperref|geometry|xcolor|color|enumitem|mathtools|"
                                                     r"bm|bbm|mathrsfs|tikz|natbib|biblatex|cleveref|thmtools|booktabs|"
                                                     r"inputenc|fontenc|lmodern|microtype|url|float|caption|subcaption|"
                                                     r"algorithm|algpseudocode|listings|fullpage|setspace|dsfont|"
                                                     r"stmaryrd|physics|siunitx|xspace|etoolbox|ifthen|calc|array|"
                                                     r"multirow|longtable|appendix|authblk|titlesec|fancyhdr)", p))
    unknown = [p for p in custom if not (root / (p + ".sty")).is_file()]
    if unknown:
        print(f"packages:  not standard-looking and no local .sty: {', '.join(unknown)} (fine if they are installed packages)")
    pdf = sorted(p.name for p in files if p.suffix == ".pdf" and p.stem == main_tex.stem) or \
        sorted(p.name for p in files if p.suffix == ".pdf")
    aux = root / (main_tex.stem + ".aux")
    print(f"PDF:       {', '.join(pdf) if pdf else 'MISSING (recommended: the compiled PDF of this exact version)'}")
    if aux.is_file():
        n = len(re.findall(r"\\newlabel\{", aux.read_text(errors="replace")))
        print(f".aux:      {aux.name} ({n} labels: exact theorem numbers)")
    else:
        print(f".aux:      MISSING (recommended: {main_tex.stem}.aux from compiling this version; without it, "
              f"theorem numbers are inferred)")
        notes.append("no .aux")
    if not pdf:
        notes.append("no PDF")
    print("RESULT:    " + ("READY" if ok else "NOT READY (fix the MISSING items)") +
          (f"; recommended: {', '.join(notes)}" if notes else ""))
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
