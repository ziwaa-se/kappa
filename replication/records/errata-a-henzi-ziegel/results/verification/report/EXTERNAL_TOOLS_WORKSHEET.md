# Human-check worksheet for external inputs

None of the items below has been **proved in Lean**. Theorems that depend on an item take it as an explicit hypothesis, so if any one of them is false, the conclusions that depend on it lose their support.

## Checking principles (read first)

1. **Direction.** What must be confirmed is that "the theorem in the literature implies our Lean parameter". The Lean parameter may be weaker than the literature's conclusion (extra hypotheses, only a special case), but not stronger.
2. **Compare item by item.** Domain, quantifier order, every hypothesis, the constants in the conclusion.
3. **Notation.** `∫⁻` is an integral with values in `[0,∞]`; `ENNReal.ofReal` truncates negative numbers to 0; `x / 0 = 0` in Lean.

## Priority overview

| Priority | # | Name | Nature | Used by |
|---|---|---|---|---|
| A | 1 | `P04_T01Consumed` | (iv) (registry: (p)): T01 has issue B1, clause not reconnected | P04, P05 (h > 1) |
| B | 2 | `GruenwaldThm1` (X03) | (i) cited, attribution doubtful | T03 |
| C | 3 | `P04_MixingOfStrict` | (ii) asserted, not proved | P04, P05 (h > 1) |

No type (iii) (A′), no type (v) (E) and no other (D) parameters are registered.

Gap hypotheses (`T01_S8_Gap`, `T01_S10_Gap`, `T02_S3a_Gap`, `T02_S3b_Gap`, `T02_S8_Gap`, `T02_S11_Gap`, `T02_S15_Gap`) are not external inputs and are explained under the issues in AUTHOR_REPORT §4. Not listed as conditions: `P05_P04Consumed` (reconnected, `verification/audits/P05_reconnect_r1.md`) and `T02_T01Consumed` (unregistered; reached only through the S15 gap of T02, which is ISSUE; if T02 is ever re-run, register it and re-check it against T01 after the B1 fix).

---

## Level A

### #1 `P04_T01Consumed`: the e-value ("if") clause of Theorem 3.1, consumed by Proposition 3.4

- **Source**: `source/VSIFP_02.tex:143-148` (Theorem 3.1), proof of the "if" direction at l.400; used at l.205–209 (h = 1 sketch). The registry `source_loc` (l.199–214) points to the sequential computation instead.
- **Why it needs checking**: type (iv) (the registry says (p)): the predecessor T01 carries issue B1 and the clause was not reconnected (the gate offered discharge by `Paper.T01.T01_S2`, `P04_gate_r2.md`).
- **Mathematical content**: for consistent S with mixing measure ν, p ≠ q in (0,1), ν[min,max) > 0, λ ∈ (0,1], the function E_{p,q;λ} is an e-value for the one-period null H_S(p,q).
- **Suggested checking route** (audit records): B1 (l.412) concerns only the necessity direction (`T01_issue_1.md` §4); `T01_S2` is gap-free in `pv_work/T01ModGaps.lean` (`T01_final.md` §9). Confirm the e-value part of Theorem 3.1 is accepted as stated.
- **Used by**: P04 (S0 `pt_bound`, S1, S5–S7, S9b, S9c, S10, S11, main); P05 h > 1 branch via P04.
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

## Level B

### #2 `GruenwaldThm1` (X03): Grünwald et al., Theorem 1, specialised to a Bernoulli null and Dirac alternative

- **Source**: `source/VSIFP_02.tex:183` and `:443` (`\cite{Gruenwald2020}`; bib entry: Grünwald, de Heide, Koolen, "Safe testing", 2020 Information Theory and Applications Workshop, `VSIFP_02.bbl:58-62`). The Lean docstring and registry say "2019" and quote old lines l.188, l.466 (stale: revision 1 changed the cite from the 2019 arXiv version to the ITA 2020 version; check Theorem 1 in the 2020 version).
- **Why it needs checking**: type (i), attribution doubtful. No network was available, so the cited theorem was not read.
- **Mathematical content**: if the likelihood ratio E* of π₁ against p₀ has E_π E* ≤ 1 on H and > 1 on [0,1] \ H, then it is the GROW e-value (GROW plus π₁-a.s. uniqueness) for null H against {π₁}.
- **Suggested checking route**: confirm that Theorem 1 gives both the identification as the likelihood ratio and a.s. uniqueness, in the Dirac prior form (W₁ the Dirac measure at π₁). An auditor probe shows X03 is satisfiable as encoded (`auditor_T03_x03sat.lean`); that is not evidence about the cited paper.
- **Used by**: T03, step S5 only (S1–S4 are proved without it).
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

## Level C

### #3 `P04_MixingOfStrict`: strict consistency implies ν charges all non-degenerate intervals

- **Source**: `source/VSIFP_02.tex:103` ("S is strictly consistent if and only if ν assigns positive mass to all non-degenerate intervals in (0,1)"), asserted without proof; regularity of the representation at l.90 ("under mild regularity conditions stated in \citet[Theorem 2.3]{Gneiting2007}"). The registry says "l.106".
- **Why it needs checking**: type (ii). The key `Gneiting2007` resolves to Gneiting, Balabdaoui, Raftery (`.bbl:52-56`), while `Gneiting2007a` is Gneiting and Raftery (`.bbl:42`); the records say "Gneiting–Raftery". Which paper's Theorem 2.3 is meant is UNVERIFIED.
- **Mathematical content**: only the "only if" direction is encoded and used.
- **Used by**: P04 (S0 `pt_bound`, S1, S5–S7, S9b, S9c, S10, S11, main; supplies ν[min(p_t,q_t),max(p_t,q_t)) > 0); P05 h > 1 branch via P04.
- **Lean definition** (`pv_work/P04Stmt.lean:107`, quoted verbatim):

```lean
def P04_MixingOfStrict (S : ℝ → ℝ → ℝ) : Prop :=
  ∀ ν : Measure ℝ, T01.MixtureRep S ν → IsStrictlyConsistent S →
    ∀ a b : ℝ, 0 < a → a < b → b < 1 → 0 < ν (Set.Ico a b)
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

## Where the notation is defined

| Notation | Where defined | Meaning |
|---|---|---|
| `IsConsistent`, `IsStrictlyConsistent`, `HS`, `IsEValue`, `IsMixingMeasure` | `pv_work/Defs.lean` | scoring-rule consistency, null set H_S(p,q), e-value predicate, mixing measure |
| `Erep`, `expPi`, `EGrowAll` | `pv_work/Defs.lean` | E_{p,q;λ}; expectation under π; likelihood ratio |
| `T01.MixtureRep` | `pv_work/T01Stmt.lean` | mixture representation of S (l.90–102) |
| `GrowIs`, `IsGrowEValue` | `pv_work/T03Stmt.lean` | GROW e-value predicates |
| `Mk`, `filtK`, `fk`, `HScInt` | `pv_work/P04Stmt.lean` | factor processes M^{[k]}, σ-fields 𝔉^{[k]}, null with integrable score differences |
