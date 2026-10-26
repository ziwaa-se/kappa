# Human-check worksheet for external inputs

None of the items below has been **proved in Lean**. Theorems that depend on an item take it as an explicit hypothesis, so if any one of them is false, the conclusions that depend on it lose their support.

## Checking principles (read first)

1. **Direction.** What must be confirmed is that "the theorem in the literature implies our Lean parameter". The Lean parameter may be weaker than the literature's conclusion (extra hypotheses, only a special case), but not stronger.
2. **Compare item by item.** Domain, quantifier order, every hypothesis, the constants in the conclusion.
3. **Notation.** `∫⁻` is an integral with values in `[0,∞]`; `ENNReal.ofReal` truncates negative numbers to 0; `ν (Set.Ico a b)` is the mass of the half-open interval `[a,b)`.

## Priority overview

| Priority | # | Name | Nature | Used by |
|---|---|---|---|---|
| A | 1 | `P04_T01Consumed` | (p), predecessor T01 (ISSUE), not reconnected | P04 |
| A (inherited) | 2 | `P05_P04Consumed` | (p), predecessor P04 (carries #1, #3) | P05 (result is ISSUE) |
| A (not load-bearing) | 3 | `T02_T01Consumed` (unregistered) | (p), predecessor T01 | premise of `T02_mod_gaps` only |
| C | 4 | `P04_MixingOfStrict` | (ii) | P04 |
| D | 5 | `GruenwaldThm1` (X03) | (i) | T03 |

- **A**: (iv) clauses of the paper's own lemmas whose proofs have issues; and (p) whose predecessor has an issue and could not be reconnected.
- **C**: facts the source asserts but does not prove. **D**: explicitly cited theorems; confirm the Lean specialization is not stronger.
- There are no A′ (iii) and no E (v) items.
- Gap hypotheses are not external inputs and are not listed here (see AUTHOR_REPORT §4).

---

## Level A

### #1 `Paper.P04.P04_T01Consumed`: the sufficiency clause of Theorem 3.1

- **Source**: `source/VSIFP_02.tex:144-149` (statement), `:403` (proof of the "if" direction: "one can easily verify"). Note: the registry row cites `:205-223`, which is the P04 statement, not Theorem 3.1.
- **Why it needs checking**: T01 has an issue (B1) and this clause was not reconnected. The issue B1 is in the *necessity* direction (l.419), which this clause does not consume; the gate probe `gate_P04_t01link.lean` derives the clause from the gap-free `Paper.T01.T01_S2`. The human-check text in `EXTERNAL_TOOLS.md` ("confirm Theorem 3.1 e-value part is accepted as stated") points at the wrong part; check the sufficiency direction.
- **Mathematical content**: for S consistent with mixing measure ν charging [min(p,q), max(p,q)), p ≠ q in (0,1), λ ∈ (0,1]: E_{p,q;λ} is nonnegative and has E_π E ≤ 1 for every π ∈ H_S.
- **Suggested checking route**: T01_final §6 and `T01_S2` in `pv_work/T01.lean`/`T01ModGaps.lean`; decide whether to reconnect.
- **Used by**: P04 (`P04_S1`, `pt_bound`, S5-S8, `P04_main`).
- **Lean definition** (`pv_work/P04Stmt.lean:78`, quoted verbatim):

```lean
def P04_T01Consumed (S : ℝ → ℝ → ℝ) : Prop :=
  IsConsistent S → ∀ ν : Measure ℝ, T01.MixtureRep S ν →
    ∀ p ∈ Set.Ioo (0:ℝ) 1, ∀ q ∈ Set.Ioo (0:ℝ) 1, p ≠ q →
      0 < ν (Set.Ico (min p q) (max p q)) →
        ∀ lam ∈ Set.Ioc (0:ℝ) 1,
          IsEValue (Erep S p q lam) (HS S p q) ∅
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

### #2 `Paper.P05.P05_P04Consumed`: the conclusion of Proposition 3.4

- **Source**: `source/VSIFP_02.tex:222-227`.
- **Why it needs checking**: P04 is CONDITIONAL; this clause carries P04's conditions (#1, #4) and its integrability scope. Level A by inheritance (coordinator's reading: the rule table does not cover a (p) clause whose predecessor is CONDITIONAL; it is placed in A because it carries #1). It contains only `E e_t ≤ 1`, not the conditional bound that the proof of P05 uses.
- **Mathematical content**: for every T ≥ h+1, e_T is ℱ_T-measurable and an e-value under `HScInt`.
- **Used by**: P05 (step `P05_Snn`).
- **Lean definition** (`pv_work/P05Stmt.lean:21`, quoted verbatim):

```lean
def P05_P04Consumed (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) : Prop :=
  ∀ T : ℕ, h + 1 ≤ T → Paper.P04.P04Conclusion S h ℱ Y c p q lam T
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

### #3 `Paper.T02.T02_T01Consumed` (unregistered; not load-bearing)

- **Source**: `source/VSIFP_02.tex:144-149`, used at `:430`.
- **Why it needs checking**: this is the necessity direction of Theorem 3.1, the part with issue B1 (l.419). It appears only as a premise of `T02_mod_gaps` (reaching the S15 gap); no proved clause of T02 rests on it.
- **Lean definition** (`pv_work/T02Stmt.lean:40`, quoted verbatim):

```lean
def T02_T01Consumed : Prop :=
  ∀ (S : ℝ → ℝ → ℝ) (ν : Measure ℝ), IsConsistent S → T01.MixtureRep S ν →
    ∀ p q : ℝ, p ∈ Set.Ioo (0:ℝ) 1 → q ∈ Set.Ioo (0:ℝ) 1 → p ≠ q →
      0 < ν (Set.Ico (min p q) (max p q)) →
      ∀ E : ℝ → ℝ, IsEValue E (HS S p q) (Set.Icc (0:ℝ) 1 \ HS S p q) →
        ∃ lam ∈ Set.Ioc (0:ℝ) 1, ∀ y ∈ ({0, 1} : Set ℝ), E y = Erep S p q lam y
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

## Level C

### #4 `Paper.P04.P04_MixingOfStrict`: strict consistency forces ν to charge every interval

- **Source**: `source/VSIFP_02.tex:106` ("S is strictly consistent iff ν assigns positive measure to all non-degenerate intervals in (0,1)"; no citation), regularity at `:93` (Thm 2.3 of the work cited as `Gneiting2007`; the .bbl gives Gneiting, Balabdaoui, Raftery 2007, JRSSB, not Gneiting and Raftery 2007, JASA (`Gneiting2007a`); confirm which was meant).
- **Why it needs checking**: asserted without proof, used silently in P04. The "only if" half is elementary (P04_gate item 6) but was left as a parameter. The first form (every strictly consistent S has an exact representation) was rejected as false (counterexample (p−y)² − 5); the approved form takes the representation as hypothesis.
- **Used by**: P04 (`P04_S1`, `pt_bound`, S5-S8, main).
- **Lean definition** (`pv_work/P04Stmt.lean:90`, quoted verbatim):

```lean
def P04_MixingOfStrict (S : ℝ → ℝ → ℝ) : Prop :=
  ∀ ν : Measure ℝ, T01.MixtureRep S ν → IsStrictlyConsistent S →
    ∀ a b : ℝ, 0 < a → a < b → b < 1 → 0 < ν (Set.Ico a b)
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

## Level D

### #5 `Paper.T03.GruenwaldThm1` (X03): GROW e-value is the likelihood ratio

- **Source**: `source/VSIFP_02.tex:188` and `:466` ("by Theorem 1 of Gruenwald2019, with W_1 the Dirac measure of {π₁}"); remark at `:174`.
- **Why it needs checking**: cited result, specialised to the Bernoulli family and a Dirac alternative. Confirm that Theorem 1 of Grünwald, de Heide, Koolen 2019 covers (a) identification of the LR as GROW when it is an e-value for H, and (b) π₁-a.s. uniqueness, in the encoded form. The auditor proved X03 as encoded in a probe (`auditor_T03_x03sat.lean`), so it is true and non-vacuous; that is not evidence about the cited paper. If uniqueness is not in Theorem 1 the priority becomes B (attribution doubt only; the clause is true here).
- **Used by**: T03, step S5 only (S1-S4 are parameter-free).
- **Lean definition** (`pv_work/T03Stmt.lean:42`, quoted verbatim):

```lean
def GruenwaldThm1 : Prop :=
  ∀ (H : Set ℝ) (π₁ p₀ : ℝ), H ⊆ Set.Icc (0:ℝ) 1 → π₁ ∈ Set.Icc (0:ℝ) 1 → π₁ ∉ H →
    p₀ ∈ Set.Ioo (0:ℝ) 1 →
    (∀ π ∈ H, expPi π (EGrowAll p₀ π₁) ≤ 1) →
    (∀ π ∈ Set.Icc (0:ℝ) 1, π ∉ H → 1 < expPi π (EGrowAll p₀ π₁)) →
    GrowIs H π₁ (EGrowAll p₀ π₁)
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

## Where the notation is defined

| Notation | Where defined | Meaning |
|---|---|---|
| `IsConsistent` (Defs.lean:21), `IsStrictlyConsistent` (:25), `HS` (:44), `IsEValue` (:56), `Erep` (:61), `expPi` (:18), `EGrowAll` (:92) | `pv_work/Defs.lean` | consistency, strict consistency, null hypothesis H_S, e-value predicate, e-value E_{p,q;λ}, Bernoulli expectation, likelihood ratio |
| `T01.MixtureRep S ν` | `pv_work/T01Stmt.lean:19` | mixture representation of S with mixing measure ν (l.93-97) |
| `GrowIs` | `pv_work/T03Stmt.lean:32` | GROW property with π₁-a.s. uniqueness |
| `HScInt` (:54), `P04Conclusion` (:67) | `pv_work/P04Stmt.lean` | ℋ_{S;c} with integrable score differences; P04 conclusion |
