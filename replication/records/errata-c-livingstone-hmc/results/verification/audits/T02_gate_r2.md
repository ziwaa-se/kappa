# T02 (Theorem 5.14, thm:light), statement gate, revision 1, amendment check r2

- Reviewer: pv-gate (claude-opus-5-5), fresh subagent; did not draft T02. Mode: check amendments
  (only the changed parts were reviewed, against `verification/audits/T02_gate.md`).
- Date: Tue Oct 13 11:07:47 EDT 2026 (from `date`).
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T02Stmt.lean`  3413fed69562741660be94ac7497ea85180309b908fb03d66cba601f8eb264eb
    (was 16d0d289...cb3 in `T02_gate.md`: changed, as expected)
  - `pv_work/T02Draft.lean` 66bb8fcc75d59e0b3b87ad352f7421eb2c02be680fd09c4338419744743057e4
    (identical to `T02_gate.md`: not edited, as required)
- Compilation: `scripts/pv_lean.sh check T02Draft` -> `RESULT T02Draft mode=check exit=0 errors=0
  sorry_warnings=18 nonstandard_axiom_lines=0 log=pv_work/logs/T02Draft_8.log olean=none`. EXIT=0.

## G-A1 (the only required change): IMPLEMENTED

- `pv_work/T02Stmt.lean:116-117` now reads
  `∀ x0 p0 : E d, ∃ s : ℝ, 0 < s ∧` /
  `(∫⁻ L : ℕ, ENNReal.ofReal (Real.exp (s * ‖xLF gU eps x0 p0 L‖)) ∂Lmeas) < ⊤`,
  exactly the requested text. The docstring (lines 109-113) mentions `s > 0` and gate G-A1, as requested.
- The clause is no longer vacuous: with `s > 0` it is the A1 exponential-moment condition (TEX:393). It is still
  satisfiable (e.g. any finitely supported `𝔏` with `𝔏{0}=0`, `𝔏{1}>0`), so `A1Law` is not inconsistent.
- Effect on the rest: `A1Law` became stronger (hence `Prop35Rand`, which takes it as a premise, became weaker,
  allowed; and every obligation taking `hA1` as a hypothesis stays true as stated). No obligation's truth is
  affected; the proof route does not use the moment clause (as noted in `T02_gate.md`).

## Any other change? NONE

Decided by `#pv_type_hashes_here`, line by line against the snapshot in `T02_gate.md`:
- `T02Stmt` copy: 17 declarations; the only difference is `Paper.T02.A1Law` `vh` 4116432215 -> 2009345566
  (`th=4147008977`, `bi=ieee` unchanged). All other 16 lines identical (`th`, `vh`, `bi`), including
  `Prop35Rand` `vh=2153272632` (its body refers to `A1Law` by name only).
- `T02Draft` copy: 18 declarations, all identical (`th`, `bi`) to `T02_gate.md`; file hash unchanged.
- Visual check of the Stmt file: the only textual differences are lines 110 (docstring) and 116 (`0 < s ∧`).

## Rulings carried over from `T02_gate.md`

Items 1-7, the TFA table (TFA-1..TFA-6 approved) and the external-parameter table (`Prop35` (ii), `GaussFacts`
(v), `T02_L03Consumed` (p) from L03, `Prop35Rand` (ii)) stand unchanged; the G-A1 reservation on items 1 and 6
is now discharged. Non-blocking coordinator notes in `T02_gate.md` (T01Stmt stale names, Defs docstring errata,
deregistration of `T02_L02Consumed`) remain open and are not gate requirements. Suspected source issues as listed
there (preliminary; none newly found).

## Statement snapshot (verbatim)

Probe files: `pv_work/probes/gate/T02/gate_T02_stmtcopy_rev1_r2.lean` (log
`pv_work/logs/gate_T02_stmtcopy_rev1_r2_1.log`, exit 0, 0 sorry), `pv_work/probes/gate/T02/gate_T02_draftcopy_rev1_r2.lean`
(log `pv_work/logs/gate_T02_draftcopy_rev1_r2_1.log`, exit 0, 18 sorry warnings).

T02Stmt copy:
```
TYPE HASHES (current file, 17 declarations)
Paper.T02.A1Law|def|th=4147008977|vh=2009345566|bi=ieee
Paper.T02.GaussFacts|def|th=3944470172|vh=290450534|bi=
Paper.T02.GeomErgodicRand|def|th=180574848|vh=361667600|bi=ieeee
Paper.T02.GeomErgodic|def|th=4031747299|vh=3856057058|bi=ieeee
Paper.T02.Prop35Rand|def|th=3944470172|vh=2153272632|bi=
Paper.T02.Prop35|def|th=3944470172|vh=2088257911|bi=
Paper.T02.T02_L03Consumed|def|th=4031747299|vh=2775182607|bi=ieeee
Paper.T02.gaussMeas|def|th=2887673794|vh=3528590644|bi=e
Paper.T02.hmcPow.match_1|def|th=413685589|vh=1344119661|bi=eeee
Paper.T02.hmcPowRand|def|th=2859588093|vh=240807773|bi=ieeeeee
Paper.T02.hmcPow|def|th=75357535|vh=896907499|bi=ieeeeee
Paper.T02.hmcStepRand|def|th=3875822958|vh=1052933529|bi=ieeeee
Paper.T02.hmcStep|def|th=70621294|vh=4104294811|bi=ieeeee
Paper.T02.rejProbRand|def|th=2141790769|vh=3480034478|bi=ieeeee
Paper.T02.rejProb|def|th=1852655836|vh=503574998|bi=ieeeee
Paper.T02.targetMeas|def|th=2842052545|vh=3780488904|bi=ie
Paper.T02.tvDist|def|th=1662510830|vh=2329294863|bi=iee
```

T02Draft copy:
```
TYPE HASHES (current file, 18 declarations)
Paper.T02.T02_S1|thm|th=1610348312|vh=-|bi=ieeeeeeeee
Paper.T02.T02_S2|thm|th=864554194|vh=-|bi=ieee
Paper.T02.T02_S3|thm|th=508132016|vh=-|bi=ieeeee
Paper.T02.T02_S4|thm|th=3084686037|vh=-|bi=ieeeeeeeee
Paper.T02.T02_S5|thm|th=723448747|vh=-|bi=ieeeeeeeeeee
Paper.T02.T02_S6|thm|th=4218063158|vh=-|bi=ieeeeeeeee
Paper.T02.T02_S7|thm|th=1426458009|vh=-|bi=ieeeee
Paper.T02.T02_S8|thm|th=2862898652|vh=-|bi=ieeeeeeeee
Paper.T02.T02_S9|thm|th=2076197918|vh=-|bi=ieeeeeeeeeee
Paper.T02.T02_SR1|thm|th=196543438|vh=-|bi=ieeeeee
Paper.T02.T02_SR2|thm|th=2225434574|vh=-|bi=ieeeeee
Paper.T02.T02_SR3|thm|th=841601394|vh=-|bi=ieeeeeeeee
Paper.T02.T02_SR4|thm|th=2426759826|vh=-|bi=ieeeeeeeeee
Paper.T02.T02_SR5'|thm|th=1258322427|vh=-|bi=ieeeeee
Paper.T02.T02_SR5|thm|th=1945612812|vh=-|bi=ieeeeeeeeee
Paper.T02.T02_SR6|thm|th=4260513628|vh=-|bi=ieeeeeeeeeee
Paper.T02.T02_main_randL|thm|th=3672511297|vh=-|bi=ieeeeeeeeeeeeeee
Paper.T02.T02_main|thm|th=463738846|vh=-|bi=ieeeeeeeeeeeeeee
```

## Overall

G-A1 implemented exactly as required; no other change (hash-verified). This snapshot supersedes the one in
`T02_gate.md` for the final audit.

STATEMENT GATE: PASS
