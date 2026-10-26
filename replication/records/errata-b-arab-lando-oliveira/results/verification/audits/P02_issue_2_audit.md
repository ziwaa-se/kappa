# P02 issue 2 — reasoning review (pv-auditor)

Reviewed: `verification/audits/P02_issue_2.md` (ruling: PAPER_ARGUMENT_GAP, THREATENS CONCLUSION: no).
Source read directly: `source/SuperParetoPaper-v12.tex:95-125, 147-159, 186-191, 260-273, 334, 354, 396-416`.

## 1. Source facts (checked myself)

| Point | Source | Finding |
|---|---|---|
| Statement has no sign condition | :263 | "independent random variables", weights >0; no "nonnegative" |
| Proof uses √ and strict Jensen | :266 | `Var(√X)=Var(√Y)`, `E√Y > θE√X+(1-θ)E√X`; both need X ≥ 0 a.s. |
| Stochastic order over all of ℝ | :117 | `Fbar_X(x) ≤ Fbar_Y(x)` for every x ∈ ℝ |
| No global nonnegativity convention | :111-113, :119 | general real-valued r.v.s |
| "nonnegative" written explicitly where meant | :147, :150, :159, :334, :354 | :354 even says "nonnegativity is not strictly necessary" |
| Real-supported X satisfying (eq:main-st) is in scope | :105, :403, :409 | super-Cauchy "allows the support to be the whole ℝ" and satisfies the conclusion of Thm 3.1 |
| :191 "remembering they are nonnegative" | :191 | refers to ITS variables (F_X(0)=0, :124), inside Thm 3.1's proof, not Prop 3.2 |
| Only consumer | :269-273 | Prop 3.3, ITS X (X > 0 a.s.), n = 2 suffices |

So the paper's printed domain for Prop 3.2 is real-valued X; reading it as nonnegative-only would be a repair, not the printed reading. The ruling's rejection of DOMAIN_CLARIFICATION as the primary code is correct.

## 2. Classification check

| Candidate | Ruling | My assessment |
|---|---|---|
| PAPER_ARGUMENT_GAP | chosen | **Agree.** VERDICTS §2: "the cited tool does not apply". Strict Jensen for √ (and Var(√X)) does not apply to signed X; the given justification fails on part of the printed scope. |
| ERROR | rejected | Agree: no counterexample to the printed clause under the gated reading ¬Integrable (see §3). |
| PAPER_ASSUMPTION_GAP | rejected | Agree: nonnegativity is not needed for the conclusion (¬Integrable reading), only for the chosen argument. |
| EXPOSITION_GAP | not discussed explicitly | Not the better fit: the source does not omit the signed case, it gives an argument that claims to cover it and that argument uses an inapplicable tool. ARGUMENT_GAP is more precise. |
| DOMAIN_CLARIFICATION (secondary, "infinite mean" for signed X) | recorded as secondary | Agree. Standard Cauchy is 1-stable: θX₁+(1-θ)X₂ =d X, so (eq:main-st) holds with equality, P(X₁=X₂)=0, E X undefined (not +∞). Under the literal reading "E X = +∞" the printed clause fails for signed X; under "no finite mean" it holds. Reasoning only, as the ruling states. |
| FAIR_IMPLICIT_STEP / ENCODING_ERROR | rejected | Agree: the problem is independent of how √ is encoded on (-∞,0) (truncation, complex, undefined): no strict-concavity Jensen is available there. |

## 3. Conclusion unthreatened (reasoning re-checked)

Suppose X integrable (real-valued). (i) Y ≥st X, E Y = E X finite ⇒ ∫_ℝ (Fbar_Y − Fbar_X) dx = E Y − E X = 0 with nonnegative right-continuous integrand ⇒ Fbar_Y = Fbar_X ⇒ X =d Y. Valid for signed integrable variables (E Z = ∫₀^∞ Fbar − ∫_{-∞}^0 F). (ii) φ(x)=√(1+x²): φ'' = (1+x²)^{-3/2} > 0, strictly convex on ℝ, 0 ≤ φ ≤ 1+|x|, so all φ-expectations finite. For θ∈(0,1), φ(θa+(1-θ)b) < θφ(a)+(1-θ)φ(b) iff a≠b; P(X₁≠X₂)>0 (from P(X₁=X₂)<1) gives E φ(Y) < E φ(X), contradicting X =d Y. Independence not used. Correct. This is a reviewer-constructed argument (suggestion only, not evidence of verification), as the ruling labels it.

Downstream scope: P03 consumes ITS X (X > 0 a.s.), where the √ argument as written works; not affected by this issue. T02, L01, P01, Section 4 do not use Prop 3.2. Agree. Issue 1 (the n=2 reduction) is separate and not reviewed here.

## 4. Lean evidence (rerun myself)

`scripts/pv_lean.sh probe pv_work/probes/issue/P02/issue_P02_sqrtneg.lean` →
`RESULT issue_P02_sqrtneg mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log `pv_work/logs/issue_P02_sqrtneg_4.log`; `#pv_walk_decl` for `not_S5WithoutNonneg`, `sqrt_not_concaveOn_univ`, `instance_negative`: `[propext, Classical.choice, Quot.sound]; sorryAx reached: false` (log lines 2, 34, 38).
Content read: `S5WithoutNonneg` keeps the S5 premises minus nonnegativity, adds independence (extra premise, allowed); the instance (X₁,X₂ i.i.d. on {−1,−2}, θ=1/2) makes both sides 0. It is correctly scoped as obstruction evidence for the √-step only, not a counterexample to Prop 3.2 (finite mean, so (eq:main-st) fails; `instance_negative` documents X<0).

## 5. Suggested fixes

- (a) add "nonnegative" to :263: sufficient. For X ≥ 0 integrable, √X ∈ L², equal law gives E√X = E√Y, and √ is strictly concave on [0,∞), so strict Jensen holds on {X₁≠X₂}. Also removes the "infinite mean" ambiguity. Covers the only use (P03). (Editorial remark: the Var(√·) detour is unnecessary, since equal law already gives E√X = E√Y.)
- (b) replace √ by φ(x)=√(1+x²) and state "X has no finite mean": sufficient by §3.

## 6. Status for the authors

Prop 3.2's √/Jensen argument (:266) is valid only for X ≥ 0, while the statement is for real-valued X (the paper itself treats real-supported super-Cauchy X): PAPER_ARGUMENT_GAP, conclusion still true under "no finite mean"; for signed X "infinite mean" should be read as "no finite mean" (Cauchy). Prop 3.3 unaffected.

REVIEW: CONFIRMED
