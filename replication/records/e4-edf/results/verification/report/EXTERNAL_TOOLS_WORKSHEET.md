# Human-check worksheet for external inputs

None of the items below has been **proved in Lean**. Theorems that depend on an item take it as an explicit hypothesis, so if any one of them is false, the conclusions that depend on it lose their support.

## Checking principles (read first)

1. **Direction.** What must be confirmed is that "the theorem in the literature implies our Lean parameter". The Lean parameter may be weaker than the literature's conclusion, but not stronger.
2. **Compare item by item.** Domain, quantifier order, every hypothesis, the constants in the conclusion.
3. **Notation.** `Q.real S` is the real-valued measure of `S`; `Kfun z = 1 - 2 ∑' k, (-1)^k exp(-2 (k+1)^2 z^2)` (k from 0, so it equals the source's series with k+1); `⨆` is Lean's real supremum.

## Priority overview

| Priority | # | Name | Nature | Used by |
|---|---|---|---|---|
| B | 1 | `GlivenkoCantelli` | (i), cited by name only (no `\cite`); goal-shaped | P01 |
| B | 3 | `KolmogorovFormula` | (i), `\cite{kolmogorov}`; attribution nuance; equals T01's cdf clause | T01 |
| D | 2 | `DonskerUniformSup` | (i), `\cite{donsker}` | T01 |

There are no items of level A, A′, C or E. Gap hypotheses do not exist in the final proofs.

---

## Level B

### #1 `GlivenkoCantelli`: iid real sequences satisfy sup_t |F_n − F| → 0 almost surely

- **Source**: `source/main.tex:50`
- **Why it needs checking**: no `\cite`, attribution by name only. The parameter equals P01's own conclusion (goal-shaped, VERDICTS §4.2), so the Lean check of P01 shows only instantiation.
- **Mathematical content**: classical Glivenko–Cantelli theorem, any distribution function F (no continuity).
- **Suggested checking route**: compare with a textbook statement (iid, real-valued, arbitrary F, a.s. uniform convergence).
- **Used by**: P01 (`Paper.P01.P01_main`, step S1).
- **Lean definition** (`pv_work/P01Stmt.lean:26`, verbatim):

```lean
def GlivenkoCantelli.{u} : Prop :=
  ∀ (Ω : Type u) [MeasurableSpace Ω] (P : Measure Ω) (X : ℕ → Ω → ℝ),
    IsIIDSeq P X → GCConclusion P X
```

where (`P01Stmt.lean:10,16`) `GCConclusion P X := ∀ᵐ ω ∂P, Tendsto (fun n : ℕ => Dn P X n ω) atTop (𝓝 0)` and `IsIIDSeq` says: `P` is a probability measure, each `X k` is measurable, `iIndepFun X P`, and `IdentDistrib (X k) (X 0) P P`.

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

### #3 `KolmogorovFormula`: sup|B| of a Brownian bridge has cdf K(z) for z > 0

- **Source**: `source/main.tex:62`, `\cite{kolmogorov}`
- **Why it needs checking**: equals the cdf clause of T01 (proved by citation only in the source). Per the gate (T01_gate §6) and the final audit (T01_final_r2 §8), Kolmogorov 1933 gives the limit law of √n D_n and the bridge formulation is Doob/Donsker; not checked (no network).
- **Mathematical content**: P(sup_{0≤u≤1}|B(u)| ≤ z) = 1 − 2 Σ_{k≥1} (−1)^{k−1} e^{−2k²z²}, z > 0.
- **Suggested checking route**: compare the series, indexing shift and z > 0 domain with the literature; confirm `IsBrownianBridge` (below) is the standard bridge.
- **Used by**: T01 (`Paper.T01.T01`, step S6, `cdf` clause).
- **Lean definition** (`pv_work/T01Stmt.lean:69`, verbatim):

```lean
def KolmogorovFormula : Prop :=
  ∀ (Ω' : Type) [MeasurableSpace Ω'] (Q : Measure Ω') [IsProbabilityMeasure Q]
    (B : ℝ → Ω' → ℝ), IsBrownianBridge Q B →
      ∀ z : ℝ, 0 < z → Q.real {ω | supAbs B ω ≤ z} = Kfun z
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

## Level D

### #2 `DonskerUniformSup`: for iid uniform[0,1] samples √n D_n → sup|B| in distribution

- **Source**: `source/main.tex:61`, `\cite{donsker}`
- **Why it needs checking**: the continuous-mapping step ("applied to the supremum", main.tex:61-62) is folded into the parameter; the gate accepted this. Only the uniform case is assumed (weaker than the source's use; the general continuous-F case is proved in Lean, T01_S2–S4).
- **Mathematical content**: Donsker's invariance principle for the empirical process, at the level of the sup statistic.
- **Used by**: T01 (`conv` clause, step S5).
- **Lean definition** (`pv_work/T01Stmt.lean:60`, verbatim):

```lean
def DonskerUniformSup : Prop :=
  ∀ (Ω : Type) [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P] (U : ℕ → Ω → ℝ),
    (∀ k, Measurable (U k)) → ProbabilityTheory.iIndepFun U P →
    (∀ k, P.map (U k) = volume.restrict (Icc (0:ℝ) 1)) →
    ∀ (Ω' : Type) [MeasurableSpace Ω'] (Q : Measure Ω') [IsProbabilityMeasure Q]
      (B : ℝ → Ω' → ℝ), IsBrownianBridge Q B →
      ConvInDist P (fun n ω => Real.sqrt n * Paper.Defs.Dn P U n ω) Q (supAbs B)
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

## Where the notation is defined

| Notation | Where defined | Meaning |
|---|---|---|
| `IsBrownianBridge`, `ConvInDist`, `supAbs`, `Kfun` | `pv_work/T01Stmt.lean:27, 17, 37, 41` | Brownian bridge on [0,1] (measurable coordinates, continuous paths, centered Gaussian marginals with covariance min(s,t) − st); weak convergence via bounded continuous test functions; sup over [0,1] of \|B\|; Kolmogorov series. The source defines none of the first two. |
| `Dn`, `edf`, `edfRV` | `pv_work/Defs.lean:49, 21, 31` | D_n = ⨆ t, \|F_n(t) − F(t)\|; EDF of x; random EDF. |
