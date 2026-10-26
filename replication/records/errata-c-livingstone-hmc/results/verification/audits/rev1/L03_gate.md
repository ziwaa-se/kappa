# L03 (Lemma 5.17, lem:arate_0) — statement gate

- Reviewer: pv-gate (independent subagent, opus); date: Mon Oct 12 22:35:17 EDT 2026 (`date`)
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/L03Stmt.lean` ca8bf94f7013e76ccae838523c987381f8ae6b8658804d164bd3489142cf3a7f
  - `pv_work/L03Draft.lean` 9a1f53c354bb672b23eaee4e0df85a77ead2af86373ad221ea37e5daae4816fc
  - `pv_work/notes/L03_draft_notes.md` 89095082146047e209b4e8419ee2ca48ccee4d1f6b004636bebf9b47138d287c (leads only)
- Also read in full: `pv_work/Defs.lean`, `pv_work/L02Stmt.lean`, `pv_work/L02Draft.lean` (for `L02_S10`, `L02_S11`, `L02_main_fixedDelta_osc`).
- Compilation: `scripts/pv_lean.sh check L03Draft` → `RESULT L03Draft mode=check exit=0 errors=0 sorry_warnings=14 nonstandard_axiom_lines=0 log=pv_work/logs/L03Draft_2.log olean=none` (14 sorries = main + 13 steps, as expected for a draft).

## Source quotations (read directly)

- Statement, TEX:939-944: "If (17), (18) and (19) hold then for any δ<1 it holds that lim_{‖x_0‖→∞, ‖p_0‖≤‖x_0‖^δ} α(x_0,x_{Lε}) = 0."
- Proof, TEX:946-971: acceptance formula (949); bound on ‖p_{Lε}‖ (953-955) "where (18) is used for the second line" (957); γ_L>0 (957); squaring (958-961, with undefined δ_L at 960); 962-965; "for any M<∞ we can choose ‖x_0‖ large enough that (εγ_L/4)‖∇U(x_{Lε})‖ ≥ M‖x_{Lε}‖ ≥ 2^L‖x_0‖" (966-969); "then ‖p_0‖²−‖p_{Lε}‖² ≤ −‖x_0‖² … envoking (19) gives the result" (970).
- Leapfrog, TEX:330-336 (ε>0 at 336); Prop 4.2 acceptance formula and eqn:mprop2, TEX:366-373; M=I, TEX:354-356.
- (17) TEX:865-867, (18) TEX:868-871, (19) TEX:873-875; Thm 5.14 "fixed integration time T=Lε … for any choice T>0", TEX:876.
- L02 statement TEX:899-901; L02 proof claim "‖x_{iε}‖ ≥ 2‖x_{(i−1)ε}‖ for any fixed i, establishing the result", TEX:934; L03 lead-in TEX:937.

## Item rulings

1. **Hypotheses — PASS.** (17),(18),(19) = `hexp`, `hosc`, `hosc2 : HypOscillation2 U L` (Defs encodings already passed DEFS gate). `heps : 0 < eps` printed at TEX:336. `hL : 1 ≤ L` is an extra premise: approved as TFA (below). No `variable`, structure or class premises; `accProb`, `tailMomFilter` contain no hidden hypotheses. No conclusion-shaped hypothesis: `hL02` contains only L02 content (‖x‖-growth along the trajectory), nothing about α, p_{Lε} or the exponent.
   - `IsGradField U gU` omitted: accepted as a generalisation (fewer premises). I checked that the generalised main statement is still true along the source route (nothing in 946-971 uses gU = ∇U; see item 5), so the omission cannot manufacture a paper error, and the source-faithful special case follows by instantiation. DEFS_gate recommendation (line 30/68) is satisfied by this explicit acceptance; record the generalisation in RESULTS.
2. **Conclusion — PASS.** `Tendsto (fun q => accProb U gU eps L q.1 q.2) (tailMomFilter d δ) (𝓝 0)`: α → 0 along ‖x_0‖→∞ restricted to {‖p_0‖ ≤ ‖x_0‖^δ}; neither weakened nor strengthened. `accProb` = 1 ∧ (π(x_{Lε})/π(x_0))·exp(½‖p_0‖²−½‖p_{Lε}‖²) (TEX:368), equal to TEX:949 (S1).
3. **Quantifiers — PASS.** N5: the statement has no η; "for any δ<1, lim … = 0" is per-δ, so δ fixed after all other data is the literal reading. N3: (19) is instantiated with the leapfrog L, which is what TEX:874/876 mean (L is the fixed HMC step count of Thm 5.14). U, gU, ε, L are fixed before δ and the limit. For d = 0 the filter is ⊥ and the statement is vacuous, harmless.
4. **Domains/details — PASS.** E d = EuclideanSpace (TEX:192-194); real-valued α (no ℝ≥0∞ truncation); `‖x0‖ ^ δ` is `Real.rpow` with base ≥ 0, fine for any real δ<1 (including δ ≤ 0); limit is pointwise along a filter, no a.e. issues.
5. **Step obligations — PASS.** All checked for truth as stated:
   - S1 true (exp(−a)/exp(−b)·exp(c) = exp(b−a+c)). S2 true for L ≥ 1 (summing p_{n+1} = p_n − (ε/2)g(x_n) − (ε/2)g(x_{n+1})); false for L = 0, and it carries `hL`. S3 true (triangle inequality, ε>0).
   - S4a true: (b) gives 2‖x_{(j)}‖ ≤ ‖x_{(j+1)}‖ and, by telescoping (b), ‖x_{jε}‖ ≥ 2^j‖x_0‖ ≥ ‖x_0‖ ≥ C/2 for large ‖x_0‖; iterate (18). (Docstring attributes ‖x_{jε}‖ ≥ 2^j‖x_0‖ to (a); (a) is only for the fixed L, the bound actually follows from (b). Comment-only, no change required.)
   - S4b true (reindex k = L−i; the x_0 term (ε/2)(1/3)^L G ≤ ε(1/3)^L G; G ≥ 0). S5 true (γ_L = 3^{−L} > 0, identity). S6 true (0 ≤ a−b ≤ P; `hb` redundant, harmless). S7, S8 pure algebra, true. 
   - S9 true with `M ≥ 1`: second inequality from (a) and M ≥ 1; first from (17) at x_{Lε} with ‖x_{Lε}‖ ≥ 2^L‖x_0‖ → ∞ (constant K = 4M·3^L/ε). The restriction M ≥ 1 is necessary (for M = 0 and x_0 ≠ 0 the second inequality is false), and the proof only needs some large M, so it does not obstruct the source route.
   - S10 true (with γ = 3^{−L}, b = ‖p_0‖ ≤ ‖x_0‖^δ, εγG/4 ≥ M2^L‖x_0‖: ‖p0‖²−‖pL‖² ≤ εγG(‖x_0‖^δ − M2^L‖x_0‖) ≤ −‖x_0‖² for M2^L ≥ 2 and ‖x_0‖ large). It carries `hL` (false for L = 0).
   - S11 true (exponent ≤ U(x_0)−U(x_{Lε})−½‖x_0‖² eventually; map q ↦ (q.1, x_{Lε}) tends into the (19) filter because (a) puts it eventually in the principal set). S12 true (exp → 0, min 1 → 0, via S1).
   - No smuggling: no step assumes the exponent bound or α → 0; S11/S12 take earlier-step outputs as explicit premises, which is the intended chaining.
   - Assembly: main = S1 + S10 + S11 + S12; S10 from S3–S9; all premises of the steps are available in `L03_main`. The chain closes.
6. **External parameters — PASS.** Only `L03_L02Consumed`, provenance (p), declared in `L03Stmt.lean`, `namespace Paper.L03`, name `<ID>_<PredID>Consumed`, no clash (the copy importing L02Stmt compiles). Detailed ruling:
   - Part (a) = `Paper.L02.ConclFixedDelta gU eps L`, exactly the fixed-δ reading of L02's printed statement (TEX:900), used at TEX:968 and for the region of (19) at TEX:970 (and stated by the source itself at 937). Not stronger.
   - Part (b) is **literally** the conclusion of `Paper.L02.L02_S10` instantiated at this L (same quantifier order ∀δ<1 ∃η ∀x0 p0 … ∀ i∈[1,L]), and is the claim the source prints at TEX:934 inside L02's proof. It is needed at TEX:954: getting the weights (1/3)^{L−i} from (18) requires consecutive doubling; (a) at the fixed L gives only one comparison. It is stronger than L02's *printed statement* but not than what the paper asserts and what L02's proof establishes; it is not goal-shaped (no α, momentum or exponent content, nothing that first appears in L03's proof). Approved as (p) with the registry note below. (Part (a) is redundant given (b) by `L02_S11`-style telescoping; harmless.)
   - Applicability at reconnection: (b) ← `L02_S10` (needs `L02_L01Consumed` = L01 `ConclFixedDelta`, L01 FINAL AUDIT PASS/UNCONDITIONAL; `0 < eps`; (17); (18)) — all available in `L03_main` (`heps`, `hexp`, `hosc`). (a) ← `L02_main_fixedDelta_osc` / `L02_S11`∘`L02_S10`, same premises. Note: L02's verdict-bearing `L02_main_fixedDelta` lacks (18) and stops at S8b; reconnection must go through the (18)-variant, which is legitimate here because (18) is a hypothesis of L03. If L02 ends ISSUE/UNFINISHED, this clause counts as (iv) (priority A on the worksheet).
   - Mathlib evidence: n/a (paper's own lemma).
7. **Doubts about the source** — preliminary classes only (no ruling here):
   - TEX:953-957 with TEX:934/899-901: L03 applies (18) to consecutive pairs, which needs the doubling ‖x_{iε}‖ ≥ 2‖x_{(i−1)ε}‖ that L02 only proves, never states (INVENTORY X5); L02 itself uses (18) without listing it. Preliminary EXPOSITION_GAP (L03 assumes (18), so no assumption gap here) — dispatch pv-issue-checker.
   - TEX:954: the printed sum pairs (1/3)^i with ‖∇U(x_{iε})‖ (index reversed); the aggregate inequality is correct after reindexing. Preliminary EDITORIAL.
   - TEX:957-959: squaring needs (εγ_L/2)‖∇U(x_{Lε})‖ ≥ ‖p_0‖, unstated but immediate from 966-969. FAIR_IMPLICIT_STEP.
   - TEX:960: δ_L undefined (= γ_L). EDITORIAL (N2).
   - TEX:966-970: "for any M<∞" with "M‖x_{Lε}‖ ≥ 2^L‖x_0‖" is false for M < 1; the argument needs only some sufficiently large M (depending on L), and the passage to "≤ −‖x_0‖²" is not spelled out. Preliminary EXPOSITION_GAP (possibly EDITORIAL) — dispatch pv-issue-checker.
   - L = 0: lemma false (α ≡ 1), but excluded by context (T = Lε > 0, TEX:876; L is a count of leapfrog steps). Not a paper issue; handled by TFA-1.

## TFA table

| Premise | Ruling | Reason |
|---|---|---|
| `hL : 1 ≤ L` (main, S2, S3, S4b, S10) | APPROVED (TFA) | Derivable from context: Thm 5.14 (TEX:876) fixes T = Lε > 0 with ε > 0 (TEX:336), hence L ≥ 1; L = 0 (no leapfrog step) is a degenerate case the source never discusses. Not DOMAIN_CLARIFICATION: the context resolves it. |
| `hM : 1 ≤ M` (S9, internal step) | APPROVED (encoding of "any M<∞") | S9 is false for M < 1; the proof uses a large M, so this restricts the source's free constant to the range it uses. Not a premise of the main theorem. |
| `hba : b ≤ a` (S6) | APPROVED (FAIR_IMPLICIT_STEP) | Needed for squaring; holds for large ‖x_0‖ by S9. |
| Omission of `IsGradField U gU` | APPROVED (generalisation) | Fewer premises; generalised statement checked true. |

## External parameters

| Name | Type | Ruling |
|---|---|---|
| `Paper.L03.L03_L02Consumed` (L03Stmt.lean:25-28) | (p), predecessor L02; source_loc TEX:899-901 (part a) and TEX:934 (part b, proof-internal claim of L02); Lean sources `Paper.L02.ConclFixedDelta`, `Paper.L02.L02_S10` | APPROVED. Registry must state that part (b) is a proof-internal clause of L02 (not its printed statement), reconnected via `L02_S10` / `L02_main_fixedDelta_osc` using L03's (18). |

## Required changes

None. Non-binding: S4a docstring should say ‖x_{jε}‖ ≥ 2^j‖x_0‖ comes from telescoping (b), not from (a).

## Statement snapshot

`pv_work/probes/gate/L03/gate_L03_stmtcopy.lean` (log `pv_work/logs/gate_L03_stmtcopy_1.log`, exit=0, sorry_warnings=0):
```
TYPE HASHES (current file, 1 declarations)
Paper.L03.L03_L02Consumed|def|th=1855146743|vh=1680933595|bi=ieee
```
`pv_work/probes/gate/L03/gate_L03_draftcopy.lean` (log `pv_work/logs/gate_L03_draftcopy_1.log`, exit=0, sorry_warnings=14):
```
TYPE HASHES (current file, 14 declarations)
Paper.L03.L03_S10|thm|th=3390298265|vh=-|bi=ieeeeeeeeee
Paper.L03.L03_S11|thm|th=1239329597|vh=-|bi=ieeeeeeeeee
Paper.L03.L03_S12|thm|th=1718148883|vh=-|bi=ieeeeee
Paper.L03.L03_S1|thm|th=746365136|vh=-|bi=ieeeeee
Paper.L03.L03_S2|thm|th=3090615228|vh=-|bi=ieeeeee
Paper.L03.L03_S3|thm|th=3920446577|vh=-|bi=ieeeeeee
Paper.L03.L03_S4a|thm|th=200682339|vh=-|bi=ieeeeeee
Paper.L03.L03_S4b|thm|th=1773759309|vh=-|bi=ieeeeeeeeeeeee
Paper.L03.L03_S5|thm|th=619142150|vh=-|bi=eee
Paper.L03.L03_S6|thm|th=2443879956|vh=-|bi=eeeeee
Paper.L03.L03_S7|thm|th=1893876815|vh=-|bi=eeee
Paper.L03.L03_S8|thm|th=2007435786|vh=-|bi=eeeeee
Paper.L03.L03_S9|thm|th=3097158171|vh=-|bi=ieeeeeeeeee
Paper.L03.L03_main|thm|th=138878381|vh=-|bi=ieeeeeeeeeeee
```

## Overall verdict

Statement faithful; one consumed (p) clause approved with registry note; TFA `1 ≤ L` approved; no false-as-stated obligations.

STATEMENT GATE: PASS
