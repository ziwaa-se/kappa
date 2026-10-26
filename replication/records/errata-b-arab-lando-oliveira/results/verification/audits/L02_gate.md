# L02 statement gate (Lemma 4.10, lem:inv-NWU)

- Reviewer: pv-gate (independent subagent, Opus)
- Date: Mon Oct 12 22:48:47 EDT 2026 (from `date`)
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L02Stmt.lean` caf65f96097f30510613ecbaae09a9c88816a2a2da4b1ac2edc1d2a5b5256d1f
  - `pv_work/L02Draft.lean` 896bee2a8ccebf32420543931cc5eee3475889baab6e695b079a0565b6e9a31f
  - `pv_work/L01Stmt.lean` (imported) 3e9b3f0c87c438951c23ab2a1747bdb9f47a1155dcfd26a64401d421d03ad57e
  - `pv_work/notes/L02_draft_notes.md` 851406e78b66fe937063046a48699515e4371d9e7b481d0b338f6ad711ba7726 (leads only)
  - `source/SuperParetoPaper-v12.tex` 88ba28dedca45ca91f426ef9180ace03331f773afa7a3643099ea0eadb103294
- Compilation: `scripts/pv_lean.sh check L02Draft` gave
  `RESULT L02Draft mode=check exit=0 errors=0 sorry_warnings=4 nonstandard_axiom_lines=0 log=pv_work/logs/L02Draft_2.log olean=none` (4 sorry = main + S1..S3, expected for a draft).

## Source quotations (read directly)

- F:111: "a function v is said to be subadditive if v(x+y) ≤ v(x)+v(y), for every x,y in the domain of v."
- F:113: F_X cdf, Fbar_X = 1-F_X; F:119: random variables and their cdfs identified.
- F:344-349 (Def 4.9(1)): "We say that a random variable X such that F_X(0)=0 is ... super-heavy-tailed if −Log F_X(1/x) is subadditive".
- F:354: "Note that the nonnegativity is not strictly necessary for the above definitions."
- F:356: "in the general case, F_X(1/x) = 1 − F^-_{1/X}(x)."
- F:358: "The following characterisation is straightforward." (no proof printed)
- F:359-366 (Lemma 4.10): "A random variable X is super-heavy-tailed if and only if F_X(x/θ)F_X(x/(1−θ)) ≤ F_X(x), ∀x≥0, θ∈(0,1)."
- Later uses of eq:inv-NWU: only F:392 (Example 4.13: "(eq:inv-NWU) is not [satisfied], so R_a is not super-heavy-tailed"), i.e. the "only if" direction. Thm 4.11 proof (F:381) works from the definition, not the lemma.
- Parallel precedent: Def 2.2 (F:124) / Lemma 2.3 (F:130-134) have the same shape; see `verification/audits/L01_gate.md` and `L01_issue_1.md` (PAPER_ASSUMPTION_GAP recorded for the omitted F_X(0)=0).

## Item 1. Hypotheses — FAIL (one extra premise)

- `IsProbabilityMeasure μ`: X represented by its law; faithful (F:113, F:119). No hidden hypotheses in `F` (L01Stmt: `ProbabilityTheory.cdf μ x`), no `variable`s, no structures or classes beyond this.
- `h0 : F μ 0 = 0` in `L02_main` is an extra premise not printed in Lemma 4.10 (F:361-364). It is rejected as a TFA (see TFA table): it is not derivable from eq:inv-NWU (at x=0 it reads F(0)^2 ≤ F(0), always true) and it excludes non-degenerate laws the printed lemma covers (e.g. X uniform on [−1,0], X ≡ 0, X ≡ −1: F ≡ 1 on [0,∞), so eq:inv-NWU holds as 1·1 ≤ 1, but F(0)=1 ≠ 0). Adding it repairs the "if" direction and hides exactly the suspected gap. The L01 gate rejected the identical premise for Lemma 2.3; consistency requires the same here.
- `h0` in `L02_S2` is fine: S2 is used only inside the forward direction, where `h0` is the first conjunct of `IsSuperHeavyTailed`.

## Item 2. Conclusion — PASS (after amendment)

`IsSuperHeavyTailed μ ↔ InvNWUCond μ` is the printed iff. `IsSuperHeavyTailed` includes the presupposition F_X(0)=0 of Def 4.9 (F:346) literally as a conjunct, same treatment as `IsInvSub` in L01 (gate-approved). `InvNWUCond` matches F:364 exactly (x ≥ 0, θ ∈ (0,1), product ≤ F(x)). No clause missing, no weakening/strengthening.

## Item 3. Quantifiers and constants — PASS

No constants. Quantifier order ∀x≥0 ∀θ∈(0,1) as in F:364; subadditivity ∀x,y in domain as in F:111.

## Item 4. Domains and details — PASS

- Domain of `−Log F_X(1/·)` read as (0,∞): 1/x is undefined at 0 in the source; same reading as L01 (gate-approved). It also does not matter: under any extension with 1/0 = +∞, F(+∞)=1 gives v(0)=0 and subadditivity involving 0 is trivially v(x) ≤ v(x)+0. Lean's 1/0=0 is never reached (S ⊆ Ioi 0).
- Log 0: `negLogInv` returns ⊤ (= +∞) when F(1/x)=0, else the real −log F(1/x) ≥ 0 (since 0 < F ≤ 1). This is the standard extended-real convention (−log 0 = +∞) and avoids Lean's `Real.log 0 = 0` junk value, which would have changed the statement. Values never ⊥, so EReal addition is the honest one (⊤ + a = ⊤). The case F(1/x)=0 does occur when F_X(0)=0 (e.g. support in [1,∞), large x), so the choice is substantive and is the natural one. The source does not discuss it: recorded as candidate DOMAIN_CLARIFICATION (notes item 3), not an encoding problem.
- x>0 vs x≥0: the displayed condition uses x ≥ 0 (encoded literally); the x=0 instance is trivial given F(0)=0 (S2). No mismatch.
- Natural log assumed; base irrelevant (any base > 1 gives an equivalent condition).
- No ℝ≥0∞/ℝ truncation: `cdf` is real-valued; no `toReal`/`ofReal`.
- Periodicity, a.e. equality, measurability, existence: not applicable.

## Item 5. Step obligations — PASS (each checked for truth as stated)

- **S1** (forward, x>0): with a=θ/x, b=(1−θ)/x, a+b=1/x, subadditivity gives −log F(x) ≤ −log F(x/θ) − log F(x/(1−θ)) in [0,∞]. If either factor on the left of eq is 0 the product is 0 ≤ F(x); if F(x)=0 then LHS ⊤ forces a factor = 0; otherwise exponentiate. TRUE as stated. Corresponds to F:358 (only "straightforward").
- **S2** (x=0): 0/θ = 0 in Lean and math; F(0)·F(0) = 0 ≤ 0. TRUE as stated (needs h0, which is supplied by `IsSuperHeavyTailed`).
- **S3** (converse subadditivity): x,y>0, x0 = 1/(x+y), θ = x/(x+y) ∈ (0,1), x0/θ = 1/x, x0/(1−θ) = 1/y; F(1/x)F(1/y) ≤ F(1/(x+y)); if F(1/(x+y))=0 a factor is 0 and RHS = ⊤; else all positive, take −log. TRUE as stated.
- No obligation smuggles the conclusion or a stronger intermediate claim.
- Assembly (after removing `h0` from main): forward = S1 + S2 (with h.1) — complete. Reverse = S3 gives the subadditivity conjunct but **not** the conjunct F(0)=0. So `L02_main` without `h0` is **false as stated** in its "if" direction (counterexample X ≡ 0, i.e. μ = dirac 0), and the obligations faithfully expose the missing part, exactly as in L01. This falsity comes from the printed statement (F:361 omits "such that F_X(0)=0" while Def 4.9 F:346 has it), not from the encoding.

## Item 6. External parameters — PASS (none)

No `def … : Prop` tools; none needed (pure elementary manipulation). No mathlib-absence claims to check. Names `negLogInv`, `SubadditiveOnE`, `IsSuperHeavyTailed`, `InvNWUCond` are new, in `namespace Paper.L02`; L01's `F` is imported, not redeclared.

## Item 7. Doubts about the source — recorded, not ruled

1. F:361-364 (with F:346): Lemma 4.10 omits "such that F_X(0)=0"; the "if" direction is false as printed (X ≡ 0). Preliminary: PAPER_ASSUMPTION_GAP, alternatively DOMAIN_CLARIFICATION if the convention of Def 4.9 is read as standing. Note for the checker: unlike L01 (consumed at F:180), the only later use of eq:inv-NWU (F:392) uses the true "only if" direction. Recommend dispatching pv-issue-checker.
2. F:349/F:358: −Log F_X(1/x) undefined when F_X(1/x)=0 (which occurs under F_X(0)=0) and the domain is unspecified; no proof given. Preliminary: DOMAIN_CLARIFICATION / EXPOSITION_GAP (minor). May be folded into the checker's task.

## TFA rulings

| Premise | Ruling | Reason |
|---|---|---|
| `h0 : F μ 0 = 0` in `L02_main` | REJECTED | Not derivable from eq:inv-NWU; excludes non-degenerate laws (any law with F ≡ 1 on [0,∞), e.g. uniform on [−1,0], satisfies eq:inv-NWU but has F(0)=1) that the printed lemma covers; it repairs the statement and masks the suspected gap. Same ruling as L01 gate for the identical premise. |
| `h0` in `L02_S2` | not a TFA question | Internal obligation; premise is available from `IsSuperHeavyTailed` in the only place S2 is used. |

## External parameters

None.

## Required changes

1. `pv_work/L02Draft.lean` lines 10-12: delete line 11 `    (h0 : F μ 0 = 0) :` so that the signature reads
   `theorem L02_main (μ : MeasureTheory.Measure ℝ) [MeasureTheory.IsProbabilityMeasure μ] :`
   `    IsSuperHeavyTailed μ ↔ InvNWUCond μ := by`
   and update the docstring (lines 7-9) to state that the "if" direction lacks F_X(0)=0 (suspected paper issue, F:361 vs F:346), without asserting h0 as a convention. No other change; `L02Stmt.lean`, S1, S2, S3 unchanged.

## Statement snapshot

Probe copies: `pv_work/probes/gate/L02/gate_L02_stmtcopy.lean` (RESULT exit=0, sorry_warnings=0, log `pv_work/logs/gate_L02_stmtcopy_1.log`), `pv_work/probes/gate/L02/gate_L02_draftcopy.lean` (RESULT exit=0, sorry_warnings=4, log `pv_work/logs/gate_L02_draftcopy_1.log`).

L02Stmt copy:
```
TYPE HASHES (current file, 4 declarations)
Paper.L02.InvNWUCond|def|th=3905129696|vh=1097506931|bi=e
Paper.L02.IsSuperHeavyTailed|def|th=3905129696|vh=1915010453|bi=e
Paper.L02.SubadditiveOnE|def|th=3398320362|vh=2787305485|bi=ee
Paper.L02.negLogInv|def|th=998799875|vh=1981073015|bi=ee
```

L02Draft copy (pre-amendment; `L02_main` hash will change after the required change):
```
TYPE HASHES (current file, 4 declarations)
Paper.L02.L02_S1|thm|th=3729239319|vh=-|bi=eceeeee
Paper.L02.L02_S2|thm|th=1901557866|vh=-|bi=eceee
Paper.L02.L02_S3|thm|th=1459483526|vh=-|bi=ece
Paper.L02.L02_main|thm|th=2155422696|vh=-|bi=ece
```

## Overall verdict

Statement definitions (L02Stmt) and obligations S1-S3 are faithful and true as stated; the only defect is the rejected extra premise `h0` on `L02_main`. After removal, check amendments in `L02_gate_r2.md`.

STATEMENT GATE: PASS_WITH_AMENDMENTS
