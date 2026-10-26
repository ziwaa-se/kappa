# P05 issue 1: counterexample review

- Role: pv-auditor (Claude Opus 5.5), independent subagent, counterexample-review mode
- Date: Tue Oct 13 02:26:12 EDT 2026 (from `date`)
- Reviewed: `verification/audits/P05_issue_1.md` (ruling), `pv_work/P05_Counterexample1.lean`, gate `verification/audits/P05_gate.md`.
- Source read directly: `source/SuperParetoPaper-v12.tex` :100-149, :330-444. I searched the whole file for global conventions ("F_X(0)=0", "Throughout", "We assume", "nonnegative random", "positive random") and for every use of `cor:invNWU` (hits: :430 label, :448 only).

## Hashes (`python3 scripts/pv_snapshot.py hash`)

| File | sha256 | Matches |
|---|---|---|
| pv_work/P05_Counterexample1.lean | 441c152a…4b4135 | ruling §3 |
| pv_work/P05_Counterexample1.olean | 77db7eed…b24be4 | ruling §3 |
| pv_work/P05Stmt.lean | b5c0badc…a72b | gate (line 11) |
| pv_work/L02Stmt.lean | caf65f96…256d1f | gate (line 13) |
| pv_work/L01Stmt.lean | 3e9b3f0c…ad57e | gate (line 14) |
| probe pv_work/probes/auditor/P05/aud_P05_cex1.lean (mine) | 554e8c22…15ab | n/a |

## 1. Encoding fidelity (decisive item)

| Item | Source | Lean | Judgement |
|---|---|---|---|
| Quantifier | F:431 "A random variable $X$" (no qualifier) | `∀ μ [IsProbabilityMeasure μ]` (F:119: notions depend only on the cdf) | faithful; the extra premise only weakens the clause |
| Hypothesis | F:424 order: $1/F_2^{-1}(F_1^-(1/x))$ subadditive, $F_2=\mathcal H$ (F:142) | `InvSubLE (F μ) Hcdf` = `SubadditiveOnE (invSubFn …) (Ioi 0)`, `invSubFn = recipE ∘ genInv Hcdf ∘ leftVer F ∘ (1/·)` | gate-approved; my probe shows by `Iff.rfl` that it unfolds to `Function.leftLim (cdf μ)`, the sup-based `genInv` (F:111) and `recipE` |
| Conclusion | "super-heavy-tailed", Def 4.9(1) F:346-349: $X$ "such that $F_X(0)=0$" and $-\Log F_X(1/x)$ subadditive | `IsSuperHeavyTailed μ := F μ 0 = 0 ∧ SubadditiveOnE (negLogInv μ) (Ioi 0)` | literal; gate-approved (P05 gate item 2, L02 gate) |
| `PrintedIfClause` | "if" direction of F:431 | `∀ μ [IsProb μ], InvSubLE (F μ) Hcdf → IsSuperHeavyTailed μ` | not stronger: no premise dropped, conclusion = the printed one |

**Refutes the gated statement.** My probe recomputes the type hash of a verbatim copy of `P05_main (μ) : P05Conclusion μ`: `th=2049719506`, equal to the gate snapshot (gate line 118). `#pv_type_hashes P05Stmt` reproduces all 8 gate fingerprints exactly (gate lines 100-108). `P05_main_gap_false : ¬ ∀ μ : Measure ℝ, P05Conclusion μ` checks against the unfolded type `¬ ∀ μ, IsSuperHeavyTailed μ ↔ InvSubLE (F μ) Hcdf`. So it refutes the gated `P05_main`, universally quantified. The walk shows that the L02Stmt fingerprints reached (`IsSuperHeavyTailed` vh=1915010453, `SubadditiveOnE` vh=2787305485, `negLogInv` vh=1981073015) are the gate-approved ones (same as in the L02 issue audit).

**Constructed vs. global objects.** Only $F_X$ (and hence $F_X^-$) is built from the parameter μ. $\mathcal H$, `genInv`, `recipE` and `negLogInv` are fixed definitions. No global object is mis-scoped.

**Encoding dependence.** The failure does not come from our representation choices:

| Choice | Effect on the instance |
|---|---|
| Domain `(0,∞)` vs `ℝ∖{0}` (gate item 4) | order holds under both (`invSubLE_dirac0`, `invSub_dirac0_punctured`, value 0 on x>0 and +∞ on x<0) |
| `recipE` conventions `1/⊤=0`, `1/0=⊤` | only `ℋ^{-1}(1)=+∞ ⇒ 1/∞ = 0` is used on x>0, which is the only sensible value (the source's own formula gives $-\Log 1 = 0$) |
| `Hcdf = 0` on x≤0 | it is used only in the ℝ∖{0} robustness lemma (`ℋ^{-1}(0)=0`). On x>0, `genInv_H_one` needs only `Hcdf ≤ 1` |
| `F` vs `F^-` | on x>0 both equal 1 for δ₀, so the instance does not depend on the S3 bridge |
| `-Log 0 = +∞` (EReal) | not reached: `subadditive_negLogInv_dirac0` (all values 0) |

The instance fails **only** the conjunct $F_X(0)=0$, which is the source's own Def 4.9 preamble (F:346).

## 2. The instance satisfies every printed hypothesis

| Check | Result |
|---|---|
| δ₀ is a probability law | yes (instance inferred in my probe) |
| $F_{δ_0}\le_{i-sb}\mathcal H$ | yes: $F^-(1/x)=P(X<1/x)=1$ for x>0, $\mathcal H^{-1}(1)=\sup\mathbb R=+\infty$, so the function is $0$ and $0\le0+0$ |
| Conclusion fails | $F_{δ_0}(0)=1\ne0$ (`not_superHeavy_dirac0`). Sanity in my probe: `F δ₀ (-1) = 0`, `F δ₀ 0 = 1` (the cdf is non-degenerate, right-continuous) |
| No global convention excludes X≡0 | none found: F:111-119 have no positivity convention; F:354 says nonnegativity "is not strictly necessary"; F:431 opens with a fresh "A random variable $X$" |

**Standing-convention readings (requested check).**
- **F:426** ("rules out distributions whose supports strictly include the origin") does not exclude δ₀. The support {0} does not strictly include the origin, and δ₀ satisfies the order under the ℝ∖{0} reading as well. At most F:426 forces $P(X<0)=0$, which δ₀ meets; this is weaker than $F_X(0)=0$.
- **F:346** read as a standing restriction for Section 5 would exclude δ₀ (and make the proposition true, given S2+S3). Against it: F:442 prints the qualifier for the parallel result, so the authors print it where they intend it; F:431 has a fresh quantifier; F:354 disclaims a sign convention. This is a reading question for the authors, not an encoding defect. The ruling flags it for human check (§8), and I agree.
- **A third reading the ruling does not discuss:** F:354 ("not strictly necessary for the above definitions") could mean that the preamble of Def 4.9 is dispensable, i.e. super-heavy-tailed = subadditivity only. Under that reading δ₀ is super-heavy-tailed and P05 holds as printed. But that reading is not consistent paper-wide: the ITS definition (F:124) keeps $F_X(0)=0$, so Thm thm:inv-nwu-fsub (F:378, SHT ⇒ ITS) would then fail at δ₀. This makes it a weaker rescue than the standing-convention reading. The human check should still mention it.

Against the statement as printed, read with the definition as printed (the gate-approved reading), the counterexample is valid.

**Non-degenerate instance (ruling §3).** I re-checked it by hand. For x>0, $F^-(1/x)=p+qe^{-x}$, and $p+qab-(p+qa)(p+qb)=pq(1-a)(1-b)\ge0$, so the order holds while $F(0)=p>0$. Correct. It is not checked in Lean and is not needed for validity.

## 3. The counterexample itself is proved

| Check | Result |
|---|---|
| My probe `scripts/pv_lean.sh probe pv_work/probes/auditor/P05/aud_P05_cex1.lean` (imports the built `P05_Counterexample1`) | `RESULT aud_P05_cex1 mode=probe exit=0 errors=0 sorry_warnings=1 nonstandard_axiom_lines=0 log=pv_work/logs/aud_P05_cex1_1.log`. The single sorry is my intentional copy of `P05_main`, made only to recompute its type hash (log line 1, probe line 40). It is not in the counterexample. |
| `#print axioms` `P05_if_counterexample`, `P05_as_printed_false`, `P05_main_gap_false`, `invSub_dirac0_punctured` | [propext, Classical.choice, Quot.sound] (log lines 13-16) |
| `#pv_walk_decl Paper.P05.P05_main_gap_false` | closure axioms standard; `sorryAx reached: false`; project modules reached: L01Stmt (1), L02Stmt (3), P05Stmt (8), P05_Counterexample1 (11) (log lines 17-45) |
| `#pv_axioms P05_Counterexample1` / `P05Stmt` | ALL STANDARD (19 / 8 declarations) |
| Earlier theorems used | none. Only gate-approved statement definitions (L01Stmt, L02Stmt, P05Stmt) are used, none redefined, and no theorem needing an audit record is consumed |
| Forbidden constructs | the walk reaches no `sorryAx`. The file (read in full) has no `axiom`, `native_decide`, `implemented_by` or `extern` |

I did not rerun the ruling's `build` command. The `.olean` hash matches the ruling, and my probe imports that `.olean` successfully.

## 4. Scope

- **Refuted:** the "if" direction of Prop cor:invNWU as printed (F:431), hence the printed biconditional and the gated `P05_main` (`∀ μ`). `P05_main_gap_false` also shows that the prover's gap proposition is false, so `P05_main_mod_gaps` is vacuous and cannot support a verified verdict.
- **Not refuted:** the "only if" direction (SHT ⇒ order), and the equivalence of the order with the subadditivity conjunct (δ₀ satisfies both sides), i.e. the proposition for $X$ with $F_X(0)=0$.
- **Downstream:** confirmed by search. The only later use is F:448 (alternative proof of thm:inv-nwu-fsub), which uses SHT ⇒ $F_X\le_{i-sb}\mathcal H$ (the unrefuted direction); $F_X(0)=0$ for the cor:fsub step comes from SHT itself. The ruling states the scope correctly, neither too broadly nor too narrowly.

## 5. Suggested fix

Adding "such that $F_X(0)=0$" at F:431 (mirroring F:442) removes the counterexample. With the qualifier, the "if" direction needs only order ⇒ subadditivity of $-\Log F_X(1/x)$, i.e. S2+S3, and the "only if" direction is unchanged. Sufficiency is conditional on S3 (the F/F^- bridge). The gate checked S3 by hand and the prover reports it proved, but I have not audited it here. The alternative fix (dropping the preamble from Def 4.9) is **not** sufficient paper-wide: it would break thm:inv-nwu-fsub at δ₀ unless the ITS definition (F:124) is changed as well. The ruling's minimal fix is the better one.

## 6. Classification remark (second opinion, not decisive for validity)

PAPER_ASSUMPTION_GAP is acceptable and consistent with L01/L02. DOMAIN_CLARIFICATION remains the alternative if the authors intended F:346 as a standing Section 5 convention. The human check in ruling §8 should settle it.

Reason: δ₀ (X = 0 a.s.) satisfies $F_X\le_{i-sb}\mathcal H$ under both domain readings, but has $F_X(0)=1$, so it is not super-heavy-tailed per Def 4.9 (F:346). It refutes exactly the printed "if" direction of F:431 and the gated `P05_main` (type hash 2049719506 reproduced). The encoding is literal and not stronger, no source convention excludes δ₀, and the build is clean with only standard axioms.

COUNTEREXAMPLE VALID
