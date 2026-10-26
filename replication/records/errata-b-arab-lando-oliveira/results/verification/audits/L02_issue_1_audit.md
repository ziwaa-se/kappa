# L02 issue 1: counterexample review

- Role: pv-auditor (Claude Opus 5.5), independent subagent, counterexample-review mode
- Date: Tue Oct 13 01:14:02 EDT 2026 (from `date`)
- Reviewed: `verification/audits/L02_issue_1.md` (ruling), `pv_work/L02_Counterexample1.lean` (sha256 a13f445eb2837cc6516105ed526f95d2aad22a80a3bf9e66762964273c8d0d1c, matches the ruling), `pv_work/L02Stmt.lean` (caf65f96…5256d1f, matches gate r2 line 7), `pv_work/L01Stmt.lean` (3e9b3f0c…3ad57e).
- Source read directly: `source/SuperParetoPaper-v12.tex` :111-124, :341-392, :442; searched the whole file for global conventions ("F_X(0)=0", "Throughout", "We assume", "nonnegative random") and for every use of `lem:inv-NWU` / `eq:inv-NWU`.

## 1. Encoding fidelity (decisive item)

| Item | Source | Lean | Judgement |
|---|---|---|---|
| Quantifier | F:361 "A random variable $X$" (no qualifier) | `∀ μ [IsProbabilityMeasure μ]` (law of X; F:119 identifies r.v. with its cdf) | faithful |
| Hypothesis | F:364 $F_X(x/\theta)F_X(x/(1-\theta))\le F_X(x)$, $\forall x\ge0,\theta\in(0,1)$ | `InvNWUCond`: `∀ x, 0 ≤ x → ∀ θ ∈ Ioo 0 1, F(x/θ)*F(x/(1-θ)) ≤ F x` | word for word |
| Conclusion | "super-heavy-tailed", Def 4.9(1) F:346-349: X "such that $F_X(0)=0$" and $-\Log F_X(1/x)$ subadditive | `IsSuperHeavyTailed μ := F μ 0 = 0 ∧ SubadditiveOnE (negLogInv μ) (Ioi 0)` | literal; gate-approved (gate r2) |
| cdf | F:113 $F_X$ cumulative distribution function | `F μ x := cdf μ x` = μ(Iic x) | standard right-continuous cdf |
| `PrintedIfClause` | "if" direction of F:361-364 | `∀ μ [IsProb μ], InvNWUCond μ → IsSuperHeavyTailed μ` | not stronger: no premise dropped, conclusion = printed conclusion |

Independent check: in my probe the clause is shown `Iff.rfl`-equal to its fully unfolded form (cdf inequality ⇒ `cdf μ 0 = 0 ∧` subadditivity of `negLogInv` on (0,∞)). `printedIf_of_printedIff` correctly shows the printed biconditional implies the clause, so refuting the clause refutes the gated `L02_main` (universally quantified).

Constructed vs. global objects: the only object built from the parameter is $F_X$ (from μ); `negLogInv`, `SubadditiveOnE` are fixed definitions. No global object is mis-scoped.

Representation choices do not create the failure: the counterexample fails only the conjunct $F_X(0)=0$; `subadditive_dirac_zero` shows the subadditivity conjunct holds, so the `EReal`/⊤ convention, the (0,∞) domain and Lean's `1/0=0` are irrelevant.

## 2. The instance satisfies every printed hypothesis

| Check | Result |
|---|---|
| μ = δ₀ is a probability measure (a law of a real r.v.) | yes (instance inferred) |
| (eq:inv-NWU) for all x ≥ 0, θ ∈ (0,1) | yes: x/θ, x/(1-θ), x ≥ 0 so all three cdf values are 1; `1*1 ≤ 1` (`invNWUCond_dirac_zero`) |
| Any source definition/convention excluding X ≡ 0 | none found: no global nonnegativity/positivity convention (F:111-119); F:354 says nonnegativity "is not strictly necessary"; Lemma 4.10 opens with a fresh "A random variable $X$" |
| Conclusion fails | `F δ₀ 0 = 1 ≠ 0` (`not_superHeavy_dirac_zero`) |

Sanity check (my probe): `F δ₀ (-1) = 0`, confirming the cdf encoding is non-degenerate.

Non-degenerate instance in ruling §3(b) (reasoning, re-checked by hand): with F = p + qG on [0,∞), q = 1-p, G(x/θ)G(x/(1-θ)) ≤ G(x); (p+qa)(p+qb) − p − q·ab = pq(a+b−1−ab) = −pq(1−a)(1−b) ≤ 0, and q·ab ≤ q·c. Correct; the failure is not confined to degenerate laws. Not checked in Lean (not needed for validity).

## 3. The counterexample itself is proved

| Check | Result |
|---|---|
| `scripts/pv_lean.sh check L02_Counterexample1` (run by me) | `RESULT … exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/L02_Counterexample1_2.log` |
| Independent verbatim copy + extra checks, `pv_work/probes/auditor/L02/aud_L02_cex1.lean` (sha256 bc707e93…77462d) | `RESULT aud_L02_cex1 mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/aud_L02_cex1_2.log` |
| `#print axioms` of `L02_if_counterexample`, `L02_main_as_printed_false` (copy) | [propext, Classical.choice, Quot.sound] |
| `#pv_walk_decl …L02_main_as_printed_false` | closure axioms standard; `sorryAx reached: false`; project constants only `Paper.L01.F` and the four L02Stmt defs (fingerprints equal to gate r2 snapshot: InvNWUCond th=3905129696/vh=1097506931, IsSuperHeavyTailed vh=1915010453, SubadditiveOnE vh=2787305485, negLogInv vh=1981073015) |
| `#pv_axioms L02Stmt`, `#pv_axioms L01Stmt` | ALL STANDARD |
| Earlier theorems used | none; only gate-approved statement definitions (L01Stmt, L02Stmt). No theorem needing an audit record is consumed. |

## 4. Scope

- **Refuted:** the "if" direction of Lemma 4.10 as printed (F:361-364, with "super-heavy-tailed" per Def 4.9 F:346-349), hence the printed biconditional and the gated `L02_main`. Also `prover_gap_false`: the prover's gap proposition `L02_main_Gap` is false, so `L02_main_mod_gaps` is vacuous and cannot support any verified verdict.
- **Not refuted:** the "only if" direction; the equivalence for X with $F_X(0)=0$; the equivalence "subadditivity of $-\Log F_X(1/x)$ ⇔ (eq:inv-NWU)" (which δ₀ satisfies on both sides).
- **Downstream:** confirmed by search that the only later reference is Ex 4.13 (F:392), which uses the contrapositive of the "only if" direction. Thm 4.12 (F:376-386) argues from Def 4.9 directly. No downstream use of the defective direction. Scope in the ruling is stated correctly, neither too broad nor too narrow.

## 5. Suggested fix

Adding "such that $F_X(0)=0$" at F:361 (mirroring F:442) suffices: the "if" direction then needs only inv-NWU ⇒ subadditivity, which follows by taking $x'=1/(x+y)$, $\theta=x/(x+y)$ in (eq:inv-NWU) to get $F_X(1/x)F_X(1/y)\le F_X(1/(x+y))$ (zeros handled by +∞); the "only if" direction is unaffected. I checked this by hand only; S1-S3 in L02ModGaps were not re-audited here.

Alternative fix the ruling does not mention, which also works: drop "such that $F_X(0)=0$" from Def 4.9(1). Then δ₀ is super-heavy-tailed (subadditivity holds), and the lemma as printed is true (at x = 0 the condition reads $F_X(0)^2\le F_X(0)$, which always holds).

## 6. Classification remark (second opinion, not decisive for validity)

PAPER_ASSUMPTION_GAP is acceptable, but I consider DOMAIN_CLARIFICATION a stronger alternative than the ruling says. F:354 ("the nonnegativity is not strictly necessary for the above definitions") cuts both ways. The ruling reads it as evidence against a standing convention. It can equally be read as the authors saying the qualifier $F_X(0)=0$ in Def 4.9 is dispensable, and under that reading Lemma 4.10 is true as printed (see §5). So the defect is an inconsistency between Def 4.9's preamble and Lemma 4.10, and it can be resolved either way. The human check in ruling §8 should cover this reading as well. Either way the counterexample is valid against the statement as printed, read with the definition as printed.

Reason: δ₀ satisfies (eq:inv-NWU) for all x≥0, θ∈(0,1) but has F_X(0)=1, so it is not super-heavy-tailed per Def 4.9 (F:346) and refutes exactly the printed "if" direction of Lemma 4.10. The encoding is word for word and no stronger; the build is clean and uses only standard axioms.

COUNTEREXAMPLE VALID
