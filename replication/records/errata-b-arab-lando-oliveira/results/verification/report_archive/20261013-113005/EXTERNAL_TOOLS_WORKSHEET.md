# Human-check worksheet for external inputs

None of the items below has been **proved in Lean**. Theorems that depend on an item take it as an explicit hypothesis, so if any one of them is false, the conclusions that depend on it lose their support. No item has been checked by a person so far.

## Checking principles (read first)

1. **Direction.** What must be confirmed is that "the theorem in the literature (or the repaired lemma) implies our Lean parameter". The Lean parameter may be weaker than the literature's conclusion, but not stronger.
2. **Compare item by item.** Domain, quantifier order, every hypothesis.
3. **Notation.** `F μ x` is the cdf of the law μ, `IsInvSub`/`SubCond` are defined in `pv_work/L01Stmt.lean`, `Fbar` in `pv_work/T02Stmt.lean:15` and `P04Stmt.lean:17`, `SuperPareto` in `pv_work/P04Stmt.lean`, `StarShaped`/`ginv` in `pv_work/T01Stmt.lean`.
4. Items whose predecessor has a recorded issue (Level A) may be false or only partly true; do not assume them.

## Priority overview

| Priority | # | Name | Nature | Used by |
|---|---|---|---|---|
| A | 1 | `T01_L01Consumed` | (p) L01 repaired clause | T01 |
| A | 2 | `T02_L01Consumed` | (p) L01 "only if" | T02, P03 |
| A | 3 | `P03_T02Consumed` | (p) T02 at n=2 | P03 |
| A | 4 | `P03_P02Consumed` | (p) P02 at n=2, signed X | P03 |
| A | 5 | `T03_T01Consumed` | (p) T01, **refutable** | none |
| B | 6 | `T01_X02Tool` | (i) Lemma 4.1, ineq-order2024 | T01 |
| B | 7 | `P04_X01Tool` | (i) Prop 1, superPareto2024 | P04 clause 2 |

Priority per `VERDICTS.md` §4: all (p) items have a predecessor with an issue, so they count as (iv), and were not reconnected (A). `T01_X02Tool` is B because the scope of the cited Lemma 4.1 (h increasing?) is doubtful; `P04_X01Tool` is B because it is doubtful whether Prop 1 states the F<1/concavity-domain form that was encoded. No (iii), (ii) or (v) items are registered. Gap hypotheses are not external inputs and are not listed here; they are explained under the corresponding issue in AUTHOR_REPORT §4.

---

## Level A

### #1 `T01_L01Consumed`: Lemma 2.3 repaired with F(0)=0 on the "if" half

- **Source**: `source/SuperParetoPaper-v12.tex:128-135`; consumed at :178 and :180.
- **Why it needs checking**: the printed lemma is false in the "if" direction (B01); this is the repaired version, which the source does not state, and L01's S1 and S2 were never proved in Lean.
- **Mathematical content**: InvSub ⇒ eq:sub-1x, and F(0)=0 plus eq:sub-1x ⇒ InvSub.
- **Suggested checking route** (`T01_final.md` §7): substitute s=θ/x, t=(1-θ)/x; the equivalence with subadditivity of 1-F(1/x) is a rewriting.
- **Used by**: T01 (`T01_main`).
- **Lean definition** (`pv_work/T01Stmt.lean:36`, verbatim):

```lean
def T01_L01Consumed : Prop :=
  ∀ μ : Measure ℝ, IsProbabilityMeasure μ →
    (IsInvSub μ → SubCond μ) ∧ (F μ 0 = 0 → SubCond μ → IsInvSub μ)
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

### #2 `T02_L01Consumed`: Lemma 2.3, "only if" direction

- **Source**: `source/SuperParetoPaper-v12.tex:201` (and :256); Lemma 2.3 at :128-135.
- **Why it needs checking**: predecessor L01 is ISSUE; the direction used is the one B01 records as not affected, but it was not proved in Lean. (The registry previously said "iff"; the Lean clause is one implication.)
- **Mathematical content**: InvSub ⇒ (eq:sub-1x) for the law considered.
- **Suggested checking route** (`T02_final.md` §4): true for x>0 by the substitution, for x=0 from F(0)=0. Could in principle be proved in Lean without any external input.
- **Used by**: T02 (S3, S4, `pos_step`), P03 (as antecedent of `P03_T02Consumed`).
- **Lean definition** (`pv_work/T02Stmt.lean:33`, verbatim):

```lean
def T02_L01Consumed : Prop :=
  ∀ (ν : Measure ℝ) [IsProbabilityMeasure ν], Paper.L01.IsInvSub ν → Paper.L01.SubCond ν
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

### #3 `P03_T02Consumed`: Theorem 3.1 at n=2, θ=(1/2,1/2)

- **Source**: `source/SuperParetoPaper-v12.tex:269` ("immediate" consequence); Theorem 3.1 at :186-189.
- **Why it needs checking**: T02 is ISSUE (B06, invalid step at :256), and T02's main theorem is not verified as a whole. The n=2 case S1-S4 is verified in T02 conditional on `T02_L01Consumed`; the statement shapes were not compared, so this clause may be dischargeable from it (not checked).
- **Mathematical content**: i.i.d. copies of an InvSub X satisfy X ≤st (X₁+X₂)/2.
- **Suggested checking route**: compare with `T02_S4` in `pv_work/T02ModGaps.lean`; the conclusion of Thm 3.1 is not threatened by B06 (argued, not formalised).
- **Used by**: P03 (S4).
- **Lean definition** (`pv_work/P03Stmt.lean:17`, verbatim):

```lean
def P03_T02Consumed : Prop :=
  Paper.T02.T02_L01Consumed →
  ∀ (Ω : Type) [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (Xs : Fin 2 → Ω → ℝ),
    Paper.T02.IIDCopies μ X Xs →
    Paper.L01.IsInvSub (μ.map X) →
    Paper.T02.StDom μ X (fun ω => ∑ i, (1 / 2 : ℝ) * Xs i ω)
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

### #4 `P03_P02Consumed`: Proposition 3.2 at n=2, real-valued X

- **Source**: `source/SuperParetoPaper-v12.tex:269`; Prop 3.2 at :261-264.
- **Why it needs checking**: P02 is ISSUE (B02, B03). Its n=2 argument is verified only for nonnegative X; this clause covers signed X. P03 itself proves X>0 a.s. (S3), so a weaker clause with a nonnegativity premise would suffice (a reconnection question, not decided).
- **Mathematical content**: independent copies, P(X₁=X₂)<1, X ≤st (X₁+X₂)/2 ⇒ X not integrable.
- **Suggested checking route**: restate with nonnegativity and reconnect to `P02_S6`; decide the authors' intended domain and the meaning of "infinite mean" for signed X.
- **Used by**: P03 (S6).
- **Lean definition** (`pv_work/P03Stmt.lean:32`, verbatim):

```lean
def P03_P02Consumed : Prop :=
  ∀ (Ω : Type) [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (X : Ω → ℝ) (Xs : Fin 2 → Ω → ℝ),
    Measurable X → (∀ i, Measurable (Xs i)) →
    iIndepFun Xs μ →
    (∀ i, IdentDistrib (Xs i) X μ μ) →
    μ {ω | ∀ i j, Xs i ω = Xs j ω} < 1 →
    Paper.P02.StDom μ X (fun ω => ∑ i, (1 / 2 : ℝ) * Xs i ω) →
    Paper.P02.InfiniteMean μ X
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

### #5 `T03_T01Consumed`: Theorem 2.8 for the law of Z-1 (defined in Lean, not registered)

- **Source**: `source/SuperParetoPaper-v12.tex:337`; Thm 2.8 at :169-172.
- **Why it needs checking**: it does **not** need checking for any verdict. The clause is **refutable**: `not_T03_T01Consumed` in `pv_work/T03_Counterexample2.lean` (g = max(y-1,0); `T03_issue_2.md` §3, review VALID). T03 cannot be CONDITIONAL on it; T03 stays ISSUE (B09, B10).
- **Used by**: none for any verdict.
- **Lean definition** (`pv_work/T03Stmt.lean:30`, verbatim):

```lean
def T03_T01Consumed : Prop :=
  ∀ g : ℝ → ℝ, Continuous g → Paper.T01.StarShaped g →
    Paper.L01.IsInvSub lawY → Paper.L01.IsInvSub (lawY.map g)
```

- **Check result**: ☐ confirmed false (T03 stays ISSUE)  ☐ other: ____

## Level B

### #6 `T01_X02Tool`: Lemma 4.1 of ineq-order2024

- **Source**: `source/SuperParetoPaper-v12.tex:174`: "Since h is star-shaped, its inverse, h^{-1}, is anti-star-shaped (see Lemma 4.1 in \cite{ineq-order2024})".
- **Why it needs checking**: attribution to a cited paper not available here. The Lean form is weaker than the source's use (requires h monotone on [0,∞)), which created the formalization-side ENCODING_ERROR for obligation S0 (`T01_issue_2.md`).
- **Mathematical content**: for continuous increasing star-shaped h, the generalised inverse is anti-star-shaped.
- **Suggested checking route**: find Lemma 4.1 in ineq-order2024; confirm the statement and whether it assumes h increasing. If it does, `T01_issue_2.md` expects at most an editorial citation-scope remark.
- **Used by**: T01 (S3).
- **Lean definition** (`pv_work/T01Stmt.lean:26`, verbatim):

```lean
def T01_X02Tool : Prop :=
  ∀ h : ℝ → ℝ, Continuous h → StarShaped h → MonotoneOn h (Set.Ici 0) →
    AntiStarShaped (ginv h)
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

### #7 `P04_X01Tool`: Proposition 1 of superPareto2024 (Prop 4.3)

- **Source**: `source/SuperParetoPaper-v12.tex:296-299`.
- **Why it needs checking**: the encoded form adds F<1 everywhere and a concavity domain `suppIn (F μ)` that the printed Prop 4.3 does not state. A first encoding was rejected as false (δ₀, ½δ₀+½δ₁; `P04_gate.md`); this one was approved after gate amendment (`P04_gate_r2.md` item 6) on reasoning, not Lean.
- **Mathematical content**: X super-Pareto iff Fbar>0 everywhere and 1/Fbar concave.
- **Suggested checking route**: read Prop 1 of superPareto2024; confirm the F<1 condition and the domain of concavity.
- **Used by**: P04 clause 2 only (the parenthetical at :317).
- **Lean definition** (`pv_work/P04Stmt.lean:64`, verbatim):

```lean
def P04_X01Tool : Prop :=
  ∀ μ : Measure ℝ, IsProbabilityMeasure μ →
    (SuperPareto μ ↔
      ((∀ x, F μ x < 1) ∧ ConcaveOn ℝ (suppIn (F μ)) (fun x => 1 / Fbar μ x)))
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

## Where the notation is defined

| Notation | Where defined | Meaning |
|---|---|---|
| `F`, `Fbar`, `IsInvSub`, `SubCond` | `pv_work/L01Stmt.lean` | cdf, survival function, Def 2.2 (InvSub), eq:sub-1x |
| `StarShaped`, `AntiStarShaped`, `ginv` | `pv_work/T01Stmt.lean` | star-shaped maps and generalised inverse |
| `SuperPareto`, `suppIn` | `pv_work/P04Stmt.lean` | Def 4.4 and support domain |
| `IIDCopies`, `StDom` | `pv_work/T02Stmt.lean` | i.i.d. copies, stochastic dominance |
| `InfiniteMean` | `pv_work/P02Stmt.lean` | `¬ Integrable` |
| `lawY` | `pv_work/T03Stmt.lean` | law of Z-1, Z Pareto |
