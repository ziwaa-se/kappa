# T01 issue 1 (Theorem 3.1 `thm:uniqueness`, proof l.402-427): ruling

- Role: pv-issue-checker (independent subagent; did not draft, gate or prove T01)
- Started: Mon Oct 12 22:23:07 EDT 2026 (from `date`)
- Reported by: pv-gate (`verification/audits/T01_gate.md`, Item 7) and pv-prover (`pv_work/notes/T01_prover_notes.md`, S8/S10)
- Status: ruling written; **not confirmed** until pv-auditor counterexample review passes.

## 1. Source quotations (read directly from `source/VSIFP_02.tex`)

- Statement, l.145-148: "Let S be a consistent scoring function and p, q ∈ (0,1), p ≠ q. Assume that the mixing measure ν of S satisfies ν{[min(p,q), max(p,q))} > 0. Then a function E = E(y) is an e-value with null hypothesis H_S and alternative [0,1] \ H_S, if and only if for some **λ ∈ (0,1]**, E(y) = E_{p,q;λ}(y) = 1 + λ (S(p,y) − S(q,y)) / |S(p,1{p>q}) − S(q,1{p>q})|."
- l.403: "If E(y) is of the stated form, then E(y) ≥ E{1(p>q)} = 1−λ ≥ 0, and one can easily verify that E has the given null hypothesis. Assume that p < q (the case p > q is analogous)."
- l.407: "... d_{p,q}(0) < 0 < d_{p,q}(1), so f(π) is strictly increasing in π and equal to zero for some π_0 ∈ (0,1)."
- l.409 (eq:evalueCond): "(1−π)E(0) + πE(1) ≤ 1 ⟺ f(π) ≤ 0."
- l.413 (eq:ratio): "d(0)/(d(1)−d(0)) = (E(0)−1)/(E(1)−E(0))."
- l.417: "E(1) = 1 − {1 − E(0)} d(1)/d(0)".
- **l.419 (S8)**: "It follows from \eqref{eq:evalueCond} and \eqref{eq:ratio} that $E(0) \in (0,1)$, so with $\lambda = 1 - E(0)$,"
- l.421: "E(y) = 1 − λ d(y)/d(0) = 1 + λ d(y)/|d(0)|."
- **l.423-426 (S10)**: "Similar arguments for the case $p > q$ show that in general, E(y) = 1 + λ d(y)/|d{1(p>q)}|."

## 2. What is consumed

The step at l.419 is consumed in the necessity direction, case p < q, for an arbitrary e-value E. Its role is to put λ := 1 − E(0) into the range (0,1] required by the theorem. What the theorem needs is **E(0) ∈ [0,1)** (⟺ λ ∈ (0,1]); the source prints E(0) ∈ (0,1) (⟺ λ ∈ (0,1)).

Consumed instance where the printed step fails: λ = 1, i.e. E = E_{p,q;1}, E(0) = 0. This E is an e-value by the sufficiency half of the theorem itself (l.403; proved as `T01_S2` in `pv_work/T01ModGaps.lean`). Concretely: ν = δ_{1/2}, S = S_{1/2} (elementary score, so ν is the mixing measure of S), p = 1/4, q = 3/4; then d(0) = −1/2, d(1) = 1/2, E(0) = 0, E(1) = 2 (the gate's abstract instance d(0) = −1, d(1) = 1, rescaled, now realised by an actual consistent scoring function with a mixing measure).

Note: the printed claim is false *in general form and in the instance actually needed*: the proof must handle every e-value, including λ = 1. So this is not a "general form false, instance true" situation (LESSONS 2); the step is wrong exactly where it is used — but only for the boundary value λ = 1.

## 3. Classification

### S8 (l.419): `PAPER_ARGUMENT_GAP`

- The sentence asserts a false intermediate claim (E(0) > 0 does not follow from eq:evalueCond and eq:ratio; it is false for λ = 1). The correct consequence E(0) ∈ [0,1) does follow: E(0) ≥ 0 by definition of e-value (l.78), E(0) ≤ 1 from eq:evalueCond at π = 0 (f(0) = d(0) < 0), E(0) ≠ 1 from eq:ratio (left side < 0). The theorem's conclusion is true. A justification that fails while the conclusion is true is `PAPER_ARGUMENT_GAP`.
- Not `ERROR`: the printed result (Theorem 3.1) is true; only an intermediate proof claim is false.
- Not `EXPOSITION_GAP`: the proof does not merely leave λ = 1 uncovered; it asserts something false (the printed step, taken literally, would show that no e-value has λ = 1, contradicting l.403). "The justification fails" is `PAPER_ARGUMENT_GAP`, not `EXPOSITION_GAP`.
- Not `FAIR_IMPLICIT_STEP` / `EDITORIAL`: a reader cannot "fill in" a false claim; the step has to be corrected (open → half-open interval). It is, however, minor: the fix is a one-character change and the rest of the argument goes through unchanged (S9 = l.419-421 does not use E(0) > 0; prover notes and `T01_S9`).
- Not `ENCODING_ERROR`: the counterexample uses the shared definitions (`IsConsistent`, `MixtureRep`, `IsEValue`, `HS`, `Erep`) exactly as gated, and the instance is a genuine instance of the paper's setting (elementary score with δ_{1/2}); E(0) = 0 is forced by the paper's own formula with λ = 1.

### S10 (l.423-426): no independent issue; the mirror argument is a `FAIR_IMPLICIT_STEP` that inherits the S8 defect

- l.403 announces "the case p > q is analogous" and l.423 "Similar arguments". The p > q case is the exact mirror of S3-S9 with the roles of y = 0 and y = 1 exchanged (d(1) < 0 < d(0), f strictly decreasing, E(0) = 1 − {1 − E(1)} d(0)/d(1), λ = 1 − E(1)). This is routine for a competent reader: `FAIR_IMPLICIT_STEP`.
- The mirrored analogue of l.419 ("E(1) ∈ (0,1)") is false for the same reason (λ = 1, E(1) = 0); checked on the instance p = 3/4, q = 1/4 (`mirror_E1_zero`, `mirror_evalue`). This is the **same** issue as S8 (one defect, two places), not a second issue.
- The printed conclusion of l.423-426 (the representation for p > q with λ ∈ (0,1]) is true; the mirror counterexample refutes only the mirrored l.419 step, not l.426.
- Consequence for the prover: S10 cannot be closed by "faithfully mirroring" the source without either reproducing the false range or using the corrected range. It stays a gap (`T01_S10_Gap`) attributed to this issue; see §8 for the fill-in recipe of the fair part.

## 4. Does it threaten the conclusion?

- Theorem 3.1's conclusion: **no**. Both directions are true; the gate checked the statement by hand, the prover proved sufficiency (`T01_S2`) and S1-S7, S9 without gaps, and `S8_corrected_range` (reviewer-constructed, suggestion only) shows the needed range E(0) ∈ [0,1) holds under exactly the hypotheses of S8.
- Downstream results: **not affected**. They consume the statement of Theorem 3.1 (or eq:representation), which is true:
  - Theorem `thm:grow` (statement l.154; proof l.430: "All e-values for the given null hypothesis are of the form eq:representation") — consumes the statement only. Unaffected.
  - Discussion l.174, Proposition `prop:combination` usage of eq:representation (l.206, l.211, l.229) — use the formula / statement only. Unaffected.
- Affected: only the proof of Theorem 3.1, necessity direction, at l.419 and (mirrored) l.423, and only for the boundary case λ = 1.

## 5. Evidence (Lean)

File: `pv_work/T01_Counterexample1.lean` (namespace `Paper.T01.Issue1`, imports `T01ModGaps`), sha256 `1b15ec0a04133484be99987c6ff23b65d1a78837a303ae6b8461e659d7308427` (`python3 scripts/pv_snapshot.py hash`).

- `scripts/pv_lean.sh build T01_Counterexample1` → `RESULT ... exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log `pv_work/logs/T01_Counterexample1_3.log`, olean `pv_work/T01_Counterexample1.olean`.
- Axiom probe `pv_work/probes/issue/T01/issue_T01_cex1_axioms.lean` (`#pv_axioms T01_Counterexample1`, `#pv_type_hashes`) → `exit=0`, log `pv_work/logs/issue_T01_cex1_axioms_1.log`: "#pv_axioms T01_Counterexample1: ALL STANDARD (24 declarations checked)" (each `[propext, Classical.choice, Quot.sound]`).

Contents:
- `PrintedClause_l419 : Prop` — the l.419 claim in its context: hypotheses of l.145 (`IsConsistent S`, `MixtureRep S ν`, p,q ∈ (0,1), `0 < ν(Ico (min p q) (max p q))`), case assumption p < q (l.403), E an e-value for H_S vs [0,1]\H_S (l.407-409); conclusion `E 0 ∈ Ioo 0 1`. No premise dropped, conclusion not strengthened.
- Instance: `ν0 = dirac (1/2)`, `S0 = mixtureScore ν0`; `S0_cons : IsConsistent S0`, `S0_rep : MixtureRep S0 ν0` (incl. `IsMixingMeasure`, integrability), `ν0_pos`; `E0 = Erep S0 (1/4) (3/4) 1`, `E0_evalue` (via the prover's `T01_S2`, gap-free), `E0_at_zero : E0 0 = 0`.
- `not_PrintedClause_l419 : ¬ PrintedClause_l419`.
- Scope: `printed_of_S8Gap : T01_S8_Gap → PrintedClause_l419`, hence `not_S8Gap : ¬ T01_S8_Gap` (the gated obligation S8 is refuted too, and the printed clause is not stronger than S8 as consumed).
- `E0_in_family`: the instance lies inside the theorem's conclusion (λ = 1 ∈ (0,1]) — the theorem is not contradicted.
- Mirror (S10): `mirror_E1_zero : Erep S0 (3/4) (1/4) 1 1 = 0`, `mirror_evalue` (it is an e-value) — the mirrored "E(1) ∈ (0,1)" fails.
- `S8_corrected_range` — **constructed by the reviewer, not in the source, suggestion only, not used in any verification**: under the hypotheses of `T01_S8_Gap`, `E 0 ∈ Ico 0 1`.

Independence note: `E0_evalue` and `mirror_evalue` depend on the prover's `T01_S2` (gap-free, standard axioms per prover notes). The auditor may prefer to re-check `T01_S2` or to verify IsEValue directly; this was not duplicated here.

## 6. Suggestion to the authors (minimal)

l.419: replace "$E(0) \in (0,1)$" by "$E(0) \in [0,1)$" (E(0) ≥ 0 since E is an e-value; E(0) < 1 by eq:evalueCond at π = 0 and eq:ratio). With λ = 1 − E(0) ∈ (0,1] the rest of the proof is unchanged; the mirrored statement for p > q reads E(1) ∈ [0,1). Sufficiency of the fix checked in Lean (`S8_corrected_range`, together with the prover's `T01_S9`, which does not use E(0) > 0). Suggestion only.

## 7. Parts not checked

- No Lean assembly of the full necessity direction with the corrected range was done here (that would be a repair; not our role). The claim that `T01_S9` ignores its `h0` hypothesis is from the prover notes, consistent with its statement but not re-verified with `#pv_hyp_usage` here.
- The S10 mirror argument (S3-S9 for q < p) is not formalized here; only the mirrored l.419 failure is.
- Human check: not required for the classification; optional confirmation that the authors intended [0,1).

## 8. Fill-in recipe for the fair part of S10 (for the prover; mirror of l.403-421 for q < p)

1. Sign (mirror of l.407, already `cfacts`/`dsign` in T01ModGaps): d(1) < 0 < d(0), from `key` applied to (q, p) with ν(Ico q p) > 0.
2. f(π) = (1−π)d(0) + πd(1) strictly decreasing, zero at π₀ = d(0)/(d(0)−d(1)) ∈ (0,1).
3. eq:evalueCond as in `T01_S5` (unchanged).
4. From the iff at π = 1 (f(1) = d(1) < 0): E(1) ≤ 1; at π = 0 (f(0) > 0): E(0) > 1; compare the zeros as in `T01_S6` to get d(1)/(d(0)−d(1)) = (E(1)−1)/(E(0)−E(1)).
5. Rearrange (mirror of l.417): E(0) = 1 − {1 − E(1)} d(0)/d(1).
6. Mirror of l.419: **the source would give E(1) ∈ (0,1) — this is the defect of this issue**; the step cannot be taken faithfully at λ = 1. Keep it as the gap point (`T01_S10_Gap` stays, attributed to issue 1).
7. With λ = 1 − E(1): E(y) = 1 − λ d(y)/d(1) = 1 + λ d(y)/|d(1)| = `Erep S p q λ y` (denominator index 1{p>q} = 1).

ISSUE VERDICT: PAPER_ARGUMENT_GAP
THREATENS CONCLUSION: no
