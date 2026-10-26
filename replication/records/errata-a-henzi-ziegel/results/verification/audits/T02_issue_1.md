# T02 (Theorem 3.2, `thm:grow`) — issue ruling (three issues, numbered 1-3)

- Role: pv-issue-checker (independent of drafter, gate, prover of T02)
- Inputs read directly: `source/VSIFP_02.tex:90-106, 137-172, 425-463`; `verification/audits/T02_gate.md`;
  `pv_work/notes/T02_prover_notes.md`; `pv_work/T02Stmt.lean`; `pv_work/Defs.lean` (defs used);
  gate probe `pv_work/probes/gate/T02/gate_T02_cex.lean`.
- Date: Mon Oct 12 22:50:26 EDT 2026 (from `date`)
- Status: complete; NOT confirmed until reviewed by pv-auditor (counterexample-review mode).

## Source quotations

- l.435: "Consider the case $p < q$. Under this assumption $d_{p,q}(0) < 0 < d_{p,q}(1)$, and $g$ is continuous
  in $\lambda$ with $g(0) = 0$ and $\lim_{\lambda \rightarrow 1} g(\lambda) = -\infty$, so a maximum is attained at
  some $\lambda \in [0,1)$."
- l.437: "$g(\lambda) = (1-\pi_1) \log (1-\lambda) + \pi_1 \log(1-\lambda h)$", l.442 "$g'(\lambda_0)=0 \iff
  \lambda_0 = \pi_1 + (1-\pi_1)/h$", l.448 "we indeed have $\lambda_0 > 0$ for all $\pi_1 \not\in H_S$".
- l.454: "With $d_{p,q}(y) = \int\one\{p \leq \theta < q\}(\theta - y) \, d\nu(\theta)$, it now follows that"
- l.456: "$\frac{d(1)-d(0)}{d(1)} = \frac{-\nu\{[p,q)\}}{-\nu\{[p,q)\} + \int_{[p,q)}\theta\,d\nu} = \frac{1}{1-\kappa}$";
  l.460 "$1-h = \frac{d(0)-d(1)}{d(0)} = \frac{1}{\kappa} > \frac{1}{\pi_1}$".
- l.462: "which gives the desired result. The case $p > q$ is analogous."
- Statement l.154: "for any $\pi_1 \not\in H_S$, $E_{\pi_1}\{\log(E_{p,q;\lambda})\}$ is maximal in $\lambda$ if and only
  if $\lambda = \ldots$"; family $\lambda \in (0,1]$ of Theorem 3.1 (l.145-148); $H_S \subseteq [0,1]$ (l.139).
- Elementary score l.98-105: $S_\theta(p,0)=\theta\,\one(p>\theta)$, $S_\theta(p,1)=(1-\theta)\,\one(p\le\theta)$.

## Evidence file (all three issues)

`pv_work/T02_Counterexample1.lean` (sha256 677c6a82c84e50ec1af0fb72ad6a4b034acd1fa0f62b38b45d1951184d05ffb9),
namespace `Paper.T02.Issue1`, imports `T02ModGaps` (read-only use).
- `scripts/pv_lean.sh check T02_Counterexample1` -> `exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`
  (log `pv_work/logs/T02_Counterexample1_2.log`); `build` -> `exit=0`, olean produced (log `..._3.log`).
- Axiom probe `pv_work/probes/issue/T02/issue_T02_axioms.lean` (`#pv_axioms`, `#pv_walk`), exit=0, log
  `pv_work/logs/issue_T02_axioms_1.log`: "ALL STANDARD (53 declarations checked)"; "AXIOMS in closure:
  [propext, Classical.choice, Quot.sound]; sorryAx reached: false".
- Instance (as given by the coordinator): ν = δ_{1/2}, S = S_{1/2} (proved `IsConsistent` and
  `T01.MixtureRep S ν`, incl. integrability), p = 1/4, q = 3/4, π₁ = 1; mirror p = 3/4, q = 1/4, π₁ = 0.
  Every printed hypothesis is proved for the instance (`hcons0 hrep0 hP hQ hPQ hν0 hπF hlt`; mirror
  `hQ hP hQP hν0' hπM hc'`). ν = δ_{1/2} is a locally finite Borel measure on (0,1) (l.97); no source
  definition excludes it (S need not be strictly consistent: Theorem 3.1 assumes only consistency, l.145).
  Instance values: d(0) = -1/2, d(1) = 1/2, κ = 1/2, H_S = [0,1/2], E_{p,q;λ}(0) = 1-λ, E_{p,q;λ}(1) = 1+λ.

---

## Issue 1 — l.435 "lim g = -∞, so a maximum is attained at some λ ∈ [0,1)" (S3a, S3b, S8)

**Consumed instance.** Case p < q (l.435); the step is consumed for every π₁ ∈ [0,1] \ H_S (l.448 "for all
π₁ ∉ H_S"). Here [0,1] \ H_S = (κ, 1] (π₁ ∉ H_S ⟺ π₁ d(1) + (1-π₁) d(0) > 0, l.446), so π₁ = 1 is an
admissible alternative. At π₁ = 1, g(λ) = log(1 - λh) (l.437 with 1-π₁ = 0), h < 0: finite and strictly
increasing on [0,1], so lim_{λ→1} g = log(1-h) > -∞ and sup_{[0,1)} g is not attained. Mirror: p > q, π₁ = 0
(the analogue required by l.462, see issue 3).

**What fails.** Only the edge π₁ = 1 (p < q) / π₁ = 0 (p > q). For π₁ < 1 the limit claim is true
(`lim_holds_below_one`, at the same S, ν, p, q, all π < 1). Consequently also the silent step S8
(λ₀ < 1 and λ₀ is the unique maximiser on [0,1)) fails at π₁ = 1, since λ₀ = 1 there (gate `S8_false`).

**Lean evidence** (`pv_work/T02_Counterexample1.lean`):
- `PrintedClause_l435_lim` (the limit conjunct only; dropping the other printed conjuncts makes the clause
  weaker) and `PrintedClause_l435_max` ("some l ∈ [0,1) maximises g over [0,1)"; implied by the reading
  "the maximum over [0,1] is attained in [0,1)", so not stronger than either reading). g = `growthRate`
  = E_{π₁} log E_{p,q;λ}(Y) (l.432); on [0,1) both E values are positive, so `Real.log` takes genuine values.
- `counterexample_l435_lim : ¬ PrintedClause_l435_lim`, `counterexample_l435_max : ¬ PrintedClause_l435_max`.
- Scope: `printed_lim_of_gap : T02_S3a_Gap → PrintedClause_l435_lim` (my clause is weaker than the gated
  S3a encoding); `consumed_of_printed : PrintedClause_l435_max ↔ T02_S3b_Gap` (the clause consumed downstream
  is exactly the printed one); `lim_holds_below_one` (failure confined to π₁ = 1 at this S, ν, p, q).
- Positive (threat to the conclusion): `conclusion_holds_at_instance : Conclusion S0 ν0 (1/4) (3/4) 1` —
  the theorem's full conclusion (grow_iff over (0,1] and the e-value formula) holds at the counterexample
  instance (printed λ = 1, E(0) = 0 = (1-π₁)/(1-κ), E(1) = 2 = π₁/κ). Mirror: `conclusion_holds_at_mirror`.

**Classification: `PAPER_ARGUMENT_GAP`.**
- Not `ERROR`: the printed conclusion of Theorem 3.2 is true at the edge (Lean at the instance; in general
  by the hand computation below, reasoning, not checked in Lean).
- Not `EXPOSITION_GAP`: the proof does not leave π₁ = 1 out — l.435 asserts the limit claim for the case
  p < q without restriction and l.448 explicitly says "for all π₁ ∉ H_S"; the given justification is
  *false* at an admissible value, which is the definition of `PAPER_ARGUMENT_GAP` (justification fails,
  conclusion may be true), not an uncovered range.
- Not `FAIR_IMPLICIT_STEP`: the printed claim is false, not merely unexpanded.
- Not `ENCODING_ERROR`: g is encoded as printed (l.432-433); the failure is visible in the source's own
  formula l.437 (coefficient 1-π₁ = 0 kills the log(1-λ) term).
- Not `PAPER_ASSUMPTION_GAP`: no missing hypothesis is needed for the theorem; only the argument fails.

**Does it threaten the conclusion?** No. General edge check (reasoning, not checked in Lean; agrees with
the gate's hand check, Item 2): p < q, π₁ = 1: g(λ) = log(1 - λh) strictly increasing on (0,1], every
λ ∈ (0,1] is `GrowFinite` (E(1) = 1 - λh > 0; E(0) irrelevant for π₁ = 1), unique maximiser λ = 1 = printed
π₁ + (1-π₁)d(0)/d(1); E(0) = 0 = (1-π₁)/(1-κ), E(1) = 1 - h = 1/κ = π₁/κ (l.460 identity). Mirror p > q,
π₁ = 0 symmetric. Theorem 3.2 is not threatened; only its proof is incomplete at the edge.

**Affected:** T02 obligations S3a, S3b, S8 (only at π₁ = 1), S9 (via S8), S15 (mirror π₁ = 0), and the
assembly of the main theorem `T02` (which cannot close through the printed route at the edge).
**Unaffected:** S1, S2, S4, S5, S6, S7, S10, S12, S13a, S13b, S14 (proved by the prover); all π₁ ∈ (κ,1)
for p < q (resp. (0,κ) for p > q); the statement of T02; T01, T03, P04, P05 (no numbered result depends on
T02, `verification/INVENTORY.md:19-23`); the unnumbered use of GROW e-values at l.229.

**Suggestion to the authors (minimal).** In l.435 add the edge case: "If π₁ = 1, then g(λ) = log(1 - λh) is
strictly increasing and the maximum over (0,1] is attained at λ = 1, in agreement with the formula; for
π₁ < 1, lim_{λ→1} g(λ) = -∞ …" (and the mirror sentence π₁ = 0 for p > q). Checked: at π₁ = 1 the printed λ
and e-value formulas give λ = 1, E(0) = 0, E(1) = 1/κ, which is the true maximiser and its e-value (Lean at
the instance). Constructed by the reviewer, not in the source, suggestion only, not used in any verification.

Human check: recommended only to confirm the class (PAPER_ARGUMENT_GAP vs EXPOSITION_GAP) — the
mathematics is settled by the Lean evidence.

ISSUE 1 VERDICT: PAPER_ARGUMENT_GAP / THREATENS CONCLUSION: no

---

## Issue 2 — l.454 sign of d_{p,q}(y) (S11)

**What the source says.** l.454: d_{p,q}(y) = ∫ 1{p ≤ θ < q}(θ - y) dν(θ). From l.98-105 and eq:mixture
(l.95), for p < q: S_θ(p,0) - S_θ(q,0) = θ(1{p>θ} - 1{q>θ}) = -θ·1{p ≤ θ < q} and S_θ(p,1) - S_θ(q,1) =
(1-θ)(1{p≤θ} - 1{q≤θ}) = (1-θ)·1{p ≤ θ < q}; hence d(y) = ∫ 1{p ≤ θ < q}(y - θ) dν — the printed integrand
has the opposite sign. It also contradicts l.435 "d(0) < 0" (the printed formula gives d(0) = ∫_{[p,q)} θ dν > 0).

**Consumed.** l.456 and l.460 consume only the ratios (d(1)-d(0))/d(1) and (d(0)-d(1))/d(0). l.456's middle
expression "-ν[p,q) / (-ν[p,q) + ∫θ dν)" is computed with the printed (wrong) sign, consistently; both ratios
are homogeneous of degree 0 in d, so the global sign change does not change them and l.456/l.460's final
values 1/(1-κ), 1/κ are correct.

**Lean evidence:** `counterexample_l454 : ¬ PrintedClause_l454` (at y = 0: LHS -1/2, RHS 1/2);
`printed_l454_iff_gap : PrintedClause_l454 ↔ T02_S11_Gap` (scope = gated S11); positive
`correct_sign_at_instance` (the correctly signed formula holds at the instance, y ∈ {0,1});
`ratio_sign_invariant : ((-a) - (-b))/(-a) = (a - b)/a` (why l.456/l.460 are unaffected).

**Classification: `PAPER_ARGUMENT_GAP` (minor; sign typo).** The printed identity used as the
justification ("With d(y) = …, it now follows") is false for every admissible instance, while the step's
conclusion (l.456 and l.460 final values) is true. Not `ERROR` (no printed result is false); not
`EXPOSITION_GAP` (no range uncovered); not `FAIR_IMPLICIT_STEP` (the printed formula is wrong, not
unexpanded). A human may reasonably downgrade it to `EDITORIAL`, since a reader repairs it by flipping one
sign and nothing downstream changes; I do not do so because the printed middle expression of l.456 is a
false equation for the true d (it equals the true ratio only by sign invariance).

**Threatens the conclusion?** No. **Affected:** S11 only (stopped, used by nothing per prover notes).
**Unaffected:** S12, S13a, S13b, S14 (the prover proved S12/S13a from the correctly signed computation —
note for the auditor: that is the correct d, so it is a deviation from the printed l.454 route which must
be recorded as such, not as following l.454), the theorem statement, all other results.

**Suggestion (minimal):** in l.454 replace (θ - y) by (y - θ), and in l.456 the middle expression by
ν[p,q) / (ν[p,q) - ∫_{[p,q)} θ dν). Checked: with the correct d, (d(1)-d(0))/d(1) = N/(N-A) = 1/(1-κ) and
(d(0)-d(1))/d(0) = N/A = 1/κ (instance: 2 and 2, κ = 1/2). Reviewer's suggestion, not used in verification.

Human check: recommended (PAPER_ARGUMENT_GAP vs EDITORIAL).

ISSUE 2 VERDICT: PAPER_ARGUMENT_GAP / THREATENS CONCLUSION: no

---

## Issue 3 — l.462 "The case p > q is analogous" (S15) and the λ-range passage [0,1) → (0,1] (A09)

**3a. "Analogous".** The p > q case is the p < q argument under the relabelling y ↦ 1-y, π₁ ↦ 1-π₁
(normaliser d(1{p>q}) = d(1)). With A = ∫_{[q,p)} θ dν, N = ν[q,p): d(0) = A > 0, d(1) = -(N-A) < 0;
E(1) = 1-λ, E(0) = 1 - λh' with h' = d(0)/d(1) < 0; g(λ) = (1-π₁) log(1-λh') + π₁ log(1-λ);
π₁ ∉ H_S ⟺ (1-π₁)A - π₁(N-A) > 0 ⟺ π₁ < κ ⟺ (1-π₁) + π₁/h' > 0; critical point λ₀ = (1-π₁) + π₁/h' =
(1-π₁) + π₁ d(1)/d(0) = printed l.157; E(1) = 1-λ₀ = π₁(d(0)-d(1))/d(0) = π₁N/A = π₁/κ;
E(0) = 1-λ₀h' = (1-π₁)(d(1)-d(0))/d(1) = (1-π₁)N/(N-A) = (1-π₁)/(1-κ) = printed l.164. (reasoning, not
checked in Lean beyond the mirror instance.) The analogy is exact, so for π₁ ∈ (0, κ) this is
`FAIR_IMPLICIT_STEP`. At π₁ = 0 the analogue of l.435 fails (Lean: `analogue_l462_fails` — note this
clause is NOT printed; it is the l.435 analogue that "analogous" invokes), while the conclusion holds there
(`conclusion_holds_at_mirror`). That edge is the mirror of issue 1 and is ruled there; it is not a separate
paper issue.

**3b. λ range (A09).** The theorem maximises over the family λ ∈ (0,1] (l.145, l.154); the proof over [0,1)
(l.435). For π₁ < 1 (p < q) the passage is a fair implicit step: λ = 0 is outside the family, but the
maximiser is λ₀ > 0 (l.448); λ = 1 gives E(0) = 0, so g(1) = (1-π₁) log 0 = -∞ (the paper's value; in
Lean `GrowFinite` fails at λ = 1 because π₁ ≠ 1), so λ = 1 is never a maximiser and max over (0,1] = max over
(0,1). At π₁ = 1 the passage breaks only because the maximiser is λ = 1 — issue 1 again.

**How to fill in (for the prover; source route only, π₁ < 1 for p < q, π₁ > 0 for p > q):**
1. S8 (silent): from l.435 (a maximiser l* ∈ [0,1) exists), l.442 (the only zero of g' in [0,1) is λ₀) and
   l.448 (λ₀ > 0): note g'(0) = -(1-π₁) - π₁h = -h·λ₀ > 0 (S4 at λ = 0, h < 0), so l* ≠ 0; hence l* is an
   interior maximiser, g'(l*) = 0, l* = λ₀. Strictness: any l ∈ [0,1) with g(l) = g(λ₀) is also a maximiser,
   hence = λ₀. λ₀ < 1 because (1-π₁)/h < 0 gives λ₀ < π₁ ≤ 1.
2. S9 (A09): for l ∈ (0,1], l = 1 is excluded by `GrowFinite` (E(0) = 1 - 1 = 0, π₁ ≠ 1); for l ∈ (0,1) use
   step 1; λ₀ ∈ (0,1) ⊂ (0,1] and `GrowFinite` at λ₀ since E(0) = 1-λ₀ > 0, E(1) = 1-λ₀h > 0.
3. S15: repeat S1-S14 with the relabelling of 3a (d(1) < 0 < d(0), h' = d(0)/d(1), λ₀ = (1-π₁) + π₁/h',
   π₁ ∉ H_S ⟺ λ₀ < 1 ... ⟺ (1-π₁) + π₁/h' > 0); the κ identities via the same `core`-style computation on
   [q,p). The l.435 analogue is false at π₁ = 0: stop there and record it under issue 1 (do not add the
   increasing-function argument; that is the reviewer's suggestion, not the source's).

**Classification: `FAIR_IMPLICIT_STEP`** (for 3a outside π₁ = 0, and for 3b outside π₁ = 1); the edge cases
are issue 1. Not `EXPOSITION_GAP`: the omitted case is an exact symmetric copy that a competent reader fills
in routinely, and it does not cover anything issue 1 does not already record.

**Threatens the conclusion?** No. Affected: none beyond issue 1's edge. Unaffected: everything else.

ISSUE 3 VERDICT: FAIR_IMPLICIT_STEP / THREATENS CONCLUSION: no

---

## Not checked

- The general (all S, ν, p, q) truth of Theorem 3.2 at the edges and the full p > q case: reasoning, not
  checked in Lean (Lean checks only the instance and the mirror instance).
- `#pv_hyp_usage` not run (no conditional theorem in this file).
- This ruling is not confirmed until pv-auditor's counterexample review passes.

## Summary verdict for issue 1 (the primary issue of this report)

ISSUE VERDICT: PAPER_ARGUMENT_GAP
THREATENS CONCLUSION: no
