# Human-check worksheet for external inputs

None of the items below has been **proved in Lean** as a parameter. Theorems that depend on an item take it as an explicit hypothesis, so if it were false, the conclusions that depend on it would lose their support.

## Checking principles (read first)

1. **Direction.** What must be confirmed is that the Lean parameter is true (here: it is a clause of the paper's own lemma).
2. **Compare item by item.** Domain, quantifiers, hypotheses, the conclusion.

## Priority overview

| Priority | # | Name | Nature | Used by |
|---|---|---|---|---|
| A | 1 | `T01_L02Consumed` | (iv) (gated as (p)) predecessor clause, predecessor L02 has issue B1, not reconnectable | T01 clause 3 |

Gap hypotheses (`L02_S2_Gap`, `L02_S3_Gap`) are not external inputs; see AUTHOR_REPORT §4.1. `C01_L02Consumed` is a parameter of the remark obligation `C01_S4` only (not a condition of Corollary 2.4); it is the same statement as #1.

---

## Level A

### #1 `T01_L02Consumed`: Lemma 2.2's conclusion ρ ≤ min{θ², σ²}

- **Source**: `source/main.tex:48-50` (statement), used at `source/main.tex:65-66`.
- **Why it needs checking**: the printed proof of Lemma 2.2 (main.tex:54-55) has false steps (B1). The conclusion itself was independently proved in Lean in a gate probe (reviewer evidence, not a verdict basis), so a person may accept it.
- **Mathematical content**: for all θ, σ satisfying the standing assumption, θ²σ²/(θ²+σ²) ≤ min{θ², σ²}.
- **Suggested checking route** (from `L02_issue_1.md` §7): ρ = ½·HM(θ²,σ²) and HM ≤ 2·min.
- **Used by**: Theorem 2.3, step S5 / clause `le_min`.
- **Lean definition** (`pv_work/T01Stmt.lean:20`, quoted verbatim):

```lean
def T01_L02Consumed : Prop :=
  ∀ θ σ : ℝ, Setting θ σ → Paper.L02.Conclusion θ σ
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

## Where the notation is defined

| Notation | Where defined | Meaning |
|---|---|---|
| `Setting θ σ` | `pv_work/Defs.lean:7` | standing assumption (main.tex:25) |
| `risk`, `oracleFactor`, `oracleRisk` | `pv_work/Defs.lean:12,15,18` | R(c), c*, ρ |
| `Paper.L02.Conclusion` | `pv_work/L02Stmt.lean:6` | ρ ≤ min{θ², σ²} |
