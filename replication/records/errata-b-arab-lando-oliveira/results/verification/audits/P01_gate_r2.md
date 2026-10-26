# P01 statement gate, amendment check r2 (Proposition 2.5, `prop:ITS-dens`)

- Reviewer: pv-gate (independent subagent, Claude Opus), amendment-check mode against `verification/audits/P01_gate.md` (R1, R2)
- Date: Mon Oct 12 22:11:45 EDT 2026 (from `date`)
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/P01Stmt.lean` 2cef2627b63d6b32a21679d7f4a8eb9503a3a2616330ea6f243a9f2dab5ebe98
  - `pv_work/P01Draft.lean` 75ebe207a0bd0fce1d07a19cf6a8e2a71bcdb9525740cedb2a8beb26b6a859b8
  - `pv_work/notes/P01_draft_notes.md` f7e202c7800ba65e47848f3900ca4dbc67a0ff297fcc9ba828f860ee0d93df9a (leads only)
- Compilation: `scripts/pv_lean.sh check P01Draft` -> `exit=0 errors=0 sorry_warnings=8 nonstandard_axiom_lines=0`, log `pv_work/logs/P01Draft_4.log`.
- Probes (`pv_work/probes/gate/P01/`):
  - `gate_P01_stmtcopy_r2.lean` exit 0, log `pv_work/logs/gate_P01_stmtcopy_r2_1.log`
  - `gate_P01_draftcopy_r2.lean` exit 0, 8 sorry warnings, log `pv_work/logs/gate_P01_draftcopy_r2_1.log`
  - `gate_P01_oleancheck_r2.lean` exit 1, the single expected error `unknown identifier 'Paper.P01.AntiStarShapedSubadditive'` (so the compiled `P01Stmt.olean` that the draft imports reflects R1); its `#pv_type_hashes P01Stmt` output matches the Stmt-copy snapshot below line for line. Log `pv_work/logs/gate_P01_oleancheck_r2_1.log`.

## R1 (remove X04): IMPLEMENTED

- `P01Stmt.lean`: `AntiStarShapedSubadditive` and its docstring are gone (file now ends at `AntiStarShaped`, line 44, then `end Paper.P01`). The remaining text is identical to the reviewed version; mechanically confirmed: the 8 remaining defs have the same `th`/`vh`/`bi` as in the r1 snapshot.
- `P01Draft.lean`: `hX04` removed from `P01_main` (lines 11-16) and from `P01_S7` (lines 74-75), which now reads exactly as required: `(μ : Measure ℝ) [IsProbabilityMeasure μ] (h6 : AntiStarShaped (vExt μ)) : SubadditiveOnPos (invDist μ)`. Docstring updated as required.
- S7 true as stated: for x,y>0, `vExt = invDist` off 0, and antitonicity of `v t / t` on `(0,∞)` gives `v(x+y) = x·v(x+y)/(x+y) + y·v(x+y)/(x+y) ≤ v x + v y`.
- Notes mark X04 as removed. `verification/EXTERNAL_TOOLS.md:34` still lists X04 for P01: coordinator must unregister it (and from `RESULTS.json` if present); not a draft change.

## R2 (S4 a.e. version): IMPLEMENTED

- `P01Draft.lean:48-53`: binders and conclusion match the required text character for character (`μ`, `[IsProbabilityMeasure μ]`, `f`, `hf`, `hdens`, `hhaz`; `∀ᵐ x ∂volume, 0 < x → (1/x) * (f (1/x)).toReal + F μ (1/x) - 1 ≤ 0`). Docstring as required (`:153`, D2).
- True as stated: where `Fbar(1/x) > 0`, `hhaz` at `1/x` gives `f(1/x).toReal ≤ x·Fbar(1/x)`; where `f(1/x)=∞` the term is 0 and `F ≤ 1`; the set `{s>0 : Fbar s = 0}` is `[s0,∞)`, on whose interior `f = 0` a.e. since `μ (s0,∞) = 0`; `x ↦ 1/x` maps volume-null subsets of `(0,∞)` to null sets. The earlier counterexample (`dirac 0`, `f ≡ 1`) is excluded by `hdens`.
- Assembly: S5 still consumes S2, S3, S4 (S5's statement unchanged); main = S1 ∧ S7(S6(S5)). OK.

## Other changes: NONE

By `#pv_type_hashes` (r1 vs r2): `P01_S1`, `S2`, `S3`, `S5`, `S6` identical `th`/`bi`; changed only `P01_S4` (R2), `P01_S7` and `P01_main` (R1, removal of `hX04` binder: `bi` lost one leading `e`); Stmt: only `AntiStarShapedSubadditive` removed. The text of all other declarations was also compared by eye and is unchanged.

## TFAs / external parameters

- TFAs: none.
- External parameters: none (X04 removed). P01 is now a candidate for UNCONDITIONAL, subject to proof and final audit.

## Required changes

None for the draft. Coordinator housekeeping: unregister X04 in `verification/EXTERNAL_TOOLS.md:34` (and `RESULTS.json`). Non-blocking recommendations N1, N2 of `P01_gate.md` remain open (not required). Preliminary doubts D1-D5 of `P01_gate.md` are unchanged; D1 may go to pv-issue-checker at low priority.

## Statement snapshot (amended text)

`pv_work/probes/gate/P01/gate_P01_stmtcopy_r2.lean` (log `pv_work/logs/gate_P01_stmtcopy_r2_1.log`):
```
TYPE HASHES (current file, 8 declarations)
Paper.P01.AntiStarShaped|def|th=4254974927|vh=810757625|bi=e
Paper.P01.Fbar|def|th=390107078|vh=3618553444|bi=ee
Paper.P01.F|def|th=390107078|vh=2204204658|bi=ee
Paper.P01.InvSub|def|th=3905129696|vh=244172552|bi=e
Paper.P01.SubadditiveOnPos|def|th=4254974927|vh=4121237076|bi=e
Paper.P01.hazard|def|th=3114261911|vh=311329179|bi=eee
Paper.P01.invDist|def|th=390107078|vh=4282577196|bi=ee
Paper.P01.vExt|def|th=390107078|vh=2525779558|bi=ee
EXIT=0
```

`pv_work/probes/gate/P01/gate_P01_draftcopy_r2.lean` (log `pv_work/logs/gate_P01_draftcopy_r2_1.log`):
```
TYPE HASHES (current file, 8 declarations)
Paper.P01.P01_S1|thm|th=285931251|vh=-|bi=eceee
Paper.P01.P01_S2|thm|th=1943743511|vh=-|bi=eceee
Paper.P01.P01_S3|thm|th=480467246|vh=-|bi=eeeee
Paper.P01.P01_S4|thm|th=1496723460|vh=-|bi=eceeee
Paper.P01.P01_S5|thm|th=3868911127|vh=-|bi=eceeee
Paper.P01.P01_S6|thm|th=2949884150|vh=-|bi=ece
Paper.P01.P01_S7|thm|th=3578570055|vh=-|bi=ece
Paper.P01.P01_main|thm|th=2242076990|vh=-|bi=eceeeee
EXIT=0
```

## Overall verdict

Both required changes R1 and R2 are implemented exactly; no other change to any statement; draft compiles (exit 0). Proof work may begin.

STATEMENT GATE: PASS
