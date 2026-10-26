# T02 (Theorem 5.14, thm:light) — independent statement gate

- Reviewer: pv-gate (claude-opus-5-5), fresh subagent; did not draft T02.
- Date: 2026-10-13 01:19 EDT (from `date`).
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/T02Stmt.lean`  1f52792d965224cea96f6da59ff5fc89dd9ef2bfb5bb9c4c5feaffabe2bb0bca
  - `pv_work/T02Draft.lean` a63574ae19612ea8c859385d408bc6c4cf08eba040670d79461b281615655638
- Also read: `pv_work/Defs.lean` (gated), `pv_work/L02Stmt.lean`, `pv_work/L03Stmt.lean`, `L03_main` signature
  (`pv_work/L03.lean:330`), `verification/audits/L02_issue_1.md` §6-7, INVENTORY §7 (E1, E6, X1, X2) and N3,
  draft notes (leads only).
- Compilation: `scripts/pv_lean.sh check T02Draft` -> `RESULT T02Draft mode=check exit=0 errors=0 sorry_warnings=10
  nonstandard_axiom_lines=0 log=pv_work/logs/T02Draft_2.log`. EXIT=0.

## Source quotations (read directly)

- Statement, TEX:863-877: "If (eqn:explode) `lim_{‖x‖→∞} ‖∇U(x)‖/‖x‖ = ∞`, and there is a fixed `C<∞` such that
  whenever `‖y‖ ≥ 2‖x‖ ≥ C` then (eqn:oscillations) `‖∇U(y)‖ ≥ 3‖∇U(x)‖`, and (eqn:oscillation2)
  `lim_{‖x‖→∞, ‖y‖≥2^L‖x‖} (U(x) − U(y) − ½‖x‖²) = −∞`, then the HMC method with fixed integration time `T = Lε`
  does not produce a geometrically ergodic Markov chain for any choice `T>0`."
- Proof, TEX:879: Lemmas xelower/xlower give `‖x_{Lε}‖ ≥ 2^L‖x_0‖`; Lemma arate_0 gives `α(x_0,x_{Lε}) → 0` as
  `‖x_0‖→∞` provided `‖p_0‖ ≤ ‖x_0‖^δ`, `δ<1`, "allowing Proposition prop:supr to be envoked. To conclude we simply
  note that `P(‖p_0‖ ≤ ‖x_0‖^δ) → 1`".
- Geometric ergodicity, TEX:265-268: `∃ρ<1` and a `π`-a.e. finite `M : X → [0,∞]` with `‖P^n(x,·) − π‖_TV ≤ M(x)ρ^n`.
- TV, `P^n`, `μ^G`, `X = R^d`: TEX:192-194.
- MH type, TEX:274-279: `P(x,dy) = α(x,y)Q(x,dy) + r(x)δ_x(dy)`, `r(x) = 1 − ∫α(x,y)Q(x,dy)`; α from eqn:accept
  (TEX:163-167, density-ratio form).
- Prop 3.5, TEX:300-303: "If P is of MH type, then (eqn:geoerg) fails to hold if `esssup r(x) = 1`." Cited from
  roberts1996geometric (TEX:298); printed with no further hypotheses (Prop 3.3 conditions TEX:283-288 not repeated).
- Target / U: TEX:320 "`π(x) ∝ e^{−U(x)}` for some `U : X → [0,∞)`"; TEX:324 "Provided U(x) is differentiable";
  leapfrog TEX:331-336 "for some step-size `ε>0`"; Algorithm 1 TEX:338-352; `M = I` TEX:354-356; Prop 4.2 TEX:361-374.
- Predecessors: L01 TEX:884-886, L02 TEX:899-901 (proof 903-935, intermediate bound TEX:934), L03 TEX:939-944.

## Item 1 — Hypotheses: PASS (with amendment A1 on the consumed clause, see item 6)

- (17), (18), (19) -> `HypExplode gU`, `HypOscillations gU`, `HypOscillation2 U L` (gated in Defs); (19) uses the
  same `L` as the kernel (N3). Correct.
- Extra premises `0<d`, `IsGradField U gU`, `∫⁻ e^{−U} < ∞`, `0<eps`, `1≤L`: all TFAs (table below).
- Source hypothesis not encoded: `U ≥ 0` (TEX:320). Omitting it generalises the theorem; the proof route never uses
  it (only ratios `π(y)/π(x)` and the normalisation enter). Acceptable; noted.
- No hidden hypotheses: no `variable`s, structures or classes; imported defs inspected.
- No conclusion-as-hypothesis: `Prop35` concludes `¬GeomErgodic` but only under `esssup r = 1`, which is the cited
  result's own form and is exactly what T02 must establish (see item 6).

## Item 2 — Conclusion: PASS

`¬ GeomErgodic U gU eps L` with `GeomErgodic` = TEX:266-268: `∃ ρ ∈ [0,1)`, `M : X → [0,∞]` π-a.e. finite,
`∀ x n, tvDist(P^n(x,·), π) ≤ M(x) ρ^n`. `ρ ≥ 0` is harmless (ρ<0 gives no extra content); `tvDist = sup_A |μA−νA|`
differs from the `sup_{|f|≤1}` convention (TEX:194) by the factor 2, absorbed in `M`, so `GeomErgodic` is
equivalent. `hmcStep` = Algorithm 1 with fixed `L`, `p_0 ~ N(0,I)`, acceptance `accProb` (Defs, gated); `hmcPow` =
TEX:192 recursion. `π` normalised (`targetMeas`). No clause missing.

## Item 3 — Quantifiers / constants: PASS

`eps`, `L` are theorem parameters (∀). "for any choice `T>0`" (TEX:876): every `T>0` is `Lε` with `ε>0`, `L≥1`;
since (19) carries `2^L`, the hypothesis set depends on `L`, and the Lean form "∀ ε>0, L≥1, (19 for this L) ->
not GE" covers both readings (fixed `L` and varying `ε`, or varying both). Constants of the obligations (η, R)
chosen after `gU, eps, L, δ`, matching TEX:879 and the fixed-δ reading of L01-L03. See suspected issue 3 (minor).

## Item 4 — Domains and details: PASS

- `X = R^d`, `E d = EuclideanSpace ℝ (Fin d)`, non-periodic; `d ≥ 1` as TFA.
- `esssup` taken w.r.t. `π` (source does not say; π ~ Lebesgue since `e^{−U} > 0`): fair.
- Measurability: `hmcStep`/`hmcPow` use `Measure.bind`, which collapses to `0` for non-measurable kernels. Under
  `IsGradField U gU`, `gU = gradient U` is measurable (fderiv is measurable), hence `xLF`, `accProb`, the kernel are
  measurable; the main theorem carries `hgrad`, so the definitions are non-degenerate. The final auditor should
  confirm the proof does not exploit a degenerate `bind`.
- `ℝ≥0∞`/`ℝ`: `ENNReal.ofReal (rejProb …)`, `rejProb ∈ [0,1]` for measurable α (S7' gives `≤ 1` unconditionally);
  `toReal` in `tvDist` only on finite (probability) measures. No truncation trap found.
- `R ^ δ` is `Real.rpow`; for `R → ∞`, `δ > 0` fine.

## Item 5 — Step obligations: FAIL as drafted (one obligation false as stated; fixed by A2)

| Step | Source | True as stated? | Notes |
|---|---|---|---|
| S1 | TEX:879 sentence 1 | yes (from `hL02` part (a) = `L02.ConclFixedDelta`) | faithful |
| S2 | TEX:879 "Lemma arate_0 shows…" | yes (= `Paper.L03.L03_main`) | faithful |
| S3 | implicit unpacking of limit | yes (filter definition of `tailMomFilter`) | FAIR_IMPLICIT_STEP |
| S4 | TEX:274-279 used at 879 | yes (needs `hE6`(a) and measurability from `hgrad`, both present) | MH form of the kernel |
| S5 | TEX:879 "we simply note" | yes (from `hE6`(b)) | |
| S6 | X1 part 1 | yes (`r ≥ 1 − κ/2 − P(‖p‖>‖x‖^δ)`; `δ>0` and `hgrad` present) | X1 |
| S7 | X1 part 2 | **NO — false as stated** | see below |
| S7' | `α ≥ 0` | yes, unconditionally (Bochner integral of a nonnegative function is `≥ 0` even if not integrable) | |
| S8 | TEX:879 "allowing Prop 3.5 to be envoked" | yes (direct instance of `hE1`) | |

**S7 is false as stated.** It has no measurability/differentiability premise on `U`. Take `d = 1` and a partition of
ℝ into countably many pairwise disjoint sets `B_1, B_2, …` each of full outer Lebesgue measure (Bernstein-type
construction, ZFC); put `U := n` on `B_n`. Every set `{e^{−U} > c}` is a finite union of `B_n`'s, whose complement
has full outer measure, so it has inner measure 0; hence `∫⁻ ofReal(e^{−U}) = 0` (`hπ` holds), `targetMeas U =
0⁻¹ • 0 = ⊤ • 0 = 0`, and `essSup _ 0 = 0 ≠ 1`. For this `U`, `accProb` is non-measurable in `p` for suitable `gU`
(e.g. `gU = 0`, `xLF = x + Lεp`), so the Bochner integral is `0`, `rejProb ≡ 1`, and `h6`, `hle` hold. With
`IsGradField U gU` (U differentiable, so continuous and measurable) the obligation is true: `Z = ∫⁻ e^{−U} ∈ (0,∞)`,
`π{‖x‖>R} > 0` for every `R` (open nonempty set as `d ≥ 1`, positive density), so `essSup ≥ 1 − κ` for all `κ`, and
`≤ 1` by `hle`. This is a formalization defect of the obligation (LESSONS 10 pattern), not a paper issue.

Assembly: fix `δ = 1/2`; S2 -> `h`; S6 (∀κ) -> `h6`; S7' -> `hle`; S7 (amended) -> `esssup = 1`; S8 -> conclusion.
All premises (`hd, hgrad, hπ, heps, hL, hE1, hE6, hL02, hexp, hosc, hosc2`) are available in `T02_main`. The
obligations do not smuggle in the conclusion or a stronger intermediate.

## Item 6 — External parameters: PASS_WITH_AMENDMENTS (A1, A3)

- **`Prop35`** (E1). Specialised to the HMC kernel with standing conventions as extra premises: weaker than the
  printed Prop 3.5 (which is for any MH-type kernel). Not goal-shaped in the forbidden sense: its hypothesis
  `esssup r = 1` is the substantive step T02's proof must establish (S6, S7); it is the literal content of the cited
  result. Truth check: as encoded it is true — `hmcPow x n {x} ≥ r(x)^n` and `π{x} = 0` give
  `tvDist ≥ r(x)^n`, so `M(x)ρ^n ≥ r(x)^n` for all `n` forces `r(x) ≤ ρ` wherever `M(x) < ∞`, i.e. π-a.e., contradicting
  `esssup r = 1`. So no hidden false parameter. Provenance: the docstring says (i); the project registers
  out-of-scope numbered results as **(ii) by user instruction** (INVENTORY.md:28, :179, :183). Amendment A3.
- **`GaussFacts`** (E6), type (v): (a) `gaussMeas d` probability; (b) `P(‖p‖ ≤ R^δ) → 1` for `δ>0`. Both true for all
  `d` (including `d=0`). Evidence checked by me: grep in `.lake/packages/mathlib/Mathlib/Probability` and
  `Analysis/SpecialFunctions/Gaussian` for `stdGaussian|multivariateGaussian` -> no hit; only 1-D `gaussianPDF`
  (`Probability/Distributions/Gaussian.lean:159`) and Gaussian integrals on `EuclideanSpace`
  (`Analysis/SpecialFunctions/Gaussian/FourierTransform.lean:257,302`). (v) is justified (proving it needs
  infrastructure, pieces exist). Approved.
- **Consumed clause of L02 (reuse of `Paper.L03.L03_L02Consumed`)**: content is correct and not stronger than
  L02: part (a) = L02's printed conclusion (fixed-δ), part (b) = the bound L02 proves at TEX:934 (`L02_S10`);
  applicability: L02's hypothesis (17) and the (18) used in its proof are `hexp`, `hosc` of T02. T02 needs both
  parts because S2 calls `L03_main`, which is conditional on exactly this clause. However the reuse violates the
  naming/location rule (POLICY rule card; PIPELINE.md:70, :75; VERDICTS §4.1 (p)): a consumed clause must be named
  `<ID>_<PredID>Consumed` = `T02_L02Consumed`, declared in `T02Stmt.lean` in `namespace Paper.T02`, using only names
  from `Defs*` and `L02Stmt` (not `L03Stmt`). Reconnection (PIPELINE stage 6b) and the per-consumer registry depend
  on this. Amendment A1. Note for registration: L02's final audit suggests verdict ISSUE (PAPER_ARGUMENT_GAP,
  non-threatening, `L02_issue_1.md`); if L02 is recorded ISSUE, this clause counts as (iv) with predecessor L02.

## Item 7 — Doubts about the source: recorded, preliminary only

1. TEX:879 (X1): passage from "α → 0 on `{‖p_0‖ ≤ ‖x_0‖^δ}`" plus the Gaussian tail fact to "`esssup r = 1`", and the
   identification of the HMC kernel as MH type (eqn:mhtype with α from eqn:accept needs densities; HMC's α depends
   on `p_0`). Preliminary: FAIR_IMPLICIT_STEP, possibly EXPOSITION_GAP. Low priority for pv-issue-checker.
2. TEX:300-303: Prop 3.5 printed without Prop 3.3's conditions. Preliminary: likely not an issue for T02 — the
   specialisation used here is true by the elementary argument in item 6. Optional dispatch.
3. TEX:876: "for any choice T>0" with `L` appearing in (19): preliminary EDITORIAL / DOMAIN_CLARIFICATION (minor);
   the Lean form covers every `(ε, L)`. No dispatch needed.
4. `d = 0`: degenerate, excluded by TFA; not a paper issue (FAIR, X = R^d means d ≥ 1).

## TFA table

| TFA | Premise | Ruling | Reason |
|---|---|---|---|
| TFA-1 | `0 < eps`, `1 ≤ L` | approved | `ε>0` TEX:336; `T = Lε > 0` TEX:876 with `L ∈ ℕ` forces `L ≥ 1` |
| TFA-2 | `0 < d` | approved | `X = R^d` (TEX:192) is a dimension ≥ 1; `d=0` is the degenerate one-point space (theorem false there, chain stationary), not discussed |
| TFA-3 | `IsGradField U gU` | approved | `∇U` presupposes differentiable U (TEX:324, 332) |
| TFA-4 | `∫⁻ e^{−U} < ∞` | approved | π finite target (TEX:192), probability density `∝ e^{−U}` (TEX:320) |

## External parameter table

| Name | Type | Ruling |
|---|---|---|
| `Paper.T02.Prop35` | (ii) per project instruction (cited (i) location TEX:298) | approved; provenance label to fix (A3) |
| `Paper.T02.GaussFacts` | (v) | approved |
| `Paper.L03.L03_L02Consumed` (reused) | (p), predecessor L02 | content approved; **rejected as named/located** -> A1 |

## Required changes

- **A1 (T02Stmt.lean / T02Draft.lean).** In `T02Stmt.lean` add `import L02Stmt` and declare, in `namespace Paper.T02`,
  `def T02_L02Consumed {d : ℕ} (gU : E d → E d) (eps : ℝ) (L : ℕ) : Prop :=
  Paper.L02.ConclFixedDelta gU eps L ∧ ∀ δ : ℝ, δ < 1 → ∃ η : ℝ, ∀ x0 p0 : E d, η < ‖x0‖ → ‖p0‖ ≤ ‖x0‖ ^ δ →
  ∀ i : ℕ, 1 ≤ i → i ≤ L → 2 * ‖xLF gU eps x0 p0 (i - 1)‖ ≤ ‖xLF gU eps x0 p0 i‖`
  (same content as `L03_L02Consumed`, so `L03_main` accepts it by unfolding), with a docstring giving provenance (p),
  predecessor L02, location (`Paper.L02.ConclFixedDelta`, `L02_S10`, TEX:899-901, 934) and applicability ((17),(18)
  = `hexp`, `hosc`). Update the module docstring line 13. In `T02Draft.lean` remove line 6
  (`open Paper.L03 (L03_L02Consumed)`) and replace `L03_L02Consumed` by `T02_L02Consumed` at lines 20, 31, 41
  (keep `hL02` first in `T02_main`).
- **A2 (T02Draft.lean, `T02_S7`, line 86-89).** Add the premise `(hgrad : IsGradField U gU)` (e.g. after `(hd : 0 < d)`).
  Without it S7 is false as stated (item 5).
- **A3 (T02Stmt.lean docstrings lines 11 and 68).** Label `Prop35` as provenance (ii) per the project instruction
  (INVENTORY.md:28, 179), keeping the note that it is cited from roberts1996geometric (TEX:298). Docstring only;
  `vh` unchanged.

No other change is requested; the definitions `gaussMeas, targetMeas, rejProb, hmcStep, hmcPow, tvDist, GeomErgodic,
Prop35, GaussFacts` and the obligations other than S7 (and the renaming in A1) are approved as they stand.

## Statement snapshot (verbatim, from `pv_work/logs/gate_T02_stmtcopy_1.log` and `gate_T02_draftcopy_1.log`)

Probe files: `pv_work/probes/gate/T02/gate_T02_stmtcopy.lean` (exit 0, 0 sorry),
`pv_work/probes/gate/T02/gate_T02_draftcopy.lean` (exit 0, 10 sorry warnings).

T02Stmt copy:
```
TYPE HASHES (current file, 10 declarations)
Paper.T02.GaussFacts|def|th=3944470172|vh=290450534|bi=
Paper.T02.GeomErgodic|def|th=4031747299|vh=3856057058|bi=ieeee
Paper.T02.Prop35|def|th=3944470172|vh=2088257911|bi=
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
Paper.T02.T02_S1|thm|th=229025027|vh=-|bi=ieeeeee
Paper.T02.T02_S2|thm|th=138878381|vh=-|bi=ieeeeeeeeeeee
Paper.T02.T02_S3|thm|th=1610697241|vh=-|bi=ieeeeeeee
Paper.T02.T02_S4|thm|th=4218063158|vh=-|bi=ieeeeeeeee
Paper.T02.T02_S5|thm|th=339674535|vh=-|bi=eeee
Paper.T02.T02_S6|thm|th=4021163334|vh=-|bi=ieeeeeeeeeeee
Paper.T02.T02_S7'|thm|th=1426458009|vh=-|bi=ieeeee
Paper.T02.T02_S7|thm|th=3787073306|vh=-|bi=ieeeeeeee
Paper.T02.T02_S8|thm|th=2076197918|vh=-|bi=ieeeeeeeeeee
Paper.T02.T02_main|thm|th=2186627870|vh=-|bi=ieeeeeeeeeeeeeee
```
(Pre-amendment snapshot; `T02_main`, `T02_S1`, `T02_S2`, `T02_S7` and the new `T02_L02Consumed` will change under
A1/A2 and are re-snapshotted in `T02_gate_r2.md`.)

## Overall

Items 1, 2, 3, 4, 7: PASS. Item 5: S7 false as stated (fix A2). Item 6: consumed clause misnamed/mislocated (A1),
Prop35 provenance label (A3). After A1-A3 an amendment check (`T02_gate_r2.md`) is required.

STATEMENT GATE: PASS_WITH_AMENDMENTS
