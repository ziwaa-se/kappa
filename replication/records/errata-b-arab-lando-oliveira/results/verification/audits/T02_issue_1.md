# T02 issue 1 (revision 1): zero weights / reduction to strictly positive weights

Role: pv-issue-checker. Reported by pv-gate (`verification/audits/T02_gate.md`, item C, line 92) and
pv-prover (`pv_work/notes/T02_prover_notes.md`, "Stopped item"). Current open goal:
`Paper.T02.T02_ZeroWeights_Gap` in `pv_work/T02ModGaps.lean:452-457`.
(The earlier ruling of a different issue is archived at `verification/audits/rev1/T02_issue_1.md`; this file is the
revision-1 issue 1.)

## 1. Source text (read directly)

- `source/SuperParetoPaper-v12.tex:95`: "given $n$ i.i.d. copies of $X$, say $X_1,\ldots,X_n$, and weights
  $\theta_1,\ldots,\theta_n\geq0$ such that $\theta_1+\cdots+\theta_n=1$, we have (eq:main-st)
  $X\leqst \theta_1 X_1+\cdots+\theta_n X_n$" (:96-98).
- `:102`: "In particular, if $\Mexp X<\infty$, (eq:main-st) holds trivially, with equality in distribution,
  if and only if exactly one coefficient is strictly positive." (The authors themselves treat the
  single-positive-coefficient case as trivial, with equality in distribution; the "if" direction of that
  remark does not use finiteness of the mean.)
- `:186-188` (Theorem 3.1, thm:main): "If $X$ is \ITS, then the stochastic dominance (eq:main-st) holds."
- `:191`: "We proceed by induction on the number of random variables. ... for every $x\geq 0$ and
  $\theta\in(0,1)$, ..."; `:217`: "... so (eq:main-st) holds for $n=2$."
- `:219`: "Assume now that (eq:main-st) holds whenever considering $n-1$ random variables and $n-1$
  nonnegative weights that sum up to $1$. Given $\theta_1,\ldots,\theta_n>0$ satisfying
  $\theta_1+\cdots+\theta_n=1$, ..."
- Definitions used: `:117` (Def 2.1, $X\leqst Y$ iff $\Fbar_X(x)\le\Fbar_Y(x)$ for all $x$; depends only on
  distributions, :119), `:124` (Def 2.2, ITS requires $F_X(0)=0$).

Not written in the proof: (i) $n=1$; (ii) $n=2$ with $\theta\in\{0,1\}$; (iii) $n\ge3$ with some
$\theta_i=0$. The induction hypothesis at :219 is phrased for nonnegative weights, but the step is carried
out only for strictly positive weights; the step itself consumes the hypothesis only at the normalised
weights $\theta_i/(1-\theta_n)$ (:223), which are strictly positive.

## 2. Consumed instance

The theorem as stated at :186-188 with the weights of :95: every $n\ge1$, every $\theta\in[0,\infty)^n$ with
$\sum\theta_i=1$, i.i.d. copies of an ITS $X$. Formal statement: `Paper.T02.T02_main` (type hash
th=703880595 per prover notes). The proof route covers exactly the sub-case "all $\theta_i>0$"
(`Paper.T02.T02_PosVersion`, proved from the source route in `pos_all`, `pv_work/T02ModGaps.lean:479-522`,
modulo the external parameter `T02_L01Consumed`).

## 3. What the missing reduction needs

Given $\theta\ge0$ with $\sum\theta_i=1$, let $S=\{i:\theta_i\neq0\}$ (nonempty, because the sum is 1). Then
pointwise $\sum_{i\le n}\theta_iX_i=\sum_{i\in S}\theta_iX_i$; the family $(X_i)_{i\in S}$ is again $|S|$
i.i.d. copies of $X$ (sub-family of an independent family, same marginals); $(\theta_i)_{i\in S}$ is strictly
positive and sums to 1. Applying the strictly-positive case with $|S|$ variables gives the claim. If $|S|=1$
this is the identity-in-law case the authors call trivial at :102. Nothing about $F_X$, ITS, or the
inequality (eq:sub-1x) is used; no constants, no ranges of $x$ are involved.

## 4. Classification: FAIR_IMPLICIT_STEP

Reasons:
- The reduction is pure bookkeeping (deleting zero terms, reindexing a sub-family of i.i.d. copies), with no
  analytic content; a competent reader fills it in routinely and the source itself signals it: the degenerate
  one-positive-weight case is explicitly called trivial at :102, and the induction hypothesis at :219 is
  stated for nonnegative weights, i.e. the authors intend the statement with zeros allowed and regard
  zero-weight terms as absent.
- Why not `EXPOSITION_GAP`: there is no uncovered range that the argument would have to absorb; the
  uncovered cases are literally instances of the covered case with fewer variables, obtained by a
  reindexing that preserves every hypothesis. Nothing in the proof's estimates (Figure 1, :198, :230) would
  need to be extended to $\theta\in\{0,1\}$ (where e.g. $x/\theta$ is undefined), because those cases never
  reach the estimates after the reduction.
- Why not `PAPER_ARGUMENT_GAP`: no written justification fails; every written step (S1-S8) passes as written
  (prover notes, gate table).
- Why not `PAPER_ASSUMPTION_GAP` / `ERROR`: no hypothesis is missing and the printed claim is true (Lean
  evidence below, modulo the separate external parameter `T02_L01Consumed`).
- Why not `ENCODING_ERROR`: the statement `T02_main` encodes :95/:186 faithfully (gate-approved).

Stricter fallback, for the auditor's consideration only: if the auditor judges that an unwritten case split
is never "implicit", the class would be a minor `EXPOSITION_GAP`; this does not change section 5.

## 5. Does it threaten the conclusion?

- Final conclusion of T02 (Theorem 3.1 with $\theta_i\ge0$): **no**. It follows from the positive-weight
  route plus the reduction (Lean, below).
- Downstream: no result is affected. Every downstream consumer of T02 receives the statement as printed.

## 6. Evidence (Lean, positive)

File: `pv_work/probes/issue/T02/T02_issue1_ZeroWeights.lean` (imports `T02ModGaps`, `PVTools`).
- `Paper.T02.IssueProbe1.zeroWeights_fill : Paper.T02.T02_ZeroWeights_Gap` - proves the open gap
  unconditionally (it only assumes `T02_PosVersion`, as the gap definition prescribes).
- `Paper.T02.IssueProbe1.main_with_fill (hL01 : T02_L01Consumed) ... : StDom μ X (∑ θᵢ Xsᵢ)` with `0 ≤ θ i`,
  `∑ θ i = 1`: the main theorem as printed. Its type hash th=703880595 coincides with the hash recorded for
  `T02_main` in the prover notes (same statement).

Compilation: `scripts/pv_lean.sh probe pv_work/probes/issue/T02/T02_issue1_ZeroWeights.lean`:
`RESULT ... exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log
`pv_work/logs/T02_issue1_ZeroWeights_2.log`. (Run 1, `_1.log`, failed only because `#pv_axioms` was given a
declaration instead of a module; no proof change.)
Axiom check (`#pv_walk_decl` and `#print axioms`, both declarations): `[propext, Classical.choice, Quot.sound]`,
`sorryAx reached: false`. `#pv_hyp_usage main_with_fill`: all 13 leading binders USED; the only non-source
parameter reached is `T02_L01Consumed` (the already registered external parameter).

## 7. Exact fill-in for the prover (FAIR_IMPLICIT_STEP)

Prove `T02_ZeroWeights_Gap` exactly as in the probe:
1. `s := Finset.univ.filter (fun i => θ i ≠ 0)`, `e := s.equivFin.symm : Fin s.card ≃ s`,
   `ι j := (e j).1`, injective.
2. `IIDCopies μ X (Xs ∘ ι)` from `⟨hiid.meas, _, hiid.indep.precomp hι, _⟩`.
3. `0 < θ (ι j)` from `0 ≤ θ` and membership in `s`.
4. Reindexing lemma: for `f` vanishing where `θ = 0`, `∑ j, f (ι j) = ∑ i, f i`
   (`Equiv.sum_comp e`, `Finset.sum_coe_sort`, `Finset.sum_filter_of_ne`). Apply to `θ` (sum = 1) and to
   `fun i => θ i * Xs i ω` (pointwise equality of the combinations).
5. Apply `T02_PosVersion` to `Xs ∘ ι`, `θ ∘ ι` and rewrite.
Then `T02_main := T02_main_mod_gaps zeroWeights_fill hL01 ...`. Source anchors: :95 (weights ≥ 0),
:102 (degenerate case trivial), :219 (IH for nonnegative weights).

## 8. Suggestion to the authors (optional, editorial)

Add one sentence at :191: "Terms with $\theta_i=0$ can be discarded, so we may assume all weights are
strictly positive; the case of a single positive weight is trivial (equality in distribution)."

## 9. Not checked here

The external parameter `T02_L01Consumed` (L01 "only if" direction) is outside this ruling. The `x<0` case
(gate item D) is not part of this issue. Conclusion not yet confirmed: awaits independent pv-auditor review.

ISSUE VERDICT: FAIR_IMPLICIT_STEP
THREATENS CONCLUSION: no
