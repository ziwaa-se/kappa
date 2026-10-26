# L01 (Lemma 5.15, lem:xelower) — statement gate, amendment check r2

- Reviewer: pv-gate (independent subagent, claude-opus-5-5); not the drafter.
- Date: Mon Oct 12 22:12:26 EDT 2026 (from `date`).
- Mode: amendment check against `verification/audits/L01_gate.md` (A1-A3); only changed parts examined.
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L01Stmt.lean`  b641d506158ff99af3ae6b33800fd32a4216d840ceb5af75145fc50a7d232e9b (identical to r1: unchanged)
  - `pv_work/L01Draft.lean` acc42d51dc42b2d679af348a2525ff7d50932e6049796627d144a4227d2eac69 (r1: c0fd4f42…)
  - `pv_work/notes/L01_draft_notes.md` fab7954772de0382e0c8748b6c13a58ee8da238acc3c430f38592b121d9070f2
- Compilation: `scripts/pv_lean.sh check L01Draft` -> `RESULT L01Draft mode=check exit=0 errors=0 sorry_warnings=7 nonstandard_axiom_lines=0 log=pv_work/logs/L01Draft_4.log olean=none` (EXIT=0; 7 sorries expected in a draft).
- Snapshot probes: `pv_work/logs/gate_L01_r2_stmtcopy_1.log` (exit=0, 0 sorry), `pv_work/logs/gate_L01_r2_draftcopy_1.log` (exit=0, 7 sorry); copies in `pv_work/probes/gate/L01/gate_L01_r2_{stmtcopy,draftcopy}.lean`.

## Amendment check

| # | Required | Found | Ruling |
|---|---|---|---|
| A1 | `L01Draft.lean` l.15: docstring of `L01_main_fixedDelta` replaced by the fixed-δ / verdict-bearing text | l.15 contains the required text verbatim | DONE |
| A2 | `L01Draft.lean` l.10: `Assembly: S1-S5. -/` replaced by the uniform-in-δ text | l.10 contains the required text verbatim | DONE |
| A3 | notes l.25-26: delete "record EXPOSITION_GAP and"; state that `L01_main_fixedDelta` is verdict-bearing and `lean_main` should point to it unless `L01_main` is proved along the source route | l.25-27 now say "that is a reading-choice matter, not a paper issue. `L01_main_fixedDelta` is the verdict-bearing theorem and `lean_main` should point to it unless …"; EXPOSITION_GAP suggestion removed; amendment log l.29-33 added | DONE |

## Other changes

- `L01Stmt.lean`: byte-identical (same sha256 as r1).
- `L01Draft.lean`: all 7 declaration types, binder annotations unchanged (`#pv_type_hashes_here` output identical line by line to the r1 snapshot); only the two docstrings were changed. No other changes introduced.
- Non-blocking remark (notes are leads, not evidence, and outside the snapshot): notes l.21-22 ("weaker; follows from main", "`L01_main_fixedDelta` is a corollary") and l.47 ("Corollary `L01_main_fixedDelta`") still contain the old wording; l.33 marks them as superseded by the gate ruling. The binding ruling stands: `L01_main_fixedDelta` is verdict-bearing and must be proved along S1-S5 without `L01_main`.

## Rulings of r1 carried over unchanged

Items 1-7 PASS as in `L01_gate.md`; TFAs: `hx : x0 ≠ 0` (step-local, S3) approved; external parameters: none; false-as-stated obligations: none; suspected issues: TEX:896 "6/ε²" wording (EDITORIAL / FAIR_IMPLICIT_STEP, no dispatch), TEX:885 quantifier order (DOMAIN_CLARIFICATION at most, no dispatch).

## Statement snapshot (verbatim TYPE HASHES)

From `pv_work/logs/gate_L01_r2_stmtcopy_1.log` (copy of L01Stmt.lean):
```
TYPE HASHES (current file, 2 declarations)
Paper.L01.ConclFixedDelta|def|th=922123888|vh=197406444|bi=iee
Paper.L01.Concl|def|th=922123888|vh=1830260882|bi=iee
EXIT=0
```
From `pv_work/logs/gate_L01_r2_draftcopy_1.log` (copy of L01Draft.lean):
```
TYPE HASHES (current file, 7 declarations)
Paper.L01.L01_S1|thm|th=4288029101|vh=-|bi=ieeee
Paper.L01.L01_S2|thm|th=550043121|vh=-|bi=ieeeee
Paper.L01.L01_S3|thm|th=718125916|vh=-|bi=ieeeeee
Paper.L01.L01_S4|thm|th=2586431750|vh=-|bi=ieeeee
Paper.L01.L01_S5|thm|th=3043808301|vh=-|bi=ieeeeee
Paper.L01.L01_main_fixedDelta|thm|th=2678561996|vh=-|bi=ieeee
Paper.L01.L01_main|thm|th=795169561|vh=-|bi=ieeee
EXIT=0
```

## Overall verdict

A1-A3 implemented; no other change; statement snapshot identical to r1. Verdict-bearing target: `L01_main_fixedDelta`.

STATEMENT GATE: PASS
