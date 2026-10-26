# P04 issue 1: passage from P^{-1}∘F_X to F_X^{-1}∘P in clause 1 of Proposition 4.6 (prop:conv)

- Role: pv-issue-checker (fresh subagent, claude-opus-5-5). Started: Tue Oct 13 01:49:16 EDT 2026
- Reported by: pv-prover (`pv_work/notes/P04_prover_notes.md`:8), pv-gate (`verification/audits/P04_gate_r2.md` item 7, first bullet).
- Obligation: `P04_S4_Gap` in `pv_work/P04ModGaps.lean`:74-76.

## 1. What the source says (read directly)

- source/SuperParetoPaper-v12.tex:317 (statement): "$F_X$ is \DOR\ (or, equivalently, $X$ is super-Pareto) if and only if $\mathcal{P}\leqc F_X$. Analogously $F_X$ has increasing odds rate if and only if $F_X\leqc\mathcal{P}$."
- :320 (whole proof): "Noting that the quantile of the Pareto is $\mathcal{P}^{-1}(u)=\frac1{1-u}$, we have $\mathcal{P}^{-1}\circ F_X=\frac1{\Fbar_X}=\Lambda_X+1$, so the result follows immediately."
- :310 (Def. 4.5): "$F_1\leqc F_2$, if $F_2^{-1}\circ F_1$ is convex."
- :306 (Def. 4.4): DOR iff $\Lambda_X$ concave. :301: $\Lambda_X = 1/\Fbar_X - 1$.
- :111 (generalised inverse, as quoted in the gate and encoded in `P04Stmt.lean`:37): $v^{-1}(u)=\sup\{x: v(x)\le u\}$.

So clause 1 needs: Λ_X concave ⟺ F_X^{-1}∘𝒫 convex. The proof computes only 𝒫^{-1}∘F_X = Λ_X + 1, which is directly the transform of clause 3 (F_X ≤c 𝒫). For clause 1 the reader must use the duality "an increasing function is concave iff its inverse is convex", i.e. 𝒫 ≤c F_X ⟺ 𝒫^{-1}∘F_X concave. The source does not state this step.

## 2. Consumed instance

`P04_S4_Gap`: μ a probability measure on ℝ, μ ≠ δ_c for all c (approved TFA `hnd`), `DOR μ` = (F<1 everywhere) ∧ Λ concave on S = {0<F<1}; `ConvexTransformLE paretoCdf (F μ)` = x ↦ quantile(F)(1 - 1/x) convex on suppIn paretoCdf = (1,∞).
The Dirac case (where 𝒫 ≤c δ_c holds but δ_c is not DOR) is a separate suspected issue (gate item 7, second bullet) and is not ruled here.

What the step needs: with Φ := 1/Fbar_X = Λ_X + 1 = 𝒫^{-1}∘F_X on S (already proved as `P04_S2`), and T(x) := F_X^{-1}(1 - 1/x) = F_X^{-1}∘𝒫(x) on (1,∞), show Φ concave on S (and F_X < 1) ⟺ T convex on (1,∞). Since T is, up to the generalised-inverse conventions of :111, the inverse of the increasing map Φ, this is the duality "an increasing function is concave iff its inverse is convex". The source states the transform only in the direction 𝒫^{-1}∘F_X and lets the reader apply this duality.

## 3. Classification: FAIR_IMPLICIT_STEP

Reasons:
1. The missing step is one standard fact: for strictly increasing functions, concave ⟺ inverse convex. In the convex transform order literature it is the usual equivalence "G^{-1}∘F convex ⟺ F^{-1}∘G concave". (I recall this from memory as standard textbook material, e.g. Shaked & Shanthikumar, *Stochastic Orders*, §4.B. I did not check the exact location; no network.) Mathlib also has the global version, `OrderIso.convexOn_symm` (Mathlib/Analysis/Convex/Function.lean:1024). A competent reader of this paper fills it in routinely, which is what "follows immediately" at :320 asks for.
2. The generalised inverse of :111 and possible atoms of F_X add only routine bookkeeping. This uses the three elementary quantile facts Q1–Q3 below and the right-continuity of the cdf. Under DOR, F_X can have an atom only at the left endpoint of its support, and F_X has no flat pieces inside the support. Both are handled without any new idea (§5).
3. The clause the step supports is true on the consumed instance. This is proved in Lean (§5): `P04_S4_Gap` holds, axioms standard. So nothing is false, and the only question is whether the omitted justification is routine.

Why not the neighbouring classes:
- Not `PAPER_ARGUMENT_GAP`: the justification given (the explicit transform plus "follows immediately") is not wrong or inapplicable. It is incomplete only by one standard duality that this subfield uses all the time. The definition (:310) is stated with F_2^{-1}∘F_1, and the paper's audience routinely reads ≤c in either of its two equivalent forms. No step of the source fails.
- Not `EXPOSITION_GAP`: for non-degenerate X, no range or case is left uncovered by this step. The one uncovered case, a degenerate X = c, comes from the statement and not from this duality step. It is ruled separately (gate item 7, second bullet).
- Not `ERROR`: the clause holds for every non-Dirac μ (Lean, §5).
- Not `ENCODING_ERROR`: the encoding (`quantile` = :111, `ConvexTransformLE` = :310, `DOR` = :306 with F<1) is the gate-approved one, and the obligation is true in it.

## 4. Does it threaten the conclusion?

- Final conclusion of P04: **no**. Clause 1 (DOR ⟺ 𝒫 ≤c F_X) holds for every non-degenerate probability law (Lean, §5). Clause 2 (parenthetical, via `P04_S5` and external input X01) follows from clause 1. Clause 3 (IOR ⟺ F_X ≤c 𝒫) never used this step: it is `P04_S3`, which already compiles from the source computation alone.
- Downstream results: none affected. With the step filled, every downstream use of prop:conv (for example :323, "Λ_H convex, hence H ≤c 𝒫", which uses clause 3, and the transitivity remark H ≤c 𝒫 ≤c F_X, which uses clauses 1 and 3) holds as stated for non-degenerate laws. Unaffected: P04 clause 3 (`P04_S3`), `P04_S1`, `P04_S2`, `P04_S5`, and all other results.
- The Dirac exception (the approved TFA `hnd`) is the subject of a separate issue and is not changed by this ruling.

## 5. Evidence (Lean)

Probe 1, the abstract core: `pv_work/probes/issue/P04/P04_issue1_core.lean` (sha256 adcdcb017c4db0ffd49849e4e895e785e549a0b35ca7e7ea9451b7fc77f4bf6c).
- `convexOn_inv_of_concaveOn`: if g is StrictMonoOn and ConcaveOn on a convex I, g '' I is convex, and h∘g = id on I, then h is ConvexOn g '' I. The converse `concaveOn_inv_of_convexOn` is also proved.
- `scripts/pv_lean.sh probe` → `RESULT ... exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log `pv_work/logs/P04_issue1_core_1.log`.
- `#pv_walk_decl` on both: AXIOMS [propext, Classical.choice, Quot.sound]; sorryAx reached: false.

Probe 2, the full obligation: `pv_work/probes/issue/P04/P04_issue1_S4fill.lean` (sha256 08d5dbac44029a1cca9198d79b0487810c59d21ff38eba8d1bfed87179f8d4fb).
- It imports `P04ModGaps` (sha256 b062be4f…497b) and `P04Stmt` (sha256 84cc56ad…adb7, the same as gate r2) and proves `theorem S4_holds : P04_S4_Gap`.
- `scripts/pv_lean.sh probe` → `RESULT P04_issue1_S4fill mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log `pv_work/logs/P04_issue1_S4fill_5.log`.
- `#pv_walk_decl Paper.P04.Issue1.S4_holds`: AXIOMS in closure [propext, Classical.choice, Quot.sound]; sorryAx reached: false. It reaches `Paper.P04.P04_S4_Gap` with vh=4099464923, which is the same as the hash in the prover notes.
- `hnd` is used only in backward step B below, which confirms that the Dirac exclusion is the only extra premise needed.

Status: this proof was constructed by the reviewer and is not in the source. It is evidence for the ruling only and is not used in any verification. It has not yet been independently reviewed.

### Exact fill-in (for the prover; the route is the source's identity `P04_S2` + the inverse duality)

Notation: F = F_X, Q(u) = sup{t : F t ≤ u} (:111), S = {0<F<1}, Φ = 1/(1-F) = Λ+1 on S (`P04_S2`), T(x) = Q(1-1/x) for x>1 (`supp_pareto`: suppIn 𝒫 = (1,∞), `pareto_val`).

Quantile facts for u ∈ (0,1). The set is nonempty and bounded above because F→0 at -∞ and F→1 at +∞.
- Q1: F t ≤ u ⇒ t ≤ Q u (`le_Q`).
- Q2: u ≤ F(Q u), by right-continuity (`le_F_Q`).
- Q3: t < Q u ⇒ F t ≤ u (`F_le_of_lt_Q`).
- Criterion: (∀ s>z, F s>u) ⇒ Q u ≤ z (`Q_le`).
- Monotonicity (`Q_mono`).
- Algebra: for f<1 and X>0, 1-1/X ≤ f ⟺ X ≤ 1/(1-f), and the same with < (`key_le`, `key_lt`).

(⇒) Assume DOR, so F<1 and Φ is concave on S (from Λ concave, +1).
- (a) S is upward closed, because F<1 and F is monotone.
- (b) Φ is strictly increasing to the right of any z ∈ S. If Φ(s) ≤ Φ(z) for some s>z, concavity on z<s<w gives Φ(w) ≤ Φ(z) for all w>s, which contradicts Φ→∞ (F→1).
- (c) For x_1,x_2>1, let t_i = T(x_i). By Q2, F(t_i) ≥ 1-1/x_i > 0, so t_i ∈ S and Φ(t_i) ≥ x_i.
- (d) Let z = a t_1 + b t_2 ∈ S. Concavity gives Φ(z) ≥ a x_1 + b x_2 =: X. By (b), Φ(s) > X for s>z, i.e. F(s) > 1-1/X. The criterion then gives T(X) ≤ z.

(⇐) Assume T convex on (1,∞) and μ not a Dirac mass.
- A. T is monotone (Q_mono). T is continuous because it is convex on an open set (`ConvexOn.continuousOn`).
- B. F<1. If F(b)=1, then T ≤ b. A convex function bounded above on (1,∞) is nonincreasing, so T is constant = c and Q ≡ c on (0,1). Q3 gives F=0 on (-∞,c) and Q2 gives F(c)=1, so μ = δ_c (`Measure.ext_of_Iic`). This contradicts `hnd`.
- C. Q(F p) = p for p ∈ S. "≥" holds by Q1. If Q(F p) > p, then for u < F p the criterion gives Q u ≤ p, i.e. T ≤ p on (1, 1/(1-F p)), while T(1/(1-F p)) = Q(F p) > p. This contradicts left-continuity of T.
- D. For p,q ∈ S, let X = aΦ(p)+bΦ(q) > 1 and w = ap+bq ∈ S (S is an interval). If F(w) < 1-1/X, then w < Q(1-1/X) = T(X) (by Q2 and monotonicity). But T(X) ≤ aT(Φ p)+bT(Φ q) = aQ(F p)+bQ(F q) = ap+bq = w (by C), which is a contradiction. Hence Φ(w) ≥ X, so Φ is concave on S, and so is Λ = Φ-1.

## 6. Suggestion to the authors

None is required. Optional editorial change: at :320, add after "$\Lambda_X+1$": "and, as $\mathcal P^{-1}\circ F_X$ is increasing, it is concave (convex) if and only if its inverse $F_X^{-1}\circ\mathcal P$ is convex (concave)".

## 7. Not checked

- The literature location of the duality (no network). The ruling does not depend on it, because Lean proves the instance.
- The Dirac case (separate issue) and the domain/convention questions at :306/:310 (gate item 7, third bullet). These are not ruled here.
- Independent review of this ruling and of the probes by pv-auditor: pending. Not confirmed until that review passes.

ISSUE VERDICT: FAIR_IMPLICIT_STEP
THREATENS CONCLUSION: no
