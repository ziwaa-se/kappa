# Issue ruling: L02 (Lemma 2.2, lem:min) issue 1

- Role: pv-issue-checker (claude-opus-5-5), date Mon Oct 12 22:11:10 EDT 2026 (from `date`)
- Reported by: pv-drafter, pv-gate (`verification/audits/L02_gate.md`, "Suspected paper issues"; probe `pv_work/probes/gate/L02/gate_L02_falsity.lean`)
- Status: **not confirmed** until reviewed by pv-auditor (counterexample-review mode).

## 1. Source quotations (read directly from `source/main.tex`)

- main.tex:25: "Throughout, $\theta \ne 0$ and $\sigma > 0$ are real numbers."
- main.tex:32-33: "The oracle risk is $\rho = \theta^2 \sigma^2 / (\theta^2 + \sigma^2)$."
- main.tex:48-50 (statement): "$\rho \le \min\{\theta^2, \sigma^2\}$."
- main.tex:53-55 (proof, entire): "The number $\rho$ is half the harmonic mean $2\theta^2\sigma^2 / (\theta^2 + \sigma^2)$ of $\theta^2$ and $\sigma^2$. The harmonic mean of two positive numbers is at most the smaller of them, so $\rho \le \frac12 \min\{\theta^2, \sigma^2\} \le \min\{\theta^2, \sigma^2\}$."
- No result is cited; the harmonic-mean fact is asserted without reference.

## 2. Consumed instance

- Harmonic mean as printed at l.53: HM(a,b) = 2ab/(a+b), with a = θ², b = σ², both > 0 by l.25 (any pair of positive reals arises: θ = √a, σ = √b).
- The proof consumes (A) "HM(a,b) ≤ min(a,b) for a,b > 0" (l.54) to obtain (B) "ρ ≤ ½ min{θ²,σ²}" (l.55), then (C) "½ min ≤ min" (l.55).
- Since every positive pair (a,b) is realized, the general form of (A) and the instance used coincide; LESSONS 2 ("general false, instance true") does not apply here.

## 3. What fails

- (A) is false: a = 1, b = 4 gives HM = 8/5 > 1. In fact HM(a,b) ≥ min(a,b) always (proved, `harmonicMean_ge_min`), with equality iff a = b; the printed inequality points the wrong way.
- (B) is false: θ = 1, σ = 2 gives ρ = 4/5 > 1/2. Precisely, under l.25, (B) holds **iff θ² = σ²** (proved, `clauseB_pointwise_iff`), so it fails at every admissible point with θ² ≠ σ².
- (C) and the identity ρ = ½ HM (l.53) are true.
- The lemma's printed conclusion ρ ≤ min{θ²,σ²} (l.49) is **true** (proved as a sanity check, `conclusion_true`, not along the source route).

## 4. Classification: `PAPER_ARGUMENT_GAP`

The given justification does not yield the conclusion: it rests on a false general claim (A) and passes through a false intermediate inequality (B), while the printed conclusion of the lemma holds.

Why not a neighbouring class:
- Not `ERROR`: ERROR requires the printed conclusion of the result to be false (VERDICTS §2). The conclusion at l.49 is true for all admissible θ, σ (`conclusion_true`). The false statements (A), (B) appear only inside the proof. This is noted for the human checker (see §8), since (B) is a printed false inequality, not merely a missing justification.
- Not `EXPOSITION_GAP`: no range or case is left uncovered; the argument fails at every point with θ² ≠ σ², i.e. the justification itself fails.
- Not `PAPER_ASSUMPTION_GAP`: no additional hypothesis rescues (A) or (B); (B) is false for all θ² ≠ σ² regardless of extra conditions short of θ² = σ².
- Not `FAIR_IMPLICIT_STEP`: a reader cannot fill in a false step routinely; the fix requires replacing the claimed fact by a different one (HM ≤ 2 min), which is not in the source.
- Not `ENCODING_ERROR`: the encodings use the formula printed at l.53 verbatim, the standing assumption l.25 exactly (`Setting`), and `min` on ℝ; the counterexamples are ordinary numerals (1, 4; θ = 1, σ = 2). No representation choice is involved.

## 5. Does it threaten the conclusion?

- L02's printed conclusion: **no**, it is true (`conclusion_true`). L02 cannot be verified along the source route (the route stops at S2 = (A)); its verdict is ISSUE on the proof.
- Downstream (INVENTORY.md rows 19-20):
  - T01 (thm:oracle), main.tex:65-66: uses Lemma lem:min only for "ρ ≤ min{R(0), R(1)}", i.e. only the printed conclusion of L02 → **unaffected** as to content (it consumes a true clause).
  - C01 (cor:half), main.tex:75: uses Lemma lem:min only for "ρ ≤ min{θ², σ²}" → **unaffected** as to content.
  - No result consumes (A) or (B). `consumed_of_printed` confirms that (B) is strictly stronger than the consumed clause, so the refutation does not reach what downstream uses.
  - How T01/C01 record their dependence on L02 (consumed clause L02 conclusion, whose route has an issue) is for the coordinator under VERDICTS §1; the consumed clause itself is true.

## 6. Lean evidence

- File: `pv_work/L02_Counterexample1.lean` (sha256 `5c2fbd7cd1071031b68bc40f7f08a7405e9c068f6786dd1176407c1d8aa9d8ec`), olean `pv_work/L02_Counterexample1.olean` (sha256 `7532d8d24fdba4d54fb5e66c9d7e50b23e81acd5a14d0f89a11835125862eff9`), namespace `Paper.L02.Issue1`, imports `L02Stmt` (gated).
- Compile: `scripts/pv_lean.sh build L02_Counterexample1` → `RESULT L02_Counterexample1 mode=build exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/L02_Counterexample1_1.log`.
- Axiom check: probe `pv_work/probes/issue/L02/issue_L02_axioms.lean` (sha256 `173ed147…bd240`) → `exit=0`, log `pv_work/logs/issue_L02_axioms_1.log`: `#pv_axioms L02_Counterexample1: ALL STANDARD (11 declarations checked)`; `#pv_walk`: `AXIOMS in closure: [propext, Classical.choice, Quot.sound]; sorryAx reached: false`.
- Declarations:
  - `PrintedClauseA : Prop := ∀ a b : ℝ, 0 < a → 0 < b → 2*a*b/(a+b) ≤ min a b` (l.54 verbatim, HM formula from l.53); `printedClauseA_iff : PrintedClauseA ↔ HarmonicLeMin := Iff.rfl` ties it to the gated `Paper.L02.HarmonicLeMin` (definitionally equal; `vh` differs only because one unfolds `harmonicMean`).
  - `counterexampleA : ¬ PrintedClauseA` (a = 1, b = 4; both hypotheses `0 < a`, `0 < b` discharged).
  - `PrintedClauseB : Prop := ∀ θ σ, Setting θ σ → oracleRisk θ σ ≤ (1/2) * min (θ^2) (σ^2)` (l.55 first inequality under l.25).
  - `counterexampleB : ¬ PrintedClauseB` (θ = 1, σ = 2; `Setting` discharged).
  - `clauseB_pointwise_iff` (scope: (B) ↔ θ² = σ²), `harmonicMean_ge_min` (direction reversed).
  - `consumed_of_printed : PrintedClauseB → ∀ θ σ, Setting θ σ → Conclusion θ σ` (scope check).
  - `conclusion_true` (sanity, not source route), `fix_harmonicMean_le_two_min`, `fix_chain` (check of the suggestion, §7).
- Review points (VERIFICATION_METHODS §5): the printed clauses carry exactly the printed hypotheses (positivity at l.54; l.25 for (B)), no premise dropped, conclusions as printed; the instances satisfy every hypothesis; no definition in the source excludes them.

## 7. Suggestion to the authors (minimal)

Replace l.54-55 by: "The harmonic mean of two positive numbers is at most twice the smaller of them, so $\rho \le \min\{\theta^2,\sigma^2\}$." (i.e. replace "at most the smaller" by "at most twice the smaller" and drop the intermediate "½ min" bound).

Constructed by the reviewer, not in the source, suggestion only, not used in any verification. Checked to suffice: `fix_harmonicMean_le_two_min` (HM ≤ 2 min for a, b > 0) and `fix_chain` (ρ = ½ HM, as printed at l.53, plus HM ≤ 2 min gives `Conclusion`) both compile in the file above.

## 8. Not checked / for the human checker

- Whether the authors intended a different fact (e.g. "the harmonic mean is at most the larger" or "at most twice the smaller"); the source gives no hint. The suggestion above is one minimal option.
- Human note recommended: the proof prints a false inequality (B); it is classified `PAPER_ARGUMENT_GAP` because the lemma's printed conclusion is true, but a reader may wish to flag (B) as a misstatement in the text.
- T01, C01 verdicts are not ruled on here.

ISSUE VERDICT: PAPER_ARGUMENT_GAP
THREATENS CONCLUSION: no
