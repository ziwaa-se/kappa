# T02 (Theorem 5.14, thm:light) — statement gate, amendment check r2

- Reviewer: pv-gate (claude-opus-5-5), fresh subagent; did not draft T02.
- Mode: check amendments A1, A2, A3 listed in `verification/audits/T02_gate.md` (changed parts only).
- Date: Tue Oct 13 01:21:54 EDT 2026 (from `date`).
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T02Stmt.lean`  b69ed32e3ea12267cc1da309cd2819b3d996cd21552b8afef8d44b155eb30ba0
  - `pv_work/T02Draft.lean` ccc765f41a644b2680bfce31166f4f7edf63493e43bc4532cc40c026c046ca35
- Compilation: `scripts/pv_lean.sh check T02Draft` -> `RESULT T02Draft mode=check exit=0 errors=0 sorry_warnings=10
  nonstandard_axiom_lines=0 log=pv_work/logs/T02Draft_4.log olean=none`. EXIT=0.

## A1 — consumed clause renamed and relocated: IMPLEMENTED

- `T02Stmt.lean:2` now has `import L02Stmt`; `T02Stmt.lean` imports only `Defs` and `L02Stmt` (no `L03Stmt`).
- `T02Stmt.lean:101-104` declares `def T02_L02Consumed {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ) : Prop` inside
  `namespace Paper.T02`. Its body is token-for-token identical to `Paper.L03.L03_L02Consumed`
  (`pv_work/L03Stmt.lean:25-28`) and to the text required in A1: `Paper.L02.ConclFixedDelta gU eps L ∧ ∀ δ < 1, ∃ η,
  ∀ x0 p0, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖^δ → ∀ i, 1 ≤ i → i ≤ L → 2‖xLF … (i-1)‖ ≤ ‖xLF … i‖`. So `L03_main` will accept
  it by unfolding.
- Docstring `T02Stmt.lean:93-100`: provenance (p), predecessor L02, locations (`Paper.L02.ConclFixedDelta`,
  TEX:899-901; `Paper.L02.L02_S10`, TEX:934), and applicability ((17), (18) = `hexp`, `hosc`). Complete.
- Module docstring `T02Stmt.lean:15` updated.
- Name uniqueness: grep over `T02Stmt`, `T02Draft`, `L02Stmt`, `L03Stmt` shows `T02_L02Consumed` declared only at
  `T02Stmt.lean:101`; no redeclaration.
- `T02Draft.lean`: the `open Paper.L03 (L03_L02Consumed)` line is gone; `hL02 : T02_L02Consumed gU eps L` at lines
  19 (`T02_main`, still first explicit hypothesis after the data), 30 (`T02_S1`), 40 (`T02_S2`). `T02Draft` still
  imports `L03` (needed for `L03_main` in S2); this is fine since no external parameter is taken from `L03Stmt`.

## A2 — `T02_S7` premise added: IMPLEMENTED

`T02Draft.lean:86` adds `(hgrad : IsGradField U gU)` after `(hd : 0 < d)`. With it the obligation is true as stated
(argument in `T02_gate.md` item 5: `U` continuous, so `Z ∈ (0,∞)`, `π{‖x‖>R} > 0` for all `R` as `d ≥ 1`; with `h6`
and `hle`, `essSup = 1`). The counterexample of the r1 report no longer applies (it needed non-measurable `U`).
`hgrad` is available in `T02_main`, so the assembly in `T02_gate.md` item 5 is unchanged.

## A3 — `Prop35` provenance label: IMPLEMENTED

`T02Stmt.lean:12-13` and `:70-72` now label `Prop35` as provenance (ii) per project instruction (INVENTORY.md:28,
179), keeping "cited from roberts1996geometric, TEX:298". `vh` of `Prop35` unchanged (2088257911 in r1 and r2), as
expected for a docstring-only change.

Non-blocking remark (outside A3's scope, not a required change): the docstring of `T02_main` in
`T02Draft.lean:15` still says "`hE1` Prop. 3.5 (provenance (i))". It does not affect any type; the prover may align
it to (ii) when writing `pv_work/T02.lean`. Registration in `EXTERNAL_TOOLS.md` should use (ii).

## No other change introduced

Decided by `#pv_type_hashes_here`, compared line by line with the r1 snapshot in `T02_gate.md`:
- T02Stmt: all 10 r1 lines (`GaussFacts, GeomErgodic, Prop35, gaussMeas, hmcPow.match_1, hmcPow, hmcStep, rejProb,
  targetMeas, tvDist`) identical in `th`, `vh`, `bi`; the only addition is `T02_L02Consumed` (A1).
- T02Draft: `T02_S3, T02_S4, T02_S5, T02_S6, T02_S7', T02_S8` identical to r1. Changed: `T02_S1`, `T02_S2`,
  `T02_main` (A1 renaming; `bi` unchanged) and `T02_S7` (A2; `bi` gains one `e`). These are exactly the changes
  anticipated in r1.

## Rulings

| Amendment | Status |
|---|---|
| A1 | implemented, approved |
| A2 | implemented, approved; S7 now true as stated |
| A3 | implemented, approved |

External parameters (unchanged from r1, now correctly named/labelled): `Paper.T02.Prop35` (ii), `Paper.T02.GaussFacts`
(v), `Paper.T02.T02_L02Consumed` (p, predecessor L02; becomes (iv) if L02 is recorded ISSUE, per r1 note).
TFAs approved in r1 unchanged: TFA-1 (`0 < eps`, `1 ≤ L`), TFA-2 (`0 < d`), TFA-3 (`IsGradField U gU`),
TFA-4 (`∫⁻ e^{-U} < ∞`). Suspected issues of r1 item 7 unchanged (preliminary only).

## Statement snapshot (verbatim)

Probe files: `pv_work/probes/gate/T02/gate_T02_stmtcopy_r2.lean` (log `pv_work/logs/gate_T02_stmtcopy_r2_1.log`,
exit 0, 0 sorry), `pv_work/probes/gate/T02/gate_T02_draftcopy_r2.lean` (log
`pv_work/logs/gate_T02_draftcopy_r2_1.log`, exit 0, 10 sorry warnings).

T02Stmt copy:
```
TYPE HASHES (current file, 11 declarations)
Paper.T02.GaussFacts|def|th=3944470172|vh=290450534|bi=
Paper.T02.GeomErgodic|def|th=4031747299|vh=3856057058|bi=ieeee
Paper.T02.Prop35|def|th=3944470172|vh=2088257911|bi=
Paper.T02.T02_L02Consumed|def|th=1855146743|vh=3334301295|bi=ieee
Paper.T02.gaussMeas|def|th=2887673794|vh=3528590644|bi=e
Paper.T02.hmcPow.match_1|def|th=413685589|vh=1344119661|bi=eeee
Paper.T02.hmcPow|def|th=75357535|vh=896907499|bi=ieeeeee
Paper.T02.hmcStep|def|th=70621294|vh=4104294811|bi=ieeeee
Paper.T02.rejProb|def|th=1852655836|vh=503574998|bi=ieeeee
Paper.T02.targetMeas|def|th=2842052545|vh=3780488904|bi=ie
Paper.T02.tvDist|def|th=1662510830|vh=2329294863|bi=iee
```

T02Draft copy:
```
TYPE HASHES (current file, 10 declarations)
Paper.T02.T02_S1|thm|th=3903328519|vh=-|bi=ieeeeee
Paper.T02.T02_S2|thm|th=673669910|vh=-|bi=ieeeeeeeeeeee
Paper.T02.T02_S3|thm|th=1610697241|vh=-|bi=ieeeeeeee
Paper.T02.T02_S4|thm|th=4218063158|vh=-|bi=ieeeeeeeee
Paper.T02.T02_S5|thm|th=339674535|vh=-|bi=eeee
Paper.T02.T02_S6|thm|th=4021163334|vh=-|bi=ieeeeeeeeeeee
Paper.T02.T02_S7'|thm|th=1426458009|vh=-|bi=ieeeee
Paper.T02.T02_S7|thm|th=2862898652|vh=-|bi=ieeeeeeeee
Paper.T02.T02_S8|thm|th=2076197918|vh=-|bi=ieeeeeeeeeee
Paper.T02.T02_main|thm|th=3420249181|vh=-|bi=ieeeeeeeeeeeeeee
```

## Overall

A1, A2, A3 implemented as required; no other statement change. Proof work may begin.

STATEMENT GATE: PASS
