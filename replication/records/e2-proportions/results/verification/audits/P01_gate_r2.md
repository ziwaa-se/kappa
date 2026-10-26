# Statement gate r2 (amendment check): P01 (Proposition prop:concave, main.tex:55-63)

- Reviewer: pv-gate (independent subagent, Opus), amendment-check mode
- Date: Mon Oct 12 22:11:23 EDT 2026
- Scope: only the changes required by `verification/audits/P01_gate.md` (changes 1 and 2, option A), plus a check that nothing else changed.
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/P01Stmt.lean` `18d6929bd4ed985bd290f17f7e8cdbc969049f486b33533b8a90f852a5b2b25e`
  - `pv_work/P01Draft.lean` `d53433e2c435b7a350bd559dc4d52594199ab6ff0c2563a468b74e764f960420`
  - `pv_work/notes/P01_draft_notes.md` `bf0e2d2577b7339e0f398e3806480bc2e4a03379a5e4c5fdf5c0bf4ff57bfe94`
- Compilation: `scripts/pv_lean.sh check P01Draft` -> `exit=0 errors=0 sorry_warnings=4 nonstandard_axiom_lines=0`, log `pv_work/logs/P01Draft_4.log` (4 sorries = S0, S1, S2, S3, as expected for a draft).
- Snapshot probes: `pv_work/probes/gate/P01/gate_P01_stmtcopy_r2.lean` (exit=0, log `pv_work/logs/gate_P01_stmtcopy_r2_1.log`), `pv_work/probes/gate/P01/gate_P01_draftcopy_r2.lean` (exit=0, 4 sorry warnings, log `pv_work/logs/gate_P01_draftcopy_r2_1.log`).

## Change-by-change check

1. **Change 1 (mathlib evidence in notes). IMPLEMENTED.** `P01_draft_notes.md:21-22` now cites `ConcaveOn.comp` (Function.lean:141), `Real.strictConcaveOn_sqrt` (Pow.lean:87), `Real.sqrt_le_sqrt`, and the gate probe/log; the false claim that composition "does not give concavity directly" is gone (amendment log line 25). `SqrtConcave` is stated as not registered in `external_tools`.
2. **Change 2, option A (discharge the parameter). IMPLEMENTED.**
   - `P01Draft.lean:7-11`: `theorem P01_S0 : SqrtConcave := by sorry`, placed before S1, docstring cites main.tex:61 ("well known") and the mathlib route. Its statement is exactly the previously approved `SqrtConcave` (faithful to main.tex:61 under the closed reading of $I$; true — the gate proved it from mathlib without sorry in r1).
   - Binder `(h : SqrtConcave)` removed from `P01_S1` (line 17), `P01_S3` (line 30), `P01_main` (line 35). The S1 docstring now says "Uses S0". S1 without `h` remains true as stated (concavity is a theorem), not stronger than the source step, and S3/main obligations are otherwise unchanged. `P01_main` now has hypotheses `n : ℕ`, `1 ≤ n` only, matching main.tex:24, 55-57.
   - `P01Stmt.lean:13-15`: docstring of `SqrtConcave` relabeled as "Statement of step obligation `P01_S0` (NOT an external input ...)". Definition body unchanged: `th`/`vh` of `SqrtConcave` and `P01Claim` are identical to r1 (snapshot below).
3. **No other changes.** By `#pv_type_hashes`: `P01Claim`, `SqrtConcave`, `P01_S2` hashes identical to r1; `P01_S1`, `P01_S3`, `P01_main` `th` and `bi` changed only by the removal of one explicit binder (`bi` eeeee -> eeee), as anticipated in r1; `P01_S0` is new. The text diff of the reviewed Lean files against r1 consists of exactly these edits.

## Advisory (non-blocking, notes only)

- `P01_draft_notes.md:12` still says "The external Tool is stated on the closed interval"; stale wording after option A (it is now step S0). Cosmetic.
- `P01_draft_notes.md:29` suggests "at most EXPOSITION_GAP" for main.tex:61; the gate's ruling (r1 item 7) stands: `FAIR_IMPLICIT_STEP`/`EDITORIAL`, no paper issue, no dispatch needed.

## Updated tables

- TFAs: none.
- External parameters: none (`SqrtConcave` is now the statement of step obligation `P01_S0`, not an external input).

## Statement snapshot

From `pv_work/logs/gate_P01_stmtcopy_r2_1.log`, verbatim:

```
TYPE HASHES (current file, 2 declarations)
Paper.P01.P01Claim|def|th=1771785297|vh=3019997781|bi=eee
Paper.P01.SqrtConcave|def|th=3944470172|vh=182622040|bi=
EXIT=0
```

From `pv_work/logs/gate_P01_draftcopy_r2_1.log`, verbatim:

```
TYPE HASHES (current file, 5 declarations)
Paper.P01.P01_S0|thm|th=2738458216|vh=-|bi=
Paper.P01.P01_S1|thm|th=3452030608|vh=-|bi=eeee
Paper.P01.P01_S2|thm|th=3541686319|vh=-|bi=eee
Paper.P01.P01_S3|thm|th=1121683978|vh=-|bi=eeee
Paper.P01.P01_main|thm|th=1121683978|vh=-|bi=eeee
EXIT=0
```

## Overall verdict

Both required changes are implemented as specified, no other statement change was introduced, and the draft compiles (exit=0). This snapshot supersedes the r1 snapshot for the final audit.

STATEMENT GATE: PASS
