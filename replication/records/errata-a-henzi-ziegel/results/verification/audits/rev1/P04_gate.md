# P04 statement gate (Proposition 3.4, `prop:combination`)

- Reviewer: pv-gate (independent subagent; not the drafter)
- Date: 2026-10-13 01:18:39 EDT (`date`)
- Source read directly: `source/VSIFP_02.tex` l.66-106 (scores, consistency, mixture, l.106 equivalence), l.108-131 (sequential setting, H_{S;c}), l.133-233 (one-period e-values, T01-T03 statements, h=1 sketch l.205-220, P04 statement l.222-227), l.440-478 (proofs incl. P04 proof l.469-471).
- Reviewed files (sha256 via `python3 scripts/pv_snapshot.py hash`):

| file | sha256 |
|---|---|
| pv_work/P04Stmt.lean | 5dbc28a219b65b424f99b050dc0d38e0f91cd465e5d9296f573174104e2eae5c |
| pv_work/P04Draft.lean | c27da516eef63a2af676fbb767949ef5e28741c510e63300cf370704d8e775fa |
| pv_work/notes/P04_draft_notes.md (leads only) | eba7eb86504163fd4b8186b6e29fea5f589f956fe328cc2b5a98d2463a071785 |
| pv_work/Defs.lean (imported) | 1a71b8609e9470ac5f9b63c6099d10f299ee69a114a9cc61ecd4828d0da2b41c |
| pv_work/T01Stmt.lean (imported) | 011685b5b1e5a9f9d221fb49cf0478b632e812be2257bd23085e5357d6b1c8f2 |

- Compilation: `scripts/pv_lean.sh check P04Draft` -> `exit=0 errors=0 sorry_warnings=9 nonstandard_axiom_lines=0`, log `pv_work/logs/P04Draft_2.log`.
- Gate probes (all `pv_work/probes/gate/P04/`):
  - `gate_P04_stmtcopy.lean` EXIT=0 (log `pv_work/logs/gate_P04_stmtcopy_1.log`), `gate_P04_draftcopy.lean` EXIT=0, 9 sorry (log `pv_work/logs/gate_P04_draftcopy_1.log`): snapshots below.
  - `gate_P04_mixcex.lean` EXIT=0 (log `pv_work/logs/gate_P04_mixcex_2.log`): `¬ P04_MixingOfStrict Sb` for `Sb p y = (p-y)^2 - 5`; `#pv_walk_decl`: axioms {propext, Classical.choice, Quot.sound}, sorryAx reached: false.
  - `gate_P04_t01link.lean` EXIT=0 (log `pv_work/logs/gate_P04_t01link_2.log`): `∀ S, P04_T01Consumed S` from `Paper.T01.T01_S2` (T01ModGaps); `#pv_walk_decl`: axioms {propext, Classical.choice, Quot.sound}, sorryAx reached: false.

## Source quotations

- Statement, `VSIFP_02.tex:222-227`: "Let $(Y_t, c_t, p_t, q_t, \lambda_t) \in \{0,1\}^2 \times (0,1)^2 \times [0,1]$ be defined on a measurable space $(\Omega,\mathcal F)$ and adapted to the filtration $\mathcal F_t$, $t\in\mathbb N$, and assume $\lambda_t = 0$ if $c_t = 0$. Let further $\myS$ be a strictly consistent scoring function. Then for all $T \ge h+1$, with $I_k = \{k + hs: s = 0,\dots,\lfloor (T-k)/h\rfloor - 1\}$, $e_T = \frac1h\sum_{k=1}^h \prod_{l\in I_k} E_{p_l,q_l;\lambda_l}(Y_{l+h})$ are $\mathcal F_T$-measurable and are e-values under $\mathcal H_{\myS;c}$."
- Proof, `:469-471`: "Follows as in the case $h = 1$ with sequential conditioning on $\mathcal{F}_{k + hl}$, $l = 1, \dots, \lfloor (T-k)/h \rfloor$, for each of the $h$ products."
- h=1 route, `:205-220`: tower property at $\mathcal F_T$ (l.208), pull-out of the first $T-1$ factors (l.209), $E\{E_{p_T,q_T;\lambda_T}(Y_{T+1})\mid\mathcal F_T\}\le 1$ a.s. using $\lambda_T=0$ if $c_T=0$ (l.211-215), iteration (l.217-220); averaging over $k$ motivated at l.220 ("average the products ... U-statistics merging").
- e-value, `:78`: "$E\ge0$ satisfying $\mathbb E(E)\le1$ under a given null hypothesis ... The arithmetic average of e-values is again an e-value".
- $\mathcal H_{\myS;c}$, `:116-118, 122`: probability measures with $c_t\mathbb E_{\mathbb P}\{\myS(p_t,Y_{t+h})-\myS(q_t,Y_{t+h})\mid\mathcal F_t\}\le0$ a.s., $t\in\mathbb N$; $c_t\in\{0,1\}$ $\mathcal F_t$-measurable.
- Lag, `:111`: "integer lag $h\ge1$".
- Mixture convention, `:93-97`: "under mild regularity conditions stated in [Gneiting2007, Thm 2.3], all consistent scoring functions are of the form $\myS(p,y)=\int_{[0,1]}\myS_\theta(p,y)\,d\nu(\theta)$, where $\nu$ is a locally finite Borel measure on $(0,1)$".
- `:106`: "The scoring function $\myS$ is strictly consistent if and only if $\nu$ assigns positive measure to all non-degenerate intervals in $(0,1)$."
- E-value family, `:146-148` (D14), T01 `:144-149` requires $p\ne q$ and $\nu\{[\min,\max)\}>0$.

## Item 1. Hypotheses: FAIL (amendment R1, R2)

- `SeqSetting` encodes all of l.223 (ranges, adaptedness, `λ_t = 0` if `c_t = 0`); `c_t` adaptedness also matches l.122. `1 ≤ h` from l.111. `IsStrictlyConsistent S` = D02 (l.74). No hidden hypotheses: only `variable {Ω} {m0}`; structures `SeqSetting`, `P04Conclusion` contain exactly the listed fields.
- Index `t = 0`: Lean data are indexed by ℕ including 0 and `HSc` quantifies over `t = 0` too. Harmless: a source instance (indexed from 1) embeds with `c_0 = λ_0 = 0`, `p_0 = q_0` constant, making the `t = 0` conditions of `HSc`/`HScInt` trivially true. PASS on this point.
- **Defect (R1)**: `hMix : P04_MixingOfStrict S` is an external parameter that is **false** for some strictly consistent `S` (see item 6), so as a hypothesis of `P04_main` it silently restricts the class of scores beyond the source's "under mild regularity conditions" (l.93). Required change R1.
- **Defect (R2)**: obligation `P04_S4` lacks `hS` (see item 5).

## Item 2. Conclusion: PASS

`P04Conclusion` = `Measurable[ℱ T] (eT …)` ∧ `IsEValueUnder (eT …) (HScInt …)`; matches l.226 ("ℱ_T-measurable and e-values under ℋ_{S;c}"). No alternative is claimed (none stated). `IsEValueUnder` = `e ≥ 0` everywhere and `∫⁻ ofReal e ≤ 1` (l.78); since `e ≥ 0` is a separate clause, the lintegral is exactly `E_Q e` (or `∞` when not integrable), so no `ofReal`/`toReal` truncation trap. `Ik` and `eT` match l.223-225 (ℕ division = floor, `T - k ≥ 0` as `k ≤ h < T`; `s ↦ k + hs` injective as `h ≥ 1`; `Finset.Icc 1 h` = `k = 1..h`). Conclusion is neither weakened nor strengthened, apart from the class `HScInt` (TFA-1, item 4).

## Item 3. Quantifiers and constants: PASS

`S, h, ℱ, Y, c, p, q, λ` fixed, then `∀ T ≥ h+1`, then `∀ Q ∈ HScInt` inside `IsEValueUnder`; matches l.222-226. No constants.

## Item 4. Domains and details: PASS (with recorded domain point)

- a.s. vs everywhere: `HSc` uses `∀ᵐ ∂Q` as in l.118; nonnegativity of `e_T` everywhere holds by construction (pointwise `Y ∈ {0,1}`, `λ ∈ [0,1]`), fine.
- Probability measures: `IsProbabilityMeasure Q` in `HSc` (𝒫, l.115). ✓
- Measurability: conclusion clause; `S` measurability is not assumed but follows from consistency (monotonicity of `S(·,0)`, `S(·,1)` on `[0,1]`), so S2/S3 are true with `hS`.
- **TFA-1 `HScInt`** (integrability of the score difference at every `t`): approved. With the standard definition of conditional expectation (`L¹`), the source's `E_Q{·|ℱ_t}` at l.118 is only defined under this integrability; without it Lean's `condExp` junk value `0` would make the hypothesis vacuous and the claim false. It narrows the class of `Q` (conclusion proved for fewer `Q`), it cannot hide a paper error (for binary `Y` the generalized conditional expectation `(1-π_t)d_t(0)+π_t d_t(1)` makes the source's argument work identically), and it is not goal-shaped. Note for the final report: the result is proved for `Q ∈ ℋ_{S;c}` with integrable score differences; a fully general version would encode `ℋ_{S;c}` via `π_t = E_Q(Y_{t+h}|ℱ_t)` (optional, not required).
- **`p_t = q_t`**: allowed by l.223 (`(0,1)^2`), but `E_{p,q;λ}` (l.147) is `0/0` there and T01 assumes `p ≠ q`. Lean's `Erep` gives `1` (division by zero = 0), i.e. "no bet", the same convention the source itself adopts for `λ = 0` at l.211. Acceptable as a representation choice: it does not manufacture a paper error and only makes the statement meaningful; it must be recorded as a domain point (suspected issue 2 below). PASS.
- ℝ≥0∞/ℝ: `ofReal` applied only to quantities proved nonnegative (S1); `∫⁻ … ≤ Q A` in S5 compares in ℝ≥0∞. ✓

## Item 5. Step obligations: FAIL (amendment R2; S1, S5-S8 change with R1)

| step | source | true as stated? | smuggling? | ruling |
|---|---|---|---|---|
| S1 `0 ≤ Erep …` | l.403 (T01 "if" part: E ≥ 1-λ ≥ 0), l.211 (λ=0) | true (cases λ=0, p=q give 1; else T01 clause + ν positivity) | no | PASS (after R1 its ν source changes) |
| S2 factor ℱ_{t+h}-measurable | l.226 (no justification) | true with `hS` (monotone `S(·,y)` on [0,1]) | no | PASS; FAIR_IMPLICIT_STEP |
| S3 `e_T` ℱ_T-measurable | l.226 | true: `l ∈ I_k` ⇒ `l + h ≤ k + h⌊(T-k)/h⌋ ≤ T` | no | PASS |
| S4 a.s. `π_t ∈ [0,1]`, `c_t = 1 ⇒ π_t ∈ H_S(p_t,q_t)` | l.213-215 (X04, silent) | **not justified as stated**: the pull-out `E[d_t(Y)|ℱ_t] = d_t(0)(1-π_t)+d_t(1)π_t` needs `ω ↦ S(p_t ω, y)` to be (a.e.) ℱ_t-measurable; S4 has no hypothesis on `S` at all (arbitrary, possibly non-measurable `S`), so it may be false as stated. With `hS` it is true (`d_t(0)(1-Y)`, `d_t(1)Y` are integrable because `|diff| = |d_0|(1-Y)+|d_1|Y`; `condExp_mul_of_stronglyMeasurable_left`) | no | FAIL → R2 |
| S5 `∫_A E_t ≤ Q A`, `A ∈ ℱ_t` | l.213-215 | true (write `E_t = a_t(1-Y)+b_tY`, `a_t,b_t ≥ 0` ℱ_t-measurable; lintegral tower; T01 clause at `π_t`) | it is the h=1 one-step bound of the source, not the target | PASS |
| S6 `∫ g·E_t ≤ ∫ g`, `g` ℱ_t-meas. | l.209 | true from S5 (simple-function/monotone approximation) | no | PASS |
| S7 `∫⁻ ofReal ∏_{s<n} E_{k+hs}(Y_{k+hs+h}) ≤ 1` | l.470, 217-220 | true by induction on `n` with S2, S6 at `t = k+h(n-1)` | no (one product, not `e_T`) | PASS; follows the h=1 route invoked at l.469 (conditioning at forecast time, cf. l.208-209), not the literal σ-field list of l.470 (suspected issue 1) |
| S8 `IsEValueUnder e_T (HScInt …)` | l.220, 226, 78 | true from S1, S7, linearity of `∫⁻`, `I_k` = image of `range ⌊(T-k)/h⌋` | equals the e-value clause of the conclusion; acceptable as the assembly step, proved from S7 | PASS; averaging = FAIR_IMPLICIT_STEP (l.78 "arithmetic average of e-values is again an e-value") |
| main | l.222-227 | S3 + S8 assemble to `P04Conclusion` | — | PASS |

Assembly: `P04_main` follows from S3 (measurable) and S8 (evalue) directly. ✓

## Item 6. External parameters: FAIL for `P04_MixingOfStrict` (R1); `P04_T01Consumed` approved

| parameter | provenance | ruling | reason |
|---|---|---|---|
| `P04_T01Consumed S` | (p) predecessor T01, l.144-149 "if" direction, proof l.403 | **APPROVED** | Exact clause of T01 with a weaker alternative (`∅` instead of `[0,1] \ H_S`); hypotheses identical to T01 (`IsConsistent`, `MixtureRep`, `p ≠ q` in `(0,1)`, `ν{[min,max)} > 0`, `λ ∈ (0,1]`); not goal-shaped; named `P04_T01Consumed`, in `namespace Paper.P04`, declared only in `P04Stmt.lean`, no name clash (checked T01/T02/T03 Stmt, Defs). Applicability in P04: pointwise at `p_t(ω), q_t(ω), λ_t(ω)` when `c_t = 1`, `λ_t > 0`, `p_t ≠ q_t`; `ν`-positivity from the l.106 parameter. **Note**: probe `gate_P04_t01link.lean` proves `∀ S, P04_T01Consumed S` from `Paper.T01.T01_S2` (gap-free step of `T01ModGaps`, standard axioms only). T01's verdict is ISSUE, so per VERDICTS §4.1 the (p) clause would count as (iv); the coordinator may instead discharge it now by importing `T01ModGaps` (recommendation, not a gate requirement). |
| `P04_MixingOfStrict S` | stated (i)+(ii)+(iii) | **REJECTED as stated** | It asserts that *every* strictly consistent `S` has an exact mixture representation `T01.MixtureRep S ν`, dropping the "mild regularity conditions" of l.93 / Gneiting-Raftery Thm 2.3. It is **false**: `S(p,y) = (p-y)^2 - 5` is strictly consistent but `S(1/2,0) = -4.75 < 0 ≤ ∫ θ 1{θ<1/2} dν` for every `ν` (Lean proof: `pv_work/probes/gate/P04/gate_P04_mixcex.lean`, `not_mixingOfStrict`, standard axioms). Hence it is stronger than the source's use and makes `P04_main` vacuous for such `S` (whose score differences, hence `Erep`, `ℋ_{S;c}` and `e_T`, coincide with those of the Brier score). The second half (l.106 "only if": strict consistency ⇒ `ν` charges every `[a,b) ⊂ (0,1)`) is a faithful (ii) and true (if `ν[a,b) = 0`, `π = (a+b)/2`, `p = a` give equal expected scores). Should it be an external input at all? The l.106 part may stay a parameter (asserted without proof, little infrastructure to save; or the prover may prove it); the representation part must not be a parameter but the source's convention (R1). |

## Item 7. Doubts about the source (preliminary, not ruled here)

1. `VSIFP_02.tex:470`: conditioning σ-fields `ℱ_{k+hl}`, `l = 1..⌊(T-k)/h⌋`. The factor with `l' = k+h(s)` is `E_{l'}(Y_{l'+h})`, ℱ_{k+h(s+1)}-measurable; the h=1 route (l.208-209, conditioning on ℱ_T for the factor `E_T(Y_{T+1})`) requires conditioning at the forecast times `ℱ_{k+hl}`, `l = 0..⌊(T-k)/h⌋-1`. As printed the list is shifted by one step `h`, and conditioning on the last listed σ-field gives no information. The route is clear from l.469 "as in the case h = 1". Preliminary: EXPOSITION_GAP (possibly EDITORIAL index slip). Dispatch pv-issue-checker.
2. `VSIFP_02.tex:223` with `:147` and T01 `:145`: `p_t = q_t` is allowed but `E_{p,q;λ}` is `0/0` and T01 assumes `p ≠ q`; the natural reading (factor 1, as for `λ = 0` at l.211) is what Lean uses. Preliminary: DOMAIN_CLARIFICATION. Dispatch pv-issue-checker.
3. `VSIFP_02.tex:93`: "under mild regularity conditions ... all consistent scoring functions are of the form (mixture)" ignores additive terms `a(y)` (e.g. Brier − 5 above); affects the global convention, not P04's mathematics (score differences unchanged). Preliminary: EDITORIAL/DOMAIN_CLARIFICATION (the regularity conditions are cited, not stated). Optional dispatch; low priority.
4. Drafter's lead "PAPER_ARGUMENT_GAP-by-omission" for S5-S8: I do not support it at the gate; S5-S7 are the h=1 argument the proof explicitly invokes, S8 is covered by l.78/l.220. The unstated integrability/measurability points are FAIR_IMPLICIT_STEP / TFA-1.

## TFAs ruled on

| id | content | ruling | reason |
|---|---|---|---|
| TFA-1 `HScInt` | `Integrable (S(p_t,Y_{t+h}) − S(q_t,Y_{t+h})) Q` for all `t` | APPROVED | standard L¹ meaning of `E{·|ℱ_t}` at l.118; avoids Lean junk `condExp = 0`; not goal-shaped; only narrows the class of `Q` |
| TFA-2 (introduced by R1) `(ν) (hrep : T01.MixtureRep S ν)` | `S` is given with its mixing measure | APPROVED (to be added) | article-wide convention l.93-97 ("scoring functions" are of mixture form), as in `T01Stmt` (l.145 "the mixing measure ν of S"); excludes only scores without exact representation, whose score differences equal those of a represented score |
| `p_t = q_t` → `Erep = 1` | representation choice | APPROVED (record suspected issue 2) | same "no bet" convention as l.211; does not create or hide an error |

## External parameters

| name | type | ruling |
|---|---|---|
| `P04_T01Consumed` | (p) → (iv) since T01 is ISSUE; dischargeable by `Paper.T01.T01_S2` | APPROVED |
| `P04_MixingOfStrict` (current) | (i)+(ii)+(iii) | REJECTED (false; stronger than l.93) |
| `P04_MixingOfStrict` (after R1) | (ii) l.106, silently used (iii) in P04 | APPROVED in the R1 form |

## Required changes

- **R1** (`pv_work/P04Stmt.lean` l.85-92 and all users in `pv_work/P04Draft.lean`): replace the definition by the l.106 implication with `ν` given:
  ```lean
  def P04_MixingOfStrict (S : ℝ → ℝ → ℝ) : Prop :=
    ∀ ν : Measure ℝ, T01.MixtureRep S ν → IsStrictlyConsistent S →
      ∀ a b : ℝ, 0 < a → a < b → b < 1 → 0 < ν (Set.Ico a b)
  ```
  (docstring: provenance (ii) l.106, used silently (iii) in P04; the mixture representation is the convention of l.93-97, not a parameter). In `P04_main`, `P04_S1`, `P04_S5`, `P04_S6`, `P04_S7`, `P04_S8` add the binders `(ν : Measure ℝ) (hrep : T01.MixtureRep S ν)` immediately after `(S : ℝ → ℝ → ℝ)` (keep `hMix`). Update the notes and the docstrings of S1/S5 ("ν from hrep").
- **R2** (`pv_work/P04Draft.lean` l.53-54, `P04_S4`): add `(hS : IsStrictlyConsistent S)` after `(hset : SeqSetting ℱ Y c p q lam)`.
- No other change. (Optional, not required: discharge `P04_T01Consumed` by importing `T01ModGaps` and using `Paper.T01.T01_S2`; coordinator decision.)

## Statement snapshot (pre-amendment; to be superseded by the r2 snapshot)

`pv_work/logs/gate_P04_stmtcopy_1.log`:
```
TYPE HASHES (current file, 34 declarations)
Paper.P04.HScInt|def|th=4049409469|vh=4086871767|bi=iieeeeeee
Paper.P04.HSc|def|th=4049409469|vh=4068097418|bi=iieeeeeee
Paper.P04.Ik|def|th=2688782768|vh=1188971402|bi=eee
Paper.P04.IsEValueUnder|def|th=991135443|vh=3738125688|bi=iiee
Paper.P04.P04Conclusion.casesOn|def|th=2675418763|vh=1507955123|bi=iiiiiiiiiiiiee
Paper.P04.P04Conclusion.evalue|thm|th=4035352186|vh=-|bi=iiiiiiiiiiie
Paper.P04.P04Conclusion.measurable|thm|th=4135999659|vh=-|bi=iiiiiiiiiiie
Paper.P04.P04Conclusion.mk|ctor|th=2848929677|vh=-|bi=iiiiiiiiiiiee
Paper.P04.P04Conclusion.noConfusionType|def|th=29438603|vh=2860735649|bi=iiiiiiiiiiieee
Paper.P04.P04Conclusion.noConfusion|def|th=3611900954|vh=4253560742|bi=iiiiiiiiiiiiiie
Paper.P04.P04Conclusion.recOn|def|th=2675418763|vh=1945409720|bi=iiiiiiiiiiiiee
Paper.P04.P04Conclusion.rec|rec|th=2364683867|vh=-|bi=iiiiiiiiiiiiee
Paper.P04.P04Conclusion|induct|th=2076968018|vh=-|bi=iieeeeeeeee
Paper.P04.P04_MixingOfStrict|def|th=3052518861|vh=2443578863|bi=e
Paper.P04.P04_T01Consumed|def|th=3052518861|vh=4113823044|bi=e
Paper.P04.SeqSetting.Y_adapted|thm|th=1845958995|vh=-|bi=iiiiiiiiee
Paper.P04.SeqSetting.Y_mem|thm|th=2839112627|vh=-|bi=iiiiiiiieee
Paper.P04.SeqSetting.c_adapted|thm|th=2580291967|vh=-|bi=iiiiiiiiee
Paper.P04.SeqSetting.c_mem|thm|th=405650024|vh=-|bi=iiiiiiiieee
Paper.P04.SeqSetting.casesOn|def|th=2469678534|vh=2258885665|bi=iiiiiiiiiee
Paper.P04.SeqSetting.lam_adapted|thm|th=295661739|vh=-|bi=iiiiiiiiee
Paper.P04.SeqSetting.lam_mem|thm|th=2343973461|vh=-|bi=iiiiiiiieee
Paper.P04.SeqSetting.lam_zero|thm|th=1211223059|vh=-|bi=iiiiiiiieeee
Paper.P04.SeqSetting.mk|ctor|th=588935457|vh=-|bi=iiiiiiiieeeeeeeeeee
Paper.P04.SeqSetting.noConfusionType|def|th=3681074281|vh=2499496481|bi=iiiiiiiieee
Paper.P04.SeqSetting.noConfusion|def|th=2508541176|vh=145876914|bi=iiiiiiiiiiie
Paper.P04.SeqSetting.p_adapted|thm|th=2626217022|vh=-|bi=iiiiiiiiee
Paper.P04.SeqSetting.p_mem|thm|th=791283169|vh=-|bi=iiiiiiiieee
Paper.P04.SeqSetting.q_adapted|thm|th=1779977113|vh=-|bi=iiiiiiiiee
Paper.P04.SeqSetting.q_mem|thm|th=1757075794|vh=-|bi=iiiiiiiieee
Paper.P04.SeqSetting.recOn|def|th=2469678534|vh=2691199307|bi=iiiiiiiiiee
Paper.P04.SeqSetting.rec|rec|th=29311890|vh=-|bi=iiiiiiiiiee
Paper.P04.SeqSetting|induct|th=15571848|vh=-|bi=iieeeeee
Paper.P04.eT|def|th=4241663065|vh=662740667|bi=ieeeeeeee
EXIT=0
```

`pv_work/logs/gate_P04_draftcopy_1.log`:
```
TYPE HASHES (current file, 9 declarations)
Paper.P04.P04_S1|thm|th=3868466976|vh=-|bi=iieeeeeeeeeeeeee
Paper.P04.P04_S2|thm|th=1825503320|vh=-|bi=iieeeeeeeeeee
Paper.P04.P04_S3|thm|th=3849468069|vh=-|bi=iieeeeeeeeeeeee
Paper.P04.P04_S4|thm|th=365105143|vh=-|bi=iieeeeeeeeeeee
Paper.P04.P04_S5|thm|th=2158422543|vh=-|bi=iieeeeeeeeeeeeeeeee
Paper.P04.P04_S6|thm|th=2911702032|vh=-|bi=iieeeeeeeeeeeeeeeee
Paper.P04.P04_S7|thm|th=2951475114|vh=-|bi=iieeeeeeeeeeeeeeeee
Paper.P04.P04_S8|thm|th=1200732502|vh=-|bi=iieeeeeeeeeeeeeee
Paper.P04.P04_main|thm|th=3440550368|vh=-|bi=iieeeeeeeeeeeeeee
EXIT=0
```

## Overall verdict

Two required changes (R1: `P04_MixingOfStrict` is false as stated and stronger than l.93; replace it by the l.106 implication with `ν`, `MixtureRep S ν` as hypotheses. R2: add `hS` to `P04_S4`). Everything else passes. After the amendments, an amendment check with a new snapshot goes in `P04_gate_r2.md`.

STATEMENT GATE: PASS_WITH_AMENDMENTS
