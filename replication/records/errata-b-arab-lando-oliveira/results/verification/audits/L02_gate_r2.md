# L02 statement gate, round 2 (amendment check)

- Reviewer: pv-gate (independent subagent, Opus), amendment-check mode
- Date: Tue Oct 13 01:06:02 EDT 2026 (from `date`)
- Reference: `verification/audits/L02_gate.md` (PASS_WITH_AMENDMENTS, 1 required change)
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L02Stmt.lean` caf65f96097f30510613ecbaae09a9c88816a2a2da4b1ac2edc1d2a5b5256d1f (identical to round 1: unchanged)
  - `pv_work/L02Draft.lean` d1da090183b2453ca9cad47a0dd867b8f44ee3405d5a0ffb14b6b22027fdca8f (round 1: 896bee2a...)
  - `pv_work/notes/L02_draft_notes.md` e3662b4fa267363b4e85ad82227a87c046f93d6049801ec087085a2d5597e83c (leads only)
- Compilation: `scripts/pv_lean.sh check L02Draft` gave
  `RESULT L02Draft mode=check exit=0 errors=0 sorry_warnings=4 nonstandard_axiom_lines=0 log=pv_work/logs/L02Draft_4.log olean=none` (4 sorry = main + S1..S3, expected for a draft).

## Required change 1 — IMPLEMENTED

- `L02_main` (L02Draft.lean:10-11) now reads
  `theorem L02_main (μ : MeasureTheory.Measure ℝ) [MeasureTheory.IsProbabilityMeasure μ] :`
  `    IsSuperHeavyTailed μ ↔ InvNWUCond μ := by`
  exactly as required; the hypothesis `h0 : F μ 0 = 0` is gone. Confirmed by hash: `L02_main` binder string changed from `bi=ece` to `bi=ec` and `th` changed (2155422696 -> 352959930).
- Docstring (lines 7-9) records the suspected gap (F:361 vs F:346, "if" direction lacks F_X(0)=0, e.g. X ≡ 0) and states "No extra hypothesis is assumed"; it does not assert h0 as a convention. Matches the requirement.

## No other changes

- `L02Stmt.lean`: file sha256 identical to round 1; all four `th`/`vh`/`bi` lines identical to the round-1 snapshot.
- `L02_S1`, `L02_S2`, `L02_S3`: `th` and `bi` identical to the round-1 snapshot; text unchanged.
- Notes: only an amendment log appended, withdrawing the candidate-TFA row. No effect on the statement.

## Consequence (unchanged from round 1, recorded for the record)

`L02_main` as now stated is the printed Lemma 4.10 and is false in its "if" direction (μ = dirac 0: InvNWUCond holds, F(0)=1 so IsSuperHeavyTailed fails). This is the faithful exposure of the suspected paper issue (F:361-364 vs F:346; preliminary PAPER_ASSUMPTION_GAP or DOMAIN_CLARIFICATION), not an encoding defect. Forward direction = S1 + S2 (with h.1); reverse direction = S3 gives only the subadditivity conjunct. Recommend dispatching pv-issue-checker (as in round 1). Obligations S1-S3 remain true as stated.

## Statement snapshot

Probe copies: `pv_work/probes/gate/L02/gate_L02_stmtcopy_r2.lean` (RESULT exit=0, sorry_warnings=0, log `pv_work/logs/gate_L02_stmtcopy_r2_1.log`), `pv_work/probes/gate/L02/gate_L02_draftcopy_r2.lean` (RESULT exit=0, sorry_warnings=4, log `pv_work/logs/gate_L02_draftcopy_r2_1.log`).

L02Stmt copy:
```
TYPE HASHES (current file, 4 declarations)
Paper.L02.InvNWUCond|def|th=3905129696|vh=1097506931|bi=e
Paper.L02.IsSuperHeavyTailed|def|th=3905129696|vh=1915010453|bi=e
Paper.L02.SubadditiveOnE|def|th=3398320362|vh=2787305485|bi=ee
Paper.L02.negLogInv|def|th=998799875|vh=1981073015|bi=ee
```

L02Draft copy:
```
TYPE HASHES (current file, 4 declarations)
Paper.L02.L02_S1|thm|th=3729239319|vh=-|bi=eceeeee
Paper.L02.L02_S2|thm|th=1901557866|vh=-|bi=eceee
Paper.L02.L02_S3|thm|th=1459483526|vh=-|bi=ece
Paper.L02.L02_main|thm|th=352959930|vh=-|bi=ec
```

## TFAs / external parameters

TFAs approved: none (h0 on main removed). External parameters: none.

## Overall verdict

The single required change is implemented exactly; no other statement change. Proof work may begin (the "if" direction is expected to stop at the missing F_X(0)=0 conjunct).

STATEMENT GATE: PASS
