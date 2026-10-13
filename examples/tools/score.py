#!/usr/bin/env python3
"""score.py — compare a finished run with an answer key written before the run.

The key is a JSON object keyed by the paper's result numbers (as in RESULTS.json `pdf_number`):

  {"2.5": {"expect": ["ISSUE:ERROR"], "accept": [], "other_class": ["ISSUE:PAPER_ARGUMENT_GAP"]}, ...}

Outcome tokens: UNCONDITIONAL; CONDITIONAL, or CONDITIONAL:<p> to require a condition of provenance <p> (i, ii, iii,
iv, v, p); ISSUE:<CODE>; UNFINISHED, or UNFINISHED:<REASON>. A (p) clause whose predecessor ended as ISSUE also counts
as (iv), as the rules treat it (PIPELINE, stage 6b, case 5). A result scores
  agrees        when its outcome matches an `expect` token,
  accepted      when it matches an `accept` token (an outcome the key allows),
  other class   when it matches an `other_class` token (the problem found, classified differently),
  differs       otherwise.
Results of the run that the key does not list are reported as "not in key".

Usage: python3 examples/tools/score.py <run folder> <key.json> [--markdown]
"""
import json
import re
import sys
from pathlib import Path

CODES = ("ERROR", "PAPER_ARGUMENT_GAP", "PAPER_ASSUMPTION_GAP", "EXPOSITION_GAP", "DOMAIN_CLARIFICATION")


def outcome(r, tools, blockers, verdicts):
    """The tokens that describe a recorded result."""
    v = r.get("verdict")
    toks = {v}
    if v == "CONDITIONAL":
        for c in r.get("conditions") or []:
            t = tools.get(c) or {}
            prov = t.get("provenance")
            if prov:
                toks.add(f"CONDITIONAL:{prov}")
            if prov == "p" and verdicts.get(t.get("predecessor")) == "ISSUE":
                toks.add("CONDITIONAL:iv")
    if v == "ISSUE":
        for b in r.get("issues") or []:
            m = re.search(rf"^##\s+{re.escape(b)}\b.*$", blockers, flags=re.M)
            for code in (re.findall(r"\b(" + "|".join(CODES) + r")\b", m.group(0)) if m else []):
                toks.add(f"ISSUE:{code}")
    if v == "UNFINISHED" and r.get("reason"):
        toks.add(f"UNFINISHED:{r['reason']}")
    return toks


def main():
    a = sys.argv[1:]
    if len(a) < 2:
        print(__doc__)
        return 2
    run, key = Path(a[0]), json.loads(Path(a[1]).read_text())
    state = json.loads((run / "verification/RESULTS.json").read_text())
    tools = {t.get("id"): t for t in state.get("external_tools", []) if isinstance(t, dict)}
    bl = (run / "verification/BLOCKERS.md")
    blockers = re.sub(r"<!--.*?-->", "", bl.read_text(), flags=re.S) if bl.exists() else ""
    rows, counts = [], {}
    seen = set()
    verdicts = {r.get("id"): r.get("verdict") for r in state.get("results", [])}
    for r in state.get("results", []):
        no = str(r.get("pdf_number"))
        seen.add(no)
        toks = outcome(r, tools, blockers, verdicts)
        k = key.get(no)
        if k is None:
            status = "not in key"
        elif toks & set(k.get("expect", [])):
            status = "agrees"
        elif toks & set(k.get("accept", [])):
            status = "accepted"
        elif toks & set(k.get("other_class", [])):
            status = "other class"
        else:
            status = "differs"
        counts[status] = counts.get(status, 0) + 1
        shown = sorted(t for t in toks if ":" in t) or sorted(toks)
        rows.append((no, r.get("id"), " / ".join((k or {}).get("expect", ["—"])), ", ".join(shown), status))
    for no in key:
        if no not in seen and not no.startswith("_"):
            rows.append((no, "—", " / ".join(key[no].get("expect", [])), "not registered", "missing"))
            counts["missing"] = counts.get("missing", 0) + 1
    print("| No. | ID | Expected | Run | Score |\n|---|---|---|---|---|")
    for row in rows:
        print("| " + " | ".join(str(c) for c in row) + " |")
    print("\n" + ", ".join(f"{v} {k}" for k, v in sorted(counts.items())))
    return 0 if all(s in ("agrees", "accepted", "not in key") for *_, s in rows) else 1


if __name__ == "__main__":
    sys.exit(main())
