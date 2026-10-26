# T02 issue 1: counterexample review (pv-auditor)

- Auditor: pv-auditor (claude-opus-5-5). Written Tue Oct 13 01:33:58 EDT 2026 (from `date`).
- Audited: `pv_work/T02_Counterexample1.lean` (not modified), ruling `verification/audits/T02_issue_1.md`.
- Source read directly: `source/SuperParetoPaper-v12.tex:95-98, 111-137, 186-201, 217-256, 279`.
- Auditor probe: `pv_work/probes/auditor/T02/aud_T02_issue1.lean`, `scripts/pv_lean.sh probe` exit=0 errors=0, log `pv_work/logs/aud_T02_issue1_2.log`.

## 1. Encoding fidelity (decisive item)

Source :253-256: from `P ≥ b + d + a(a−b−d)` (with `a=F̄(x)`, `b=F̄(x/θₙ)`, `d=F̄(x/(1−θₙ))`) the text says
"the large parenthesis is negative, it follows that `P ≥ F̄(x/θₙ)+F̄(x/(1−θₙ)) ≥ F̄(x)`".

| Item | Source | `PrintedIntermediate` (Lean) | Judgement |
|---|---|---|---|
| Event | `P(θ₁X₁+⋯+θₙXₙ > x)` (:248, :256) | `μ {ω | x < ∑ θ i * Xs i ω}` | faithful (strict `>`) |
| Bound | `F̄_X(x/θₙ)+F̄_X(x/(1−θₙ))` | `Fbar (μ.map X) (x/θ last) + Fbar … (x/(1−θ last))`, `Fbar = 1 − cdf` (:113) | faithful |
| Variables | `n` i.i.d. copies of ITS `X` (:95, :188) | `IIDCopies`, `IsInvSub (μ.map X)` (gated defs of L01/T02) | faithful |
| Induction step | `n ≥ 3` copies, `θᵢ > 0`, `∑θᵢ = 1` (:219) | `n+1` copies, `2 ≤ n`, `0 < θ i`, `∑ = 1` | faithful |
| IH (:219, used at :225-227) | (eq:main-st) for `n−1` variables | only the normalised-weight instance (as in `T02_S7`) | **weaker premise than source** (see below) |
| Range of `x` | `x ≥ 0` (:191) | `0 ≤ x` | faithful; the Lean witness uses `x = 1/2 > 0` |
| Conclusion | first inequality of :256 only | first inequality only | not stronger |

Weak-IH point. The source's IH is "(eq:main-st) holds for any `n−1` variables" (all weights), whereas
`PrintedIntermediate` assumes only one instance, which makes the encoded clause formally slightly
*stronger* than the printed one. I closed this myself: auditor probe `not_full` refutes
`PrintedIntermediateFullIH`. That version has the IH for **all** positive weights on the first `n` copies,
and requires `0 < x` strictly. It uses the same witness and discharges the full IH via `T02_S4` for each
weight pair. The theorem compiles, with axioms `[propext, Classical.choice, Quot.sound]`. So the refutation also holds for an encoding
that is at least as weak as the printed clause. Objects: `X`, `Xs`, `θ`, `x` are universally quantified
parameters of the step; there are no global objects.

`PrintedInference` (Part A) encodes the printed inference "drop a nonpositive term from a lower bound" as
pure real arithmetic, with all available side facts (`0≤a,b,d≤1`, `a−b−d≤0`). It is faithful and not stronger.

## 2. Instance satisfies every printed hypothesis

| Hypothesis | Discharge | Check |
|---|---|---|
| `X` ITS (Def 2.2, :122-125) | `isInvSub_P`: Pareto(1), `F(0)=0`, `invDist = min(y,1)` subadditive on `(0,∞)` | read; matches source :279 ("Pareto(1) … is ITS") |
| i.i.d. copies | `iid3`: coordinates under `Measure.pi`, via `iIndepFun_iff_map_fun_eq_pi_map` | read; compiled |
| `n=3 ≥ 3`, `θ ≡ 1/3 > 0`, sum 1 | `norm_num` | ok |
| IH | `T02_S4 hL01` (n=2 case), for the specific or (auditor probe) all weights | ok; see §3 |
| `x = 1/2 ≥ 0` (also `> 0`) | `norm_num` | ok |

Arithmetic: `x/θ₃ = 3/2`, so `b = 2/3`; `x/(1−θ₃) = 3/4 < 1`, so `d = 1`. Thus `b+d = 5/3 > 1 ≥ P`. No
definition or convention in the source excludes this instance. Pareto(1) appears in the source itself as an
ITS example (:279). The ITS domain reading (`(0,∞)`) is the gated L01 encoding. The counterexample does not
depend on how `x/0` is handled, and the boundary `x = 0` is not needed. `intermediate_fails_at_zero`
(failure at `x=0` for every instance) is correct but is supplementary.

## 3. The counterexample is proved

| Check | Result |
|---|---|
| `scripts/pv_lean.sh check T02_Counterexample1` (run by me) | exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 (log `_5`) |
| `#pv_axioms T02_Counterexample1` | ALL STANDARD (30 declarations); `#pv_walk_decl not_printedIntermediate`: axioms `[propext, Classical.choice, Quot.sound]`, sorryAx reached: false |
| `#pv_hyp_usage not_printedIntermediate` | `hL01` USED, `h` USED |
| Earlier theorems used | `T02_S4` (refutation) and `T02_S11` (scope lemma `second_half_true` only), both from `T02ModGaps`. T02 has no final audit, so neither has an individual record. **Audited on the spot**: `T02_S4` statement (`T02ModGaps.lean:255-260`) is the `n=2` case of Theorem 3.1; it takes only `hL01` and no gap hypothesis; `#print axioms T02_S4` gives the standard three. It is used only to discharge the IH premise, whose Lean meaning (`StDom μ3 X3 …`) I read directly. `T02_S11` is not used in the refutation. |
| External parameter | The refutation is conditional on `T02_L01Consumed` (the "only if" direction of L01, unaffected by the L01 issue). Where it is actually used, at the law `μP`: my probe `P_sub` proves `SubCond μP` directly with the three standard axioms. So the condition is satisfied at the instance; the formal statement still carries `hL01` as a hypothesis. |

## 4. Scope

- Refuted: the first inequality of :256, `P(θ₁X₁+⋯+θₙXₙ > x) ≥ F̄(x/θₙ)+F̄(x/(1−θₙ))`, which is false at an
  instance satisfying all premises of the induction step with `x > 0`. Also refuted: the printed inference
  ("the parenthesis is negative, so it follows"), which is invalid (`not_printedInference`).
- Not refuted: the second inequality `F̄(x/θₙ)+F̄(x/(1−θₙ)) ≥ F̄(x)` ((eq:sub-1x); `second_half_true`), the
  consumed conclusion `P ≥ F̄(x)` of the induction step, Theorem 3.1 itself, the `n=2` case, and P03.
- Classification `PAPER_ARGUMENT_GAP`: confirmed. The false statement is an intermediate claim inside the proof,
  not the printed conclusion of Theorem 3.1, so `ERROR` does not apply. It is not an encoding artefact.
  Recording "intermediate claim false (not merely unjustified)" is accurate.
- Formalization note (agree with the ruling, §5): `T02_S10b_Gap` in `T02ModGaps` encodes the same false step. So
  `T02_main_mod_gaps` must not be cited as conditional evidence for that link. This is a formalization-side
  matter, not a paper issue.

## 5. Suggested fix

Replace the first inequality by `(b+d+a(a−b−d)) − a = (1−a)(b+d−a) ≥ 0`, using `a ≤ 1` and (eq:sub-1x). I
checked the algebra by hand, and `final_of_254` compiles with standard axioms. The fix is sufficient for this
sentence. It relies on line :254, which is outside this issue (S5/S6a and the zero-weight items remain
separate). The fix is reviewer-constructed: it is a suggestion only, not evidence.

## Verdict

The encoding matches the printed clause and is not stronger (I verified a full-IH variant). The instance
satisfies every printed hypothesis. The proof compiles with only standard axioms, and the one earlier theorem
consumed was audited on the spot. The scope and classification stated in the ruling are correct.

COUNTEREXAMPLE VALID
