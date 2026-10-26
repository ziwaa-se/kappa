# Human-check worksheet for external inputs (state after revision 1)

None of the items below has been **proved in Lean**. Theorems that depend on an item take it as an explicit hypothesis, so if any one of them is false, the conclusions that depend on it lose their support. No item has been checked by a person so far. Line numbers `:N` are those of the current `source/SuperParetoPaper-v12.tex`; audit records keep baseline numbers (baseline lines from 258 on map to `old - 23`).

## Checking principles (read first)

1. **Direction.** What must be confirmed is that "the theorem in the literature (or the repaired lemma) implies our Lean parameter". The Lean parameter may be weaker than the literature's conclusion, but not stronger.
2. **Compare item by item.** Domain, quantifier order, every hypothesis.
3. **Notation.** `F μ x` is the cdf of the law μ, `IsInvSub`/`SubCond` are defined in `pv_work/L01Stmt.lean`, `Fbar` in `pv_work/T02Stmt.lean:15` and `P04Stmt.lean:17`, `SuperPareto` in `pv_work/P04Stmt.lean`, `StarShaped`/`ginv` in `pv_work/T01Stmt.lean`.
4. Items whose predecessor has a recorded issue (Level A) may be false or only partly true; do not assume them.

## Priority overview

| Priority | # | Name | Nature | Used by |
|---|---|---|---|---|
| A | 1 | `T02_L01Consumed` | (p) L01 "only if" direction only | T02 (sole condition), P03 |
| A | 2 | `T01_L01Consumed` | (p) L01 repaired clause | T01 |
| A | 3 | `P03_P02Consumed` | (p) P02 at n=2, signed X | P03 |
| A | 4 | `T03_T01Consumed` | (p) T01, **refutable, unregistered** | none |
| B | 5 | `T01_X02Tool` | (i) Lemma 4.1, ineq-order2024 | T01 |
| B | 6 | `P04_X01Tool` | (i) Prop 1, superPareto2024 | P04 clause 2 |

Priority per `VERDICTS.md` §4: all (p) items here have a predecessor with an issue and are not reconnected, so they count as (iv) (A). `T02_L01Consumed` is A by that rule although the clause is the direction that B01 records as unaffected. `T01_X02Tool` is B because the scope of the cited Lemma 4.1 (h increasing?) is doubtful; `P04_X01Tool` is B because it is doubtful whether Prop 1 states the F<1/concavity-domain form that was encoded. No (iii), (ii) or (v) items exist. Gap hypotheses are not external inputs and are not listed here; they are explained under the corresponding issue in AUTHOR_REPORT §4.

**Discharged by revision 1 (no check needed):** `P03_T02Consumed` (`pv_work/P03Stmt.lean:17`) is proved from `T02_main` in `pv_work/P03Closed_r1.lean` (`P03_T02Consumed_holds`; `P03_reconnect_r1.md`: RECONNECT AUDIT PASS) and is no longer a parameter of P03. One note from that audit: in `main_closed` the outer `hL01` is redundant (the antecedent inside the clause is reported UNUSED); no effect on the conditions.

---

## Level A

### #1 `T02_L01Consumed`: Lemma 2.3, "only if" direction

- **Source**: `source/SuperParetoPaper-v12.tex:128-135` (Lemma 2.3); consumed at :201 ("using (eq:sub-1x) for the last inequality") and, after revision 1, at :231-233 ("taking into account (eq:sub-1x)").
- **Why it needs checking**: predecessor L01 is ISSUE (B01); the direction used is the one B01 records as not affected, but it was never proved in Lean (L01 stopped at ISSUE). It is the sole condition of T02 and one of the two conditions of P03; a Lean proof of L01's only-if half would remove it from both.
- **Mathematical content**: InvSub ⇒ (eq:sub-1x) for the law considered (one implication; no "if" half).
- **Suggested checking route** (`T02_final.md` §4): true for x>0 by subadditivity at θ/x, (1-θ)/x; at x=0 the condition reads F(0) ≤ 1. Check against Def 2.2 (`tex:122-125`); the gate gave a sketch only.
- **Used by**: T02 (`T02_main` → `pos_all` → `T02_S4` / `pos_step` → `T02_S8` → `T02_S3`; `hL01` applied at `pv_work/T02.lean:221`), P03 (through `main_closed` and as the antecedent of the clause in `P03_main`).
- **Lean definition** (`pv_work/T02Stmt.lean:33`, verbatim):

```lean
def T02_L01Consumed : Prop :=
  ∀ (ν : Measure ℝ) [IsProbabilityMeasure ν], Paper.L01.IsInvSub ν → Paper.L01.SubCond ν
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

### #2 `T01_L01Consumed`: Lemma 2.3 repaired with F(0)=0 on the "if" half

- **Source**: `source/SuperParetoPaper-v12.tex:128-135`; consumed at :178 ("only if" half, applied to X) and :180 ("if" half, applied to h(X)).
- **Why it needs checking**: the printed lemma is false in the "if" direction (B01); this is the repaired version, which the source does not state, and L01's S1 and S2 were never proved in Lean. Note also that T01 itself is ISSUE (B05) and B05 does not rest on this input.
- **Mathematical content**: InvSub ⇒ eq:sub-1x, and F(0)=0 plus eq:sub-1x ⇒ InvSub.
- **Suggested checking route** (`T01_final.md` §7): substitute s=θ/x, t=(1-θ)/x; the equivalence with subadditivity of 1-F(1/x) is a rewriting.
- **Used by**: T01 (`T01_main_mod_gaps`).
- **Lean definition** (`pv_work/T01Stmt.lean:36`, verbatim):

```lean
def T01_L01Consumed : Prop :=
  ∀ μ : Measure ℝ, IsProbabilityMeasure μ →
    (IsInvSub μ → SubCond μ) ∧ (F μ 0 = 0 → SubCond μ → IsInvSub μ)
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

### #3 `P03_P02Consumed`: Proposition 3.2 at n=2, real-valued X

- **Source**: `source/SuperParetoPaper-v12.tex:246` ("As a consequence of Theorem 3.1 and Proposition 3.2, the following result is immediate"); Prop 3.2 at :238-241, proof :243.
- **Why it needs checking**: P02 is ISSUE (B02, B03) and is not reconnectable (`P03_reconnect_r1.md`). Its n=2 argument is verified only for nonnegative X (`P02_S6`); this clause covers real-valued X, so it is stronger than the verified part (`P03_final.md` §4). P03 itself proves X>0 a.s. (S3), so a weaker clause with a nonnegativity premise would suffice; that restatement needs a new gate and was not decided. `P02_S6` has no Lean non-vacuity witness.
- **Mathematical content**: independent copies, P(X₁=X₂)<1, X ≤st (X₁+X₂)/2 ⇒ X not integrable (`InfiniteMean := ¬ Integrable`).
- **Suggested checking route**: decide the authors' intended domain of Prop 3.2 and the meaning of "infinite mean" for signed X; or restate with nonnegativity and reconnect to `P02_S6`.
- **Used by**: P03 (S6, `pv_work/P03.lean:204`, and the reconnected `main_closed`).
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

### #4 `T03_T01Consumed`: Theorem 2.8 for the law of Z-1 (defined in Lean, **not registered**)

- **Source**: `source/SuperParetoPaper-v12.tex:314` ("so the conclusion follows by applying Theorem 2.8"); Thm 2.8 at :169-172.
- **Why it is listed**: it is a visible Lean parameter of the T03 statement and draft that is absent from `RESULTS.json`, `EXTERNAL_TOOLS.md` and the T03 `conditions` field (priority A assigned at the gate, `T03_gate.md` item 6). It does **not** need checking for any verdict. The clause is **refutable**: `not_T03_T01Consumed` in `pv_work/T03_Counterexample2.lean` (g = max(y-1,0); `T03_issue_2.md` §3, review VALID). T03 cannot be CONDITIONAL on it; any proof of `T03_main` through it would be ex falso. T03 stays ISSUE (B09, B10).
- **Used by**: none for any verdict (only the T03 draft assembly; T03 has no proof file and no final audit).
- **Lean definition** (`pv_work/T03Stmt.lean:30`, verbatim):

```lean
def T03_T01Consumed : Prop :=
  ∀ g : ℝ → ℝ, Continuous g → Paper.T01.StarShaped g →
    Paper.L01.IsInvSub lawY → Paper.L01.IsInvSub (lawY.map g)
```

- **Check result**: ☐ confirmed false (T03 stays ISSUE)  ☐ other: ____

## Level B

### #5 `T01_X02Tool`: Lemma 4.1 of ineq-order2024

- **Source**: `source/SuperParetoPaper-v12.tex:174`: "Since h is star-shaped, its inverse, h^{-1}, is anti-star-shaped (see Lemma 4.1 in \cite{ineq-order2024})".
- **Why it needs checking**: attribution to a cited paper not available here. The Lean form is weaker than the source's use (requires h monotone on [0,∞), whereas :174 states no monotonicity premise), which created the formalization-side ENCODING_ERROR for obligation S0 (`T01_issue_2.md`, no counterexample review). The gate says a mathlib search "is not applicable (research lemma)"; no `#check` evidence is recorded.
- **Mathematical content**: for continuous increasing star-shaped h, the generalised inverse is anti-star-shaped.
- **Suggested checking route**: find Lemma 4.1 in ineq-order2024; confirm the statement and whether it assumes h increasing. If it does, `T01_issue_2.md` expects at most an editorial citation-scope remark.
- **Used by**: T01 (S3 only; B05 does not rest on it).
- **Lean definition** (`pv_work/T01Stmt.lean:26`, verbatim):

```lean
def T01_X02Tool : Prop :=
  ∀ h : ℝ → ℝ, Continuous h → StarShaped h → MonotoneOn h (Set.Ici 0) →
    AntiStarShaped (ginv h)
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

### #6 `P04_X01Tool`: Proposition 1 of superPareto2024 (Prop 4.3)

- **Source**: `source/SuperParetoPaper-v12.tex:273-276` (Proposition 4.3, "[Proposition 1 in \cite{superPareto2024}] ... super-Pareto if and only if 1/F̄_X(x) is concave").
- **Why it needs checking**: the encoded form adds F<1 everywhere and a concavity domain `suppIn (F μ)` that the printed Prop 4.3 does not state. A first encoding was rejected as false (`P04_gate.md`); this one was approved after gate amendment A2 (`P04_gate_r2.md` item 6) on reasoning, not Lean. No `#check` evidence for "not in mathlib" is recorded ("paper-specific class; no search needed").
- **Mathematical content**: X super-Pareto iff F̄>0 everywhere and 1/F̄ concave on the support domain.
- **Suggested checking route**: read Prop 1 of superPareto2024; confirm the F<1 condition and the domain of concavity.
- **Used by**: P04 clause 2 only (the parenthetical "or, equivalently, X is super-Pareto" at :294, via `P04_S5`; clauses 1 and 3 do not reach it). T03 carries a binder of this type but does not use it.
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
