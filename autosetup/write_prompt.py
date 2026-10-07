#!/usr/bin/env python3
"""write_prompt.py — write the next prompt for a project into <project>/NEXT_PROMPT.txt and print it.

The prompt text is taken verbatim from docs/GUIDE_EN.md, section 8 (the tested prompts); only the file names
are replaced by this paper's.

Usage: python3 autosetup/write_prompt.py <project> start|resume|revise|report
"""
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
GUIDE = HERE.parent / "docs" / "GUIDE_EN.md"
SECTION = {"start": "8.1", "resume": "8.2", "revise": "8.3", "report": "8.5"}


def main():
    if len(sys.argv) < 3 or sys.argv[2] not in SECTION:
        sys.exit(__doc__)
    proj, kind = Path(sys.argv[1]), sys.argv[2]
    m = re.search(rf"### {re.escape(SECTION[kind])} .*?\n```\n(.*?)\n```", GUIDE.read_text(), flags=re.S)
    if not m:
        sys.exit(f"section {SECTION[kind]} not found in {GUIDE}")
    text = m.group(1)
    # this paper's main file, PDF and .aux
    main = ""
    state = proj / "verification" / "RESULTS.json"
    if state.exists():
        data = json.loads(state.read_text())
        # Before /pv-setup, RESULTS.json holds the template's placeholder "source/main.tex": trust main_tex only
        # once the project is set up and the file exists.
        cand = (data.get("paper") or {}).get("main_tex", "")
        if data.get("results") and cand and (proj / cand).is_file():
            main = cand
    if not main:
        mains = [p for p in (proj / "source").rglob("*.tex")
                 if re.search(r"\\documentclass", p.read_text(errors="replace")[:20000])]
        main = str(mains[0].relative_to(proj)) if mains else "source/main.tex"
    stem = main[:-4] if main.endswith(".tex") else main
    pdf = stem + ".pdf" if (proj / (stem + ".pdf")).exists() else None
    aux = stem + ".aux" if (proj / (stem + ".aux")).exists() else None
    text = text.replace("source/main.tex", main)
    if pdf and aux:
        text = text.replace("source/main.pdf and source/main.aux", f"{pdf} and {aux}")
    elif pdf:
        text = text.replace("source/main.pdf and source/main.aux", pdf)
    elif aux:
        text = text.replace("the compiled PDF is source/main.pdf and source/main.aux", f"the .aux is {aux}")
    else:
        text = text.replace("; the compiled PDF is source/main.pdf and source/main.aux (use them for theorem numbers)",
                            " (there is no compiled PDF or .aux; infer theorem numbers from the source)")
    out = proj / ("START_PROMPT.txt" if kind == "start" else "NEXT_PROMPT.txt")
    out.write_text(text + "\n")
    print(f"--- {out} ---")
    print(text)


if __name__ == "__main__":
    main()
