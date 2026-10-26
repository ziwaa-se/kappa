# L01 issue 1: counterexample review (pv-auditor)

- Role: pv-auditor (Claude Opus 5.5), independent subagent; counterexample-review mode
- Date: Mon Oct 12 22:13:48 EDT 2026
- Reviewed: `verification/audits/L01_issue_1.md` (ruling), `pv_work/L01_Counterexample1.lean`, `pv_work/L01Stmt.lean`, `pv_work/L01Draft.lean`, `verification/audits/L01_gate.md`; source read directly at F:109-181, plus a search for `F_X(0)=0` / "nonnegativ" across the whole file.
- Hashes (`python3 scripts/pv_snapshot.py hash`), all identical to those in the gate and the ruling:

| File | sha256 |
|---|---|
| `pv_work/L01Stmt.lean` | 3e9b3f0c…d03ad57e (= gate) |
| `pv_work/L01Draft.lean` | abafe13b…0503e2c (= gate) |
| `pv_work/L01_Counterexample1.lean` | 03793f90…e1074f (= ruling) |
| `pv_work/L01_Counterexample1.olean` | fe5b5d01…d6a5f128 (= ruling) |
| `source/SuperParetoPaper-v12.tex` | 88ba28de…db103294 |

## 1. Encoding fidelity (decisive item): PASS

- Printed clause (F:130-133): "A random variable $X$ is \ITS\ if and only if $F_X(\frac{x}{\theta})+F_X(\frac{x}{1-\theta})\le F_X(x)+1,\ \forall x\ge0,\theta\in(0,1)$."
- Def 2.2 (F:124): "a random variable $X$ such that $F_X(0)=0$ is \ITS\ ... if $F^-_{1/X}$ is subadditive"; $F^-_{1/X}(x)=1-F_X(1/x)$ (F:121).
- `IsInvSub μ := F μ 0 = 0 ∧ SubadditiveOn (invDist (F μ)) (Ioi 0)`, with `F = ProbabilityTheory.cdf` (right-continuous, $P(X\le x)$, matching F:113). The gate approved it, and I agree: the $F_X(0)=0$ conjunct is the printed qualifier of Def 2.2.
- `SubCond` is exactly (eq:sub-1x): `∀ x ≥ 0, ∀ θ ∈ Ioo 0 1, F(x/θ)+F(x/(1-θ)) ≤ F x + 1`.
- `PrintedIfClause := ∀ μ [IsProbabilityMeasure μ], SubCond μ → IsInvSub μ`: the "if" direction, word for word. The only premise is the printed hypothesis; the conclusion is exactly "X is ITS". **It is not stronger than the source.** My probe confirms `PrintedIfClause = AuditPrintedIf` by `rfl`, where `AuditPrintedIf` is my own independent encoding.
- `L01_main_as_printed_false` refutes `∀ μ [IsProbabilityMeasure μ], IsInvSub μ ↔ SubCond μ`. This is exactly the universal closure of the gated `L01_main` type (`example` in the probe).
- Parameters and global objects: the lemma has a single parameter, X (its law). `F`, `invDist`, `SubadditiveOn`, `IsInvSub` and `SubCond` are built from that law alone. There are no global constants.
- Representation choices do not manufacture the failure. The failing conjunct is $F_X(0)=0$, which does not depend on the domain chosen for $F^-_{1/X}$ (gate item 4). The subadditivity conjunct is even proved to **hold** for the instance (`subadditive_dirac_zero`). The Lean convention 1/0=0 is never used at the failure point.

## 2. Instance satisfies every printed hypothesis: PASS

- μ = `Measure.dirac 0` (X = 0 a.s.) is a genuine random variable, a probability measure on ℝ (checked with `inferInstance` in the probe).
- (eq:sub-1x): F = 1 on [0,∞) and x/θ, x/(1-θ) ≥ 0, so the condition reads 2 ≤ 2 (`subCond_dirac_zero`). I also checked this by hand.
- No definition or convention in the source excludes it:
  - Searching for "F_X(0)=0" finds the qualifier only locally (F:124, F:346, F:442), never as a standing convention.
  - "nonnegative" occurs locally (F:147, F:150, F:159, F:191, F:334). F:191 ("remembering they are nonnegative") sits inside the proof of Thm 3.1, where X is ITS and therefore F_X(0)=0. It is not a global convention.
  - F:354 says explicitly that nonnegativity "is not strictly necessary".
  - Even a global nonnegativity convention would not exclude X = 0 a.s., since that variable is nonnegative. Only a convention "F_X(0)=0" would, and none is printed.
- F:180 consumes the broad reading. It applies the lemma's "if" direction to h(X) without checking $F_{h(X)}(0)=0$. So the restricted reading ("Lemma 2.3 is only about X with F_X(0)=0") is not the one the paper relies on. This supports the literal encoding.

## 3. Counterexample proved: PASS

| Check | Result |
|---|---|
| Probe `pv_work/probes/auditor/L01/aud_L01_cex1_check.lean` (imports the module) | `exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0` (log `pv_work/logs/aud_L01_cex1_check_1.log`) |
| `#pv_axioms L01_Counterexample1` | ALL STANDARD (10 declarations): [propext, Classical.choice, Quot.sound] |
| `#pv_walk L01_Counterexample1`, `#pv_walk_decl …L01_main_as_printed_false` | closure axioms standard; `sorryAx reached: false` |
| Project constants reached | only `L01Stmt` defs (F, IsInvSub, SubCond, SubadditiveOn, invDist; th/vh fingerprints identical to the gate snapshot) and the file's own lemmas. No earlier theorem is used, so no audit record is needed. |
| Independent recompile: verbatim copy `pv_work/probes/auditor/L01/aud_L01_cex1_copy.lean` against `L01Stmt` only | `exit=0 errors=0 sorry_warnings=0` (log `pv_work/logs/aud_L01_cex1_copy_1.log`); `#print axioms` standard |

I read the lemma bodies myself. Each one is an elementary computation of `cdf (dirac 0)` and contains no hidden hypotheses.

## 4. Scope

- **Refuted**: the "if" direction of Lemma 2.3 as printed (F:130), and therefore the printed biconditional.
- **Not refuted**:
  - the "only if" direction (ITS ⇒ eq:sub-1x);
  - the equivalence that the proof (F:137) actually argues, subadditivity of $1-F_X(1/x)$ ⇔ (eq:sub-1x) (S1∘S2, hand-checked by the gate, not yet in Lean);
  - the lemma with the qualifier $F_X(0)=0$ added.
- **Downstream**:
  - Thm 2.6 (F:180) consumes exactly the refuted clause (`consumed_of_printed` is a trivial instantiation, correct). So that step needs separate examination in Thm 2.6's own pipeline.
  - Thm 3.1 (F:201) uses only "only if" and is unaffected.
  - The ruling states the scope neither too broadly nor too narrowly; I agree.
- **Non-degeneracy**: the mixture p·δ₀ + (1−p)·Fréchet(1) (ruling §3) is reasoning only, not checked in Lean. I checked the algebra: LHS − RHS = (1−p)[H(x/θ)+H(x/(1−θ))−H(x)−1] ≤ 0 for x > 0, and 2p ≤ p+1 at x = 0. It is credible, but it is not needed: the Dirac instance alone suffices.

## 5. Suggested fix

The suggested fix inserts "such that $F_X(0)=0$" at F:130, mirroring F:442.

- **Sufficient for L01**: under that qualifier, Def 2.2 reduces to subadditivity on (0,∞), and the proof's equivalence finishes the argument. I re-checked the S1 substitution: s = θ/x and t = (1−θ)/x is a bijection (0,∞)×(0,1) ↔ (0,∞)², with s+t = 1/x. The x = 0 case of S2 is F(0) ≤ 1.
- **Not sufficient for Thm 2.6**: the ruling correctly says that the fix does not repair Thm 2.6. I checked its lead by hand:
  - h(x) = max(x−1,0) is continuous, h(0)=0, and h(x)/x is non-decreasing (F:111);
  - for X Fréchet(1), $F_{h(X)}(0)=P(X\le1)=e^{-1}>0$.
  
  This is a lead for Thm 2.6, not ruled here.
- **Classification**: PAPER_ASSUMPTION_GAP is consistent with the evidence. The omitted hypothesis cannot be derived from (eq:sub-1x), and it is printed in the parallel F:442. The ruling discusses the ERROR and DOMAIN_CLARIFICATION alternatives openly. I see no reason to change the classification. A human check that no global F_X(0)=0 convention was intended is reasonable, as the ruling notes.

## 6. Not checked

- S1 and S2 in Lean (prover's task).
- The mixture instance and the Thm 2.6 / F:334 leads in Lean (hand reasoning only).

Reason: X = 0 a.s. satisfies (eq:sub-1x), the only printed hypothesis, but has F_X(0)=1, so it is not ITS under Def 2.2. The encoding of the printed "if" clause is faithful and not stronger. The proof compiles with only the standard axioms and no sorry.

COUNTEREXAMPLE VALID
