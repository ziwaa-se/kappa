# Statement gate r2 (amendment check): P01 (Proposition prop:popoviciu, source/main.tex:58-63)

- Reviewer: pv-gate (independent subagent; did not draft P01), amendment-check mode
- Date: Mon Oct 12 22:08:55 EDT 2026 (from `date`)
- Reference report: `verification/audits/P01_gate.md` (PASS_WITH_AMENDMENTS, 2 required changes)
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/P01Stmt.lean` `26761c173fe62dfdb88a401ab78c90446c62f48f7bd4096d48b24ecdaeae7f78`
  - `pv_work/P01Draft.lean` `786341abb5308957ba99336bda47bda7d337008b3dfedc3e7278e0777b44b3cb`
- Compilation: `scripts/pv_lean.sh check P01Draft` -> `exit=0 errors=0 sorry_warnings=2 nonstandard_axiom_lines=0`, log `pv_work/logs/P01Draft_4.log`
- Probes (`pv_work/probes/gate/P01/`):
  - `gate_P01_stmtcopy_r2.lean` -> exit=0, sorry_warnings=0, log `pv_work/logs/gate_P01_stmtcopy_r2_1.log`
  - `gate_P01_draftcopy_r2.lean` -> exit=0, sorry_warnings=2 (expected), log `pv_work/logs/gate_P01_draftcopy_r2_1.log`
- Drafter notes `pv_work/notes/P01_draft_notes.md` l.28-31 (amendment log) read as leads only.

## Check of required changes

1. **`P01Stmt.lean` `Popoviciu` closed form: IMPLEMENTED.** Lines 11-13 now read exactly the text
   required in `P01_gate.md` ("∀ (n : ℕ) (a b : ℝ) (x : Sample n), 1 ≤ n → (∀ i, a ≤ x i ∧ x i ≤ b) →
   (1 / (n : ℝ)) * ∑ i, (x i - sampleMean x) ^ 2 ≤ (b - a) ^ 2 / 4"). The docstring (l.5-10) no longer
   says "specialized to the given sample". It states provenance (i) (main.tex:66-67, bib :103-106) and the
   mathlib evidence. The parameter is now a closed `Prop` that does not depend on P01's sample, so it is not
   goal-shaped. It is the cited inequality as printed at l.66-67. It is true: it is the standard Popoviciu
   inequality, and it is vacuous when a > b. With `1 ≤ n` it is weaker than or equal to the source's use.
   In `namespace Paper.P01` it is the only declaration.
2. **`P01Draft.lean` `hP : Popoviciu` in `P01_S1` (l.9) and `P01` (l.24): IMPLEMENTED.** The proof of
   `P01` (l.26-27) is unchanged. `P01_S1` is still true as stated: instantiate `hP` at `n` (`2 ≤ n`
   gives `1 ≤ n`), `a b x hx`.

## Other changes

None detected. `P01_S2` has the same type hash as in the pre-amendment snapshot (`th=2016942701`).
`P01_S1` and `P01` hashes changed, which is expected because only the type of `hP` changed. The
conclusions and the other binders are textually the same as before (binder pattern `bi` unchanged). The
draft compiles, with the 2 `sorry`s in S1/S2 only.

## External parameters (updated)

| Name | Provenance | Ruling |
|---|---|---|
| `Paper.P01.Popoviciu : Prop` (closed form) | (i), main.tex:66-67, bib :103-106 | **Approved** |

TFAs: none.

## Statement snapshot

From `pv_work/logs/gate_P01_stmtcopy_r2_1.log` (verbatim):
```
TYPE HASHES (current file, 1 declarations)
Paper.P01.Popoviciu|def|th=3944470172|vh=810227485|bi=
EXIT=0
```
From `pv_work/logs/gate_P01_draftcopy_r2_1.log` (verbatim):
```
TYPE HASHES (current file, 3 declarations)
Paper.P01.P01_S1|thm|th=565281750|vh=-|bi=eeeeeee
Paper.P01.P01_S2|thm|th=2016942701|vh=-|bi=eeeeee
Paper.P01.P01|thm|th=1195702439|vh=-|bi=eeeeeee
EXIT=0
```

## Overall verdict

Both required changes are implemented exactly and nothing else changed. Proof work may begin.

STATEMENT GATE: PASS
