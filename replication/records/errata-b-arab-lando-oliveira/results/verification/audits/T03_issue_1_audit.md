# T03 issue 1 audit: counterexample review (Theorem 4.8, `cor:inclusion`)

- Role: pv-auditor (Claude Opus 5.5), independent subagent; counterexample-review mode. Tue Oct 13 02:29:34 EDT 2026 (`date`).
- Reviewed: ruling `verification/audits/T03_issue_1.md`; Lean `pv_work/T03_Counterexample1.lean` (sha256 de440709…c38b5), read in full.
- Source read directly: `source/SuperParetoPaper-v12.tex` (sha256 88ba28de…eb103294, = gate) at :105-126, :275-340, plus :426.
- Definitions read in full: `pv_work/T03Stmt.lean` (bbdcfd41…a7606c9, = gate), `pv_work/P04Stmt.lean` (84cc56ad…adb7, = P04_gate_r2), `pv_work/L01Stmt.lean` (3e9b3f0c…3ad57e, = L01_gate), `pv_work/T03Draft.lean`.

## 1. Encoding fidelity (decisive item)

| Check | Result |
|---|---|
| `PrintedThm48` vs :334 "If X is nonnegative super-Pareto then X is ITS" | word for word: probability law μ, `SuperPareto μ` (Def 4.1), `Nonneg μ`, conclusion `IsInvSub μ` (Def 2.2) |
| Same as the GATED statement | yes. Auditor probe `pv_work/probes/auditor/T03/T03_cx_audit_probe.lean`: `GatedBody` (body of `T03_main`, T03Draft.lean:61-63, copied verbatim after its two parameters) `= PrintedThm48` by `rfl`; `gatedBody_false : ¬ GatedBody` compiles (`RESULT … exit=0 errors=0`, log `pv_work/logs/T03_cx_audit_probe_1.log`) |
| Fingerprints of reached definitions (walk, log `pv_work/logs/T03_Counterexample1_3.log`) vs gate records | `T03.Nonneg` th=3905129696 vh=2774941542 (= T03_gate); `P04.SuperPareto` vh=2740489307, `P04.paretoMeasure` vh=1064029993 (= P04_gate_r2:105,107); `L01.IsInvSub` vh=4092780251, `L01.invDist` vh=4160654643, `L01.F` vh=2204204658 (= L01_gate:92-96). All identical |
| Not stronger than source | no premise dropped, conclusion not strengthened. `PrintedThm48Pos` adds a premise (`F μ 0 = 0`), so it is weaker; `pos_of_printed` checks this |
| `SuperPareto` vs Def 4.1 (:286) | ∃ h measurable, monotone on [1,∞) ("increasing" = non-decreasing, :111), convex on [1,∞), nonconstant on [1,∞), μ = law of h(Z), Z ~ 𝒫 (:279). Faithful; the extra measurability only makes instances harder |
| `IsInvSub` vs Def 2.2 (:122-124, :121) | `F μ 0 = 0 ∧` subadditivity of `1 - F(1/x)` on (0,∞). The `F_X(0)=0` clause is the class restriction of Def 2.2 ("X such that F_X(0)=0 is ITS if …"), so a law with `F_X(0)≠0` is not ITS in the paper's sense |
| `Nonneg` vs "nonnegative" | μ(-∞,0)=0, i.e. X ≥ 0 a.s.; gate item 1 approved |

Gated `T03_main` itself (with parameters `hX01`, `hT01`) is not refuted: `hT01 = T03_T01Consumed` is refutable (issue 2 file), so `gatedMain_exfalso : GatedMain` is provable (probe). The counterexample refutes the printed clause, which is what the gate approved as the hypothesis/conclusion encoding (gate items 1-3). This is the correct target: the parameter is a predecessor clause, not part of the printed statement.

## 2. The instances satisfy every printed hypothesis (checked by hand, independently of Lean)

| Instance | super-Pareto (Def 4.1) | nonnegative | fails |
|---|---|---|---|
| A: X = max(Z-2,0) | h(z)=max(z-2,0): non-decreasing, convex, h(1)=0≠1=h(3) | yes, h ≥ 0 | F_X(0)=P(Z≤2)=1/2 ≠ 0, so outside Def 2.2's class |
| B: X = Z+1 | h(z)=z+1: increasing, convex (affine), nonconstant | yes, X ≥ 2 | F_X(0)=0, but v(x)=1-F_X(1/x): v(1/2)=1-P(Z≤1)=1, v(1/4)=1-P(Z≤3)=1/3; 1 > 2/3 |

Definitions searched in the text: "increasing" (:111), super-Pareto (:286, only definition; :296-299 is a cited equivalence, not a definition), ITS (:124), "nonnegative" (:147, :150, :159, :191, :334, :354; always "X ≥ 0", never "support starting at 0"). No convention excludes A or B. B in particular is not excluded by any reading I found: its points 1/4, 1/2 lie in every candidate domain of v. Prop 4.3 on the support domain gives 1/Fbar_B = x-1 on [2,∞), concave, so it is consistent with B being super-Pareto. (On all of ℝ, 1/Fbar is not concave even for Z itself, so the support reading is the only coherent one.) The authors themselves say at :426 that this order "is not shift-invariant", which is the mechanism behind B.

Instance A depends on the F_X(0)=0 clause of Def 2.2. B does not, so the refutation does not depend on how that clause is read.

## 3. The counterexample is proved

| Check | Result |
|---|---|
| Compile (auditor run) | `scripts/pv_lean.sh check T03_Counterexample1` → `RESULT … exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/T03_Counterexample1_3.log` |
| Axioms (log :133-135, walk :2, :41, :83) | `not_PrintedThm48`, `not_PrintedThm48Pos`, `consumed_of_printed`: `[propext, Classical.choice, Quot.sound]`; `sorryAx reached: false` |
| Project modules reached | `L01Stmt`, `P04Stmt`, `T03Stmt` (gated definitions only, fingerprints above) and the file itself. No earlier theorem is used, so no audit record is needed beyond the gates |
| Lemma content | `pm_eq` (density x^{-2} on (1,∞) = `paretoMeasure`), `tail`, `Iic_one`, `F_P_*`, `F_map_pre`, `F_A_zero`, `F_B`, `not_inv_A/B`: genuine computations, no hypotheses, nothing assumes the conclusion |
| Non-vacuity | the instances are concrete probability laws (`μA_prob`, `μB_prob`). The probe also exhibits X=Z satisfying hypotheses and conclusion, so the hypothesis class is not empty or contradictory |

## 4. Scope

- Refutes: Thm 4.8 as printed (:334), for "nonnegative" = X ≥ 0 a.s. (A and B), and also the repair "positive"/"F_X(0)=0" (B). It also refutes the reading "essential infimum 0" in the sense that A still applies (reasoning; A has ess inf 0).
- Does not refute: Thm 4.8 for some nonnegative super-Pareto laws (X = Z is ITS, `isInvSub_Z`); any other numbered result (`cor:inclusion` appears only at :333; no consumer). Prose at :107 and :331 claims the inclusion and is affected. I agree with the ruling's scope; it is neither too broad nor too narrow.
- Classification ERROR: confirmed. The printed conclusion is false under hypotheses that are satisfied in full, and no reading of "nonnegative" excludes both instances.

## 5. Suggested fix ("F_X(0)=0 and F_X(x)>0 for every x>0")

I checked it (reasoning only, not in Lean). It excludes A (atom at 0) and B (F_B(x)=0 for x<2). Under it, h(1)=ess inf X=0 (monotone and convex on [1,∞) force h(1)=h(1+), and Z has no atom at 1), and h>0 on (1,∞). So g(y)=h(y+1) is convex with g(0)=0 and g>0 on (0,∞), hence star-shaped, strictly increasing and continuous, with g→∞. Fbar_X(x)=1/(1+g^{-1}(x)). Since g^{-1}(u)/u is non-increasing, φ(s)=1-F_X(1/s) satisfies φ(s)/s=1/(s+s·g^{-1}(1/s)) non-increasing, and a nonnegative function with φ(s)/s non-increasing is subadditive. The argument looks credible and sufficient (not necessary: X=Z). This is a suggestion to the authors only, not evidence.

Reason: instances A (max(Z-2,0)) and B (Z+1) satisfy every printed hypothesis of Thm 4.8 under the gated, fingerprint-identical encodings of Def 4.1, Def 2.2 and "nonnegative"; `¬ PrintedThm48` (= body of gated `T03_main`, by `rfl`) compiles with standard axioms only; B also defeats the "positive" repair.
COUNTEREXAMPLE VALID
