# T04 statement gate, round 2 (amendment check; Theorem 4.12, thm:inv-nwu-fsub)

- Reviewer: pv-gate (independent subagent, Claude Opus), amendment-check mode against `verification/audits/T04_gate.md`
- Date: Tue Oct 13 01:42:31 EDT 2026 (from `date`)
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T04Stmt.lean` 707930e6d8070e6f318678c0e06c5d3d473cf4065fd8f005159d936e00216522 (unchanged from round 1)
  - `pv_work/T04Draft.lean` bca30c4aa6b3961a9c9cfa2b8041aab6942c8b9ff9b712f2a2ff7a7d5689c2c5 (round 1: bcbaf4f0...)
  - `pv_work/L02Stmt.lean` caf65f96097f30510613ecbaae09a9c88816a2a2da4b1ac2edc1d2a5b5256d1f (unchanged)
  - `pv_work/L01Stmt.lean` 3e9b3f0c87c438951c23ab2a1747bdb9f47a1155dcfd26a64401d421d03ad57e (unchanged)
  - `pv_work/notes/T04_draft_notes.md` 4f3b62a22ba8ebf377a97f9867442be9ef59a9b3217973f0cb8b23111958b021
- Compilation: `scripts/pv_lean.sh check T04Draft` -> `RESULT T04Draft mode=check exit=0 errors=0 sorry_warnings=7 nonstandard_axiom_lines=0 log=pv_work/logs/T04Draft_4.log`. EXIT=0 (7 sorries: main, S1-S5, S4z; expected for a draft).

## Amendment A1 — implemented
`T04_S4z` inserted between `T04_S4` and `T04_S5` (T04Draft.lean:49-55). Statement text identical to the one specified in round 1 (binders `μ`, `[IsProbabilityMeasure μ]`, `{x y}`, `hx`, `hy`, `h0 : F μ (1/x) = 0 ∨ F μ (1/y) = 0`; conclusion `F μ (1/x) + F μ (1/y) - 1 ≤ F μ (1/(x+y))`). Docstring as specified.
Truth as stated: if F(1/x)=0 the LHS is F(1/y)-1 ≤ 0 ≤ F(1/(x+y)) (cdf values in [0,1]); symmetric otherwise. TRUE. Not conclusion-shaped (it is a pointwise case of `hchain`, which is the source's own chain output, F:383).
Assembly now complete: for x,y>0, `hchain` follows from S2+S4 (both F-values positive) or S4z (one is zero, since F ≥ 0); S5 then yields `T04_main`.

## Amendment A2 — implemented
- `T04_S1` docstring (T04Draft.lean:19-20): now "The case `F_X(1/x)=0` or `F_X(1/y)=0` is covered by S4z (convention `Log 0 = -∞`)." As specified.
- `T04_S5` docstring (T04Draft.lean:61-62): now "`hchain` is supplied by S2+S4 when `F_X(1/x),F_X(1/y)>0` and by S4z otherwise." As specified.
- Notes: line 15 (assembly) and item "Suspected paper issues 1" (line 24) updated; amendment log at lines 27-28.

## Other changes
None found. T04Stmt.lean byte-identical (same sha256). Type hashes of `T04_main` and S1-S5 identical to round 1 (see below); the only new declaration is `T04_S4z`. The remaining text of the draft was compared against round 1 report content and the copy made for this snapshot; no further edits.

## Statement snapshot
Copies: `pv_work/probes/gate/T04/gate_T04_r2_stmtcopy.lean` (probe exit 0, log `pv_work/logs/gate_T04_r2_stmtcopy_1.log`), `pv_work/probes/gate/T04/gate_T04_r2_draftcopy.lean` (probe exit 0, 7 sorries, log `pv_work/logs/gate_T04_r2_draftcopy_1.log`).

T04Stmt copy:
```
TYPE HASHES (current file, 0 declarations)
EXIT=0
```
T04Draft copy:
```
TYPE HASHES (current file, 7 declarations)
Paper.T04.T04_S1|thm|th=1510204608|vh=-|bi=eceiieeee
Paper.T04.T04_S2|thm|th=3418143244|vh=-|bi=eceiieeee
Paper.T04.T04_S3|thm|th=2649797432|vh=-|bi=iiee
Paper.T04.T04_S4z|thm|th=2164773689|vh=-|bi=eciieee
Paper.T04.T04_S4|thm|th=497200072|vh=-|bi=eciiee
Paper.T04.T04_S5|thm|th=3290591031|vh=-|bi=ecee
Paper.T04.T04_main|thm|th=362827318|vh=-|bi=ece
EXIT=0
```
Comparison with round 1 (line by line): `T04_main` 362827318/ece, S1 1510204608, S2 3418143244, S3 2649797432, S4 497200072, S5 3290591031 — all th and bi identical. New: S4z 2164773689.

## TFAs / external parameters
Unchanged from round 1: no TFAs proposed (S1 extra conjunct accepted); no external parameters.

## Overall verdict
Both amendments implemented exactly; no other changes; statement hashes unchanged; obligations now true as stated and assemble to `T04_main`.

STATEMENT GATE: PASS
