# C01 issue 1: hypothesis (18) of Thm 2.2(i) versus E(β,α), 2 < β < log₂6

- Checker: pv-issue-checker (Opus), started Tue Oct 13 02:07:08 EDT 2026 (from `date`)
- Dispatched by the coordinator on the basis of `verification/audits/C01_gate.md` Item 5 / Item 7.1 and `pv_work/notes/C01_draft_notes.md` (S2 row). These were leads only; all quotations below were read directly from `source/geo_erg_HMC_v3.1.tex`.
- Status: complete, awaiting independent review by pv-auditor

## 1. Source quotations

- TEX:223-226 (class E(β,α)): "π(x) ∈ C^1(R) and for all |x|>M for some M<∞ it holds that π(x) ∝ exp(-α|x|^β) for some α,β>0 and any x ∈ R."
- TEX:229-238 (Cor 2.3): "under assumption A1 ... (ii) If β < 1 or β > 2, then the Hamiltonian Monte Carlo method will *not* produce a geometrically ergodic chain".
- TEX:806 (the entire proof of (ii)): "Part (ii) is a direct consequence of Theorem \ref{thm:negative}".
- TEX:208-217 (Thm 2.2): "(i) lim_{‖x‖→∞} ‖∇U(x)‖/‖x‖ = ∞ and (18) and (19) are satisfied; (ii) There is an M<∞ such that ‖∇U(x)‖ ≤ M for all x ∈ X, and E_π[e^{s‖x‖}] = ∞ for every s>0."
- TEX:868-871, (18): "there is a fixed C < ∞ such that whenever ‖y‖ ≥ 2‖x‖ ≥ C then ‖∇U(y)‖ ≥ 3‖∇U(x)‖".
- TEX:873-876, (19), and "then the Hamiltonian Monte Carlo method with fixed integration time T = Lε does not produce a geometrically ergodic Markov chain for any choice T>0."
- Where (18) is consumed inside the proof of Thm 5.14:
  - TEX:930-934 (`lem:xlower`): "Envoking (18) gives ‖∇U(x_0)‖/(2‖∇U(x_ε)‖) ≤ 1/6", applied to the pair (x_0, x_ε), where `lem:xelower` (TEX:885) only states ‖x_ε‖ > 2‖x_0‖; "An entirely analogous argument ... ‖x_{iε}‖ ≥ 2‖x_{(i-1)ε}‖".
  - TEX:953-957 (`lem:arate_0`): ‖∇U(x_{iε})‖ ≤ (1/3)^{L-i}‖∇U(x_{Lε})‖ "where (18) is used for the second line"; the bracket 1 - 2Σ_{i=1}^L (1/3)^i > 0 needs the factor 3 (with factor 2 it would be ≤ 0).
- Other negative routes in the paper: the only other one is `thm:heavy` (TEX:978-983), which needs a globally bounded gradient and so does not apply for β > 2. The source has no other route to (ii) for β > 2 (I searched for `thm:light`, `thm:negative` and `beta>2`). TEX:245 says the results are "analogous to those found for MALA in roberts1996exponential", but TEX:806 does not cite that work as a justification, and for L ≥ 2 it would not apply in any case.

## 2. Consumed instance

C01Stmt `InExpFam β α U` on `E 1` (d = 1, ‖x‖ = |x|), `IsGradField U gU`, deterministic L ≥ 1, β > 2 branch. In the tail |x| > M we have U = -log c + α|x|^β, so ∇U(x) = αβ|x|^{β-2}x and ‖∇U(x)‖ = αβ|x|^{β-1}. For ‖y‖ = 2‖x‖, both in the tail, the gradient ratio is exactly 2^{β-1}. This is < 3 if and only if β < 1 + log₂3 = log₂6 ≈ 2.585.

What TEX:806 consumes on this branch is hypothesis (18) **as printed**, i.e. for all pairs with ‖y‖ ≥ 2‖x‖ ≥ C. The draft obligation `C01_S2` has exactly this type (`pv_work/C01Draft.lean:34-35`).

Note (LESSONS 2, general form vs. instance used; reasoning, not checked in Lean): inside the proof of Thm 5.14, (18) is applied only to pairs along a leapfrog trajectory, (x_0, x_ε), (x_ε, x_{2ε}), ..., and (x_{iε}, x_{Lε}). Under (17), the norm ratios of these pairs grow without bound as ‖x_0‖ → ∞ (by the inequality displayed at TEX:894, ‖x_ε‖/‖x_0‖ ≥ (ε²/2)‖∇U(x_0)‖/‖x_0‖ - 1 - o(1)). For E(β,α) the gradient ratio of such pairs therefore also tends to infinity. So the instance that is actually needed is plausibly satisfied for every β > 2. The printed premise "ratio ≥ 2" is what is too weak. This observation is the reviewer's own and is not in the source. It is not used in any verification.

## 3. Lean evidence

File `pv_work/C01_Counterexample1.lean` (sha256 60ec6bb2a437c5b6d62a87bb59a5c0d8a90fbbb67094f55a350be9a95667b85b), namespace `Paper.C01.Issue1`. It imports only `C01Stmt` and uses `InExpFam`, `IsGradField` and `HypOscillations` verbatim.

- `scripts/pv_lean.sh check C01_Counterexample1`: `RESULT ... exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0` (log `pv_work/logs/C01_Counterexample1_2.log`).
- `scripts/pv_lean.sh build C01_Counterexample1`: exit=0, `.olean` written (log `pv_work/logs/C01_Counterexample1_3.log`).
- Axiom probe `pv_work/probes/issue/C01/issue_C01_axioms.lean` (sha256 283ae262aecfd9c774350a8cc37cf0923b2e83b2ffa496a659bfb9c00c6af007), run with `scripts/pv_lean.sh probe`: exit=0. Its output reads `#pv_axioms C01_Counterexample1: ALL STANDARD (12 declarations checked)`, and each declaration uses only [propext, Classical.choice, Quot.sound] (log `pv_work/logs/issue_C01_axioms_1.log`). The same probe checks by `rfl` that `S2Printed` is the binder list of `C01_S2`.

Theorems:

| Name | Content |
|---|---|
| `tail_grad`, `tail_norm` | For every member of E(β,α) with β > 1: there is R ≥ 0 with gU x = (αβ‖x‖^{β-2})•x and ‖gU x‖ = αβ‖x‖^{β-1} for ‖x‖ > R. This uses uniqueness of gradients plus mathlib's `hasFDerivAt_norm_rpow`. |
| `osc_fails` | **Obstruction**: for **every** member of E(β,α) (any α, M, c) with 2 < β < logb 2 6, `¬ HypOscillations gU`. The witness pair is x = single 0 t, y = 2x, with t = \|C\| + R + 1. |
| `osc_fails_of_rpow` | The same under the hypothesis 2^{β-1} < 3 (β > 1). |
| `osc_holds` | Converse: for every member with β > 1 and logb 2 6 ≤ β, (18) holds with C = 2R + 1. This confirms the gate's claim for β ≥ log₂6, including the boundary case β = log₂6 (ratio exactly 3, and "≥" is satisfied) and negative y (only ‖y‖ enters). |
| `S2Printed`, `not_S2Printed` | The printed step "every member of E(β,α) with β > 2 satisfies (18)" is false. The witness is β = 5/2, α = 1, U = ‖x‖^{5/2} (in the class with M = 0, c = 1; π = exp(-‖x‖^{5/2}) is C^1 via `contDiff_norm_rpow`). |
| `consumed_of_printed` | Scope check: the refuted proposition is exactly the type of `C01_S2`, so it is not stronger than what TEX:806 needs. |

Consequence: for β ∈ (2, log₂6), Thm 2.2(i) as printed **never** applies to any member of E(β,α). For β ≥ log₂6 its hypothesis (18) does hold. (17) and (19) hold for every β > 2; the gate already ruled these FAIR_IMPLICIT_STEP, and I have not proved them in Lean here.

**The Lean evidence does not refute Cor 2.3(ii).** It refutes only the justification, i.e. the applicability of Thm 2.2(i).

## 4. Classification

**PAPER_ARGUMENT_GAP** (TEX:806, restricted to 2 < β < log₂6).

- What fails: TEX:806 derives (ii) for all β > 2 as a "direct consequence" of Thm 2.2(i). That theorem's hypothesis (18) is false for every member of E(β,α) with 2 < β < log₂6 (Lean: `osc_fails`). The given justification therefore does not yield the claim on this range.
- Why it is not ERROR: there is no counterexample to the conclusion "HMC is not geometrically ergodic". The conclusion is plausibly true on this range, for two reasons (reasoning, not checked in Lean). First, for L = 1, HMC is MALA, and TEX:245 refers to the analogous MALA result of roberts1996exponential, an external result I have not checked. Second, the proof mechanism of Thm 5.14 only consumes trajectory pairs whose ratios are unbounded (§2). Failure of a sufficient condition does not make the conclusion false.
- Why it is not PAPER_ASSUMPTION_GAP: the corollary does not lack a hypothesis on π that would make the stated argument work. The paper's own route fails on a parameter range of the stated class, and adding β ≥ log₂6 would be a restriction of scope, not a missing hypothesis. Thm 2.2/5.14 itself is not affected: it is correct as a conditional statement, and only its invocation fails.
- Why it is not EXPOSITION_GAP: the problem is not an uncovered range that the paper's constants could absorb. The cited theorem's hypothesis is false on the range, so the justification fails (card: "the justification fails" is PAPER_ARGUMENT_GAP).
- Why it is not FAIR_IMPLICIT_STEP: a competent reader cannot fill this step routinely, because the printed (18) is false there. Repairing it requires changing (18) and re-running `lem:xelower`, `lem:xlower` and `lem:arate_0` with a different ratio. That is new argument.
- Why it is not ENCODING_ERROR: `HypOscillations` is (18) verbatim, `InExpFam` is TEX:223-226 verbatim, and the failure is a property of the real function |x|^β. Our representation choices (d = 1 as `E 1`, π = e^{-U}) do not create it.

## 5. Does it threaten the conclusion?

- Does Cor 2.3(ii) fail because of this? **No.** The conclusion is not shown false. It is left **unestablished by the source** for 2 < β < log₂6 (fixed L, the scope of the check).
- β ≥ log₂6: TEX:806 is sound as far as (18) is concerned (`osc_holds`).
- β < 1: not affected (see §6).
- C01 overall: the β > 2 branch of `C01_main` depends on `C01_S2`, which is false as stated and must stay a recorded gap. C01 cannot be verified as printed, and its expected verdict is ISSUE.

## 6. Other questions from the coordinator

- **(19) and its dependence on L** (TEX:874): reasoning, not checked in Lean. For β > 2, each fixed L and ‖y‖ ≥ 2^L‖x‖ in the tail, U(x) - U(y) - ‖x‖²/2 ≤ -α(2^{Lβ} - 1)‖x‖^β - ‖x‖²/2 + O(1), which tends to -∞. The L-dependence costs nothing, and it is consistent with C01's quantification over every L ≥ 1. No issue here (the gate made a preliminary FAIR_IMPLICIT_STEP ruling).
- **(18) for β ≥ log₂6**: confirmed in Lean (`osc_holds`). The factor 3 is attained exactly at β = log₂6. "For all y with ‖y‖ ≥ 2‖x‖" is correct in d = 1 for y of either sign, because only |y| enters ‖∇U(y)‖ = αβ|y|^{β-1}.
- **The β < 1 branch** (Thm 2.2(ii)): reasoning, not checked in Lean. I agree with the gate that this is FAIR_IMPLICIT_STEP and found no gap beyond it.
  - Bounded gradient: on |x| > max(M,1), ‖∇U‖ = αβ|x|^{β-1} ≤ αβ. On the compact set |x| ≤ max(M,1), ∇U = -π'/π is continuous, since π ∈ C^1 is printed and π > 0 by the convention at TEX:320.
  - E_π e^{s|x|} = ∞ for s > 0: s|x| - α|x|^β → ∞ when β < 1.
  - Thm 2.2(ii)'s "≤ M" versus `thm:heavy`'s "< M" is absorbed by M + 1.
  - How the prover fills S4/S5: (S4) take R = max(M,1). Use the tail formula from `tail_norm`, which needs β > 1 and so does not apply here; derive the tail gradient directly from U = -log c + α‖x‖^β via `HasGradientAt.unique`, using rpow differentiability away from 0. Get continuity of gU on the closed ball from gU = -(∇π)/π, then use `IsCompact.exists_bound_of_continuousOn`. (S5) lower-bound the integrand on the tail by c·exp(s|x| - α|x|^β)/Z ≥ const·exp((s/2)|x|) for large |x|, which is not integrable on the line.
- **A1 versus fixed L**: a separate scope issue (gate Item 7.3, X2) that is already dispatched under T01. Not ruled here.

## 7. Affected and unaffected results

- Affected: Cor 2.3(ii) for β ∈ (2, log₂6), i.e. obligation `C01_S2` and the β > 2 branch of `C01_main`.
- Unaffected:
  - Cor 2.3(ii) for β ≥ log₂6 (as far as (18) is concerned) and for β < 1.
  - Thm 2.2 / Thm 5.14 (T01) as conditional statements.
  - `lem:xelower`, `lem:xlower` and `lem:arate_0` as conditional lemmas (L02 and the others).
  - Cor 2.3(i), which is out of scope here and does not use Thm 2.2.

## 8. Suggestion to the authors (minimal)

1. Minimal option: in TEX:806, restrict the appeal to Thm 2.2(i) to β ≥ log₂6 (where (18) holds with the printed constants). Then either state (ii) only for β < 1 or β ≥ log₂6, or give a separate argument for 2 < β < log₂6. I verified that this suffices for the (18) part (`osc_holds`). (17) and (19) hold for every β > 2 (gate ruling, reasoning).
2. Alternative, constructed by the reviewer, not in the source, suggestion only, not used in any verification: replace "2" in (18) by "some fixed k ≥ 2". E(β,α) with β > 2 satisfies this with k = 3^{1/(β-1)}. The lemmas `lem:xelower`/`lem:xlower` would then have to deliver ‖x_{iε}‖ ≥ k‖x_{(i-1)ε}‖. Under (17), their displayed inequalities appear to give any fixed ratio. I have **not** checked that the whole chain through `lem:arate_0` goes through, so a human check is needed before adopting this.

## 9. Not checked

- Whether Cor 2.3(ii) is actually true for 2 < β < log₂6 (neither proved nor refuted).
- The external MALA result (roberts1996exponential).
- (17) and (19) for E(β,α), and S4/S5 (β < 1): reasoning only.
- Random 𝔏 under A1.
- Human check needed: yes, for the authors' intended fix (option 2 in particular).

## Review

Not yet reviewed. This ruling becomes confirmed only after `pv-auditor` passes it in counterexample-review mode. The Lean file is an obstruction to TEX:806's justification, not a counterexample to Cor 2.3(ii).

- Finished: Tue Oct 13 02:09:22 EDT 2026 (from `date`; the report was written incrementally).

ISSUE VERDICT: PAPER_ARGUMENT_GAP
THREATENS CONCLUSION: no
