# T01 issue 1 (X2): Theorem 2.2 (i) for random 𝔏 states no Assumption A1

Role: pv-issue-checker. Date: 2026-10-13 11:33 EDT. Status: ruling, **not confirmed** until pv-auditor review (positive Lean probe plus reasoning).

## 1. What the source says (read directly)

- Thm 2.2, `source/geo_erg_HMC_v3.1.tex:208-219`: "If either of the following hold then HMC will *not* produce a geometrically ergodic Markov chain: (i) lim ‖∇U‖/‖x‖ = ∞ and (18) and (19) are satisfied; (ii) …". The statement names no assumption on 𝔏. By contrast Thm 2.1 (TEX:201), Cor 2.3 (TEX:230) and Thm 5.10 (TEX:424) name A1 explicitly.
- Standing conventions: TEX:192 "let 𝔏(·) be a distribution defined over ℤ₊"; Algorithm 1 (TEX:342-343) draws `L ~ 𝔏`; TEX:381 "the distribution 𝔏(·) … does not depend on the current position" (standing for Section 5); TEX:411 results "conditioned on a fixed choice of … L". **A1 is not a standing assumption**: it is introduced at TEX:393 as an assumption to be invoked, it is invoked by name wherever it is used (201, 230, 424, 802), and TEX:404 even discusses results without it.
- A1, TEX:393: `P_𝔏[L=1] > 0` and an exponential moment `E_𝔏[e^{s‖x_{Lε}‖}] < ∞`.
- The only support for random 𝔏 in part (i), TEX:934-940: "When the number of leapfrog steps is drawn from a position-independent distribution 𝓛(·) as in Assumption A1, the same conclusion follows provided the above argument is applied conditional on each fixed L. For each fixed L the conditional acceptance probability tends to zero, while it is bounded by one. Since the law of L does not depend on x₀, dominated convergence with respect to 𝓛(·) shows that the unconditional acceptance probability also tends to zero." Then Prop. 3.5 (TEX:300-302: "If P is of Metropolis-Hastings type, then (geoerg) fails to hold if esssup r(x) = 1") as at TEX:932. Prop. 3.5 as printed has no A1 premise.
- Part (ii) (Thm 5.18, TEX:1103-1121) is not concerned by this issue.

## 2. What is consumed

The steps written at TEX:936-940 use exactly: (a) for every L charged by 𝔏 the fixed-L limit (needs L ≥ 1 and (19) for that L; TFA-C/TFA-D, already approved); (b) the acceptance probability is in [0,1]; (c) 𝔏 is a probability law independent of x₀ (stated in the sentence itself: "Since the law of L does not depend on x₀"); (d) dominated convergence on ℕ; (e) Prop. 3.5 for the mixture kernel. **Neither clause of A1 is consumed**: `P[L=1] > 0` is not used anywhere in this argument, and the exponential moment is used in the paper only for the Lyapunov function of the *positive* result (TEX:397). The phrase "as in Assumption A1" describes the setting (a position-independent law); the following sentence names the property that is used.

In our encoding, `A1Law` enters `Paper.T02.T02_main_randL` (pv_work/T02.lean:490-511) only through (1) `hA1.1` (probability), (2) `hA1.2.1` (𝔏{0} = 0), and (3) as an antecedent passed to the external parameter `Prop35Rand` (pv_work/T02Stmt.lean:146-151). Item (3) is our representation choice: printed Prop. 3.5 has no A1 antecedent. T02_final.md:81 already records that the moment clause is unused.

## 3. Classification

**ENCODING_ERROR (formalization side, not a paper issue).** The X2 stop is manufactured by our consumed clause `T01Rand_T02Consumed` (pv_work/T01Stmt.lean:84-87), which inherits an `A1Law` antecedent from `T02_main_randL`, which in turn has it because `Prop35Rand` was given an `A1Law` antecedent that Prop. 3.5 does not print. For T02 itself this is a harmless extra premise (T02's theorem is true and faithful under the narrower reading); propagated into T01 it makes the consumed clause weaker than what the source argument delivers, and so produces a stop the paper does not cause.

Why not the neighbouring classes:
- `PAPER_ASSUMPTION_GAP`: requires a hypothesis the step needs. The step at 936-940 does not need A1 (checked in Lean, §5); dropping A1 does not make any written step fail.
- `EXPOSITION_GAP`: requires an uncovered range. Laws not satisfying A1 (e.g. 𝔏 = δ₂, or any law with `P[L=1] = 0`) are covered by the argument exactly as written; nothing has to be added.
- `PAPER_ARGUMENT_GAP`: the given justification does yield the conclusion for every position-independent law on {L ≥ 1}.
- `DOMAIN_CLARIFICATION`: two readings of "as in Assumption A1" exist, (R1) "a position-independent law, as in the A1 setting" and (R2) "a law satisfying A1". Under R1 Thm 2.2 (i) for random 𝔏 is supported as printed. Under R2 the paragraph *claims* the extension only for A1 laws, but its *argument* covers all position-independent laws, so Thm 2.2 (i) is still justified by source text. The result holds under both readings, and no reading leaves part of Thm 2.2 unsupported. So this is at most an `EDITORIAL` wording point ("as in Assumption A1" over-specifies), not a domain issue.
- `FAIR_IMPLICIT_STEP`: not applicable as such, because nothing is missing from the source. The remedy is a change to our encoding, not a step for the prover to fill in.

## 4. Does it threaten the conclusion?

- Thm 2.2 as stated: **no**. Fixed L (`T01_main`) is unaffected and already proved. For random 𝔏 the source route closes without A1 (§5), conditional on the same external inputs T02 already carries (Prop. 3.5 for the mixture kernel, GaussFacts, the per-l L03 clause).
- Downstream: affected only `T01_main_randL.partI` (currently stopped at gap `T01_main_randL_partI_Gap`, pv_work/T01ModGaps.lean). **Unaffected**: `T01_main`, `T01_S1`-`T01_S3`, `T01_SR1` (A1 laws), `T01_SR3` / `T01_main_randL.partII` (Thm 5.18 route, no A1), all of T02 (`T02_main`, `T02_main_randL` stays true and faithful under reading R2), L01-L03.
- Out of scope, recorded only: whether ℤ₊ at TEX:192 includes L = 0 (handled by the approved TFA-C `𝔏{0} = 0`; an L = 0 atom proposes x itself, and the route at 936-940 would not apply to that atom). This is not part of this ruling.

## 5. Evidence (positive, Lean)

File: `pv_work/probes/issue/T01/T01_issue1_noA1.lean`. Compiled with `scripts/pv_lean.sh probe pv_work/probes/issue/T01/T01_issue1_noA1.lean`:
`RESULT T01_issue1_noA1 mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/T01_issue1_noA1_2.log`.
Axioms (`#print axioms`, because `#pv_axioms` is module-based and a probe has no module): `randL_partI_noA1`, `noA1_implies_Prop35Rand`, `dirac2_not_A1` each depend only on `[propext, Classical.choice, Quot.sound]`. `#pv_axioms T02`: ALL STANDARD (20 declarations).

Contents:
- `Prop35RandNoA1`: Prop. 3.5 for `hmcStepRand` with the antecedents the print has (standing conventions, 𝔏 a probability law with 𝔏{0} = 0), i.e. `Prop35Rand` with `A1Law` replaced by `IsProbabilityMeasure Lmeas ∧ Lmeas {0} = 0`. Probe-local external parameter.
- `noA1_implies_Prop35Rand : Prop35RandNoA1 → Prop35Rand`: scope check. The new form only drops antecedents, so it is a closer specialisation of printed Prop. 3.5, not a stronger mathematical claim than the print.
- `randL_partI_noA1`: with `hL03` (per charged l), `Prop35RandNoA1`, `GaussFacts`, standing conventions, `hP`, `h0`, and `HypPartIRand`, concludes `¬ GeomErgodicRand U gU eps Lmeas`. It follows T02_main_randL step by step (SR2 dominated convergence, SR1 per-l limit, SR3 r → 1, SR5' r ≤ 1, SR5 esssup = 1, SR6 Prop. 3.5), with no `A1Law`. The helper lemmas are verbatim copies of private lemmas of pv_work/T02.lean:43-136 (private declarations cannot be imported); no new argument. `#pv_hyp_usage`: all binders USED except `h : HypPartIRand`. This matches `T02_main_randL`, where `hexp`, `hosc`, `hosc2` are also unused (T02_final.md:39) because their content reaches the proof through `hL03`, which is supplied from L03 via `hosc2` at reconnection.
- `dirac2_not_A1`: 𝔏 = δ₂ fails `A1Law` (`P[L=1] = 0`) but meets `hP`, `h0`, so the probe covers laws outside A1.

## 6. Suggested remedy (formalization side; no change to the paper needed)

Minimal encoding change (coordinator / drafter / gate decision, not done here): replace the `A1Law gU eps Lmeas` antecedent of `Prop35Rand` (T02Stmt.lean:149) by `IsProbabilityMeasure Lmeas → Lmeas {0} = 0 →`, i.e. adopt the form `Prop35RandNoA1`. Add `T02_main_randL'` with `hP`, `h0` in place of `hA1`, whose proof is the probe's `randL_partI_noA1` route, and restate `T01Rand_T02Consumed` without `A1Law`. Then `T01_main_randL.partI` follows from the consumed clause by direct application. This requires re-gating the changed T02/T01 statements, updating the registration of the external parameter in EXTERNAL_TOOLS.md, and auditing again. The existing A1 versions can be kept, since they follow from the new ones.

Optional editorial note to authors: at TEX:935 "as in Assumption A1" could read "(as in Section 5, independent of the current position)", because A1 is not used there.

## 7. Not checked

- Applicability of Prop. 3.5 to the mixture kernel `hmcStepRand` (external parameter, inherited from T02 in both forms).
- The L03/L02 chain behind `hL03` (proved elsewhere, reconnected in T02Closed_r1).
- The L = 0 reading of ℤ₊ (§4).
- The ruling depends on the reading in §2, that "as in Assumption A1" is descriptive. This reading needs no human check for the conclusion, because the result holds under both readings.

ISSUE VERDICT: ENCODING_ERROR
THREATENS CONCLUSION: no
