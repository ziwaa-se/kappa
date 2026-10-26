# L02 (Lemma 5.16, lem:xlower) — statement gate, amendment check r2

- Reviewer: pv-gate (independent subagent, claude-opus-5-5); not the drafter.
- Date: Mon Oct 12 22:22:25 EDT 2026 (from `date`).
- Mode: amendment check against `verification/audits/L02_gate.md` (A1–A3); only changed parts examined.
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L02Stmt.lean`  a4fe112ea5c426154e33465dbdd15806722fe9db4319b414de802b8ad005f294 (unchanged since r1)
  - `pv_work/L02Draft.lean` 1b91334054931b8387b6cbd895f3dc199334eae1d6741dc02bd7ea75e9a6eb2a (r1: 5037688a…ee9c)
  - `pv_work/notes/L02_draft_notes.md` cb17430db2c7c5b839ae750e4b405e46782834a783f8b5e07d756849cdc5176f (leads only)
- Compilation: `scripts/pv_lean.sh check L02Draft` -> `RESULT L02Draft mode=check exit=0 errors=0 sorry_warnings=16 nonstandard_axiom_lines=0 log=pv_work/logs/L02Draft_4.log olean=none` (EXIT=0; 16 sorries = 16 declarations, as in r1).
- Snapshot probes: `pv_work/logs/gate_L02_stmtcopy_r2_1.log` (exit=0, 0 sorry), `pv_work/logs/gate_L02_draftcopy_r2_1.log` (exit=0, 16 sorry); copies `pv_work/probes/gate/L02/gate_L02_{stmtcopy,draftcopy}_r2.lean` (verbatim copies of the current files plus `import PVTools` and `#pv_type_hashes_here`).

## Amendment checks
| Item | Location now | Implemented? | Note |
|---|---|---|---|
| A1 | `L02Draft.lean` l.19-21, docstring of `L02_main_fixedDelta` | yes, verbatim | verdict-bearing; stops at S8b; do not replace the TEX:930 justification |
| A2 | `L02Draft.lean` l.27-30, docstring of `L02_main_fixedDelta_osc` | yes, verbatim | auxiliary, not verdict-bearing; `hosc` not a TFA |
| A3 | `L02Draft.lean` l.152-157, docstring of `L02_S10` | yes, verbatim (appended after the original text) | required route recorded |
| Notes (non-binding) | notes l.46-55 amendment log | superseding note added | old wording at l.14/18/32 left in place but explicitly superseded at l.53-54; acceptable (notes are leads only) |

## Other changes
- Disclosed extra change (notes l.50-51): docstring of `L02_main` (l.7-13) now says "auxiliary variant" instead of "candidate-TFA variant" and marks the uniform reading NOT verdict-bearing. Comment-only, consistent with the r1 ruling (a); accepted.
- No other change: every declaration's `th`/`vh`/`bi` is identical to the r1 snapshot (line-by-line comparison below); `L02Stmt.lean` sha256 unchanged. Hence no statement, hypothesis, binder or consumed-clause content changed.
- r1 rulings (items 1–7, TFA table, external-parameter table, verdict-bearing object `L02_main_fixedDelta`, `hosc` rejected as TFA, suspected issue TEX:899-901 vs 930 preliminary PAPER_ARGUMENT_GAP → dispatch pv-issue-checker) stand unchanged.

## Statement snapshot (verbatim TYPE HASHES)

From `pv_work/logs/gate_L02_stmtcopy_r2_1.log` (copy of L02Stmt.lean):
```
TYPE HASHES (current file, 3 declarations)
Paper.L02.ConclFixedDelta|def|th=1855146743|vh=342785589|bi=ieee
Paper.L02.Concl|def|th=1855146743|vh=4272201556|bi=ieee
Paper.L02.L02_L01Consumed|def|th=922123888|vh=4177531171|bi=iee
EXIT=0
```
From `pv_work/logs/gate_L02_draftcopy_r2_1.log` (copy of L02Draft.lean):
```
TYPE HASHES (current file, 16 declarations)
Paper.L02.L02_S10|thm|th=2504945767|vh=-|bi=ieeeeeeeee
Paper.L02.L02_S11|thm|th=2543577539|vh=-|bi=ieeeeeeeeeee
Paper.L02.L02_S1_general|thm|th=3818633226|vh=-|bi=ieeeee
Paper.L02.L02_S1|thm|th=2823882939|vh=-|bi=ieeee
Paper.L02.L02_S2|thm|th=3952422445|vh=-|bi=ieeeeee
Paper.L02.L02_S3|thm|th=1987123589|vh=-|bi=ieeeeeeee
Paper.L02.L02_S4|thm|th=46405899|vh=-|bi=ieeeeeee
Paper.L02.L02_S5|thm|th=606143364|vh=-|bi=ieeeeee
Paper.L02.L02_S6|thm|th=2783452467|vh=-|bi=ieeeeeeeee
Paper.L02.L02_S7|thm|th=997402863|vh=-|bi=ieeeeee
Paper.L02.L02_S8a|thm|th=394698109|vh=-|bi=ieeeeeeeee
Paper.L02.L02_S8b|thm|th=3417155813|vh=-|bi=ieeeeeee
Paper.L02.L02_S9|thm|th=2975002559|vh=-|bi=ieeeeeeee
Paper.L02.L02_main_fixedDelta_osc|thm|th=1639984634|vh=-|bi=ieeeeeee
Paper.L02.L02_main_fixedDelta|thm|th=397542044|vh=-|bi=ieeeeee
Paper.L02.L02_main|thm|th=3808770304|vh=-|bi=ieeeeee
EXIT=0
```
Comparison with r1 (`L02_gate.md`): all 19 lines identical.

## Overall verdict

A1–A3 implemented verbatim; only one other change (comment-only, disclosed, consistent with the r1 rulings); snapshot identical to r1. Verdict-bearing target: `L02_main_fixedDelta`; `L02_main_fixedDelta_osc` is auxiliary only.

STATEMENT GATE: PASS
