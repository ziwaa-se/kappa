#!/usr/bin/env python3
"""pv_summary.py — a one-page summary of the check, for readers who did not run it (kit v1.5).

Usage (from the project root):
  python3 scripts/pv_summary.py [--out FILE]    write verification/report/CHECK_SUMMARY.md (default)
  python3 scripts/pv_summary.py --stdout        print it instead

The summary says what was checked, the verdict of every numbered result, the issues, the conditions the
conditional verdicts assume, what was not checked, and where the evidence is. It is meant to be passed on: to
co-authors, or to an editor or referee if the authors choose to. AUTHOR_REPORT.md remains the full account.

It is assembled from the records only (RESULTS.json, BLOCKERS.md, KIT_VERSION), with fixed wording and no language
model, so it needs no fact check and says nothing the records do not say. Run it again whenever the records change;
/pv-report and the unattended driver run it at the end.
"""
import argparse
import sys
from datetime import datetime
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import pv_status as S  # noqa: E402
from pv_graph import COUNTED, PROVENANCE, kit_version  # noqa: E402

OUT = S.ROOT / "verification" / "report" / "CHECK_SUMMARY.md"
CLASSES = {
    "ERROR": "the printed statement is false: a counterexample satisfies all its hypotheses",
    "PAPER_ARGUMENT_GAP": "the justification given for a step does not hold; the conclusion may still be true",
    "PAPER_ASSUMPTION_GAP": "a step needs a hypothesis that the paper does not state",
    "EXPOSITION_GAP": "the conclusion is true, but the paper does not cover some range or case",
    "DOMAIN_CLARIFICATION": "the domain or object is ambiguous, and the conclusion depends on the reading",
    "ENCODING_ERROR": "formalization side: our Lean statement did not match the paper (not a problem of the paper)",
    "TRANSLATION_BLOCKED": "formalization side: the step could not be written in Lean (not a problem of the paper)",
}
PLURAL = {"Theorem": "theorems", "Lemma": "lemmas", "Proposition": "propositions", "Corollary": "corollaries"}
LOOK = [("verification/report/VERIFICATION_GRAPH.html", "the verification graph: every result, its verdict and "
         "dependencies, in a browser"),
        ("verification/report/AUTHOR_REPORT.md", "the full report: each verdict, the issues with their locations "
         "and the suggested fixes from the audits, and the human-check list"),
        ("verification/report/FILES_TO_CHECK.md", "for each result: place in the paper, Lean theorem, audit report"),
        ("verification/report/EXTERNAL_TOOLS_WORKSHEET.md", "every condition with its exact Lean text, by risk"),
        ("verification/BLOCKERS.md", "the complete issue records, with the evidence"),
        ("pv_work/", "the Lean files")]


def kinds(res):
    seen = {}
    for r in res:
        k = r.get("kind") or "result"
        seen[k] = seen.get(k, 0) + 1
    return ", ".join(f"{n} {k.lower() if n == 1 else PLURAL.get(k, k.lower() + 's')}" for k, n in seen.items())


def summary(data):
    res = [r for r in data.get("results", []) if isinstance(r, dict) and r.get("id")]
    paper = data.get("paper", {}) or {}
    lean = data.get("lean", {}) or {}
    tools = {t.get("id"): t for t in data.get("external_tools", []) if isinstance(t, dict)}
    issues = S.blocker_details()
    by_id = {b["id"]: b for b in issues}
    counts = {v: sum(1 for r in res if r.get("verdict", "UNFINISHED") == v) for v in S.VERDICTS}
    checked = sum(1 for r in res if S.all_checked(data, r))
    title = paper.get("title") or "untitled paper"
    L = [f"# Check summary: {title}", "",
         f"Made by KAPPA {kit_version()} on {datetime.now():%Y-%m-%d %H:%M} from this project's records "
         "(`verification/RESULTS.json`, `verification/BLOCKERS.md`), with fixed wording and without a language "
         "model. It is a short account of the check for readers who did not run it; `AUTHOR_REPORT.md` is the full "
         "one.", "", "## What was checked", ""]
    L.append(f"- **Paper:** {title}" + (f" (`{paper['main_tex']}`)" if paper.get("main_tex") else "") + ".")
    L.append(f"- **Numbered results:** {len(res)}" + (f" ({kinds(res)})" if res else "") + ".")
    ver = " ".join(x for x in [lean.get("toolchain", "").replace("leanprover/lean4:", "Lean "),
                               f"with Mathlib {lean['mathlib_rev'][:8]}" if lean.get("mathlib_rev") else ""] if x)
    if ver:
        L.append(f"- **Proof assistant:** {ver}.")
    L += ["- **How:** the proof of each result was translated into Lean 4 along the paper's own argument. Before "
          "any proving, an independent agent compared each Lean statement with the paper; after it, another agent "
          "audited the finished proof, and a script checked that it compiles with no `sorry` and only Lean's three "
          "standard axioms. Cited or unproved inputs became named hypotheses, never hidden axioms.", "",
          "## Verdicts", "",
          "**" + " · ".join(f"{counts[v]} {COUNTED[v]}" for v in S.VERDICTS) + ".**", ""]
    if checked:
        L += [f"For {checked} of the conditional results, a person has checked every condition; they remain "
              "conditional, because the conditions are not proved in Lean.", ""]
    L += ["| No. | Result | Verdict | Conditions, issues, or where it stopped |", "|---|---|---|---|"]
    for r in res:
        v = r.get("verdict", "UNFINISHED")
        name = S.EN.get(v, v) + ("; conditions checked by a person" if S.all_checked(data, r) else "")
        what = f"{r.get('kind') or 'Result'} ({r['id']})" + (f": {r['title']}" if r.get("title") else "")
        L.append(f"| {S.cell(r.get('pdf_number'))} | {S.cell(what)} | {name} | "
                 f"{S.cell(r.get('summary_en') or S.reason_text(r))} |")
    L += ["", "*Verified unconditionally*: the paper's proof of the whole statement compiles in Lean with no unproved "
          "input. *Verified conditionally*: it compiles, but assumes the conditions listed below. *Issue recorded*: "
          "an independently confirmed problem in the result's own statement or proof. *Unfinished*: not decided; "
          "never counted as an error in the paper.", ""]

    L += ["## Issues", ""]
    if issues:
        L += ["| Issue | Result | Class | Status | In one sentence |", "|---|---|---|---|---|"]
        for b in sorted(issues, key=lambda b: not b["open"]):
            L.append(f"| {b['id']} | {S.cell(b['number'] or b['result'])} ({S.cell(b['result'])}) | "
                     f"{', '.join(b['codes']) or '—'} | {'open' if b['open'] else 'resolved'} | "
                     f"{S.cell(b['sentence'])} |")
        used = [c for c in CLASSES if any(c in b["codes"] for b in issues)]
        L += [""] + [f"- `{c}`: {CLASSES[c]}." for c in used]
    else:
        L.append("No issue was recorded.")
    upstream = [r for r in res if r.get("upstream_issues")]
    if upstream:
        L += ["", "Results that use a result with an issue: " + ", ".join(
            f"{r['id']} ({', '.join(S.as_list(r['upstream_issues']))})" for r in upstream) + ". Such a use alone does "
            "not make a result an issue: the clause it uses becomes one of its conditions."]

    L += ["", "## Conditions", ""]
    used_tools = []
    for r in res:
        for c in S.as_list(r.get("conditions")):
            if c not in used_tools:
                used_tools.append(c)
    if used_tools:
        L += ["What the conditional verdicts assume. Each condition is a named hypothesis of the Lean theorem; the "
              "Lean kernel did not check it, so a person should.", "",
              "| Condition | Meaning | Kind | Used by | In the paper | Checked by a person |", "|---|---|---|---|---|---|"]
        for c in used_tools:
            t = tools.get(c, {})
            users = [r["id"] for r in res if c in S.as_list(r.get("conditions"))]
            hc = t.get("human_checked") if isinstance(t.get("human_checked"), dict) else None
            who = f"{hc.get('by', '?')}, {hc.get('date', '')}: {hc.get('how', '')}" if hc else "not yet"
            L.append(f"| `{S.cell(c)}` | {S.cell(t.get('meaning'))} | {S.cell(PROVENANCE.get(t.get('provenance'), ''))} | "
                     f"{', '.join(users)} | {S.cell(t.get('source_loc'))} | {S.cell(who)} |")
    else:
        L.append("No verdict depends on a condition.")
    proved = [t for t in tools.values() if isinstance(t, dict) and t.get("proved_in")]
    if proved:
        L += ["", "Proved in Lean after their results were verified, and connected (v1.5): " + ", ".join(
            f"`{S.cell(t.get('id'))}` (in `{S.cell(t['proved_in'])}`)" for t in proved) +
            ". Where they were connected, they are no longer conditions."]

    L += ["", "## What was not checked", ""]
    unf = [r for r in res if r.get("verdict", "UNFINISHED") == "UNFINISHED"]
    if unf:
        L.append("- **Unfinished results** (not counted as errors): " + "; ".join(
            f"{r.get('pdf_number') or r['id']} ({r['id']}): " + (" ".join(
                x for x in [r.get("stage", ""), r.get("reason", ""), r.get("partial") or ""] if x) or "not started")
            for r in unf) + ".")
    L += ["- **The conditions** above: they are assumed, not proved.",
          "- **Whether each Lean statement says what the paper says, and whether the basic definitions match the "
          "paper.** Independent agents compared them, but a person should read them; `FILES_TO_CHECK.md` lists "
          "where they are.",
          "- **Claims without a number** (remarks, statements in the text): the check covers numbered results only; "
          "`verification/INVENTORY.md` lists the unnumbered claims it found.",
          "- **Anything outside the proofs:** motivation, simulations, data analyses, and whether the results are new "
          "or important.", "", "## Where the evidence is", ""]
    for path, what in LOOK:
        if (S.ROOT / path).exists():
            L.append(f"- `{path}`: {what}.")
    L += ["", "Anyone can rebuild the Lean files and rerun the mechanical audit without a language model, with the "
          "kit's `examples/tools/replay.py`.", ""]
    return "\n".join(L)


def main():
    ap = argparse.ArgumentParser(description="Write a one-page summary of the check.")
    ap.add_argument("--out", default=str(OUT), help="output file (default: verification/report/CHECK_SUMMARY.md)")
    ap.add_argument("--stdout", action="store_true", help="print the summary instead of writing it")
    a = ap.parse_args()
    text = summary(S.load())
    if a.stdout:
        print(text)
        return
    out = Path(a.out)
    if not out.is_absolute():
        out = Path.cwd() / out
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(text, encoding="utf-8")
    try:
        shown = out.relative_to(S.ROOT)
    except ValueError:
        shown = out
    print(f"SUMMARY {shown}")


if __name__ == "__main__":
    main()
