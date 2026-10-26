# Grading of B "Convex combinations of random variables stochastically dominate the parent…" (Arab, Lando, Oliveira, arXiv v2): Kit, Agent and Chat

Grader: Claude (authors' assistant), 2026-10-16, following `BASELINE_PROTOCOL.md` and `grader_prompt_B.md`.

**Same source for all arms.**
- The Agent's `source/SuperParetoPaper-v12.tex` is byte-identical to `runsrc/B/SuperParetoPaper-v12.tex`.
- The Chat's `message.txt` is that file followed by prompt P0.
- The Kit's first check used the same file: `verification/source_baseline_v1/` and the before-revision snapshot's `source_baseline/` are identical to it. The Kit's current `source/` differs at lines 219–256, because the revision put the corrigendum's induction step there. That revision is ignored here.

**Inputs read.**
- The paper, `ANSWER_KEY.md`, `answer_key.json` and `HAND_CHECKS.md`.
- Kit:
  - from the before-revision snapshot: `RESULTS.json`, `BLOCKERS.md`, `EXTERNAL_TOOLS.md` and `INVENTORY.md`;
  - the first-round report `report_archive/20261013-113005/AUTHOR_REPORT.md`;
  - the Lean statement, main and counterexample files in `pv_work/`, with T02 taken from `pv_work/superseded/rev1/`;
  - the probe `pv_work/probes/issue/P02/issue_P02_sqrtneg.lean`;
  - `examples-design/results/B-round1/` (`replay.txt`, `score.md`, `usage.md`).
- Agent: `session.json`, the seven files `InvSub/*.lean`, `scratch/num.lean` and `lean_check.md`.
- Chat: `session.json`, `lean_blocks/block_01.lean` and `lean_check.md`.

**Lean re-checks done for this grading.** These ran in `<tmp>/grading-B/`: Lean v4.19.0 with Mathlib `c44e0c8e`, packages symlinked as instructed, no network. Each file compiled with exit 0, and every theorem cited below depends only on `[propext, Classical.choice, Quot.sound]`.

- **Agent.** I re-ran `Counterexamples.lean`, `Main.lean` and `Basic.lean` with `#print axioms`.
  - `lean_check.md` had left `theorem_4_8_false'` as "not printed". It is standard; the prime in its name had defeated the script.
  - `theorem_4_8_false`, `theorem_2_8_false`, `thm_3_1_proof_last_step_false`, `theorem_3_1_st` and `lemma_2_3_needs_F0` are also standard.
  - For the other files I rely on `lean_check.md`: 9/9 files compile, with no `sorry`.
- **Chat.** `block_01.lean` compiles with 0 errors and 2 linter warnings. `shifted_pareto_not_invsub`, `lemma_2_3`, `lemma_4_10` and `thm_4_12` are standard, which agrees with `lean_check.md`. The reply says the code was "not compiled", which is true: the Chat had no tools. It does compile.
- **Kit.** I compiled the cited evidence files against the Kit's own `.olean` files of the imported statement and gap modules. I did not rebuild the import chain; the offline replay (`results/B-round1/replay.txt`) rebuilt it from scratch and confirmed every module.
  - The files: `L01_Counterexample1`, `P01`, `T01_Counterexample1`, `superseded/rev1/T02_Counterexample1`, `P03`, `P04`, `P04_Counterexample2`, `T03_Counterexample1`, `L02_Counterexample1`, `T04`, `P05_Counterexample1`, `P06` and the P02 probe.
  - All are standard: `L01_main_as_printed_false`, `P01_main`, `T01_counterexample`, `not_printedInference`, `intermediate_fails_at_zero`, `not_printedIntermediate`, `final_of_254`, `P03_main`, `P04_main`, `not_PrintedClause1/2`, `not_PrintedThm48`, `not_PrintedThm48Pos`, `L02_main_as_printed_false`, `T04_main`, `P05_as_printed_false`, `P06_main`, `not_S5WithoutNonneg` and `sqrt_not_concaveOn_univ`.

## 0. Reference used

Numbering follows the shared `[theorem][section]` counter. All three arms use the same numbering, and the Kit confirmed it from the PDF up to 4.3. In scope are 16 numbered results:

- 12 have a proof (or a "straightforward" remark) in the paper;
- 4 are statements quoted from other papers: 4.2, 4.3, 4.11 and 4.15.

| No. | Result | Ref. class | Defect (reference wording) | Source |
|---|---|---|---|---|
| 2.3 | InvSub ⇔ (eq:sub-1x) | PROOF (statement false as printed) | the condition F_X(0)=0 of Def 2.2 is missing; X=0 a.s. satisfies (eq:sub-1x) but is not InvSub ("if" direction) | key: verified; HAND_CHECKS: confirmed |
| 2.5 | hazard r_X ≤ 1/x ⇒ InvSub | OK | — | key |
| 2.8 | X InvSub, h continuous star-shaped ⇒ h(X) InvSub | FALSE | h can vanish near 0, so F_{h(X)}(0)>0 (h=max(x−1,0), F_X=x/(1+x)); the proof writes F_{h(X)}=F_X∘h⁻¹ | HAND_CHECKS: confirmed |
| 3.1 | InvSub ⇒ X ≤st ΣθᵢXᵢ | PROOF (published error) | induction step: the first inequality at :256, P ≥ F̄(x/θₙ)+F̄(x/(1−θₙ)), does not follow (a non-positive term is dropped from a lower bound); statement true | key (corrigendum) |
| 3.2 | (eq:main-st) + non-degenerate ⇒ infinite mean | PROOF | (first) the proof uses √X and Jensen for √ but X ≥ 0 is not assumed; (second) "enough to prove n=2" depends on the reading of the hypothesis | HAND_CHECKS: both confirmed, minor |
| 3.3 | InvSub ⇒ E X = ∞ | OK (conditional on the clause of 3.1, (iv)) | — | key |
| 4.2 | adapted Thm 1 of Chen et al. | OK (cited) | — | key: CONDITIONAL (cited) |
| 4.3 | Prop 1 of Chen et al. | OK (cited) | — | key: conditional or not registered |
| 4.6 | DOR ⇔ 𝒫 ≤c F_X (⇔ super-Pareto) | PROOF | non-degeneracy missing: for a Dirac law 𝒫 ≤c F_X holds but the law is not super-Pareto/DOR | HAND_CHECKS: confirmed |
| 4.8 | nonnegative super-Pareto ⇒ InvSub | FALSE | X=Z+1 (Z Pareto(1)) is nonnegative super-Pareto, not InvSub; the proof's "h(0)=0" is wrong | HAND_CHECKS: confirmed |
| 4.10 | super-heavy-tailed ⇔ (eq:inv-NWU) | PROOF (statement false as printed) | F_X(0)=0 missing ("if" direction; X=0 a.s.) | HAND_CHECKS: confirmed |
| 4.11 | adapted Thm 1 of Chen and Shneer | OK (cited) | — | key |
| 4.12 | super-heavy-tailed ⇒ InvSub | OK | ("the exponential is superadditive" is an editorial slip: the inequality used is right) | key; Kit |
| 4.15 | Thm 2.10 of Müller | OK (cited) | — | key |
| 5.2 | super-heavy-tailed ⇔ F_X ≤i-sb ℋ | PROOF (statement false as printed) | F_X(0)=0 missing (X=0 a.s.) | HAND_CHECKS: confirmed |
| 5.3 | F_X(0)=0: InvSub ⇔ F_X ≤i-sb 𝒫 | OK | (the proof silently replaces F_X⁻ of Def 5.1 by F_X; a true, unstated step) | key; Kit: FAIR_IMPLICIT_STEP |

**Rulings the grader had to make.** The same rules are applied to all arms.

1. **Cited statements: 4.2, 4.3, 4.11, 4.15.** They have no proof in the paper. All three arms say the same thing about them: cited, not checked.
   - Kit: the report says "External assertions not encoded: Theorems 4.2, 4.11, 4.15 … (cited, unused by any numbered result)", and 4.3 is the parameter `P04_X01Tool`.
   - Agent: "Quoted from the literature … Not checked against the source".
   - Chat: "the cited Theorems 4.2, 4.11 and 4.15 and Prop 4.3, which are taken from other papers".

   I count this as OK (conditional on the citation) for every arm. The key accepts "not registered" for 4.3, 4.11 and 4.15. For 4.2 it expects CONDITIONAL, and the Kit's own `score.md` counts 4.2 as "missing". Under that strict reading all three arms would be OPEN on 4.2 alike, so totals are given both over the 12 proved results and over all 16.
2. **Missing F_X(0)=0 or non-degeneracy (2.3, 4.6, 4.10, 5.2).** The protocol names this as a case where FALSE versus PROOF is a matter of reading. I accept either reading as "nature right".
3. **Editorial points on 4.12 and 5.3.** All three arms name the same two points:
   - "the exponential is superadditive" (4.12);
   - the F⁻→F switch (5.3).

   All three say the statement holds and the needed fact is true. The Kit labels the points editorial or fair implicit steps; the Agent writes "Wrong reason, inequality right" and "Has a gap … Proved"; the Chat writes "⚠️". I count all of these as OK with the step named, as E1 did for 2.4 in the other direction.
   - The labels "gap" and "wrong reason" could instead be read as PROOF. The Agent and the Chat would then each lose two results (4.12 and 5.3).
   - It would not create false alarms: the observations are correct.

**Known problems in the reference.**
- Published error: the 3.1 induction step.
- Confirmed by hand, not in the key: 2.3, 2.8, 3.2, 4.6, 4.8, 4.10 and 5.2. These seven come from the Kit's own run (`HAND_CHECKS.md`), so the reference is built around the Kit's findings. The baselines' own extra findings are checked in §3; none of them concerns the correctness of a proved numbered result.

**Cited or unproved inputs, by result.**

| Result | Inputs |
|---|---|
| 2.5 | "concave/anti-star-shaped and vanishing at 0 ⇒ subadditive" (asserted as well known); the sign of the derivative ⇒ monotonicity ("easily seen") |
| 3.1 | the "only if" half of Lemma 2.3; the conditioning/Stieltjes formula and the figure bounds ("easily seen", "follows easily") |
| 3.2 | "≤st with equal finite means ⇒ equal law"; strict Jensen for √ |
| 3.3 | the clauses of 3.1 (proof fails, statement true) and 3.2 (proof gap) |
| 4.6 | Prop 4.3 (cited) for the parenthetical |
| 4.12 | e^{a+b} ≥ e^a+e^b−1 for a,b ≤ 0; the Log 0 case |
| 5.2, 5.3 | quantile formulas; F⁻→F |
| 4.2, 4.3, 4.11, 4.15 | the citations themselves |

For 2.8 and 4.8 every arm gives FALSE with a counterexample, so input handling is n.a. 2.3 and 4.10 use no input.

## 1. Per-result tables

Classes are read from the final answers:
- Kit: `RESULTS.json` and `BLOCKERS.md`, and the report for the cited statements;
- Agent: its "Verdicts" table and main findings;
- Chat: its "Summary" table and result-by-result notes.

### Kit (`errata-b-arab-lando-oliveira-check`, first check, before revision)

| No. | Ref. | Kit verdict | Class | Correctly classified | Nature right | False alarm | Lean-backed (theorem) | Cited-input handling |
|---|---|---|---|---|---|---|---|---|
| 2.3 | PROOF | ISSUE B01 `PAPER_ASSUMPTION_GAP`: "omits the condition F_X(0)=0 … the 'if' direction … is false as printed" | PROOF | yes | yes | no | yes: `Paper.L01.L01_main_as_printed_false` | n.a. |
| 2.5 | OK | UNCONDITIONAL | OK | yes | n.a. | no | yes: `Paper.P01.P01_main` | proved (anti-star-shaped ⇒ subadditive and the derivative step, in integrated form) |
| 2.8 | FALSE | ISSUE B05 `ERROR`: "h(x)=max(x-1,0) gives F_{h(X)}(0)=1/2" | FALSE | yes | yes | no | yes: `Paper.T01.Issue1.T01_counterexample` | n.a. |
| 3.1 | PROOF | ISSUE B06 `PAPER_ARGUMENT_GAP`: "the first inequality at :256 … is false … the final bound P ≥ F̄(x) still follows from :254" | PROOF | yes (step :256) | yes | no | yes for the defect: `Paper.T02.Issue1.not_printedInference`, `intermediate_fails_at_zero` (rev1). The statement is not proved (n ≥ 3 gaps). | explicit (`T02_L01Consumed`) |
| 3.2 | PROOF | ISSUE B02 `PAPER_ARGUMENT_GAP` (√X without X≥0) and B03 `DOMAIN_CLARIFICATION` (n=2) | PROOF | yes (both) | yes | no | no: B02 has only an obstruction probe (§2); B03 is reasoning | proved (n=2, X≥0 steps in `P02ModGaps`) |
| 3.3 | OK | CONDITIONAL [`P03_T02Consumed`, `P03_P02Consumed`, `T02_L01Consumed`] | OK | yes | n.a. | no | no as a faithful statement: `Paper.P03.P03_main` is weaker (three consumed clauses, disclosed) | explicit |
| 4.2 | OK (cited) | not registered; report: "cited, unused by any numbered result" | OK (cited) | yes (ruling 1) | n.a. | no | n.a. | explicit |
| 4.3 | OK (cited) | external input `P04_X01Tool` (i), with a human check of "the F<1 condition and the domain of concavity" | OK (cited) | yes | n.a. | no | n.a. | explicit |
| 4.6 | PROOF | ISSUE B07 `PAPER_ASSUMPTION_GAP`: "false for X a.s. constant" | PROOF | yes | yes | no | yes: `Paper.P04.Issue2.not_PrintedClause1`, `not_PrintedClause2` | explicit (`P04_X01Tool`) |
| 4.8 | FALSE | ISSUE B09 `ERROR` (max(Z−2,0) and Z+1), B10 `PAPER_ARGUMENT_GAP` (h(0)=0 at :337) | FALSE | yes | yes | no | yes: `Paper.T03.Issue1.not_PrintedThm48`, `not_PrintedThm48Pos` | n.a. |
| 4.10 | PROOF | ISSUE B04 `PAPER_ASSUMPTION_GAP` | PROOF | yes | yes | no | yes: `Paper.L02.L02_main_as_printed_false` | n.a. |
| 4.11 | OK (cited) | not registered (as 4.2) | OK (cited) | yes | n.a. | no | n.a. | explicit |
| 4.12 | OK | UNCONDITIONAL; "'exponential is superadditive' at :383 is an editorial slip" | OK | yes | n.a. | no | yes: `Paper.T04.T04_main` | proved (both inputs, incl. the Log 0 case S4z) |
| 4.15 | OK (cited) | not registered (as 4.2) | OK (cited) | yes | n.a. | no | n.a. | explicit |
| 5.2 | PROOF | ISSUE B08 `PAPER_ASSUMPTION_GAP` | PROOF | yes | yes | no | yes: `Paper.P05.P05_as_printed_false` | proved (S1–S3 in `P05ModGaps`) |
| 5.3 | OK | UNCONDITIONAL; "the F^- to F switch (S3) and the p=1 edge (S1') are fair implicit steps" | OK (step named) | yes | n.a. | no | yes: `Paper.P06.P06_main` | proved |

### Agent (`B-agent`, final "Verdicts" table)

| No. | Ref. | Agent's words (Statement / Proof / Lean) | Class | Correctly classified | Nature right | False alarm | Lean-backed (theorem) | Cited-input handling |
|---|---|---|---|---|---|---|---|---|
| 2.3 | PROOF | "Correct, if F(0)=0 is assumed (without it, the Dirac mass at 0 is a counterexample) / Correct / Proved" | PROOF (missing hypothesis) | yes | yes | no | yes: `lemma_2_3_needs_F0` (defect), `lemma_2_3` (corrected statement) | n.a. |
| 2.5 | OK | "Correct / Correct / Proved (assuming F is differentiable on (0,∞))" | OK | yes | n.a. | no | no: `prop_2_5` is weaker (§2) | explicit (differentiability assumption disclosed; the subadditivity fact is proved in `subadd_of_antistar`) |
| 2.8 | FALSE | "**False** / Wrongly treats h as increasing and never checks F(0)=0 / Counterexample; corrected version proved" | FALSE | yes | yes | no | yes: `theorem_2_8_false` | n.a. |
| 3.1 | PROOF | "Correct / **Last step wrong**, easy to repair / Proved, all n" | PROOF | yes | yes | no | yes: `theorem_3_1_st` (statement) and `thm_3_1_proof_last_step_false` (defect) | proved (whole theorem, no parameters) |
| 3.2 | PROOF | "Correct, but loosely stated / Has gaps"; "√X needs X ≥ 0 … 'Enough to prove n = 2' is not justified" / "Not formalised; checked by hand" | PROOF | yes (both) | yes | no | no | unbacked |
| 3.3 | OK | "Correct / Correct (relies on 3.1 and 3.2) / Proved directly, without 3.1/3.2" | OK | yes | n.a. | no | yes: `prop_3_3` | proved (direct proof; 3.1 is also proved) |
| 4.2 | OK (cited) | "Quoted from the literature / — / Not checked against the source" | OK (cited) | yes | n.a. | no | n.a. | explicit |
| 4.3 | OK (cited) | "Quoted; needs 'on the support' / — / Not checked" | OK (cited), plus a correct domain remark (§3) | yes | n.a. | no | n.a. | explicit |
| 4.6 | PROOF | "Correct / Brief: one part needs the inverse of an increasing convex function to be concave / Key identity proved" | OK | **no** (misses non-degeneracy) | n.a. | no | no: `prop_4_6_identity` is one algebraic identity | unbacked (the parenthetical rests on 4.3; not said) |
| 4.8 | FALSE | "**False** / Wrong ('h(0)=0') / 2 counterexamples; corrected version proved" | FALSE | yes | yes | no | yes: `theorem_4_8_false`, `theorem_4_8_false'` | n.a. |
| 4.10 | PROOF | "Correct (no proof given; 'straightforward') / — / Proved" | OK | **no** (misses F_X(0)=0) | n.a. | no | no: `lemma_4_10` uses a definition without F_X(0)=0 (§2) | n.a. |
| 4.11 | OK (cited) | "Quoted from the literature / — / Not checked against the source" | OK (cited) | yes | n.a. | no | n.a. | explicit |
| 4.12 | OK | "Correct / Wrong reason, inequality right / Proved" | OK (editorial point named) | yes (ruling 3) | n.a. | no | no: `theorem_4_12` is weaker (positivity assumed) | hidden (F>0 on (0,∞), i.e. the Log 0 case, is assumed in Lean and not mentioned in the answer; harmless, see §2) |
| 4.15 | OK (cited) | "Quoted; 'super-Fréchet' undefined / — / Not checked against the source" | OK (cited) | yes | n.a. | no | n.a. | explicit |
| 5.2 | PROOF | "Correct / Has a gap (F⁻ vs F) / Quantile identity proved" | PROOF, but a different defect | **no** (misses F_X(0)=0) | n.a. | no (the F⁻/F remark is correct) | no: `frechet_quantile` is a step | unbacked ("only Prop 5.3's version is formalised") |
| 5.3 | OK | "Correct / Has a gap (F⁻ vs F) / Proved" | OK (step named and closed) | yes (ruling 3) | n.a. | no | no: `prop_5_3_core` and `subA_iff_subB` are not assembled into the statement | proved (both components in Lean) |

### Chat (`B-chat`, single reply)

| No. | Ref. | Chat's words (Statement / Proof) | Class | Correctly classified | Nature right | False alarm | Lean-backed (theorem) | Cited-input handling |
|---|---|---|---|---|---|---|---|---|
| 2.3 | PROOF | "✅ (needs F(0)=0 in the 'if' direction) / ✅"; "(eq:sub-1x) does not imply it" | PROOF (missing hypothesis) | yes | yes | no | no: `lemma_2_3` is the subadditivity core for an arbitrary F | n.a. |
| 2.5 | OK | "✅ / ✅ (holds more generally)" | OK | yes | n.a. | no | no: `prop_2_5_general` is a different statement | unbacked (the density ⇒ monotonicity link is prose; the subadditivity fact is proved) |
| 2.8 | FALSE | "❌ as stated; ✅ if h(x)>0 for x>0 / inequality ✅; F(0)=0 not checked" | FALSE | yes | yes | no | no: `thm_2_8_ineq` is the inequality step; the counterexample is a comment | n.a. |
| 3.1 | PROOF | "✅ / ❌ **final step is invalid** (fixable); also an event-decomposition slip" | PROOF | yes | yes | no | no: `paper_step_wrong_direction` and `paper_claim_exceeds_one` are algebraic or numeric cores | unbacked ("The measure-theoretic layer is described in prose but not formalized") |
| 3.2 | PROOF | "✅ (should say i.i.d. copies, X ≥ 0) / ✅ but convoluted; 'enough to prove n=2' unjustified" | PROOF | yes (both) | yes | no | no: `sqrt_strict_concave` is a step | unbacked ("≤st with equal finite means ⇒ equal in law" not formalized) |
| 3.3 | OK | "✅ / ✅"; gives a direct route | OK | yes | n.a. | no | no: `subadd_nsmul` is a step | unbacked |
| 4.2, 4.3, 4.11, 4.15 | OK (cited) | "Not formalized: … the cited Theorems 4.2, 4.11 and 4.15 and Prop 4.3, which are taken from other papers" | OK (cited) | yes (4/4) | n.a. | no | n.a. | explicit |
| 4.6 | PROOF | "✅ / ✅ (sketchy)" | OK | **no** (misses non-degeneracy) | n.a. | no | no: `pareto_quantile` | unbacked |
| 4.8 | FALSE | "❌ **FALSE** / ❌ wrong claim h(0)=0" | FALSE | yes | yes | no | no: `shifted_pareto_not_invsub` is weaker (§2) | n.a. |
| 4.10 | PROOF | "✅ / ✅" ("Both are correct") | OK | **no** (misses F_X(0)=0) | n.a. | no | no: `lemma_4_10` is a different statement | n.a. |
| 4.12 | OK | "✅ / ⚠️ wrong justification ('exp is superadditive')" | OK (editorial point named) | yes (ruling 3) | n.a. | no | no: `thm_4_12` is weaker (positivity assumed) | hidden (F>0 assumed, not mentioned) |
| 5.2 | PROOF | "⚠️ needs F(0)=0 / ⚠️ F vs F⁻ mismatch"; "Otherwise X ≡ 0 satisfies F ≤_{i-sb} ℋ but is not super-heavy-tailed" | PROOF | yes | yes | no | no: `frechet_quantile` | unbacked (F⁻→F in prose) |
| 5.3 | OK | "✅ / ⚠️ same F vs F⁻ mismatch" ("harmless, but needs a line") | OK (step named) | yes | n.a. | no | no: `pareto_quantile` | unbacked |

## 2. Faithfulness of the cited Lean theorems

**Definitions.**

- **Kit.** It represents X by its law μ, a probability measure on ℝ.
  - `Paper.L01.IsInvSub μ := F μ 0 = 0 ∧ SubadditiveOn (1 − F μ (1/·)) (Ioi 0)` is Def 2.2, with the domain of the inverted distribution read as (0,∞). `Paper.P06.IsInvSub` is the same.
  - `Paper.L02.IsSuperHeavyTailed` is F(0)=0 together with subadditivity of an `EReal`-valued −Log F(1/x), with −Log 0 = ⊤. This is Def 4.9(1), with log 0 handled correctly rather than by Lean's junk value.
  - `Paper.P04.SuperPareto`: μ is the image of the Pareto(1) law under h, with h monotone, convex and nonconstant on [1,∞).
  - `DOR` and `ConvexTransformLE` use concavity or convexity on {0<F<1}. This domain choice is disclosed, and the counterexample review also checked readings R2–R4.
  - Def 5.1 uses `Function.leftLim`, an `EReal` generalised inverse, and 1/0=⊤, 1/⊤=0.
  - Restriction, disclosed: real-valued variables only, so Example 2.7 (mass at +∞) is outside.
- **Agent.**
  - `InvSub μ := cdf μ 0 = 0 ∧` subadditivity of 1−cdf μ(1/x) on (0,∞): matches Def 2.2.
  - `SuperPareto` asks h to be monotone and convex on all of ℝ and nonconstant. This is stricter than Def 4.1 and makes the counterexamples only stronger.
  - In `Analytic.lean`, `SHT F` is subadditivity of the real-valued −log F(1/x), without F_X(0)=0, and `SubInv F` is subadditivity only. **`SHT` does not match Def 4.9**: it drops F_X(0)=0, the exact condition Lemma 4.10 omits, and it relies on Lean's log 0 = 0, compensated by an added hypothesis F>0. Its docstring says "(forced anyway, see the report)", but the report gives no argument. By hand, the claim is true for real-valued X with F_X(0)=0: if F(t₀)=0 for some t₀>0, let s = sup{t : F(t)=0} > 0. Then x=y=0.6/s gives a finite −log F(1/x), while −log F(1/(x+y)) = +∞, so subadditivity fails.
- **Chat.** `SubaddPos (inv F)` is subadditivity on (0,∞) of 1−F(1/x) for an arbitrary F : ℝ → ℝ, with no measures and no F(0)=0. The reply says so: "The Lean code only formalizes the deterministic real-analysis core of each result."

### Kit (`lean_main` of RESULTS.json, or the counterexample file for an issue)

| No. | Printed statement (brief) | Lean (abridged) | Verdict | Reason |
|---|---|---|---|---|
| 2.3 | "X is InvSub if and only if (eq:sub-1x)" | `L01_main_as_printed_false : ¬ (∀ μ [IsProbabilityMeasure μ], IsInvSub μ ↔ SubCond μ)` | faithful (negation) | The witness is δ₀. `SubCond` is (eq:sub-1x) for x ≥ 0 and θ∈(0,1). RESULTS.json has no `lean_main` for L01. |
| 2.5 | "nonnegative X has density f_X with r_X(x) ≤ 1/x, x>0. Then X is InvSub" | `P01_main (μ) [IsProbabilityMeasure μ] (hnn : μ (Iio 0) = 0) (f) (hf) (hdens : μ = volume.withDensity f) (hhaz : ∀ x>0, hazard μ f x ≤ 1/x) : InvSub μ` | faithful | `InvSub` includes F(0)=0. The hazard uses Lean division, which makes the hypothesis vacuous only where F̄=0, where the paper's r_X is undefined. |
| 2.8 | "X InvSub, h continuous star-shaped ⇒ h(X) InvSub" | `T01_counterexample : ¬ PrintedThm28`, where `PrintedThm28 := ∀ μ h, IsInvSub μ → Continuous h → StarShaped h → IsInvSub (μ.map h)` | faithful (negation) | Continuity on ℝ makes `PrintedThm28` weaker than printed, so refuting it refutes the printed theorem. The recorded `lean_main` `T01_main_mod_gaps` is vacuous; the Kit says "do not cite it". |
| 3.1 (step) | :256 "P(θ₁X₁+⋯+θₙXₙ > x) ≥ F̄(x/θₙ)+F̄(x/(1−θₙ))" | `not_printedInference : ¬ (∀ P a b d, … a−b−d ≤ 0 → b+d+a(a−b−d) ≤ P → b+d ≤ P)`; `intermediate_fails_at_zero : IsInvSub (μ.map X) → ¬ (F̄(0/θₙ)+F̄(0/(1−θₙ)) ≤ P(ΣθᵢXᵢ > 0))` | faithful | These are the printed inference and the printed intermediate at x=0 (allowed by :191); both are unconditional. `not_printedIntermediate`, the instance with every premise including the induction hypothesis, takes `T02_L01Consumed` (the true "only if" half of 2.3) as a hypothesis. That is weaker, and disclosed in B06. The recorded `lean_main` `T02_main_mod_gaps` is "uninformative" (Kit). |
| 3.2 (B02) | :266 "Jensen's inequality implies E√Y > … = E√X" | probe `not_S5WithoutNonneg`, `sqrt_not_concaveOn_univ` | different (obstruction only) | It shows that Mathlib's total √ (√x=0 for x<0) is not concave on ℝ and that the strict step then fails for a negative instance. Its force depends on that convention: in the paper √ of a negative number is undefined. The Kit itself says "B02 has obstruction evidence only", and the replay says "no Lean counterexample". The recorded `P02_main_mod_gaps` only applies its two gap hypotheses. |
| 3.3 | "If X is InvSub, then E X is infinite" | `P03_main (hL01 : T02_L01Consumed) (hT02 : P03_T02Consumed) (hP02 : P03_P02Consumed) … (hits : IsInvSub (μ.map X)) : ¬ Integrable X μ` | weaker (three consumed clauses, disclosed as CONDITIONAL) | The clauses are 3.1 at n=2, θ=½; 3.2 at n=2 for real-valued X; and the "only if" half of 2.3. All three are true, but none is proved in this project. |
| 4.6 | "F_X is DOR (or, equivalently, X is super-Pareto) iff 𝒫 ≤c F_X …" | `not_PrintedClause1 : ¬ ∀ μ, (DOR μ ↔ ConvexTransformLE paretoCdf (F μ))`; `not_PrintedClause2` (super-Pareto clause) | faithful (negation) | The witness is δ₀; under the Kit's domain reading, with readings R2–R4 checked by the review. The recorded `P04_main` is the corrected statement: it adds `hnd : ∀ c, μ ≠ dirac c` and `P04_X01Tool`, so it is weaker, and this is disclosed. |
| 4.8 | "If X is nonnegative super-Pareto then X is InvSub" | `not_PrintedThm48 : ¬ ∀ μ, SuperPareto μ → Nonneg μ → IsInvSub μ` (max(Z−2,0)); `not_PrintedThm48Pos` (adds F μ 0 = 0; witness Z+1) | faithful (negation) | The recorded `lean_main` `T03Draft.lean:61 Paper.T03.T03_main` is a draft with `sorry`. It is not evidence and the verdict does not use it; it is a record slip. |
| 4.10 | "X super-heavy-tailed iff (eq:inv-NWU)" | `L02_main_as_printed_false : ¬ ∀ μ, IsSuperHeavyTailed μ ↔ InvNWUCond μ` | faithful (negation) | The witness is δ₀. `L02_main_mod_gaps` is vacuous, as the Kit says. |
| 4.12 | "If X is super-heavy-tailed, then X is InvSub" | `T04_main (μ) [IsProbabilityMeasure μ] (h : IsSuperHeavyTailed μ) : IsInvSub μ` | faithful | No extra hypothesis; the F(1/x)=0 case is handled inside. |
| 5.2 | "X super-heavy-tailed iff F_X ≤i-sb ℋ" | `P05_as_printed_false : ¬ ∀ μ, (IsSuperHeavyTailed μ ↔ InvSubLE (F μ) Hcdf)` | faithful (negation) | The witness is δ₀. `P05_main_mod_gaps` is vacuous, as the Kit says. |
| 5.3 | "X with F_X(0)=0 is InvSub iff F_X ≤i-sb 𝒫" | `P06_main (μ) (h0 : cdf μ 0 = 0) : IsInvSub μ ↔ isbOrder (cdf μ) paretoCdf` | faithful | F⁻ is used as in Def 5.1. |

### Agent

| No. | Printed statement | Lean signature (abridged) | Verdict | Reason |
|---|---|---|---|---|
| 2.3 | as above | `lemma_2_3_needs_F0 : Cond23 (cdf (dirac 0)) ∧ ¬ InvSub (dirac 0)`; `lemma_2_3 : InvSub μ ↔ cdf μ 0 = 0 ∧ Cond23 (cdf μ)` | faithful (refutes the printed "if") / the corrected statement | `Cond23` is (eq:sub-1x) for x ≥ 0. The corrected form is stated openly ("with the standing hypothesis F_X(0)=0 made explicit"). |
| 2.5 | as above | `prop_2_5 (F f : ℝ → ℝ) (hF : ∀ u>0, HasDerivAt F (f u) u) (hhaz : ∀ u>0, u * f u ≤ 1 − F u) : SubInv F` | weaker | F must be differentiable at every u>0, whereas a density gives differentiability only almost everywhere; this is disclosed. The conclusion lacks the F_X(0)=0 half of InvSub, which is trivial for a nonnegative X with a density but is not said. F is not tied to a law. |
| 2.8 | as above | `theorem_2_8_false : InvSub paretoμ ∧ Continuous hcut ∧ hcut 0 = 0 ∧ MonotoneOn (hcut x / x) (Ioi 0) ∧ ¬ InvSub (paretoμ.map hcut)` | faithful (negation) | hcut = max(x−2,0). Star-shaped is h(0)=0 with h(x)/x nondecreasing, as in the paper. |
| 3.1 | "If X is InvSub, then (eq:main-st) holds" | `theorem_3_1_st (μ) [IsProbabilityMeasure μ] (hμ : InvSub μ) (n) (θ) (hθ : ∀ i, 0 ≤ θ i) (hs : Σθᵢ = 1) (x) : μ (Ioi x) ≤ (Measure.pi fun _ => μ) {ω \| x < Σ θᵢ ωᵢ}` | faithful | i.i.d. copies are modelled by the product law, with zero weights allowed as in (1). The statement is for real-valued X; Example 2.7's mass at +∞ is outside, which is the standard reading. |
| 3.1 (step) | :256 as above | `thm_3_1_proof_last_step_false : InvSub paretoμ ∧ F̄(6/5) + F̄(6/5) > 1` (x=3/5, θₙ=½) | faithful in substance | The right side of :256 exceeds 1 for an InvSub law, so "P ≥ right side" fails. The trivial link P ≤ 1 is left to the reader. |
| 3.3 | as above | `prop_3_3 (μ) [IsProbabilityMeasure μ] (h : InvSub μ) : ¬ Integrable id μ` | faithful | X ≥ 0 a.s. follows from F(0)=0, so non-integrable means E X = ∞. The proof is direct and independent of 3.1 and 3.2. |
| 4.6 | as above | `prop_4_6_identity (F : ℝ) (h : F < 1) : 1/(1−F) = F/(1−F) + 1` | different (one identity) | It does not back "Correct". |
| 4.8 | as above | `theorem_4_8_false : SuperPareto shiftμ ∧ shiftμ (Iio 0) = 0 ∧ cdf shiftμ 0 = 0 ∧ ¬ Cond23 … ∧ ¬ InvSub shiftμ`; `theorem_4_8_false'` (max(Z−2,0)) | faithful (negation) | The witness Z+1 is nonnegative, and super-Pareto under a stricter definition. |
| 4.10 | "X super-heavy-tailed iff (eq:inv-NWU)" | `lemma_4_10 (F) (hpos : ∀ u>0, 0 < F u) : SHT F ↔ Cond410 F` | different | `SHT` omits F_X(0)=0 from Def 4.9, so the theorem cannot see the defect. It adds the hypothesis F>0, covers x>0 only, and F is an arbitrary function. The answer's "Correct … Proved" rests on this mismatch. |
| 4.12 | as above | `theorem_4_12 (F) (hpos : ∀ u>0, 0 < F u) (hle : ∀ u, F u ≤ 1) (h : SHT F) : SubInv F` | weaker | The positivity hypothesis is not mentioned in the answer. It is true for super-heavy-tailed laws, by the hand argument above, but not proved. F(0)=0 is absent on both sides, which is harmless here. |
| 5.2 | as above | `frechet_quantile : sSup {x \| ℋ x ≤ p} = −1/log p ∧ 1/(−1/log p) = −log p` | different (a step) | — |
| 5.3 | as above | `prop_5_3_core : 1 / sSup {x \| 𝒫 x ≤ p} = 1 − p` (p∈[0,1)); `subA_iff_subB : SubA μ ↔ SubB μ` (subadditivity of P(X > 1/x) ⇔ of P(X ≥ 1/x)) | different (the two components, not assembled) | The p=1 edge and the composition with F⁻(1/x) are not in Lean. Both components are correct. |

The corrected versions `theorem_2_8_corrected` (add h>0 on (0,∞)) and `theorem_4_8_corrected` (X=h(Y), F_Y(x)=x/(1+x), h convex with h(0)=0 and h>0 on (0,∞)) are not paper statements. They compile with standard axioms and use no cited lemma; Lemma 4.1 of the cited paper is not needed.

### Chat

| No. | Printed statement | Lean signature (abridged) | Verdict | Reason |
|---|---|---|---|---|
| 2.3 | as above | `lemma_2_3 (F) : SubaddPos (inv F) ↔ ∀ x θ, 0<x → 0<θ → θ<1 → F(x/θ)+F(x/(1−θ)) ≤ F x + 1` | different | This is the rewriting step for an arbitrary F, for x>0 only, without F(0)=0. It neither proves nor refutes the printed lemma. |
| 2.5 | as above | `prop_2_5_general (F) (hmono : ∀ u v, 0<u → u≤v → u(1−F u) ≤ v(1−F v)) : SubaddPos (inv F)` | different | It is a density-free sufficient condition for the subadditivity half only. The link from the hazard condition to the hypothesis is prose. |
| 2.8 | as above | `thm_2_8_ineq (F k) (hF : Monotone F) (hITS) (hkpos) (hk : k(x/θ) ≤ k x/θ) : … ≤ F(k x) + 1` | different (a step under the cited lemma as hypothesis) | The counterexample is only in a comment. |
| 3.1 (step) | :256 | `paper_step_wrong_direction (c A B) : 0 ≤ c → c ≤ A+B → A+B+c(c−A−B) ≤ A+B`; `paper_claim_exceeds_one : 1 < 2(1 − e^{−5})` | different | The first shows only the direction of the bound. The second is a numeric fact; that A=B=1−e^{−5} is the Fréchet survival at 0.2 is prose. |
| 3.2 | as above | `sqrt_strict_concave` (two-point strict Jensen) | different (a step) | — |
| 3.3 | as above | `subadd_nsmul : g((n+1)x) ≤ (n+1) g x` | different (a step) | — |
| 4.6, 5.2, 5.3 | as above | `pareto_quantile`, `frechet_quantile`, `one_sub_exp_subadd` | different (steps) | — |
| 4.8 | as above | `shifted_pareto_not_invsub : ¬ SubaddPos (inv Fshift)`, `Fshift x := if x < 2 then 0 else 1 − 1/(x−1)` | weaker (the core of the counterexample) | The InvSub failure of this explicit function is in Lean. That Fshift is the cdf of Z+1, and that Z+1 is nonnegative and super-Pareto, is a comment. |
| 4.10 | as above | `lemma_4_10 (F) (hF : ∀ t>0, 0 < F t) : SubaddPos (−log F(1/·)) ↔ …` | different | No F_X(0)=0 and an added positivity hypothesis, as with the Agent. |
| 4.12 | as above | `thm_4_12 (F) (hF0 : ∀ t>0, 0 < F t) (hF1 : ∀ t, F t ≤ 1) (h : SubaddPos (−log F(1/·))) : SubaddPos (inv F)` | weaker (positivity) | — |

Outside the numbered results, `R_exceeds_one`, `V_exceeds_one` (Examples 4.13 and 4.16 exceed 1 at x=1) and `geom_superheavy` (c·⌈x⌉ is subadditive) state what the Chat claims about the examples.

## 3. Claims outside the reference, and strong positive claims

### Kit

Its findings B01–B10 are the reference. Further claims:

1. **Real-valued InvSub laws have no atoms.** Report §4.3 and §4.9: "The argument that real-valued InvSub laws have no atoms is gate reasoning only and does not cover Example 2.7". **Correct**: see Chat item 1.
2. **Atoms and zero weights in 3.1.** "Unruled suspicions: :222-223 strict vs non-strict events with possible atoms; :95 (θᵢ ≥ 0) vs :219 (θᵢ > 0), zero weights". **Correct and minor.** The display double-counts {Xₙ = x/θₙ}, which matters only for laws with atoms, i.e. extended-valued ones like Example 2.7. Zero weights reduce to fewer variables.
3. **A non-degenerate counterexample to 2.3.** "p·δ₀+(1−p)·Fréchet(1)" (reasoning only). **Correct.** With a=e^{−θ/x} and b=e^{−(1−θ)/x}, F(x/θ)+F(x/(1−θ))−F(x)−1 = −(1−p)(1−a)(1−b) ≤ 0, and F(0)=p>0.
4. **The fixes for 2.8 and 4.8.**
   - For 2.8: "add 'h(x)>0 for x>0' … 'h nonconstant' or 'increasing and convex' do not suffice". **Correct**: max(x−1,0) is increasing and convex. The Agent's `theorem_2_8_corrected` proves the fix.
   - For 4.8: "F_X(0)=0 and F_X(x)>0 for every x>0; then h(0)=0 follows". **Correct.** It is equivalent to the Agent's Lean-proved `theorem_4_8_corrected`, after redefining h at the null point z=1.
5. **Caution on B04.** Dropping F(0)=0 from Def 4.9 instead would make Thm 4.12 fail at δ₀. **Correct**: δ₀ would be super-heavy-tailed (−log 1 = 0) but not InvSub.
6. **Editorial points.** All **correct**:
   - :153 "negative" should be "non-positive";
   - :385 the exponential slip;
   - :174 "only F_X increasing is needed" for that step;
   - :143 θ∈[0,1] against (0,1);
   - the conventions at :434 and :445 are unstated;
   - :269: a point mass violates (eq:sub-1x) at x=c/2, θ=½ (F(c)+F(c) = 2 > 0+1).
7. **Unchecked notes.**
   - INVENTORY notes: "Super-Frechet is used … but never defined", and Example 4.16 "V as written exceeds 1 for large x: not checked here". Both are **correct**.
   - The report lists Examples 4.13 and 4.16 under "not checked". The Kit did not draw the conclusion that both examples fail; the baselines did.
8. **Record slips, not about the paper.**
   - `RESULTS.json` gives T03's `lean_main` as a `sorry` draft.
   - L01 has no `lean_main`.
   - The `lean_main` of T01, T02, L02 and P05 are vacuous gap theorems, and `P02_main_mod_gaps` only applies its gap hypotheses. The report discloses all of these.

No wrong claim found.

### Agent

1. **Thm 2.8, h not increasing.** "Wrongly treats h as increasing". **Correct**: h(x) = −x/(1+x) is continuous and star-shaped (h(0)=0, h(x)/x = −1/(1+x) nondecreasing) and decreasing. The Kit's B05 notes and fact check say the same.
2. **Thm 2.8, the fix.** "add h > 0 on (0,∞). With that the proof goes through; Lean proves the corrected version." **Correct**: `theorem_2_8_corrected` is standard.
3. **Thm 4.8.**
   - "(2.3) fails at x = 5/2, θ = 1/2: 3/4 + 3/4 > 1/3 + 1". **Correct**: F_X(5) = 1 − 1/4 and F_X(5/2) = 1 − 2/3.
   - "Shift invariance only gives this for X − ess inf X, and InvSub is not shift-invariant (the paper says so itself in Section 5)". **Correct** (:426).
   - The fix "require h(0) = 0 and h > 0 on (0,∞)". **Correct**, Lean-backed.
4. **Thm 3.1.**
   - "For Pareto(1) at x = 3/5, θ = 1/2 the right side is 5/3 > 1". **Correct**: F̄(6/5) = 5/6.
   - The fix "(1−c)(a+b−c)". **Correct**: a+b+c(c−a−b) − c = (1−c)(a+b−c).
   - "Lean proves the full theorem for all n, with weights allowed to be 0". **Correct.**
   - "double-counts the event Xₙ = x/θₙ". **Correct**: Kit item 2.
5. **Examples 4.13 and 4.16.** "Examples 4.13 and 4.16 are not distribution functions … So the claimed strictness of the inclusions in §4.2 and §4.3 is unsupported." **Correct**:
   - R_{1/2}(1) = 2(1+1/(e²−1)) > 1;
   - V(1) = 1+e^{−1} > 1;
   - Lean: `example_4_13_not_cdf`, `example_4_16_not_cdf`.

   The intended formulas are probably typos (e.g. a^{1/x}), and the examples as printed do not support the strictness claims.
6. **Example 2.7.** "Example 2.7 puts mass p at +∞, so it is not a real-valued random variable." **Correct**: the paper says so itself.
7. **The introduction's "discrete" claim.** "The Introduction's claim that InvSub 'seems the only [class] including discrete distributions' is wrong: Example 2.7 is also super-heavy-tailed." **Correct** under the paper's Def 4.9: F(x/θ)F(x/(1−θ)) = (1−p)^{⌈θ/x⌉+⌈(1−θ)/x⌉} ≤ (1−p)^{⌈1/x⌉}. `example_2_7_SHT` proves (eq:inv-NWU) for this cdf.
8. **Thm 4.12.** "the exponential is superadditive, is false (e⁰ < e⁰ + e⁰). The correct reason is (1−a)(1−b) ≥ 0." **Correct**, and the same as the Kit's editorial note.
9. **Prop 3.2.**
   - "The statement never says the Xᵢ are copies of X." **Correct**: Kit INVENTORY X15.
   - "The step 'Var√X = Var√Y ⇒ E√X = E√Y' is a non sequitur". **Wrong (minor).** The proof has just established E X = E Y < ∞. With Var√X = E X − (E√X)² and E√· ≥ 0, equal variances do give E√X = E√Y. The step is roundabout, since equal laws give it directly, but it is valid. The Chat's word "redundant" is the right one. This is a reported problem that does not exist: a **claim-level false alarm**. It is not a result-level false alarm, because Prop 3.2 does have defects.
   - "√X needs X ≥ 0" and "'Enough to prove n = 2' is not justified, though general n works the same way" are the reference defects. **Correct.**
10. **Props 5.2 and 5.3, F⁻ against F.** "the proofs swap the left-continuous F⁻ … for F. The two versions are different functions, but subadditivity is equivalent". **Correct**: `subA_iff_subB` is standard, and the Kit ruled the step a fair implicit step.
11. **Thm 4.15.** "'super-Fréchet', which the paper never defines". **Correct**, and noted in the Kit's INVENTORY.
12. **Prop 4.3.** "should say 'concave on the support'; 1/F̄ is not concave on all of ℝ". **Correct.** On ℝ, 1/F̄ is nondecreasing, ≥ 1 and unbounded unless the support is bounded. A concave nondecreasing nonconstant function on ℝ tends to −∞ at −∞, so concavity on ℝ is impossible. The Kit records the same domain question as a human check.
13. **Prop 4.6.** "one part needs the inverse of an increasing convex function to be concave". **Correct**: Kit X13 says the same, ruled a fair implicit step.
14. **Example 2.6.** "Examples 2.4, 2.6 and 2.7 check out (2.6 numerically, with b = 0.7 giving a maximum of about 0.985 ≤ 1)". **Correct.** My own grid check of x^b(x/(1+x) − (1−b)log(1+x)) gives a maximum of 0.9853 at x ≈ 7.7 for b = 0.7. This is numeric, not a proof.

Misses that are not new claims: 4.6, 4.10 and 5.2 are called correct (§1). One wrong claim: item 9. No result-level false alarm.

### Chat

1. **"every real-valued InvSub X has a continuous cdf."** **Correct.** Let g(x) = F̄_X(1/x). It is nondecreasing and subadditive, so 0 ≤ g(x+h) − g(x) ≤ g(h). Here g(0+) = P(X = ∞) = 0 for real-valued X, so g is continuous on (0,∞). Hence F_X is continuous on (0,∞), and with F_X(0)=0 it has no atom. `continuity_of_subadd` proves the generic lemma; the link to cdfs is prose. Strong positive claim, checked.
2. **The introduction's "discrete" claim.** "Example 2.7 … is also super-heavy-tailed … So the Introduction's claim … is incorrect on both counts". **Correct** (see Agent item 7, and item 1 above).
3. **Examples 4.13 and 4.16.**
   - "Examples 4.13 and 4.16 are not distribution functions". **Correct.**
   - For the presumably intended a^{1/x}·e^{2x}/(e^{2x}−1): "Super-heavy-tailed fails, for every a … reduces to q² + q ≤ 1". **Correct.** F(2x)² ≤ F(x) ⇔ 1 ≤ (1−q)(1+q)² ⇔ q²+q ≤ 1, with q = e^{−2x}, which fails for x < ≈0.24.
   - "InvSub for a = ½ … This is not a proof". Hedged by the Chat itself; **unclear**, not checked.
4. **Example 2.6.**
   - "'b ≥ 0' includes b = 0. Then Λ₀ = log(1+x), which is concave (DOR)". **Correct.**
   - "the minimum … is about 0.015 near x ≈ 8". **Correct**: 1 − 0.9853 at x ≈ 7.7.
5. **Thm 2.8.**
   - "h(x) = −x/(1+x) gives h(X) ≤ 0". **Correct.**
   - "X Fréchet and h(x) = (x−1)⁺ give P(h(X) = 0) = e⁻¹". **Correct.**
   - "Adding h(x)>0 for x>0 fixes both, and it makes h strictly increasing". **Correct**: h(x) = x·(h(x)/x) with a positive nondecreasing factor.
6. **Thm 3.1.**
   - "For the Fréchet distribution with θ = ½ and x = 0.1, we get A + B = 2(1 − e⁻⁵) > 1". **Correct.**
   - The one-line fix. **Correct.**
   - The event-decomposition slip. **Correct.**
   - "The n = 2 step and both Figure-based integral bounds are correct." **Correct by hand**: split t∈[0,x] and t∈(x,x/θ] and use F(0)=0. This is a strong positive claim without Lean.
7. **Thm 4.8.**
   - The Z+1 counterexample at x = 4, θ = ½: 12/7 > 5/3. **Correct.**
   - "For the shifted Pareto Z + a … 1 − F(1/x) equals x/(1−ax) near 0. This is strictly convex, so it is superadditive near 0". **Correct.**
   - "Correct statement: … F_X(0) = 0 and ess inf X = 0". **Correct**: this is the Kit's fix in other words.
   - "The stochastic dominance still holds for this X, via Theorem 4.2". **Correct**, conditional on the cited theorem.
8. **"these claims must be weakened: the Introduction's 'includes … all the other classes'; the 'relatively mild' framing".** **Unclear.** The introduction already says "under some conditions on the convex transformation", and the repaired Thm 4.8 is such a condition. "Relatively mild" is a judgement. Not counted.
9. **Prop 3.2.** "The Var(√X) step is redundant", and the suggestion to use n-term strict concavity directly. **Correct.**
10. **Prop 3.3.** "Correct, since InvSub excludes degenerate laws" and the direct route F̄(ny) ≥ F̄(y)/n. **Correct** for real-valued X; the Kit's :269 ruling and the Agent's Lean `prop_3_3` say the same.
11. **5.2 and 5.3.**
    - On F⁻ against F: "subadditivity passes to both one-sided-limit versions". **Correct.**
    - "ℋ ≤_{i-sb} 𝒫 (via 1 − e^{−x} subadditive)". **Correct**: `one_sub_exp_subadd`.
    - "Transitivity of ≤_{i-sb} … fine". Correct for continuous, strictly increasing cdfs: the composition of nondecreasing subadditive maps is subadditive. With generalised inverses and F⁻ it is **unclear**. This concerns an unnumbered remark at :448.
12. **"Introduction … 'super-Pareto implies absolutely continuous' is false: max(Z−2, 0) has an atom at 0."** **Correct** under Def 4.1, where increasing means nondecreasing.
13. **"The 'only if exactly one coefficient positive' claim needs X nondegenerate."** **Correct**: for X ≡ c, (1) holds for all weights.
14. **"'T is not super-heavy-tailed' presumably means |T|. That claim is true".** **Correct as mathematics.** −log((2/π)arctan(1/x)) = (2/π)x + ½(2/π)²x² + O(x³), which is strictly convex near 0 with value 0 at 0, hence superadditive there. Which variable is meant is the Chat's own guess.
15. **Example 2.4.** "Λ′(x) = (t/(2 sinh(t/2)))² with t = 1/x". **Correct.**
16. **Typos.** "more variable that/then" (:102, :260), "or course" (:404), "beween" (:421), "subadditive order" (:438). **Correct.**
17. "'≥' where '=' is meant in the third display of the proof of Theorem 3.1". **Correct**: the second inequality there is an identity.
18. **Prop 2.5.** "A cleaner, density-free version: if y ↦ y·F̄(y) is increasing on (0, ∞), then X is InvSub." **Wrong as stated (minor).** X ≡ 0, or any law with an atom at 0, satisfies the hypothesis (y·F̄(y) ≡ 0) and is not InvSub, since F_X(0) > 0. The claim needs F_X(0)=0, which a density gives. The Lean `prop_2_5_general` proves only the subadditivity half and is true. This is a wrong positive claim, not a reported problem.
19. **The disclaimer about compiling.** "I had no Lean toolchain in this session, so the code below has **not been compiled**." This is accurate: the Chat ran with no tools. The code nevertheless compiles with 0 errors, so the list of "Lemma names most likely to need adjusting" was unnecessary.

Misses: 4.6 and 4.10 are called correct. One wrong positive claim (item 18) and two unclear claims (items 8 and 11, transitivity). No result-level false alarm.

## 4. Totals

| Measure | Kit | Agent | Chat |
|---|---|---|---|
| Results correctly classified, 12 results with a proof | **12/12** | 9/12 (misses 4.6, 4.10, 5.2) | 10/12 (misses 4.6, 4.10) |
| … over all 16, cited 4.2/4.3/4.11/4.15 as OK (ruling 1) | 16/16 | 13/16 | 14/16 |
| … strict reading of ruling 3 ("gap"/"wrong reason"/⚠️ on 4.12, 5.3 = PROOF) | 12/12 | 7/12 | 8/12 |
| Nature right (among correctly classified FALSE/PROOF) | 8/8 | 5/5 | 6/6 |
| Known problems found: published error (3.1 induction step, :256) | 1/1 | 1/1 | 1/1 |
| Known problems found: hand-confirmed, not in the key (2.3, 2.8, 3.2, 4.6, 4.8, 4.10, 5.2) | 7/7 (these are the Kit's own findings) | 4/7 | 5/7 |
| False alarms (result level) | 0 | 0 | 0 |
| Wrong claims outside the reference (claim level) | 0 | 1 (3.2 "non sequitur") | 1 (density-free 2.5 without F_X(0)=0); 2 unclear |
| Correct observations outside the reference that the Kit did not establish | — | Ex 4.13/4.16 not cdfs (Lean); Ex 2.7 super-heavy-tailed (Lean); 4.3 domain; 3.1 proved in full | Ex 4.13/4.16 not cdfs (Lean); real-valued InvSub laws atomless (argument); Ex 2.7 super-heavy-tailed; intro claims; Ex 2.6 at b=0; typos |
| Lean-backed claims (faithful only), of 12 | 10 (all but 3.2, obstruction only, and 3.3, conditional) | 5 (2.3, 2.8, 3.1, 3.3, 4.8) | 0 |
| Cited inputs: proved / explicit / hidden / unbacked (12 cases each) | 5 / 7 / 0 / 0 | 3 / 5 / 1 / 3 | 0 / 4 / 1 / 7 |
| Lean files compile without `sorry` | yes (evidence modules and the P02 probe) | 9/9 | 1/1 |
| Cost and time (existing records) | $65.22, 781 min wall clock | $4.08, 19.7 min | $1.49, 9.4 min |

**Summary.** All three arms find the published error in the induction step of Theorem 3.1, refute Theorems 2.8 and 4.8 and raise no false alarm on a numbered result, but they differ on the remaining missing-condition defects: the Kit flags all of them (Prop 4.6, Lemmas 2.3 and 4.10, Prop 5.2), the Agent only 2.3 and the Chat 2.3 and 5.2. This comparison favours the Kit by construction, since the reference beyond the key was built from its own findings, while the baselines in turn establish correct points the Kit left unchecked: Examples 4.13 and 4.16 are not distribution functions, Example 2.7 is super-heavy-tailed, and real-valued InvSub laws have no atoms. On evidence, the Kit backs 10 of 12 verdicts with faithful Lean and keeps every cited input explicit, the Agent backs 5 (including complete proofs of Theorem 3.1 and Prop 3.3, which the Kit leaves conditional) but proves Lemma 4.10 against a definition that drops F_X(0)=0, and the Chat's code compiles but formalizes only algebraic cores, so none of its verdicts is Lean-backed; the Kit cost about 16 times the Agent and 44 times the Chat.
