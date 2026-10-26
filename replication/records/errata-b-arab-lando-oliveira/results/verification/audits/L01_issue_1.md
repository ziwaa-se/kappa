# L01 issue 1: the "if" direction of Lemma 2.3 (lem:ITS-carac) omits F_X(0)=0

- Role: pv-issue-checker (Claude Opus 5.5), independent subagent
- Status: ruling complete; **not confirmed** until pv-auditor counterexample review passes
- Date: Mon Oct 12 22:11:41 EDT 2026
- Dispatched by the coordinator on a report from pv-gate (`verification/audits/L01_gate.md`, item 7) and the drafter.

## 1. Source quotations (read directly from `source/SuperParetoPaper-v12.tex`)

- F:111: "a function $v$ defined in $[0,+\infty)$ is said to be star-shaped if $v(0)=0$ and $\frac{v(x)}x$ is increasing." ("increasing" = non-decreasing, same line.)
- F:121: "$F_{\frac1X}^-(x)=1-F_X(\frac1x)$ is generally referred to as the \textit{inverted distribution} of $X$".
- F:122-124 (Def 2.2): "We say that a random variable $X$ such that $F_X(0)=0$ is \ITS\ (for ``inverted subadditive'') if $F_{\frac1X}^-$ is subadditive."
- F:128-134 (Lemma 2.3): "A random variable $X$ is \ITS\ if and only if
  $F_X(\tfrac{x}{\theta})+F_X(\tfrac{x}{1-\theta})\leq F_X(x)+1,\ \forall x\geq0,\, \theta\in(0,1)$."
- F:137 (proof): "The subadditivity of $1-F_X(\frac1x)$ is obviously equivalent to $1-F_X(\tfrac{x}{\theta})+1-F_X(\tfrac{x}{1-\theta})\geq 1-F_X(x)$, for every $x\geq0$ and $\theta\in(0,1)$, which is clearly a rewriting of (\ref{eq:sub-1x})." The proof never mentions $F_X(0)=0$.
- F:171 (Thm 2.6): "Let $X$ be \ITS\ and $h$ a continuous star-shaped function. Then $h(X)$ is \ITS." Its proof (F:174-180) derives (eq:sub-1x) for $F_{h(X)}$ and concludes "taking into account Lemma~\ref{lem:ITS-carac}" (F:180), i.e. the "if" direction applied to $h(X)$, with no check of $F_{h(X)}(0)=0$.
- F:188-201 (Thm 3.1): "If $X$ is \ITS, then ..." and later "using (\ref{eq:sub-1x}) for the last inequality" (F:201): the "only if" direction.
- F:442 (Prop cor:fsub): "A random variable $X$ such that $F_X(0)=0$ is \ITS\ if and only if $F_X\leq_{i-sb}\mathcal{P}$." Here the qualifier is printed.
- F:354: "Note that the nonnegativity is not strictly necessary for the above definitions." (So the paper has no global convention that random variables are nonnegative. A search for "nonnegative" and "F_X(0)=0" finds no blanket convention. The qualifier appears only locally, at F:124, F:346 and F:442.)

## 2. What is consumed

- **The lemma as printed** (F:130) quantifies over every random variable $X$. Its "if" direction reads: (eq:sub-1x) ⇒ X is ITS. By Def 2.2, ITS means **both** $F_X(0)=0$ **and** subadditivity of $1-F_X(1/x)$.
- **What the proof (F:137) establishes**: only "subadditivity of $1-F_X(1/x)$ ⇔ (eq:sub-1x)". It says nothing about $F_X(0)=0$, and $F_X(0)=0$ cannot be derived from (eq:sub-1x). That condition only involves $x\ge0$, and at $x=0$ it reads $2F_X(0)\le F_X(0)+1$, which always holds.
- **Instance actually consumed downstream**: Thm 2.6 (F:180) applies the "if" direction to the law of $h(X)$, after deriving (eq:sub-1x) for $F_{h(X)}$. It never establishes $F_{h(X)}(0)=0$. So the consumer needs the printed clause as stated, including for laws whose $F(0)$ has not been checked. The general form and the consumed instance coincide here: LESSONS 2 ("the general form is false but the instance used is true") does **not** rescue the step (see §5).
- Thm 3.1 (F:188, F:201) consumes only the "only if" direction (ITS ⇒ (eq:sub-1x)), which is unaffected.

## 3. Evidence (Lean)

File `pv_work/L01_Counterexample1.lean` (namespace `Paper.L01`, `import L01Stmt`; L01Stmt sha256 3e9b3f0c…d03ad57e, the same as the gate-reviewed hash).

- `PrintedIfClause : Prop := ∀ μ [IsProbabilityMeasure μ], SubCond μ → IsInvSub μ`. This is the printed "if" direction, word for word, over the gate-approved `SubCond` (eq:sub-1x, F:133) and `IsInvSub` (Def 2.2, F:124). It drops no premise and adds no conclusion.
- Instance: μ = `Measure.dirac 0` (X = 0 a.s.), a probability measure on ℝ.
  - `subCond_dirac_zero`: (eq:sub-1x) holds (F = 1 on [0,∞), so it reads 2 ≤ 2). The instance satisfies every printed hypothesis.
  - `subadditive_dirac_zero`: the subadditivity conjunct of Def 2.2 **holds** too (1 − F(1/x) ≡ 0 on (0,∞)), so the failure lies exactly in the omitted F_X(0)=0.
  - `not_isInvSub_dirac_zero`: F(0) = 1 ≠ 0.
- `L01_if_counterexample : ¬ PrintedIfClause`.
- Scope lemmas: `printedIf_of_printedIff` (the printed biconditional implies `PrintedIfClause`) and `L01_main_as_printed_false : ¬ (∀ μ [IsProbabilityMeasure μ], IsInvSub μ ↔ SubCond μ)`. `consumed_of_printed` shows that the use at F:180 (for an arbitrary law ν of h(X)) is an instance of the printed clause.
- Compilation: `scripts/pv_lean.sh build L01_Counterexample1` gave `RESULT L01_Counterexample1 mode=build exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/L01_Counterexample1_1.log olean=pv_work/L01_Counterexample1.olean`.
- Axiom check: probe `pv_work/probes/issue/L01/L01_issue1_axioms.lean` (`#pv_axioms L01_Counterexample1` plus `#print axioms`), run with `scripts/pv_lean.sh probe …`, gave exit=0. The log `pv_work/logs/L01_issue1_axioms_1.log` reads "#pv_axioms L01_Counterexample1: ALL STANDARD (10 declarations checked)". Every declaration uses only [propext, Classical.choice, Quot.sound].
- Hashes (sha256): `L01_Counterexample1.lean` 03793f90e160c148c8c126f7780957cff7cd9d984829970bd2ccb17ba0e1074f; `L01_Counterexample1.olean` fe5b5d0179393753fee497ffb0ed2e0def86474376c150a40ee7873f3a7f5128; probe a3166e80433e620f1d629f3c5d98bfbfa9143df12162a68968e95cd4f6d48496; source 88ba28dedca45ca91f426ef9180ace03331f773afa7a3643099ea0eadb103294.
- Non-degenerate instance (reasoning, not checked in Lean): the law p·δ₀ + (1−p)·Fréchet(1) with p ∈ (0,1) also satisfies (eq:sub-1x). The left side minus the right side equals (1−p)[H(x/θ)+H(x/(1−θ))−H(x)−1] ≤ 0 by Example 2.4 (F:143). It has F(0) = p > 0, so the failure is not restricted to degenerate laws.

## 4. Classification

**PAPER_ASSUMPTION_GAP.** The missing hypothesis is "such that $F_X(0)=0$" in Lemma 2.3 (F:130).

- Why not FAIR_IMPLICIT_STEP or ENCODING_ERROR: $F_X(0)=0$ cannot be derived from (eq:sub-1x), as the Lean counterexample shows. The encoding of Def 2.2 includes its printed presupposition F:124 literally. The domain of `invDist` does not matter: the gate showed (item 4) that X = 0 a.s. defeats the clause under the (0,∞), [0,∞) and ℝ readings. So our representation choices do not manufacture the problem.
- Why not DOMAIN_CLARIFICATION: one could read Def 2.2's "X such that F_X(0)=0" as a standing restriction on the universe of discourse. Under that reading the lemma is true (S1∘S2, which the gate hand-checked). But (i) the paper itself prints the qualifier explicitly when it intends it, in the parallel characterisation at F:442 (and at F:346); (ii) F:354 disclaims a nonnegativity convention; (iii) decisively, the paper **consumes** the broad reading: Thm 2.6 (F:180) applies the "if" direction to h(X) without establishing $F_{h(X)}(0)=0$. So the reading under which the lemma holds is not the one the paper relies on.
- Why not EXPOSITION_GAP: the conclusion is false on the uncovered case (not merely unargued), and no constant can absorb it.
- Why not ERROR (borderline, stated openly): the counterexample does satisfy every printed hypothesis, which meets the ERROR evidence standard for the clause as printed. But the defect consists entirely of one omitted qualifier that the paper's own definition (F:124) states. The equivalence the proof actually argues (subadditivity ⇔ (eq:sub-1x)) is correct. VERDICTS §2.1 puts "a hypothesis the source does not print and that cannot be fairly derived, with an example showing the step is false without it" under PAPER_ASSUMPTION_GAP, which matches exactly.
- Not PAPER_ARGUMENT_GAP: the argument at F:137 is fine for what it argues. The problem is the statement's hypothesis set.

## 5. Does it threaten the conclusion?

- **L01 as printed**: yes. The "if" direction, and hence the printed biconditional, is false (Lean: `L01_main_as_printed_false`). With the qualifier added, the lemma is expected to hold by the source's own argument (S1∘S2; gate item 5, hand-checked, not yet proved in Lean). The "only if" direction and the equivalence "subadditivity ⇔ (eq:sub-1x)" are unaffected.
- **Downstream**:
  - **Affected: Thm 2.6 (thm:inclusion, F:171-180).** Its last step consumes the "if" direction for h(X). Lead for that result's gate or issue-checker (reasoning, not checked in Lean, not ruled here): h(x) = max(x−1, 0) is continuous and star-shaped in the sense of F:111 (h(0)=0, h(x)/x = max(1−1/x, 0) non-decreasing). For X Fréchet(1) (ITS by Ex 2.4), $F_{h(X)}(0) = P(X\le1) = e^{-1} > 0$, so h(X) is not ITS per Def 2.2. Similarly h(x) = −x satisfies the F:111 definition (h(x)/x ≡ −1 is non-decreasing). Adding the qualifier to L01 therefore does **not** by itself repair Thm 2.6. Thm 2.6 must separately ensure $F_{h(X)}(0)=0$ (e.g. h > 0 on (0,∞)).
  - **Possibly affected via Thm 2.6**: the result at F:334 (nonnegative super-Pareto ⇒ ITS, proof F:337 uses Thm 2.6 with h increasing convex, h(0)=0). Whether h may vanish on an interval there depends on the super-Pareto definition. Lead only.
  - **Unaffected**: Thm 3.1 (thm:main, F:188-201), which uses only the "only if" direction; Prop 2.5 (prop:ITS-dens, F:148-154), examples rem:frechet, ex:oddsFbar, ex:discITS (F:140-166), which establish subadditivity directly for laws with F(0)=0 (or only use "only if"/(eq:sub-1x) from ITS); Prop cor:fsub (F:442), which prints the qualifier. Each of these should still be checked against its own proof by its own pipeline. This list only records that they do not consume the L01 "if" direction for a law with unchecked F(0).

## 6. Suggestion to the authors (minimal)

Replace "A random variable $X$ is \ITS\ if and only if" at F:130 with "A random variable $X$ such that $F_X(0)=0$ is \ITS\ if and only if", mirroring F:442. Sufficiency check: under F_X(0)=0, Def 2.2 reduces to subadditivity, and the source proof F:137 gives subadditivity ⇔ (eq:sub-1x) (gate item 5: S1, S2 true for any cdf). So the fix suffices for L01 itself. It does not suffice for Thm 2.6 (see §5). Any condition on h there is constructed by the reviewer, is not in the source, is a suggestion only, and is not used in any verification.

## 7. Not checked

- S1 and S2 (the corrected lemma) are not proved in Lean here; that is the prover's job.
- The Thm 2.6 and F:334 leads are reasoning only, not checked in Lean, and not ruled here.
- The non-degenerate mixture instance (§3) is reasoning, not checked in Lean.

## 8. Needs human check

Yes, briefly: confirm that the authors did not intend a global standing convention $F_X(0)=0$. The evidence against such a convention is F:354, F:442 and the use at F:180.

ISSUE VERDICT: PAPER_ASSUMPTION_GAP
THREATENS CONCLUSION: yes
