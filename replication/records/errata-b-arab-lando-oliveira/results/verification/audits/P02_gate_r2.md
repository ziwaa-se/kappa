# P02 statement gate, amendment check r2 (Proposition 3.2, prop:inf-mean)

- Reviewer: pv-gate (independent subagent, claude-opus-5-5), amendment-check mode
- Date: Mon Oct 12 22:11:06 EDT 2026
- Scope: only the changes required in `verification/audits/P02_gate.md` (A1, A2), plus a check that nothing else changed.
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `7eddf12f4c2ef0f609d8feb581aa0dac9d881254d5ee588908b04f6f79c339f9  pv_work/P02Stmt.lean` (identical to r1: unchanged, as required)
  - `7f47d0a431bb882e1b3a4ce1333a63aa6076f9db5a09a9d8d6c0bf1140f0d103  pv_work/P02Draft.lean` (r1: 39f520ae...)
- Compilation: `scripts/pv_lean.sh check P02Draft` -> `RESULT P02Draft mode=check exit=0 errors=0 sorry_warnings=8 nonstandard_axiom_lines=0 log=pv_work/logs/P02Draft_4.log olean=none`.

## A1 (premise `hmean` in `P02_S4b`): IMPLEMENTED

`pv_work/P02Draft.lean:75` now reads `(hmean : ∫ ω, Y ω ∂μ = ∫ ω, X ω ∂μ)`, inserted after `(hXi ...) (hYi ...)` and before `hdom`, exactly as required. Other premises and the conclusion of S4b are unchanged (text compared against the r1 draft copy `pv_work/probes/gate/P02/gate_P02_draftcopy.lean:72-78`).

Truth as stated (re-checked): for X, Y ≥ 0 integrable on a probability space, √X, √Y ∈ L², Var√X = E X − (E√X)², Var√Y = E Y − (E√Y)²; with `hmean` and `hvar`, (E√X)² = (E√Y)², and both integrals are ≥ 0, so E√X = E√Y. The r1 counterexample (X ≡ 0, Y ≡ 1) now violates `hmean`. No smuggling: `hmean` is the conclusion of S2 (source :266 "E(Y)=E(X)"), not the S4b conclusion or an equivalent; the S3 conclusion (equal distribution) is still not a premise. PASS.

## A2 (S4b docstring): IMPLEMENTED

`pv_work/P02Draft.lean:66-71`: the claim "not a valid implication in general (suspected PAPER_ARGUMENT_GAP ...)" is replaced by the description of the step via E X = E Y (S2, `hmean`) and Var√X = E X − (E√X)², marked FAIR_IMPLICIT_STEP, with the drafter's suspicion forwarded to pv-issue-checker. Accurate. PASS.

## No other changes

Text comparison of the r1 draft copy with the current draft: the only differences are the S4b docstring (lines 66-71) and the added line 75. Confirmed by `#pv_type_hashes_here`: all hashes except `P02_S4b` are identical to r1; the `P02_S4b` `th` changed (1753446197 -> 1572475144) and `bi` gained exactly one explicit binder (`iceceeeeeeeeee` -> `iceceeeeeeeeeee`), consistent with A1. `P02Stmt.lean` sha256 and its hashes (th, vh, bi) are unchanged.

All other rulings of `P02_gate.md` (items 1-4, 6, 7; TFAs; no external parameters) stand. The suspected source issues listed in r1 item 7 remain for pv-issue-checker.

## Statement snapshot

Statement copy `pv_work/probes/gate/P02/gate_P02_stmtcopy.lean` (content matches current `P02Stmt.lean`, same sha256 as at r1; `RESULT gate_P02_stmtcopy mode=probe exit=0 errors=0 sorry_warnings=0`, log `pv_work/logs/gate_P02_stmtcopy_2.log`):
```
TYPE HASHES (current file, 3 declarations)
Paper.P02.InfiniteMean|def|th=1957365751|vh=1062878209|bi=icee
Paper.P02.StDom|def|th=180540177|vh=4122359899|bi=iceee
Paper.P02.TwoCase|def|th=3944470172|vh=215005570|bi=
```

Draft copy `pv_work/probes/gate/P02/gate_P02_draftcopy_r2.lean` (`RESULT gate_P02_draftcopy_r2 mode=probe exit=0 errors=0 sorry_warnings=8`, log `pv_work/logs/gate_P02_draftcopy_r2_1.log`):
```
TYPE HASHES (current file, 8 declarations)
Paper.P02.P02_S1|thm|th=320467813|vh=-|bi=eicecieeeeeeeeeee
Paper.P02.P02_S2|thm|th=4187370773|vh=-|bi=iceceeeeeeeeee
Paper.P02.P02_S3|thm|th=4084716335|vh=-|bi=iceceeeeeeee
Paper.P02.P02_S4a|thm|th=2655103998|vh=-|bi=iceceee
Paper.P02.P02_S4b|thm|th=1572475144|vh=-|bi=iceceeeeeeeeeee
Paper.P02.P02_S5|thm|th=1897498061|vh=-|bi=iceceeeeeeeeeeeeeee
Paper.P02.P02_S6|thm|th=2865709670|vh=-|bi=iceceeeeeeeeeeeeeeeee
Paper.P02.P02_main|thm|th=1724241671|vh=-|bi=icecieeeeeeeeeee
```

## Overall verdict

A1 and A2 are implemented, there are no other changes, and S4b is now true as stated. Proof work may begin.

STATEMENT GATE: PASS
