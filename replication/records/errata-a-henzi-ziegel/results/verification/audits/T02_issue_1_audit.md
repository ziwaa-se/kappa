# T02 issue 1: counterexample review (pv-auditor)

- Audited: `verification/audits/T02_issue_1.md` (issue 1, l.435), evidence `pv_work/T02_Counterexample1.lean`
  (sha256 677c6a82…05ffb9, the same hash as the ruling; I did not modify it).
- Source read directly: `source/VSIFP_02.tex:89-106` (eq:mixture, eq:elementary, ν), `:137-172` (H_S, Thm 3.1, Thm 3.2),
  `:429-463` (proof of Thm 3.2). Definitions read: `pv_work/Defs.lean` (expPi, IsConsistent, elemScore,
  IsMixingMeasure, mixtureScore, HS, Erep, kappa, growthRate, GrowFinite, IsGrowLambda, EGrow), `T01Stmt.lean`
  (MixtureRep), `T02Stmt.lean` (growLambda, Conclusion), `T02ModGaps.lean` (T02_S3a_Gap, T02_S3b_Gap).
- Date: Tue Oct 13 01:09:27 EDT 2026 (from `date`).

## Mechanical checks (run by me)

| Check | Result |
|---|---|
| `scripts/pv_lean.sh check T02_Counterexample1` | exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 (log `pv_work/logs/T02_Counterexample1_4.log`) |
| Probe `pv_work/probes/auditor/T02/aud_T02_issue1.lean` (`pv_lean.sh probe`) | exit=0 errors=0 (log `pv_work/logs/aud_T02_issue1_1.log`) |
| `#pv_axioms T02_Counterexample1` | ALL STANDARD (53 declarations checked) |
| `#pv_walk T02_Counterexample1` | closure axioms [propext, Classical.choice, Quot.sound]; sorryAx reached: false |
| `#print axioms` for `counterexample_l435_lim`, `counterexample_l435_max`, `conclusion_holds_at_instance` | [propext, Classical.choice, Quot.sound] each |
| Project constants reached (walk) | definitions only (Defs, T01Stmt.MixtureRep, T02Stmt.growLambda/Conclusion, T02ModGaps gap defs) and the auto-generated `growLambda.eq_1`; **no earlier theorem is used**, so no individual audit record is needed for any consumed theorem |

## 1. Encoding fidelity (decisive)

Source l.435 (case p < q): "… $g$ is continuous in $\lambda$ with $g(0)=0$ and $\lim_{\lambda\to1} g(\lambda)=-\infty$,
so a maximum is attained at some $\lambda\in[0,1)$", with $g$ defined at l.432-433 as $\mathbb{E}_{\pi_1}[\log E_{p,q;\lambda}(Y)]$.

| Item | Finding |
|---|---|
| Hypotheses | Thm 3.1 assumptions via l.154 (consistent S, p,q ∈ (0,1), p ≠ q, ν[min,max) > 0), S represented by ν (eq:mixture, `MixtureRep`), π₁ ∈ [0,1] \ H_S (l.154, H_S ⊆ [0,1] l.139), case p < q (l.435). Same as or stronger than the source context; nothing dropped. |
| g | `growthRate S p q π₁ λ = (1-π₁) log Erep(λ,0) + π₁ log Erep(λ,1)` with `Erep` = eq:representation (l.147). Confirmed by an `Iff.rfl` unfolding in my probe. Same as l.432-433 (for p < q, 1{p>q} = 0, and \|d(0)\| = -d(0) because d(0) < 0, so l.147 and l.433 agree). |
| `PrintedClause_l435_lim` | Only the limit conjunct, read as λ → 1⁻ (`𝓝[<] 1`, the domain is [0,1)). Dropping conjuncts weakens the clause, so it is **not stronger** than l.435. |
| `PrintedClause_l435_max` | "some l ∈ [0,1) maximises g over [0,1)". Implied by any reading of "a maximum is attained at some λ ∈ [0,1)" (over [0,1) or over [0,1] with g(1) = -∞), so **not stronger**. |
| `Real.log` artefact | None at the instance: Erep(λ,0) = 1-λ > 0 and Erep(λ,1) = 1+λ > 0 on [0,1), and at π₁ = 1 the y = 0 term has coefficient 0. |
| Global vs constructed objects | S, ν, p, q, π₁ are all universally quantified parameters of the theorem and the proof; g is built from them; no global object is fixed. |
| Consumed downstream | `consumed_of_printed : PrintedClause_l435_max ↔ T02_S3b_Gap` is `Iff.rfl`; `printed_lim_of_gap : T02_S3a_Gap → PrintedClause_l435_lim`. The refuted clauses are exactly what the proof route consumes. |

No `ENCODING_ERROR` found.

## 2. The instance satisfies every printed hypothesis

ν = δ_{1/2}, S = S_{1/2} (l.98-99), p = 1/4, q = 3/4, π₁ = 1.
- ν is a locally finite Borel measure on (0,1) (l.97): `IsMixingMeasure` proved inside `hrep0`.
- S = ∫ S_θ dν (l.95): `hrep0` (with integrability). S is consistent: `hcons0`. Thm 3.1 (l.145) requires only
  consistency, not strict consistency (l.106), so a Dirac mixing measure is admissible; no definition in the source excludes it.
- ν[1/4, 3/4) = 1 > 0: `hν0`. p, q ∈ (0,1), p ≠ q, p < q: proved.
- π₁ = 1 ∉ H_S: E₁{d(Y)} = d(1) = S(1/4,1) - S(3/4,1) = 1/2 > 0 (`hπF`). π₁ = 1 is a probability in [0,1]; the
  source restricts alternatives only by π₁ ∉ H_S (l.151, l.154, l.448 "for all π₁ ∉ H_S"). I checked by hand that l.460
  ("1/κ > 1/π₁" = 2 > 1) and the printed e-value formula (E(0) = 0, E(1) = 1/κ = 2) are meaningful at π₁ = 1, so the source
  does not implicitly exclude this value.
- By hand: d(0) = -1/2, d(1) = 1/2, h = -1, g(λ) = log(1+λ) at π₁ = 1, so lim_{λ→1⁻} g = log 2 ≠ -∞, and sup_{[0,1)} g = log 2
  is not attained in [0,1). This agrees with `gF1`, `not_lim_at_instance` and `counterexample_l435_max`.

## 3. The counterexample is proved

`counterexample_l435_lim : ¬ PrintedClause_l435_lim` and `counterexample_l435_max : ¬ PrintedClause_l435_max` compile
cleanly, use the three standard axioms only, and do not reach `sorryAx`. No earlier theorem is used (definitions only).

## 4. Scope

- Refuted: the l.435 assertions "lim_{λ→1} g(λ) = -∞" and "a maximum is attained at some λ ∈ [0,1)", at the edge
  π₁ = 1 of the case p < q. Hence the downstream obligations that consume them (S3a, S3b, S8 "λ₀ < 1 and λ₀ is the unique
  maximiser on [0,1)", and S9) are also unsupported at that edge.
- Mirror p > q, π₁ = 0 (via l.462 "analogous"): the l.435 analogue, which the source does not print, also fails
  (`analogue_l462_fails`). This is correctly treated as the same issue, not a separate printed-clause refutation.
- Not refuted: the statement of Theorem 3.2. `conclusion_holds_at_instance` and `conclusion_holds_at_mirror` prove the full
  `Conclusion` at both edge instances. Also by hand: for p < q and π₁ = 1, g(λ) = log(1 - λh) with h < 0 is strictly increasing,
  so the unique maximiser over (0,1] is λ = 1, which is the printed value π₁ + (1-π₁)d(0)/d(1). The e-values are E(0) = 0 and
  E(1) = 1 - h = 1/κ. This general edge argument is reasoning, not Lean.
- Also not refuted: π₁ < 1 for p < q. In general (1-π₁) log(1-λ) → -∞ while π₁ log(1-λh) stays bounded (1 ≤ 1-λh ≤ 1-h);
  `lim_holds_below_one` checks this at the instance. Other results are not affected: no numbered result depends on T02.
- Remark on the positive check: `GrowFinite` drops the y = 0 term when π₁ = 1, which is the standard reading of
  E_{π₁}[·] under a point mass (P(Y = 0) = 0). This representation choice affects only the "not ERROR" judgement, not the
  counterexample. It is fair and matches the printed formula E(0) = (1-π₁)/(1-κ) = 0.

Scope is stated neither too broadly (the theorem is not claimed false) nor too narrowly (the mirror edge and the
consuming obligations S3a/S3b/S8/S9/S15 are included).

## 5. Classification

`VERDICTS.md` §2 table defines `PAPER_ARGUMENT_GAP` as "the justification given for some step does not hold: … an
intermediate assertion is false … The conclusion itself may still be true", and `EXPOSITION_GAP` as "the source does not
cover some range or case". Here l.435 explicitly asserts, for the whole case p < q, an intermediate claim that is false at an
admissible π₁, and l.448 extends the argument "for all π₁ ∉ H_S". The case is not left uncovered; a false assertion
covers it. **PAPER_ARGUMENT_GAP confirmed.** It is not `ERROR` (the conclusion holds at the edge), not `ENCODING_ERROR` (§1),
and not `PAPER_ASSUMPTION_GAP` (no missing hypothesis is needed). THREATENS CONCLUSION: no, confirmed.

## 6. Suggested fix

The fix suggested in the ruling is: at π₁ = 1, g(λ) = log(1-λh) is strictly increasing, so the maximum over (0,1] is at λ = 1;
for π₁ < 1, the limit is -∞. Plus the mirror sentence for p > q at π₁ = 0. I checked it by hand. The π₁ < 1 limit holds
because the second term is bounded. At π₁ = 1, the formula value λ = 1 lies in the family (0,1] and is the unique maximiser.
The fix removes the problem, and it is consistent with the printed λ and e-value formulas. It is a reviewer's suggestion
only and is not used as evidence.

## Status for the authors

The proof of Thm 3.2, l.435, asserts lim_{λ→1} g = -∞ and the existence of a maximiser in [0,1). Both are false at the
admissible edge π₁ = 1 (p < q), and the same holds at π₁ = 0 for p > q. The theorem's conclusion still holds there.
Lean counterexample: clean build, standard axioms.

ISSUE CLASS CONFIRMED: PAPER_ARGUMENT_GAP / THREATENS CONCLUSION: no
COUNTEREXAMPLE VALID
