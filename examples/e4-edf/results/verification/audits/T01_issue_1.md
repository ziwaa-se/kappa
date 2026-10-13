# T01 issue 1: silent reduction of continuous F to uniform samples (main.tex:60-62)

- Checker: pv-issue-checker (independent subagent, claude-opus-5-5)
- Date: Mon Oct 12 22:13:01 EDT 2026
- Raised by: pv-drafter (EXPOSITION_GAP candidate), pv-gate (preliminary FAIR_IMPLICIT_STEP), pv-prover (stopped S2, S3 on gate instruction).
- Files read: `source/main.tex` (whole file, 76 lines), `pv_work/T01Stmt.lean`, `pv_work/T01ModGaps.lean`, `pv_work/Defs.lean:18-53`, `verification/audits/T01_gate.md`, `pv_work/notes/T01_prover_notes.md`, `pv_work/notes/T01_draft_notes.md` (relevant lines).
- No Lean evidence was produced for this ruling (none required: no counterexample is possible, the conclusion is the classical Kolmogorov–Smirnov theorem). Status: **not yet confirmed**; needs pv-auditor reasoning review.

## 1. What the source says

- `source/main.tex:53-58` (Theorem thm:ks): "If $X_1, X_2, \dots$ are independent and identically distributed with a continuous distribution function $F$, then $\sqrt{n}\, D_n$ converges in distribution to $\sup_{0 \le u \le 1} |B(u)|$, where $B$ is a Brownian bridge on $[0,1]$. The limit has the distribution function $K(z) = \dots$ for $z > 0$."
- `source/main.tex:60-62` (proof): "The convergence is Donsker's invariance principle for the empirical process \cite{donsker}, applied to the supremum, which is a continuous functional. The form of $K$ is due to Kolmogorov \cite{kolmogorov}."
- `source/main.tex:29-31`: $D_n = \sup_{t\in\mathbb R}|F_n(t) - F(t)|$, $F$ the distribution function of $X_1$.
- `source/main.tex:66-69`: Donsker, "Justification and extension of Doob's heuristic approach to the Kolmogorov–Smirnov theorems", Ann. Math. Stat. 23 (1952) 277-281.
- The word "continuous" in the hypothesis (main.tex:54) is the only place where continuity of $F$ appears; the proof never says where it is used.

## 2. What is consumed

The project encodes the citation as `DonskerUniformSup` (T01Stmt.lean:60-66): uniform[0,1] iid samples only, at the level of the sup statistic. To reach the theorem for a general continuous `F`, the assembly `T01_S5` (T01ModGaps.lean:43-56) consumes:
- `T01_S2_Gap`: `F∘X_k` measurable, iid, law `volume.restrict (Icc 0 1)` (probability integral transform), for continuous `F = cdfOf P X`;
- `T01_S3_Gap`: `∀ᵐ ω, ∀ n, Dn P X n ω = Dn P (F∘X) n ω`.
Both are needed only for continuous `F`, with `P` a probability measure and the `X_k` identically distributed; all of these are printed hypotheses (main.tex:54) or the meaning of "random variables" (main.tex:29). No stronger/general form is consumed.

The source's own reading admits two routes, and both need exactly one routine step that uses continuity:
- (a) "Donsker for the empirical process" read as the uniform empirical process (which is what Donsker 1952 formulates; to the best of my knowledge, *not checked here: no network, recollection only*): reduction $F(X_i)$ iid uniform and $D_n(X) = D_n(F\circ X)$ a.s. (this is S2+S3);
- (b) read as the general-$F$ empirical process $\sqrt n(F_n - F) \Rightarrow B\circ F$: then one needs $\sup_t |B(F(t))| = \sup_{0\le u\le 1}|B(u)|$, which holds because a continuous $F$ has range $\supseteq (0,1)$ and $B$ has continuous paths with $B(0)=B(1)=0$.
Either way the missing step is the classical "distribution-freeness of $D_n$ for continuous $F$", which goes back to Kolmogorov 1933 (the other cited paper) and is stated in every textbook treatment of the Kolmogorov–Smirnov statistic.

## 3. Classification: FAIR_IMPLICIT_STEP

Reasons:
- The step is standard and textbook-level (probability integral transform + a.s. equality of the statistics); a competent reader of a proof that consists of two citations fills it in routinely.
- The printed hypothesis "continuous distribution function $F$" (main.tex:54) exists precisely for this step; the theorem's own statement signals it. Nothing has to be invented: the reader is pointed to the right tool by the hypothesis.
- The step is part of the standard content of the cited Kolmogorov–Smirnov literature (Kolmogorov 1933 already notes the distribution-freeness for continuous $F$; Donsker 1952, whose title is the justification of the Kolmogorov–Smirnov theorems, works with the uniform reduction). *This attribution is recollection, not checked here (no network).* The classification does not rest on it: even without it, the step is routine by the first two points.

Why not the neighbouring classes:
- Not `EXPOSITION_GAP`: no range or case of the statement is left uncovered. The citation plus the routine reduction covers every continuous $F$ and every $n$; there are no constants to absorb anything into. The drafter's concern ("the reduction is not mentioned") is an omission of a routine step, not an uncovered case.
- Not `PAPER_ARGUMENT_GAP`: the given justification does not fail. The cited principle, in either reading (a) or (b), together with continuity of $F$, yields the conclusion; no step of the printed argument is wrong or insufficient beyond a standard implicit step.
- Not `PAPER_ASSUMPTION_GAP`: the one hypothesis the reduction needs (continuity of $F$) is printed. Independence and identical distribution are printed. (Without continuity the statement would be false — e.g. degenerate $X_i \equiv 0$ gives $D_n \equiv 0$ — but the source does assume continuity.)
- Not `ERROR`: the statement is the classical Kolmogorov–Smirnov theorem, true for continuous $F$; no counterexample exists.
- Not `ENCODING_ERROR`: the split into a uniform-case tool plus S2/S3 is a faithful and conservative encoding (the tool is weaker than the source's use, gate item 6). It does not manufacture an issue; it merely makes the routine step visible.

## 4. Does it threaten the conclusion?

- Final conclusion of T01: **no**. Both S2 and S3 are true as stated in `T01ModGaps.lean` (gate item 5 checked them; I agree, see the fill-in below). The `conv` clause holds given `DonskerUniformSup`; the `cdf` clause does not involve this step at all.
- Downstream: no result in the paper consumes T01 (main.tex has only L01, P01, T01). Unaffected: L01, P01 (independent of T01), and the `cdf` clause of T01 (S6, uses only `KolmogorovFormula`).

Consequence for the pipeline: since the ruling is FAIR_IMPLICIT_STEP, S2 and S3 are **not** paper issues and should be proved by the prover (they are standard implicit steps adopted fairly, POLICY §1). T01 can then be at most CONDITIONAL (external parameters `DonskerUniformSup`, `KolmogorovFormula`). If the prover cannot close S2/S3 within budget, that is UNFINISHED / formalization side, never a paper issue.

## 5. How to fill in the step (for the prover)

Notation: `F := cdfOf P X` (= `t ↦ P.real {X 0 ≤ t}`), `U k := F ∘ X k`. Hypotheses available: `IsProbabilityMeasure P`, `hmeas`, `hind`, `hid`, `hF : Continuous F`. Facts about `F` to use: monotone, tends to 0 at `-∞` and 1 at `+∞`, values in `[0,1]`, and `P.real {X k ≤ t} = F t` for every `k` (from `hid`). Mathlib anchors (located by search): `ProbabilityTheory.iIndepFun.comp` (Mathlib/Probability/Independence/Basic.lean:585), `MeasureTheory.Measure.ext_of_Iic` (Mathlib/MeasureTheory/Constructions/BorelSpace/Order.lean:418), `Continuous.measurable`.

S2 (probability integral transform):
1. Measurability: `hF.measurable.comp (hmeas k)`.
2. Independence: `hind.comp (fun _ => F) (fun _ => hF.measurable)`.
3. Law: by `ext_of_Iic` it suffices that `P {F(X k) ≤ u} = volume (Icc 0 1 ∩ Iic u)` for every `u`.
   - `u < 0`: both sides 0 (`F ≥ 0`).
   - `u ≥ 1`: both sides 1 (`F ≤ 1`).
   - `0 ≤ u < 1`: the set `S_u = {x | F x ≤ u}` is a closed (continuity), downward-closed (monotone), nonempty (`F → 0`) and bounded above (`F → 1 > u`) set, so `S_u = Iic q` with `q = sSup S_u`, and `F q = u` (for `u > 0` by the intermediate value theorem and closedness; for `u = 0` either `S_0` is empty or `F q = 0`; if `S_0 = ∅` the probability is `0 = u`). Then `P {F(X k) ≤ u} = P {X k ≤ q} = F q = u = volume (Icc 0 u)`.

S3 (a.s. equality of the statistics):
1. Null set. Let `N := {y | ∃ x < y, F x = F y}`. Then `N = ⋃ q : ℚ, {y | q < y ∧ F y = F q}` (if `x < y` and `F x = F y`, pick rational `q ∈ (x,y)`; monotonicity gives `F q = F y`). Each piece is `Ioc q b_q` with `b_q = sSup {y | F y = F q}` (closed by continuity) or `Ioi q` if unbounded (then `F q = 1`); its `P∘(X k)⁻¹`-mass is `F b_q - F q = 0` (resp. `1 - F q = 0`). Also `Z := {y | F y = 0}` has mass 0 (it is `Iic a` with `F a = 0`, or empty). So `P (⋃ k, X k ⁻¹' (N ∪ Z)) = 0` (countable union).
2. Pointwise identity off the null set. For `ω` with no `X k ω ∈ N ∪ Z`: for every `t`, `X k ω ≤ t ↔ F (X k ω) ≤ F t` (`→` monotone; `←` if `X k ω > t` and `F(X k ω) ≤ F t` then `F t = F (X k ω)`, so `X k ω ∈ N`). Hence `edfRV X n ω t = edfRV U n ω (F t)`.
3. The cdf of `U` is `G u := cdfOf P U u = max 0 (min u 1)` (from S2's law). So `|edfRV X n ω t - F t| = |edfRV U n ω (F t) - G (F t)|` and `Dn P X n ω = ⨆ u ∈ range F, |edfRV U n ω u - G u|`.
4. Compare with `Dn P U n ω = ⨆ u : ℝ, |edfRV U n ω u - G u|`. `range F ⊇ Ioo 0 1` (IVT + limits). Remaining `u`: for `u < 0` the term is `0` (`U ≥ 0`, `G = 0`); for `u ≥ 1` and `n ≥ 1` it is `0` (`U ≤ 1` so the edf is `1`, and `G = 1`; `n = 0` is item 5); for `u = 0` it is `0` because no `U k ω = F (X k ω) = 0` (`X k ω ∉ Z`). All terms lie in `[0, 1]`-bounded ranges, so the real `⨆` is the true sup (use `ciSup` lemmas with `BddAbove` by `1 + 1`), and adding zero-valued terms does not change a sup of nonnegative terms.
5. `n = 0` (Lean junk, outside the source's scope): `edfRV _ 0 _ _ = 0`, so `Dn P X 0 ω = ⨆ t, F t = 1` and `Dn P U 0 ω = ⨆ u, G u = 1`; equal. (Gate item 5 already noted this.) With S3 quantified `∀ n`, the prover must handle this case; it is a sup computation, not mathematics from the source.

These steps are a standard argument, not the reviewer's own new route: they are exactly the textbook reduction the theorem's continuity hypothesis refers to.

## 6. S1 (measurability of `D_n`)

- Source: silent; it is the implicit premise that "$\sqrt n D_n$ converges in distribution" (main.tex:54-55) is meaningful.
- In the Lean assembly it is unused (`T01_mod_gaps` takes only `hGap_2`, `hGap_3`; prover notes, `T01_S1_Gap` unused). In the encoding, `ConvInDist` uses Bochner integrals; via S4 (`integral_congr_ae`) and the tool the conclusion holds without S1.
- Classification: `FAIR_IMPLICIT_STEP` (standard measure-theoretic technicality: for continuous `F` the sup over `t` reduces to a sup over `ℚ`; in the general `S1` statement as drafted, for an arbitrary measure `P`, it is a junk-value technicality of our encoding, not of the source). It is not a paper issue under any reading. Since it is not consumed by the assembly, its open status does not affect T01's verdict; it may be dropped from the obligation list or left as an unused, recorded unfinished technical lemma (formalization side, never counted as a paper issue).

## 7. Suggestion to the authors (optional, editorial only)

Add one sentence to the proof, e.g. "Since $F$ is continuous, $F(X_1), F(X_2),\dots$ are iid uniform on $[0,1]$ and $D_n$ equals almost surely the corresponding statistic of the uniform sample, so it suffices to treat the uniform case." Not required for correctness. (Wording by the reviewer, suggestion only, not used in any verification.)

## 8. Not checked

- The content of Donsker 1952 and Kolmogorov 1933 (no network): the remark that they treat/state the reduction is recollection; the ruling does not depend on it.
- No Lean proof of S2/S3 was produced here; their truth is argued above (reasoning, not checked in Lean) and agrees with the gate's item 5. The prover's proof will be the Lean check.
- Human check needed: no (only the external parameters' human check, as for any CONDITIONAL result).

## Evidence

reasoning, not checked in Lean.

ISSUE VERDICT: FAIR_IMPLICIT_STEP
THREATENS CONCLUSION: no
