# T02 (Theorem 5.14, thm:light), statement gate, revision 1 (revised manuscript)

- Reviewer: pv-gate (claude-opus-5-5), fresh subagent; did not draft T02.
- Date: Tue Oct 13 11:02:26 EDT 2026 (from `date`).
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T02Stmt.lean`  16d0d2894599f386c1ef54cc45021a7dd144c0d96e5b983a14b19ed72d0f9cb3
  - `pv_work/T02Draft.lean` 66bb8fcc75d59e0b3b87ad352f7421eb2c02be680fd09c4338419744743057e4
- Also read: `pv_work/Defs.lean` (gated), `pv_work/L03Stmt.lean`, `L03_main` signature (`pv_work/L03.lean:345-348`),
  `pv_work/T01Stmt.lean` (consumer), pre-revision gate reports `verification/audits/rev1/T02_gate.md`, `T02_gate_r2.md`,
  draft notes (leads only).
- Compilation: `scripts/pv_lean.sh check T02Draft` -> `RESULT T02Draft mode=check exit=0 errors=0 sorry_warnings=18
  nonstandard_axiom_lines=0 log=pv_work/logs/T02Draft_6.log olean=none`. EXIT=0.

## Source quotations (read directly, `source/geo_erg_HMC_v3.1.tex`)

- Statement TEX:895-909: (17) `lim_{‖x‖→∞} ‖∇U(x)‖/‖x‖ = ∞` (897-899); "there is a fixed `C<∞` such that whenever
  `‖y‖ ≥ 3‖x‖ ≥ C` then (18) `‖∇U(y)‖ ≥ 3‖∇U(x)‖`" (900-903, revised from `2‖x‖`); (19)
  `lim_{‖x‖→∞, ‖y‖≥2^L‖x‖} (U(x)−U(y)−½‖x‖²) = −∞` (905-907); "then the HMC method with fixed integration time
  `T = Lε` does not produce a geometrically ergodic Markov chain for any choice `T>0`" (908).
- Proof TEX:911-932: fix `δ<1`; Lemma arate_0 gives `sup_{‖p_0‖≤‖x_0‖^δ} α → 0`; `μ_G(‖p_0‖>‖x_0‖^δ) → 0`;
  `1−r(x_0) = ∫α(x_0,x_{Lε}) μ_G(dp_0) ≤ sup α + μ_G(tail) → 0`; so `r → 1`, and Prop. prop:supr gives non-GE.
- Proof TEX:934-940 (new in this revision; absent from `verification/source_baseline_v1/`, grep "dominated
  convergence" no hit): "When the number of leapfrog steps is drawn from a position-independent distribution `𝓛(·)`
  as in Assumption A1, the same conclusion follows provided the above argument is applied conditional on each fixed
  `L`. For each fixed `L` the conditional acceptance probability tends to zero, while it is bounded by one. Since
  the law of `L` does not depend on `x_0`, dominated convergence with respect to `𝓛(·)` shows that the
  unconditional acceptance probability also tends to zero."
- Lemma arate_0 TEX:1011-1016: under (17),(18),(19), for any `δ<1`, `lim_{‖x_0‖→∞, ‖p_0‖≤‖x_0‖^δ} α(x_0,x_{Lε}) = 0`.
- Definitions: notation, `X = R^d`, `π` finite with Lebesgue density, `𝔏` a distribution on `ℤ_+`, `μ^G`, `P^n`
  (TEX:192); eqn:geoerg (TEX:266-268); MH type (TEX:274-279); Prop. 3.5 (TEX:300-303, cited from
  roberts1996geometric, TEX:298); `π ∝ e^{−U}`, `U` differentiable (TEX:320, 324); leapfrog, `ε>0` (TEX:331-336);
  Algorithm 1 (TEX:338-352; `L ~ 𝔏`, `T = Lε`); `M = I` (TEX:354-356); acceptance (TEX:366-369); A1 (TEX:393):
  "`P_𝔏[L=1]>0`, and for any fixed `(x_0,p_0)` and `ε>0`, and that there is an `s<∞` such that
  `E_𝔏[e^{s‖x_{Lε}‖}] < ∞`"; TEX:411 (results stated for fixed `L`, averaged under A1).

## Item 1 — Hypotheses: PASS (fixed L); PASS_WITH_AMENDMENT (random L, see G-A1)

- `T02_main`: (17) `HypExplode gU`, (18) `Paper.L03.HypOscillations3 gU` (gated with L03; `∃ C, ∀ x y,
  3‖x‖ ≤ ‖y‖ → C ≤ 3‖x‖ → 3‖gU x‖ ≤ ‖gU y‖` = TEX:900-903 revised), (19) `HypOscillation2 U L` (same `L`; `2^L`
  as printed at 906). Correct and faithful to the revision.
- Extra premises `0<d`, `IsGradField U gU`, `∫⁻ e^{−U} < ∞`, `0<eps`, `1≤L`: TFAs approved before, unchanged.
  `U ≥ 0` (TEX:320) omitted: generalisation, unused by the route (as in the pre-revision gate).
- No `variable`s, structures or classes; imported defs inspected. No conclusion-as-hypothesis.
- `T02_main_randL`: (17), (18) as above; (19) and the L03 clause for each `l ≥ 1` with `𝔏{l} ≠ 0` (TFA-6);
  `A1Law` encodes A1 plus `𝔏` probability, `𝔏{0} = 0` (TFA-5). **Defect:** in `A1Law` the exponential-moment
  clause `∀ x0 p0, ∃ s : ℝ, ∫⁻ e^{s‖x_{Lε}‖} d𝔏 < ⊤` is vacuous (take `s = 0`: the integral is `𝔏(ℕ) = 1`), so A1's
  second clause is in effect not encoded. The source's `s` is a positive exponent (Lyapunov `e^{s‖x‖}`, TEX:451;
  `s<∞` only makes sense as a positive rate). Required change G-A1. (The proof does not use this clause, so the
  amendment does not affect provability; it is needed for fidelity of `A1Law` and of the premise of `Prop35Rand`.)

## Item 2 — Conclusion: PASS

- `¬ GeomErgodic U gU eps L`: definition unchanged from the gated pre-revision version (identical `th/vh/bi`).
- `¬ GeomErgodicRand U gU eps Lmeas`: same shape as `GeomErgodic` with the mixture kernel
  `hmcStepRand = 𝔏.bind (L ↦ hmcStep L x)` (Algorithm 1 draws `L ~ 𝔏` independently of `p_0`, TEX:343) and
  `hmcPowRand` the same recursion as `hmcPow` (TEX:192). Faithful. No clause missing.

## Item 3 — Quantifiers and constants: PASS

`eps`, `L` (resp. `Lmeas`) are parameters; "for any choice `T>0`" handled as before (all `ε>0`, `L≥1`). In S1/S5/
SR3 `R` is chosen after `U, gU, eps, L, δ, κ`, matching TEX:911-932.

## Item 4 — Domains and details: PASS

`X = R^d` non-periodic, `d ≥ 1` TFA; esssup w.r.t. `π` (fair, `π ~` Lebesgue); `𝔏` on `ℕ` (discrete σ-algebra,
every `L ↦ hmcStep L x` measurable, so `hmcStepRand` is not degenerate). Measurability of `hmcStep` under
`hgrad` as in the pre-revision gate. `ℝ≥0∞/ℝ`: `ENNReal.ofReal (rejProbRand …)` with `rejProbRand ∈ [0,1]`; no
truncation trap. Bochner `∫` of a non-integrable function is `0`; I checked each obligation below against this.

## Item 5 — Step obligations: PASS (all true as stated; none smuggles the goal)

| Step | Source | True as stated? | Note |
|---|---|---|---|
| S1 | TEX:911-916 | yes: `Concl` = Tendsto along `comap‖·‖ atTop ⊓ 𝓟 region` gives the uniform form | `δ<1` only, fine |
| S2 | TEX:917-921 | yes, from `GaussFacts` (a)(b), `δ>0` | |
| S3 | TEX:922-925 | yes, definitional | |
| S4 | TEX:926-931 | yes: `h` at `p=0` forces `κ ≥ 0`; `α ≤ κ·1_R + 1_T` pointwise; non-integrable case gives `0` | |
| S5 | TEX:932 (first half) | yes, S4 with `κ/2` and S2 | |
| S6 | TEX:274-279 (implicit) | yes, needs `hE6`(a) and `hgrad` (both present) | unchanged from gated old S4 (same `th`) |
| S7 | `r ≤ 1` | yes, unconditionally (`integral_nonneg`) | = old S7' (same `th`) |
| S8 | `r→1 ⇒ esssup r = 1` | yes with `hgrad` (`Z ∈ (0,∞)`, `π{‖x‖>R}>0`, `d≥1`) | = old S7 after amendment A2 (same `th`) |
| S9 | TEX:932 (Prop. 3.5) | yes, instance of `hE1` | = old S8 (same `th`) |
| SR1 | TEX:936-938 | yes (S1+S2+S4 argument for fixed `l`); no `1 ≤ l` needed since `hL03` is assumed | |
| SR2 | TEX:938-940 | yes: on `ℕ`, `∫ f_l d𝔏 = Σ f_l 𝔏{l}`, tail mass small, uncharged `l` contribute 0 | |
| SR3 | not printed | yes (definition of `rejProbRand`, comap filter) | |
| SR4 | not printed (MH type) | yes (`ℕ` discrete; bounded integrands, `𝔏` probability via `hA1`) | |
| SR5 | not printed | yes, as S8 | |
| SR5' | not printed | yes (nonneg double integral) | `hA1` unused, harmless |
| SR6 | TEX:936 "same conclusion" | yes, instance of `hE1 : Prop35Rand` | |

Assembly (fixed `L`): `δ = 1/2`; S1(`hL03`) -> `hS1`; S5 -> `h5`; S7 -> `hle`; S8 -> esssup = 1; S9 -> goal; all
premises are in `T02_main`. Assembly (random `L`): SR1 for each charged `l` (charged `l ≥ 1` by `𝔏{0}=0`) ->
`hlim` of SR2 with `f l x = ∫ α_l dμ_G ∈ [0,1]`; SR3; SR5'; SR5; SR6. All premises in `T02_main_randL`. (17), (18),
(19) are formally unused beyond justifying the consumed clause: expected (L03 consumed).

## Item 6 — External parameters: PASS (with G-A1 affecting the premise of `Prop35Rand`)

- **`Prop35`** (E1, (ii) per project instruction): `vh=2088257911`, identical to the gated version; still faithful
  (specialisation of TEX:300-303, weaker than printed; true as encoded by the elementary argument
  `P^n(x,{x}) ≥ r(x)^n`, `π{x} = 0`, recorded in `rev1/T02_gate.md` item 6).
- **`GaussFacts`** (E6, (v)): `vh=290450534`, identical; still faithful; mathlib evidence as recorded pre-revision.
- **`T02_L03Consumed`** ((p), predecessor L03): `∀ δ<1, Paper.L03.Concl U gU eps L δ` is literally the conclusion
  of `L03_main` (`pv_work/L03.lean:348`), not stronger. Location: L03 = Lemma 5.17, TEX:1011-1016,
  `Paper.L03.Concl` / `L03_main`. Applicability: L03 needs `heps`, `hL`, `hexp`, `hosc : HypOscillations3`, `hosc2`,
  all hypotheses of `T02_main` with the same `U, gU, eps, L` (and for `T02_main_randL`: per charged `l`, with
  `l ≥ 1`, `hosc2 l`). Named `T02_L03Consumed`, in `T02Stmt.lean`, `namespace Paper.T02`, not declared elsewhere.
  L03's own `L03_L02Consumed` is inherited at reconnection; L02 is now UNCONDITIONAL per the coordinator, so this
  clause is (p) and becomes dischargeable once L03 is final. Approved.
- **`Prop35Rand`** (E1', (ii)): Prop. 3.5 specialised to the mixture kernel `hmcStepRand`, premises standing
  conventions plus `A1Law`. Not stronger than the printed Prop. 3.5 (extra premises only); it is how TEX:934-940
  uses Prop. 3.5 ("the same conclusion follows" needs Prop. 3.5 for the random-`L` kernel). Not goal-shaped: its
  hypothesis `esssup r = 1` is what SR1-SR5 establish. True as encoded (same elementary argument:
  `hmcStepRand x {x} ≥ r(x)`, hence `P^n(x,{x}) ≥ r(x)^n`; if `x ↦ hmcStepRand x` were non-measurable the `bind`
  would give `0` and non-GE is immediate). Declared only in `T02Stmt.lean`, `namespace Paper.T02`, new name.
  Approved; register as new tool `T02_Prop35Rand`, provenance (ii), human check as for `Prop35` plus "the
  `𝔏`-mixture HMC kernel counts as MH type".

## Decision on the random-L claim (focus (a)): KEEP, with amendment G-A1

TEX:934-940 is an explicit mathematical claim of the revised proof (new in this revision). Omitting it would leave
part of the source unchecked; adding it is not "a statement the source does not contain". It is correctly kept
**separate** from `T02_main` (the printed theorem is for fixed `T = Lε`, TEX:908). Its verdict should be reported
as a secondary clause of T02 (a partial pass of one is not a pass of the other).

## Item 7 — Doubts about the source (preliminary only)

1. TEX:905-907 vs 934-940: (19) contains `L`; the random-`L` paragraph needs it "conditional on each fixed `L`".
   Derivable: (19) for `L = 1` implies it for every `l ≥ 1` (region `‖y‖ ≥ 2^l‖x‖` shrinks, filter finer) and A1
   gives `P[L=1]>0`. Preliminary FAIR_IMPLICIT_STEP / EDITORIAL. Dispatch optional, low priority.
2. TEX:908 vs 934-940: the theorem is stated for fixed `T = Lε`, the proof asserts the random-`L` case too.
   Preliminary EDITORIAL. No dispatch needed.
3. TEX:932: `r(x_0) → 1` to `esssup r = 1` (needs `π{‖x‖>R}>0`), and identification of the HMC kernels as MH type
   (TEX:274-279 with α from eqn:accept, whereas HMC's α depends on `p_0`). Preliminary FAIR_IMPLICIT_STEP, possibly
   DOMAIN_CLARIFICATION. Low priority (unchanged from the pre-revision gate).
4. TEX:393: A1 sentence is garbled ("for any fixed `(x_0,p_0)` and `ε>0`, and that there is an `s<∞`"); positivity
   of `s` and the order of quantifiers are implicit. Preliminary EDITORIAL; irrelevant to this proof.
5. `d = 0` degenerate: excluded by TFA-2, not a paper issue.

## TFA table

| TFA | Premise | Ruling | Reason |
|---|---|---|---|
| TFA-1 | `0 < eps`, `1 ≤ L` | approved | `ε>0` TEX:336; `T = Lε > 0` TEX:908 |
| TFA-2 | `0 < d` | approved | `X = R^d` (TEX:192); `d=0` degenerate, not discussed |
| TFA-3 | `IsGradField U gU` | approved | `U` differentiable, `∇U` (TEX:324, 332) |
| TFA-4 | `∫⁻ e^{−U} < ∞` | approved | `π` finite target / probability density (TEX:192, 320) |
| TFA-5 | `𝔏` probability, `𝔏{0} = 0` | approved | "distribution over `ℤ_+`" (TEX:192), number of leapfrog steps `≥ 1` (TEX:404); `L = 0` is the trivial proposal `x_{0}=x_0` with `α = 1`, not discussed |
| TFA-6 | (19) and L03 clause for each `l ≥ 1` with `𝔏{l} ≠ 0` | approved | the reading "applied conditional on each fixed `L`" (TEX:936-937); equivalent, given A1's `P[L=1]>0`, to (19) for `L = 1` (monotonicity in `L`), so no substantive addition |

## External parameter table

| Name | Type | Ruling |
|---|---|---|
| `Paper.T02.Prop35` | (ii) | approved, unchanged (`vh` identical) |
| `Paper.T02.GaussFacts` | (v) | approved, unchanged (`vh` identical) |
| `Paper.T02.T02_L03Consumed` | (p), predecessor L03 (TEX:1011-1016, `Paper.L03.Concl`/`L03_main`) | approved |
| `Paper.T02.Prop35Rand` | (ii) | approved (new), premise `A1Law` to be fixed by G-A1 |
| `Paper.T02.T02_L02Consumed` | (p) | removed; must be deregistered from `EXTERNAL_TOOLS.md` |

## Required changes

- **G-A1 (`pv_work/T02Stmt.lean:116-117`, `A1Law`).** Replace
  `∀ x0 p0 : E d, ∃ s : ℝ,` / `(∫⁻ L : ℕ, ENNReal.ofReal (Real.exp (s * ‖xLF gU eps x0 p0 L‖)) ∂Lmeas) < ⊤`
  by
  `∀ x0 p0 : E d, ∃ s : ℝ, 0 < s ∧` / `(∫⁻ L : ℕ, ENNReal.ofReal (Real.exp (s * ‖xLF gU eps x0 p0 L‖)) ∂Lmeas) < ⊤`
  and mention `s > 0` in the docstring (lines 109-113). Reason: without `0 < s` the clause is vacuous (`s = 0`).
  No other line changes; `T02Draft.lean` needs no edit (`A1Law` is used only by name).

No other change requested. Non-blocking notes for the coordinator (not gate requirements):
- `pv_work/T01Stmt.lean:9` docstring still names the removed `T02_L02Consumed`, and `T01Stmt.lean:34`
  (`HypPartI`) uses the stale `Paper.Defs.HypOscillations` (`2‖x‖`) while `T02_main` now takes
  `Paper.L03.HypOscillations3` (`3‖x‖`, TEX:900-903). The old form implies the new one (take `C' = max(3C/2, 0)`),
  so reconnection is possible, but T01 should be re-drafted against the revised (18). T01's docstring at lines 43-45
  says random `L` is not covered; `T02_main_randL` now exists.
- `pv_work/Defs.lean:73-89` docstrings cite pre-revision TEX lines (865-874): a `DOC_ERRATA.md` entry.

## Fingerprint comparison with the pre-revision snapshot (`verification/audits/rev1/T02_gate_r2.md`)

Decided by `#pv_type_hashes_here` output, line by line:
- **Unchanged (identical `th`, `vh`, `bi`)**: `gaussMeas`, `targetMeas`, `rejProb`, `hmcStep`, `hmcPow`,
  `hmcPow.match_1`, `tvDist`, `GeomErgodic`, `Prop35`, `GaussFacts`. These are the T02 names T01/C01 use
  (`GeomErgodic`, `targetMeas`, `hmcStep`, plus docstring mentions of `Prop35`, `GaussFacts`).
- **Removed**: `T02_L02Consumed` (th=1855146743, vh=3334301295). No code in T01Stmt/C01Stmt uses it (only the
  T01Stmt docstring).
- **New**: `T02_L03Consumed`, `A1Law`, `rejProbRand`, `hmcStepRand`, `hmcPowRand`, `GeomErgodicRand`, `Prop35Rand`.
- **Main theorem changed**: `T02_main` th 3420249181 -> 463738846 (`bi` unchanged): consumed clause L02 -> L03
  and (18) `Defs.HypOscillations` -> `L03.HypOscillations3`. Under the cascade rule, consumers of `T02_main`
  (T01 part (i), C01 if it reconnects through `T02_main`) are affected.
- `HypPartII` is declared in `T01Stmt.lean:37`, not in T02; it does not depend on any changed T02 name.
- Step obligations renumbered: old S4/S7'/S7/S8 are now S6/S7/S8/S9 with identical `th`; S1-S5 changed; SR* and
  `T02_main_randL` new.
- G-A1 will change `vh` of `A1Law` only (expected); everything else listed here should be unchanged in `_r2`.

## Statement snapshot (verbatim)

Probe files: `pv_work/probes/gate/T02/gate_T02_stmtcopy_rev1.lean` (log `pv_work/logs/gate_T02_stmtcopy_rev1_1.log`,
exit 0, 0 sorry), `pv_work/probes/gate/T02/gate_T02_draftcopy_rev1.lean` (log
`pv_work/logs/gate_T02_draftcopy_rev1_1.log`, exit 0, 18 sorry warnings). (Suffix `_rev1` so the pre-revision
probe files stay intact.)

T02Stmt copy:
```
TYPE HASHES (current file, 17 declarations)
Paper.T02.A1Law|def|th=4147008977|vh=4116432215|bi=ieee
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
(Pre-amendment snapshot; after G-A1 only `A1Law`'s `vh` is expected to change. Re-snapshot in `T02_gate_r2.md`.)

## Overall

Items 1-7 PASS except the vacuous A1 moment clause in `A1Law` (G-A1). `T02_main` (fixed `L`) is faithful as it
stands; `T02_main_randL` is kept and is faithful after G-A1. An amendment check (`T02_gate_r2.md`) is required.

STATEMENT GATE: PASS_WITH_AMENDMENTS
