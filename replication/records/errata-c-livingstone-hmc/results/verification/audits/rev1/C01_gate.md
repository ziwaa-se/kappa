# C01 statement gate (Corollary 2.3, part (ii) only; revision 1 re-draft)

- Reviewer: pv-gate (independent subagent, opus)
- Date: Tue Oct 13 10:41:33 EDT 2026
- Scope: part (ii) only, as set by the user. Part (i) (TEX:234, proof TEX:838-885) is not encoded and not reviewed.
- Files reviewed (sha256 from `python3 scripts/pv_snapshot.py hash`):
  - `pv_work/C01Stmt.lean` 0e42cbb2e3490a0e1090e611ffd359b3be3c0b2276fc1a57a3e58ba751e7d212
  - `pv_work/C01Draft.lean` 85159b84e954329fa1da71281344c814f79cd8dd430639a942ab9ef626f0b306
  - `pv_work/notes/C01_draft_notes.md` a4743dbbbe23c1eb3b1639d4e365fb1af9ed6663a2d409c72a2d4a6c993c7751 (used only as leads)
  - Imports read in full: `pv_work/Defs.lean`, `pv_work/T01Stmt.lean`, `pv_work/T02Stmt.lean` (both pre-revision/stale; see item 6).
- Compilation: `scripts/pv_lean.sh check C01Draft` gives `RESULT C01Draft mode=check exit=0 errors=0 sorry_warnings=10 nonstandard_axiom_lines=0 log=pv_work/logs/C01Draft_4.log`. The 10 sorries are C01_main plus the 9 obligations S1a, S1b, S1c, S2, S3, S4, S5a, S5b, S6.

## Source quotations (read directly from source/geo_erg_HMC_v3.1.tex)

- TEX:192: `\X = \R^d`, Euclidean norm; "π(·) a finite target measure"; 𝔏 a distribution on Z_+.
- TEX:223-227: class E(β,α): "π(x) ∈ C^1(R) and for all |x|>M for some M<∞ ... π(x) ∝ exp(-α|x|^β) for some α,β>0".
- TEX:229-239: "For the exponential family class of models E(β,α), under assumption A1 the following results hold: ... (ii) If β<1 or β>2, then the Hamiltonian Monte Carlo method will not produce a geometrically ergodic chain".
- TEX:320: π(x) ∝ e^{-U(x)} for some U: X → [0,∞), U = -log π.
- TEX:393 (A1): P_𝔏[L=1]>0 and an exponential moment condition.
- TEX:208-219 (Thm 2.2): (i) (17) and (18), (19) hold; (ii) ‖∇U(x)‖ ≤ M for all x and E_π[e^{s‖x‖}] = ∞ for every s>0. Either one rules out geometric ergodicity.
- TEX:895-908 (thm:light, revised): (17); "a fixed C<∞ such that whenever ‖y‖ ≥ 3‖x‖ ≥ C then ‖∇U(y)‖ ≥ 3‖∇U(x)‖" (18); (19) with 2^L; conclusion for "fixed integration time T = Lε".
- TEX:934-940: the step from fixed L to random 𝔏 by dominated convergence (proof of thm:light).
- TEX:1103-1109 (thm:heavy, part (ii)): ‖∇U‖ < M for all x means ∫e^{s‖x‖}π(dx) < ∞ for some s>0 is necessary.
- TEX:804-836: the proof of (ii). β<1: "direct consequence of part (ii) of Theorem thm:negative" (806). β>2: tail gradient (807-810), (17) (811-816), (18) with C>3M and ratio ≥ 3^{β-1} > 3 (817-824), (19) via the display at 828-833, "Theorem thm:light applies conditional on each fixed L, and dominated convergence ... gives the corresponding result under A1" (834-836).
- I confirm the line ranges the coordinator gave (statement 229-239, proof 804-886; part (ii) is 804-836).

## Item 1. Hypotheses: PASS
- `InExpFam`: α>0, β>0, `ContDiff ℝ 1 (piDens U)`, ∃M c, c>0, with π = c·exp(-α‖x‖^β) for ‖x‖>M. This matches TEX:223-226, with "∝" written as the constant c>0 and d=1 written as `E 1`.
- Positivity π = e^{-U} comes from the project-wide convention of TEX:320 (U real valued). Representation only.
- U ≥ 0 (TEX:320) is dropped. This is harmless (EDITORIAL). Under `InExpFam` U is continuous and U → +∞ in the tails, so U is bounded below. All objects involved (`accProb` ratios, normalised `targetMeas`, (17)-(19), ∇U) are invariant under adding a constant to U.
- `IsGradField U gU` only links gU to ∇U (TEX:320 "U differentiable"). It already follows from π ∈ C^1 with π > 0.
- `hπ` (∫π < ∞) is TEX:192 "finite target measure", and it also follows from `InExpFam`.
- `heps : 0<eps` is TEX:175. `hL : 1 ≤ L` is L ∈ Z_+ (TEX:192).
- No hidden hypotheses in structures, classes or `variable`s. No hypothesis is conclusion-shaped. `hT01` is the predecessor clause (item 6).
- "under assumption A1" (random 𝔏) is not encoded. See item 3/4: this is a scope restriction, not an extra premise.

## Item 2. Conclusion: PASS (with scope note)
- `C01Concl.partII : (β < 1 ∨ 2 < β) → ¬ GeomErgodic U gU eps L`. This is TEX:238 exactly, for HMC with a deterministic number L of steps.
- Scope: the printed statement is "under A1" (random 𝔏 with P[L=1]>0). The Lean statement is the fixed-L claim for every L ≥ 1 and every ε > 0. The source asserts this fixed-L claim itself: at TEX:834 for β>2, and through Thm 2.2(ii)/thm:heavy, whose proof (TEX:1112-1120) is for fixed L, for β<1. The passage to random 𝔏 (TEX:834-836) is not covered, which agrees with the project convention (T01/T02, INVENTORY X2). **The final verdict must not claim the "under A1" form.**

## Item 3. Quantifiers and constants: PASS
- α, β, U are fixed by the class. ε>0 and L≥1 are universal. M and c are existential inside `InExpFam`, as at TEX:223 ("for some M<∞"). There are no other constants. The C of (18) is existential per gU, as at TEX:900.

## Item 4. Domains and details: PASS
- d=1 (TEX:223 "C^1(R)"). ‖x‖ = |x 0| on `E 1`.
- rpow `‖x‖ ^ β` is applied to nonnegative bases only.
- `E_π` is the normalised `targetMeas` (T02Stmt). Its normalisation is finite and nonzero under `InExpFam`, so S1b has no `ENNReal` inverse trap (if ∫π = ⊤ then targetMeas = 0, but `InExpFam` already forces ∫π < ⊤).
- `ofReal (exp …)` is nonnegative, so there is no truncation issue.
- (19) `HypOscillation2` (Defs) matches the revised TEX:905-907 (still 2^L). The Defs docstring line numbers are stale; that is not a content issue.

## Item 5. Step obligations: PASS (all true as stated)
| Step | Source | Correspondence | True as stated? | Notes |
|---|---|---|---|---|
| S1a | 806 | ‖∇U‖ ≤ M' on all of X (Thm 2.2(ii), first hyp.) | Yes. π ∈ C^1 and π > 0 make ∇U = -π'/π continuous, hence bounded on [-max(M,1), max(M,1)]. In the tail \|∇U\| = αβ\|x\|^{β-1} ≤ αβ·max(M,1)^{β-1}. If M < 0, `InExpFam` with β<1 is vacuous (not C^1 at 0). | The source writes no verification. Preliminary FAIR_IMPLICIT_STEP (C^1 plus compactness). |
| S1b | 806 | E_π e^{s‖x‖} = ∞ for all s>0 | Yes. The tail integrand c·e^{s\|x\|-α\|x\|^β} → ∞ for β<1, and the normalisation is finite and positive (derivable, no `hπ` needed). | Not written in the source. Preliminary FAIR_IMPLICIT_STEP. |
| S1c | 806 | apply Thm 2.2(ii) | Yes, given clause (b) of `hT01` and S1a, S1b. | none |
| S2 | 807-810 | tail gradient formula | Yes, for M' = max(M,0). Then U = α\|x\|^β − log c on the open tail and the derivative is αβ sgn(x)\|x\|^{β-1}. It is existential in M. | FAIR_IMPLICIT_STEP |
| S3 | 811-816 | (17) | Yes. In the tail ‖gU x‖/‖x‖ = αβ\|x\|^{β-2} → ∞ (β>2, α>0). | none |
| S4 | 817-824 | revised (18), `HypOscillations3` | Yes. Take C = 3·max(M,0)+1. Then \|x\| > max(M,0) and \|y\| ≥ 3\|x\| > M, so both points are in the tail and \|gU y\|/\|gU x\| = (\|y\|/\|x\|)^{β-1} ≥ 3^{β-1} > 3 exactly when β > 2. The source's "C>3M" needs M ≥ 0 implicitly so that x ≠ 0 and the ratio is defined (FAIR). | **Old B02 does not recur.** With the revised (18), 3^{β-1} > 3 holds for every β > 2. The pre-revision problem (factor 2: 2^{β-1} ≥ 3 fails for 2<β<1+log_2 3) disappears. |
| S5a | 825-833 | display bound | Yes, R = max(M,0). U x − U y = α(\|x\|^β − \|y\|^β) ≤ −α((2^L)^β − 1)\|x\|^β since \|y\| ≥ 2^L\|x\| > M and β > 0. ((2:ℝ)^L)^β = 2^{Lβ}. | none |
| S5b | 832-834 | (19) for each fixed L | Yes, from S5a: the bound → −∞ along the filter. | FAIR_IMPLICIT_STEP |
| S6 | 834 | thm:light for fixed L | Yes, given clause (a) of `hT01` and S3, S4, S5b. | none |

- Assembly: main = S1c (β<1) ∨ S6 (β>2), with S2 feeding S3 and S4. The obligations together give `C01Concl`. No obligation smuggles in the target. S1c and S6 are the target restricted to one branch, but their stated route is the consumed clause, with S1a/S1b and S3/S4/S5b as the hypotheses, as the source does.
- Not encoded (non-Lean): TEX:834-836, dominated convergence from fixed L to 𝔏 under A1. This is recorded as outside the encoding, not as a paper issue. Preliminary classification: FAIR_IMPLICIT_STEP (acceptance ≤ 1 and the law is independent of x), with the same argument at TEX:934-940.

## Item 6. External parameters / consumed clause: PASS
- `C01_T01Consumed`, provenance (p), predecessor T01 (Thm 2.2, TEX:208-219; part (i) via thm:light, TEX:895-908).
  - (a) For d=1, every U, gU, ε>0, L≥1 with `IsGradField`, ∫π<∞: (17) ∧ `HypOscillations3` ∧ (19)_L implies ¬GeomErgodic. This matches Thm 2.2(i) (TEX:213) with the **revised** (18) (TEX:900-903) and (19) as printed (TEX:905-907), for fixed T = Lε (TEX:908). It is faithful to the revised source and independent of the stale `T01Stmt.HypPartI` (which still uses the 2‖x‖ form).
  - (b) `HypPartII U gU` (‖∇U‖ ≤ M everywhere, and E_π e^{s‖x‖} = ∞ for all s>0) implies ¬GeomErgodic. This matches Thm 2.2(ii) (TEX:217) and thm:heavy (TEX:1103-1109; < M and ≤ M are equivalent up to M+1).
  - Not stronger than the source: it is a specialisation to d=1 and deterministic L (fixed T, as in thm:light and the thm:heavy proof). The dropped U ≥ 0 does not strengthen it. Given ∫e^{-U} < ∞, in (a) U → +∞ in both tails (the gradient grows superlinearly and the Darboux property makes the sign constant on each tail), and in (b) U is Lipschitz, so U is bounded below in either case and a shift gives a U ≥ 0 instance of the printed theorem.
  - It is not goal-shaped: it is the predecessor's general statement, not C01's conclusion for this U.
  - Applicability here: (b) through S1a and S1b, (a) through S3, S4 and S5b. Standing conventions come from the main hypotheses. Stated in the docstring and the notes.
  - Naming and location: declared in `C01Stmt.lean` in `namespace Paper.C01`, named `C01_T01Consumed`. No collisions: `HypOscillations3`, `InExpFam`, `TailGrad`, `C01Concl` and `C01_T01Consumed` occur only in C01 files and in old probe or superseded copies.
- `HypOscillations3` (local) agrees symbol for symbol with revised TEX:900-903: `3‖x‖ ≤ ‖y‖`, `C ≤ 3‖x‖`, `3‖gU x‖ ≤ ‖gU y‖`. Frozen `Defs.HypOscillations` (`2‖x‖`) is the pre-revision text and correctly is not used. Declaring it locally is acceptable because it is a definition, not an external parameter.
- No mathlib-absence claims are made, so no `#check` is needed.
- **Coordinator caution (no change required now):** `C01Stmt` imports `GeomErgodic`, `targetMeas` (T02Stmt) and `HypPartII` (T01Stmt) from the stale pre-revision Stmt files. The `th`/`vh` hashes below lock C01's own declarations but not the content of these imported definitions. If the T01/T02 re-draft changes any of them, or replaces (18) by a new shared definition, C01 needs an amendment check on the affected parts. At reconnection, clause (a) must be derived from the re-drafted T01 statement, if needed through an equivalence with that statement's form of (18).

## Item 7. Doubts about the source: no dispatch required
- S1a, S1b (TEX:806): the hypotheses of Thm 2.2(ii) are not verified in writing. Preliminary FAIR_IMPLICIT_STEP (standard calculus and integral). Dispatch pv-issue-checker only if the prover fails on a substantive point.
- TEX:834-836 random-𝔏 passage: not encoded (scope). Preliminary FAIR_IMPLICIT_STEP. It is not a paper issue.
- TEX:817-824 (old B02): confirmed not to recur under the revised (18).
- I make no ruling on whether the paper is right.

## TFAs ruled on
| Premise | Ruling | Reason |
|---|---|---|
| (none proposed) | n/a | `hπ`, `IsGradField`, `heps` and `hL` are standing conventions (TEX:192, 175, 320), all derivable or definitional. Dropping U ≥ 0 is EDITORIAL. |

## External parameters
| Name | Provenance | Ruling |
|---|---|---|
| `C01_T01Consumed` | (p), T01 = Thm 2.2 (TEX:208-219), part (i) in the revised form of thm:light (TEX:895-908), part (ii) = TEX:217 / thm:heavy | Approved |

## Required changes
None.

## Statement snapshot
Stmt copy `pv_work/probes/gate/C01/gate_C01_stmtcopy.lean` (log `pv_work/logs/gate_C01_stmtcopy_2.log`, exit=0, sorry_warnings=0); `diff` against the original shows only the added `import PVTools` and `#pv_type_hashes_here` lines:
```
TYPE HASHES (current file, 12 declarations)
Paper.C01.C01Concl.casesOn|def|th=3193051509|vh=4189218261|bi=iiiiiiee
Paper.C01.C01Concl.mk|ctor|th=639128161|vh=-|bi=iiiiie
Paper.C01.C01Concl.noConfusionType|def|th=3488882267|vh=1443577468|bi=iiiiieee
Paper.C01.C01Concl.noConfusion|def|th=3124602264|vh=2208376827|bi=iiiiiiiie
Paper.C01.C01Concl.partII|thm|th=2894599874|vh=-|bi=iiiiiee
Paper.C01.C01Concl.recOn|def|th=3193051509|vh=1804189570|bi=iiiiiiee
Paper.C01.C01Concl.rec|rec|th=3320441646|vh=-|bi=iiiiiiee
Paper.C01.C01Concl|induct|th=864004865|vh=-|bi=eeeee
Paper.C01.C01_T01Consumed|def|th=3944470172|vh=7859440|bi=
Paper.C01.HypOscillations3|def|th=3371666640|vh=2544497906|bi=ie
Paper.C01.InExpFam|def|th=1658877937|vh=365524624|bi=eee
Paper.C01.TailGrad|def|th=3334154647|vh=1193412124|bi=eeee
EXIT=0
```
Draft copy `pv_work/probes/gate/C01/gate_C01_draftcopy.lean` (log `pv_work/logs/gate_C01_draftcopy_2.log`, exit=0, sorry_warnings=10); `diff` shows only the two added lines:
```
TYPE HASHES (current file, 10 declarations)
Paper.C01.C01_S1a|thm|th=3960329011|vh=-|bi=iiiieee
Paper.C01.C01_S1b|thm|th=408516318|vh=-|bi=iiieeee
Paper.C01.C01_S1c|thm|th=227541489|vh=-|bi=iiiiiieeeeeee
Paper.C01.C01_S2|thm|th=3439575683|vh=-|bi=iiiiee
Paper.C01.C01_S3|thm|th=3964483344|vh=-|bi=iiiieee
Paper.C01.C01_S4|thm|th=3640951565|vh=-|bi=iiiieee
Paper.C01.C01_S5a|thm|th=109083080|vh=-|bi=iiieeee
Paper.C01.C01_S5b|thm|th=2451669095|vh=-|bi=iiieeee
Paper.C01.C01_S6|thm|th=1714459723|vh=-|bi=iiiiiieeeeeee
Paper.C01.C01_main|thm|th=3482317072|vh=-|bi=iiiiiieeeeee
EXIT=0
```

## Overall verdict
The statement is faithful to TEX:229-239 part (ii), restricted to deterministic L; "under A1" is not covered and must be reported as such. All obligations are true as stated. The consumed clause is faithful to Thm 2.2 with the revised (18). Re-check if T01Stmt/T02Stmt imported definitions change.

STATEMENT GATE: PASS
