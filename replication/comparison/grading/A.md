# Grading, paper A (Henzi and Ziegel, arXiv 2103.08402v2): Kit, Agent, Chat

Grader: Claude (authors' assistant), 2026-10-16, following `BASELINE_PROTOCOL.md` and `grader_prompt_A.md`.

**Inputs used.**

- Paper: `VSIFP_02.tex`. All three arms checked the same source (`cmp` against the Agent's and the Kit's copies; the Chat message is the same text minus the final comment line).
- Reference: `ANSWER_KEY.md`, `answer_key.json`, `HAND_CHECKS.md`.
- Kit: first-round records only. These are the snapshot `20261013-021156-before-revision` (RESULTS.json and BLOCKERS.md at 01:53), the round-1 report `report_archive/20261013-111542/AUTHOR_REPORT.md` (identical to the snapshot's report), `pv_work/superseded/rev1/` for P04/P05 and `pv_work/` for T01–T03. I checked that every round-1 Lean file is byte-identical to the snapshot copy. The offline replay `examples-design/results/A-round1/replay.txt` rebuilt all five modules, and the axiom logs say "ALL STANDARD".
- Agent: `session.json` "result" and its 4 Lean files. All compile with no `sorry`; I printed the axioms of `thm_uniqueness'`, missing from `lean_check.md`: standard.
- Chat: `session.json` "result" and `lean_blocks/block_01.lean`. This is the only code block, and it is identical to the reply. It compiles and all axioms are standard.

**Reference classes.**

- Thm 3.1 and Thm 3.2 are `PROOF` (minor). The answer key expected them verified, but `HAND_CHECKS.md` confirms one false proof step in each, and the protocol counts hand-confirmed findings as reference.
- Thm 3.3 and Prop 3.4 are `OK`.
- Prop 3.5 is `FALSE` (published ERROR).

Both hand-checked findings first came from the Kit's own run. All three arms found them independently, so this does not change the comparison.

**Contamination.** The paper (2021) and the correction (2022) predate the models' training data. The arms' correct findings on Prop 3.5 are reported with this caveat (answer key).

**Lean checks I ran** in `<tmp>/grading-A/proj` (pinned Lean 4.19.0, Mathlib `c44e0c8e`):

- `#print axioms` for `thm_uniqueness'`, `thm_uniqueness`, `thm_grow` and `thm_allscores`: all standard.
- `grader_T31_lt` and `grader_T31_gt`, two 4-line assemblies of the Agent's own lemmas into Theorem 3.1 for p < q and p > q (`AssembleT31.lean`). Both compile with standard axioms; see §2.

---

## 1. Per-result table

Abbreviations:

- CC = correctly classified, Nat = nature right, FA = false alarm.
- LB = Lean-backed: a cited theorem that compiles, uses only standard axioms, has no `sorry`, and states what the paper states (§2).
- Cited = handling of cited or unproved inputs (detail in §4b).

| Result | Reference class: defect | Arm | Arm's class (final answer) | CC | Nat | FA | LB (theorem) | Cited |
|---|---|---|---|---|---|---|---|---|
| Thm 3.1 | **PROOF** (minor): l.419 "E(0) ∈ (0,1)" excludes λ = 1, where E(0) = 0; correct range [0,1); statement true | Kit | PROOF: ISSUE B1, PAPER_ARGUMENT_GAP at l.419 (mirror l.423); "Theorem 3.1 holds" | yes | yes | no | yes for the defect: `Paper.T01.Issue1.not_PrintedClause_l419`. The statement is not Lean-proved: `T01_mod_gaps` assumes gap S8 (refuted) and gap S10 | explicit |
| | | Agent | PROOF: "statement correct, proof has slips"; "E(0) ∈ (0,1) should be [0,1)" | yes | yes | no | yes: `thm_uniqueness`, `thm_uniqueness'` with `d_signs`; the l = 1 case gives E0 = 0 (assembly checked by grader) | proved |
| | | Chat | PROOF: "Small errors"; "'It follows that E(0) ∈ (0,1)' is wrong" | yes | yes | no | no: `EProb.thm31` is the algebraic core in κ only | unbacked |
| Thm 3.2 | **PROOF** (minor): l.435 "lim g = −∞, maximum in [0,1)" fails at π₁ = 1 (π₁ = 0 for p > q); statement true | Kit | PROOF: ISSUE B2 (l.435/462), plus l.454 sign error | yes | yes | no | yes for the defect: `Paper.T02.Issue1.counterexample_l435_lim`, `counterexample_l435_max`. Statement only modulo gaps (`T02_mod_gaps`) | explicit |
| | | Agent | PROOF: "False step when π₁ = 1", plus sign typo | yes | yes | no | yes for the defect: `thm_grow_one`. Statement only for p < q (`thm_grow`) | hidden (p > q) |
| | | Chat | PROOF: "Gap at π₁ = 1", plus sign error and typo | yes | yes | no | no: `EProb.grow` is an abstract Gibbs bound | unbacked |
| Thm 3.3 | **OK** (conditional on Grünwald et al. Thm 1; "verified" acceptable if the citation is shown unnecessary) | Kit | OK: CONDITIONAL on X03 | yes | n.a. | no | no (weaker): `Paper.T03.T03_main` has X03 as hypothesis | explicit |
| | | Agent | OK: correct, and the citation is unnecessary | yes | n.a. | no | no (weaker): `thm_allscores` covers p < q and π₁ < 1 only | proved (partly hidden) |
| | | Chat | OK: "Correct, but needs p ≠ q"; proof OK | yes | n.a. | no | no (weaker): `nullH_of_lt` + `grow` with κ = p | proved (optimality); uniqueness by hand |
| Prop 3.4 | **OK** | Kit | OK: CONDITIONAL (`P04_T01Consumed`, `P04_MixingOfStrict`); l.470 index slip ruled editorial | yes | n.a. | no | no (weaker): `Paper.P04.P04_main` (rev1) with 2 explicit hypotheses and an integrability scope | explicit |
| | | Agent | OK: "correct, minor gaps" (p_t = q_t gives 0/0; index off by one) | yes | n.a. | no | no (weaker): `Sequential.integral_avg_prod_le_one` with bounded abstract factors | hidden (l.106) |
| | | Chat | OK: "Correct if p_t = q_t is handled"; "Sketch OK, index range wrong" | yes | n.a. | no | no (no Lean) | unbacked |
| Prop 3.5 | **FALSE** (published ERROR): E(e_τ) ≤ 1 fails for h ≥ 2; the proof's premise E(e_t ∣ ℱ_t) ≤ 1 is unavailable | Kit | FALSE: ISSUE B3 ERROR; h = 2 counterexample with E e_τ = 5/4; premise unjustified for every h; h = 1 "believed true" | yes | yes | no | yes: `Paper.P05.Issue1.not_printed` | n.a. |
| | | Agent | FALSE for h ≥ 2: Lean counterexample with E = 13/10; proof invalid for every h; true for h = 1 | yes | yes | no | yes: `Counterexample.prop_3_5_false_h2` | n.a. |
| | | Chat | FALSE for h ≥ 2: E = 5/4 "checked by arithmetic"; proof invalid | yes | yes | no | no: `EProb.prop35_false` is arithmetic only | n.a. |

All three arms classify Prop 3.4 as OK while raising the same two remarks (p_t = q_t and the l.470 index). The remarks are correct (§3) and none of the arms treats them as a failure of the result, so all three are graded alike.

---

## 2. Faithfulness of the Lean theorems cited as evidence

### Kit (`lean_main` in RESULTS.json, or the counterexample file for an issue)

**T01 lean_main: `Paper.T01.T01_mod_gaps` (`pv_work/T01ModGaps.lean:308`). Weaker, and in fact vacuous.**

- Printed: for consistent S with mixing measure ν, p ≠ q in (0,1) and ν[min, max) > 0, E is an e-value with null H_S and alternative its complement iff E = E_{p,q;λ} for some λ ∈ (0,1].
- Lean: `(hGap8 : T01_S8_Gap) (hGap10 : T01_S10_Gap) … : IsEValue E (HS S p q) (Icc 0 1 \ HS S p q) ↔ ∃ lam ∈ Ioc 0 1, ∀ y ∈ {0,1}, E y = Erep S p q lam y`.
- The definitions match the paper: `IsConsistent`, `MixtureRep`, `HS`, `IsEValue`, and `Erep` with denominator at 1{p > q}.
- The theorem is weaker because of two gap hypotheses. `T01_S8_Gap` is refuted in the Kit's own file (`not_S8Gap`), so the theorem proves nothing. The Kit discloses this and does not cite it as a proof: the report says the l.419 step "is a gap … false at λ = 1".

**T01 issue: `Paper.T01.Issue1.not_PrintedClause_l419`. Faithful to the defect.**

- `PrintedClause_l419` encodes the step at l.419 under the theorem's hypotheses: p < q, E an e-value with null H_S ⇒ `E 0 ∈ Ioo 0 1`.
- It is refuted with ν = δ_{1/2}, p = 1/4, q = 3/4 and λ = 1, which give E(0) = 0.

**T02 lean_main: `Paper.T02.T02_mod_gaps` (`T02ModGaps.lean:385`). Weaker (vacuous).**

- `Conclusion` encodes l.154–167 faithfully. `IsGrowLambda` maximises over λ ∈ (0,1] and handles log 0 through `GrowFinite`; `EGrow` uses κ_ν.
- The premises add gap S8, which is false at π₁ = 1, and gap S15, which is the entire p > q case, plus `T02_T01Consumed`. All are disclosed.

**T02 issue: `counterexample_l435_lim` and `counterexample_l435_max`. Faithful to the defect.**

- They encode l.435 ("lim_{λ→1} g = −∞" and "some λ ∈ [0,1) maximises g") under the theorem's hypotheses with p < q.
- They are refuted at δ_{1/2}, p = 1/4, q = 3/4, π₁ = 1.
- `counterexample_l454` also refutes the printed l.454 formula.

**T03 lean_main: `Paper.T03.T03_main` (`T03.lean:145`). Weaker by one explicit hypothesis, disclosed.**

- Lean: `(X03 : GruenwaldThm1) … (h2 : π₁ ∉ HAll p q) : GrowIs (HAll p q) π₁ (EGrowAll p π₁)`.
- Apart from X03 it is faithful. It covers both p < q and p > q and the edge π₁ = 1. GROW is defined as maximal over all e-values with null H, with a log-finiteness convention, and uniqueness holds on outcomes of positive probability.
- By hand, X03 as encoded is true, so the theorem is not vacuous: it is the Gibbs argument both baselines give.

**P04 (rev1) lean_main: `Paper.P04.P04_main` (`superseded/rev1/P04.lean:556`). Weaker, disclosed.**

- Explicit hypotheses: `P04_T01Consumed` (sufficiency of Thm 3.1) and `P04_MixingOfStrict` (l.106). The scoring function is given in mixture form (`MixtureRep`).
- The e-value clause is claimed only for Q ∈ `HScInt`, i.e. with integrable score differences.
- E_{p,p;λ} = 1 through Lean's division by zero.
- Otherwise it matches the printed statement: I_k, e_T, ℱ_T-measurability, e ≥ 0, and E ≤ 1 (as a lower integral).

**P05 (rev1) lean_main: `Paper.P05.P05_main_mod_gaps`.** It rests on `P05_Sbridge_Gap`, which is false (`not_Sbridge`), so it is vacuous. It is not cited as evidence.

**P05 issue: `Paper.P05.Issue1.not_printed`. Faithful; it refutes an even weaker clause.**

- `PrintedClause` is Prop 3.5 with extra premises: P04's conclusion, τ ≥ h + 1 a.s., and integrability. The instance satisfies all of them.
- Instance: h = 2, Brier score (with strict consistency proved, `hS0`), p = 1/4, q = 3/4, λ₂ = 1, Y₃ = Y₄ a fair coin, τ = 3 or 4. Then E_Q e_τ = 5/4.
- e_τ is read as e_{τ(ω)}(ω), which is the paper's reading at l.476.

### Agent

**`thm_uniqueness` / `thm_uniqueness'` with `d_signs`: faithful, modulo an unwritten assembly.**

- Lean: `(h0 : d0 < 0) (h1 : 0 < d1) (E0 E1) : IsEvalNullAlt d0 d1 E0 E1 ↔ ∃ l ∈ Ioc 0 1, E0 = 1 - l ∧ E1 = 1 + l * d1 / |d0|`. The p > q mirror uses denominator |d1|.
- `IsEvalNullAlt` is the paper's e-value with null H_S and alternative its complement, with E ≥ 0.
- `Sθ` matches eq. (3). The difference S(p,y) − S(q,y) is encoded as ∫(S_θ(p,y) − S_θ(q,y)) dν. This agrees with the paper whenever S is finite, and the answer discloses it.
- `d_signs` turns ν[p,q) ∈ (0, ∞) into d0 < 0 < d1. Finiteness follows from local finiteness of ν on (0,1).
- The final assembly and the p > q sign lemma are not in the agent's files. I wrote them (`grader_T31_lt` and `grader_T31_gt`, 4 lines each, no new mathematics) and they compile with standard axioms. Counted as Lean-backed, with this note.

**`thm_grow`: weaker, not disclosed.**

- Lean: `(h0 : d0 < 0) (h1 : 0 < d1) (halt : 0 < (1-π1)*d0 + π1*d1) (hπ1 : π1 < 1)`. Conclusion: l0 ∈ (0,1) is the unique maximiser over [0,1), and 1 − l0 = (1−π₁)/(1−κ), 1 − l0·h = π₁/κ. `boundary_eq_kappa` identifies κ with κ_ν.
- The maximisation over [0,1) instead of (0,1] is harmless, because the growth rate at λ = 1 is −∞ for π₁ < 1.
- It covers p < q only. The p > q branch of the formula is not proved, and the answer says "Correct (proved in Lean)" without that restriction.

**`thm_grow_one`: faithful to the defect.**

- Lean: `∀ l ∈ Icc 0 1, l < 1 → log (1 - l*(d1/d0)) < log (1 - 1*(d1/d0))`, together with λ₀ = 1.
- At π₁ = 1, g(λ) = log(1 − λh), so this shows that no maximiser lies in [0,1) and that the limit is finite. This refutes l.435. It is stated in reduced coordinates; π₁ = 1 ∉ H_S is immediate from d1 > 0.

**`thm_allscores`, with `H_eq_lt`, `H_eq_gt` and `Estar_valid`: weaker.**

- Lean: `(hp0 : 0 < p) (hp1 : p < 1) (hπ1 : p < π1) (hπ1' : π1 < 1) (hE0 : 0 < E0) (hE1 : 0 < E1) (hvalid : (1-p)*E0 + p*E1 ≤ 1)`. Conclusion: the growth of E is at most that of E\*, with equality only if E = E\*.
- It is stronger than needed in one respect: only validity at π = p is used, so it covers all e-values for H.
- `E0, E1 > 0` is a harmless log 0 device and is disclosed in the docstring.
- It is narrower than the theorem: p < q only, and π₁ = 1 excluded. The answer does not disclose either restriction.

**`Sequential.integral_avg_prod_le_one`, with `condExp_one_add_mul_le_one`: weaker / different.**

- Lean: `(hZ0 : ∀ l ω, 0 ≤ Z l ω) (hZC : ∀ l ω, Z l ω ≤ C) (hZm : … ℱ (l+h)) (hZce : ∀ l, μ[Z l | ℱ l] ≤ᵐ 1) (T) : ∫ (1/h) ∑_{k=1}^h ∏_{s<(T-k)/h} Z (k+h s) ≤ 1`.
- The index set matches I_k. The factors are abstract, and the link to E_{p,q;λ}, S, strict consistency and H_{S;c} is not composed.
- Bounded factors are an added hypothesis, which the answer discloses. ℱ_T-measurability of e_T is not stated.

**`Sequential.lintegral_stoppedValue_le_one` (Prop 3.5 for h = 1): weaker.** It uses the same bounded abstract factors and indexes the product from 0, which is harmless. It is correct for every ℕ-valued stopping time.

**`Counterexample.prop_3_5_false_h2`: faithful.**

- Lean: `Adapted ℱ Y ∧ (∀ t, μ[d (Y (t+h)) | ℱ t] ≤ᵐ 0) ∧ IsStoppingTime ℱ τ ∧ 1 < ∫ e (τ ω) ω ∂μ`.
- e_T follows the paper's formula, and E_{p,q;1} uses the denominator |d(0)| (p < q). The null is H_S with c ≡ 1.
- Strict consistency of the Brier score, p, q ∈ (0,1) and λ ∈ [0,1] hold by construction but are not stated in the theorem. By hand, the Brier score is strictly consistent: E_π(p − Y)² = (p − π)² + π(1 − π).

### Chat

**`EProb.thm31` with `reduction`: different (algebraic core), disclosed.**

- Lean: `(hκ0 : 0 < κ) (hκ1 : κ < 1) (hE0 : 0 ≤ E0) (hE1 : 0 ≤ E1) : (∀ r ∈ [0,1], (1-r)E0 + rE1 ≤ 1 ↔ r ≤ κ) ↔ ∃ l ∈ (0,1], E0 = 1-l ∧ E1 = 1 + l(1-κ)/κ`.
- The reduction d(0) = −A, d(1) = N − A from S and ν is done by hand, and only the case p < q is covered. E ≥ 0 is assumed on both sides.
- The answer discloses this: "Algebraic core proved"; "measure-theoretic link … done by hand"; "p>q cases … not written out".

**`EProb.grow` with `grow_in_family`: different / weaker.**

- It bounds the growth of every (E0, E1) > 0 that is valid at κ, for 0 < π₁ < 1, and shows E\* is in the family with λ = (π₁−κ)/(1−κ).
- Uniqueness (the "iff" of Thm 3.2) is not in Lean; the answer says it "follows from the strict version", by hand.
- The E > 0 assumption is disclosed. The restriction π₁ < 1 is not.

**For Thm 3.3: `EProb.nullH_of_lt` with `grow` at κ = p.**

- `nullH_of_lt` is faithful for "H = [0,p] when p < q", and its `Sθ` matches eq. (3).
- Optimality is as for `grow` above: p < q only and no uniqueness. Weaker overall.

**`EProb.prop35_false`: different (arithmetic only), disclosed.**

- Lean: `(1/2)*((EC 1 + EC 1)/2) + (1/2)*((EC 0 + 1)/2) = 5/4`.
- There is no probability space, filtration, stopping time or null hypothesis in the theorem. `null_ok` is the arithmetic ½d(0) + ½d(1) = 0.
- The counterexample itself is correct by hand. Under H_S, P(Y_{t+2} = 1 ∣ ℱ_t) = 1/2 for every t, τ = 3 + Y₃ is a stopping time, and E e_τ = 5/4.

---

## 3. Claims outside the reference (all hand-checked)

"Correct" means the claim is true. "Wrong" claims are false alarms. "Unclear" claims are not counted.

### Kit

| # | Claim | Ruling | Argument |
|---|---|---|---|
| K1 | l.454 prints ∫1{p≤θ<q}(θ − y)dν; the sign should be (y − θ) | correct | S_θ(p,y) − S_θ(q,y) = −(θ − y)1{p ≤ θ < q} for p < q, so the printed form gives d(0) > 0, against l.435. The ratio at l.456 is sign-invariant, so there is no effect on the result. |
| K2 | l.470: the conditioning σ-fields are shifted by h (ruled editorial) | correct | Conditioning on ℱ_{k+hl}, l = 1…⌊(T−k)/h⌋, makes the last factor measurable, so the conditioning has no effect. The right list is ℱ_l for l ∈ I_k. |
| K3 | p_t = q_t is allowed, but E_{p,q;λ} is then 0/0 (candidate, unruled) | correct | The denominator \|S(p,·) − S(q,·)\| is 0. This is a domain clarification. |
| K4 | Prop 3.5 concludes for H_S while it assumes c_t | correct | Minor domain clarification. The authors kept H_S in v3. |
| K5 | e_τ is undefined for τ < h + 1 | correct | e_T is defined only for T ≥ h + 1 (l.223). |
| K6 | l.93 "all consistent scoring functions are of the form" ignores additive terms (e.g. Brier − 5) | correct (minor) | The Brier score equals ∫S_θ·2dθ; adding −5 keeps consistency but breaks the representation. |
| K7 | Typos: l.456 stray `\}`, l.165 unmatched `\big\}`, l.236 "a almost", l.176 `\label` before `\caption`, l.151 garbled sentence, "Lemma" used for Prop 3.4 | correct | All are present in the source. |
| K8 | The l.93 key `Gneiting2007` resolves to Gneiting, Balabdaoui and Raftery (2007), not the JASA paper | correct (as a flag) | Confirmed in the `.bbl`. |
| K9 | l.252 anytime-valid p-value for h ≥ 2 "possibly affected, not checked" | correct, but only flagged | This is the answer key's bonus item. The Kit did not establish it. |
| K10 | Strong positive claims: "Theorem 3.1 holds" and "Theorem 3.2 holds" (including edges and p > q); "h = 1 believed true"; general h ≥ 2 gives E e_τ = 1 + 1/(2h) | correct | Thms 3.1 and 3.2: see `HAND_CHECKS.md`. h = 1: e_t is a nonnegative supermartingale, so the bound follows by Fatou. Formula: a single λ = 1 bet at the boundary, revealed one step early, gives ½·1 + ½·(h+1)/h. |
| K11 | DEFS N2: the logarithmic score is infinite at p ∈ {0,1}, so real-valued consistency on [0,1] excludes it | correct | This concerns the formalization, not the paper. |

### Agent

| # | Claim | Ruling | Argument |
|---|---|---|---|
| A1 | "Sign typo: … It should be (y − θ)" (l.454) | correct | Same as K1. |
| A2 | "S(p,y) can be infinite … mixing density θ⁻³, S(p,0) = ∞" | correct | S(p,0) = ∫_{θ<p} θ·θ⁻³dθ = ∫₀^p θ⁻²dθ = ∞, and θ⁻³dθ is locally finite on (0,1). The difference S(p,0) − S(q,0) is then ∞ − ∞. |
| A3 | Thm 3.2: "the trailing '> 1/π₁' is irrelevant, and there is a stray '}'" | correct | The inequality is true (π₁ > κ) but never used. |
| A4 | Thm 3.3, p > q: "the supremum over θ is not attained" | correct | sup_{θ∈[q,p)}(θ − π) = p − π, approached only as θ → p. |
| A5 | Strong positive claim: "showed directly, without citing Grünwald et al., that the likelihood ratio … is the unique growth-optimal choice among all e-values" | correct | For binary Y, every e-value for H = [0,p] satisfies (1−p)E0 + pE1 ≤ 1. Gibbs' inequality then gives E\*; at π₁ = 1, E1 ≤ 1/p forces E = (0, 1/p). The answer key accepts this route. The Lean covers only p < q and π₁ < 1. |
| A6 | Prop 3.4: p_t = q_t gives 0/0; off by one in the proof; "lemma" naming | correct | Same as K3, K2 and K7. |
| A7 | Prop 3.5: "proof … invalid even when h = 1", because e_t is ℱ_t-measurable | correct | The Kit says the same. |
| A8 | Strong positive claim: Prop 3.5 holds for h = 1 | correct | Nonnegative supermartingale plus Fatou. The Lean version assumes bounded factors. |
| A9 | Strong positive claim: "the procedure … sets λ_t = 0 from τ on and reports e_{τ+h−1}" is valid; "Appendix B's inequality also checks out" | correct | λ_t 1{t < τ} is adapted, e'_T is constant for T ≥ τ + h − 1 and equals e_{τ+h−1}; Fatou gives the bound. This is the published correction's Prop 3.5. Appendix B is unchanged in v3. |
| A10 | "the proposition is stated for H_S instead of H_{S;c}" | correct | Same as K4. |
| A11 | Anytime-valid p-values are "unjustified for h > 1" | correct | This is the answer key's bonus item, replaced for h > 1 in the correction. |
| A12 | "Table 1: all three mixing densities and κ formulas are correct" | correct | Brier: ∫2θ/(2(q−p)) = (p+q)/2. Log: ∫θ^{-1}(1−θ)^{-1}θ = log((1−p)/(1−q)). Spherical: `sph_kappa` compiles. |
| A13 | "Table 3 caption … min(p_t, q_t) ≥ 0.5, but the text defines c_t = 1{max(p_t, q_t) ≥ 0.5}" | correct | l.370 vs l.316; still present in v3. |
| A14 | Case study: "9% or 27% … does not say which airports" | correct | "respectively" has no referent (l.357; PDF text checked). |
| A15 | "Section 4.1: the claim … iff μ ≤ 0.5 is correct" | correct | π_t ≤ (p+q)/2 ⇔ μ ≤ 1/2 when p < q. |

### Chat

| # | Claim | Ruling | Argument |
|---|---|---|---|
| C1 | Thm 3.1: the step "E_π(E) = 1 iff f(π) = 0" "needs a short argument" | correct | The step is omitted but easy (continuity of an affine function). It is a fair implicit step, so this is not a false alarm. |
| C2 | S(p,y) = ∞ is possible; d should be defined as an integral | correct | Same as A2. |
| C3 | Sign error at l.454; stray `\}`; `\{` paired with `\big\}` | correct | Same as K1 and K7. |
| C4 | Shorter proof of Thm 3.2 via Gibbs' inequality | correct | E_{π₁}(E/E\*) = (1−κ)E0 + κE1 ≤ 1. |
| C5 | Thm 3.3 "needs p ≠ q: if p = q then H = [0,1]" | correct (harmless) | At p = q no π₁ ∉ H exists, so the statement is vacuous, not false. The Kit says the same. |
| C6 | Prop 3.4: p_t = q_t; "indices should be … l = 0,…,⌊(T−k)/h⌋−1"; "lemma" naming | correct | Same as K2, K3 and K7. |
| C7 | "The h=1 derivation before it puts Y_{T+1} into the product, while the Proposition uses Y_{l+h} ≤ T" | correct | The two index conventions differ by one; harmless. |
| C8 | Prop 3.5 proof invalid; "Replacing it with F_{t−1} doesn't help either" | correct | 1(τ = t) is not ℱ_{t−1}-measurable. |
| C9 | "Correct version (all h): set λ'_l = λ_l·1{l < τ} … E[e'_{τ+h−1}] ≤ 1"; "I checked the Appendix B argument and it is correct" | correct | Same as A9. |
| C10 | "Any positive dependence between Y_{t+1} and Y_{t+2} produces a similar violation" | unclear | A plausible heuristic, not argued; not load-bearing. |
| C11 | Table 3 caption min vs max | correct | Same as A13. |
| C12 | "'p-values and e-values largely lead to the same conclusions' is overstated", with five cells listed | unclear | The five cells are quoted correctly (e.g. ZRH lag 3: E = 31.9, p = 0.44). "Overstated" is a judgement; the authors kept the sentence in v3. |
| C13 | Rounding inconsistency: 5.9e−05 and 5.0e−05 are shown as 0.0001, while other values below 10⁻⁴ are shown as `<10^{-4}` | unclear | The display fits rounding to four decimals, with `<10^{-4}` used where the rounded value would be 0. At most cosmetic. |
| C14 | Section 5.3: "9% or 27% … respectively" and the 85% figure are garbled | correct (first part) | The first part is the same as A14. That the 85% figure lacks its hypothesis is weak: the context implies the same hypothesis. |
| C15 | **"Section 5.1 has a broken sentence: 'While the stochastic ordering assumption of IDR is certainly reasonable in this application' is left over"** | **wrong (false alarm)** | The phrase is on source line 305, which begins with `%` and is commented out. The compiled PDF reads "…without any tuning parameters. The method is not specifically tailored…" (checked with `pdftotext`). |
| C16 | Supplement "close to μ = 0.05" should be μ = 0.5 | correct | The null boundary is μ = 0.5. At 0.05 the t-test would not over-reject. |
| C17 | Section 4.1 averages e-values, which "also needs the fact that averages of e-values … are again e-values" | correct (minor) | Linearity of expectation, a trivial fact. |
| C18 | Table 1 `\label` precedes `\caption`, "so `Table \ref{tab:scores}` prints the wrong number" | correct | The PDF prints "Table 3.1 gives this boundary". The authors fixed this in v3. |
| C19 | Appendix B "Y_{t+s} ≡ 1 should be Y_{s+h}" | correct | The factor at s is E_{p_s,q_s;λ_s}(Y_{s+h}). |
| C20 | Prop 3.5 "should be H_{S;c}" | correct | Same as K4. |
| C21 | Nine typos ("on on", "are are", "tests tests" ×2, missing "than" ×2, "e-vales", "a almost", "the $1/E$ is", "at time if $T$", "forecasts dominance tests") | correct | All present in the source (l.84, 122, 322/601, 597, 236, 78, 151, 63). |

---

## 4. Totals

### 4a. Totals per arm

| Measure | Kit | Agent | Chat |
|---|---|---|---|
| Results correctly classified (of 5) | 5 | 5 | 5 |
| Nature right (of 3 FALSE/PROOF results) | 3 | 3 | 3 |
| Known problems found (published error: Prop 3.5, h ≥ 2) | 1 of 1 | 1 of 1 | 1 of 1 |
| Bonus, unnumbered (anytime-valid p-value for h > 1) | flagged as "possibly affected, not checked" | yes ("unjustified for h > 1") | no |
| False alarms on numbered results (protocol definition) | 0 | 0 | 0 |
| Wrong claims elsewhere (grader prompt item 3) | 0 | 0 | 1 (Section 5.1 sentence) |
| Lean-backed claims (faithful only) | 3: 3.1 defect, 3.2 defect, 3.5 counterexample | 3: 3.1 statement (incl. λ = 1), 3.2 defect, 3.5 counterexample | 0 |
| Cited inputs, per result 3.1–3.4 (3.5 n.a.) | explicit 4 | proved 2, hidden 2 | proved 1, unbacked 3 |
| Cited inputs, per input (7 inputs, §4b) | explicit 7 | proved 4, explicit 1, hidden 2 | proved 1, unbacked 5, bypassed 1 |

### 4b. Cited inputs per input

| Input | Used by | Kit | Agent | Chat |
|---|---|---|---|---|
| I1: mixture representation of S (cited, l.93; used l.407) | 3.1, 3.2 | explicit (TFA-2, in words) | explicit (Lean works with ν; disclosed) | unbacked (by hand; disclosed) |
| I2: p > q case of 3.1, "similar arguments" (asserted, l.423) | 3.1 | explicit (gap `T01_S10_Gap`) | proved (`thm_uniqueness'`) | unbacked (disclosed) |
| I3: Thm 3.1 necessity, used at l.430 (result with a problem; not load-bearing) | 3.2 | explicit (`T02_T01Consumed`) | proved (`thm_uniqueness`) | bypassed (Gibbs bound over all valid E) |
| I4: p > q case of 3.2, "analogous" (asserted, l.462) | 3.2 | explicit (gap S15) | hidden ("proved in Lean"; p < q only) | unbacked (disclosed) |
| I5: Grünwald et al. Thm 1 (cited, l.466) | 3.3 | explicit (X03) | proved (p < q, π₁ < 1; the rest hidden) | proved (abstract; uniqueness by hand) |
| I6: Thm 3.1 sufficiency (result with a problem) | 3.4 | explicit (`P04_T01Consumed`) | proved in pieces, not composed | unbacked |
| I7: l.106, strict consistency ⇒ ν charges intervals (asserted) | 3.4 | explicit (`P04_MixingOfStrict`) | hidden (factor non-negativity assumed) | unbacked |

### 4c. Summary

1. All three arms classified the five results correctly. Each found the published error in Proposition 3.5 (h ≥ 2) with a correct counterexample, as well as the two minor proof slips in Theorems 3.1 and 3.2, and none raised a false alarm on a numbered result. The Chat arm made one wrong editorial claim about commented-out text.
2. The arms differ in evidence. The Kit and the Agent each have three faithful Lean-backed claims. The Kit's are concrete refutations of the printed steps and of Proposition 3.5. The Agent's are a gap-free proof of Theorem 3.1, the π₁ = 1 defect and a formal counterexample, but its positive results for 3.2–3.4 are narrower than printed (p < q, bounded factors), and it does not always say so. The Chat arm's compiled code is only an algebraic core and arithmetic.
3. On cited inputs, the Kit keeps every input as an explicit Lean hypothesis. The Agent proves most of them, including a direct proof that makes the Grünwald citation unnecessary, but leaves the p > q case of Theorem 3.2 and the l.106 input hidden. The Chat arm leaves most inputs unbacked, though it says so openly.
