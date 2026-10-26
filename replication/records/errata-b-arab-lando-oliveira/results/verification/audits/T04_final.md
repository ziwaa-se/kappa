# T04 final audit (Theorem 4.12, thm:inv-nwu-fsub)

- Auditor: pv-auditor (independent subagent, Claude Opus), final-audit mode
- Date: Tue Oct 13 01:45:41 EDT 2026 (from `date`)
- Audited object: `pv_work/T04.lean` (no gap file; DEFS: none; `T04Stmt.lean` declares nothing)
- Gate snapshot: `verification/audits/T04_gate_r2.md` (STATEMENT GATE: PASS; round 1 `T04_gate.md` PASS_WITH_AMENDMENTS)
- Source read directly: `source/SuperParetoPaper-v12.tex` F:111, F:113, F:119-125, F:344-356, F:376-386
- Read: `pv_work/T04.lean` (full), `T04Stmt.lean`, `L01Stmt.lean`, `L02Stmt.lean`, prover notes, both gate reports

## 1. Mechanical checks (run by me)

`python3 scripts/pv_audit_mech.py T04` -> `verification/audits/T04_mech.md`, **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile T04 | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL |
| 3 | PVTools hash | PASS |
| 4/4a | fingerprints vs gate r2 (7 gated theorems) | PASS, all th/vh/bi identical |
| 6 | `#pv_axioms T04` | PASS, all standard |
| 7 | `#pv_walk T04` | PASS, no sorryAx; propext, Classical.choice, Quot.sound only |
| 11 | traced conditions | none |
| 12 | last writer | pv-prover |

No gap file, so item 2 of the procedure (gap-file `example` checks) does not apply.

## 2. Per-theorem conditionality (item 10)

| Theorem | UNUSED | Assessment |
|---|---|---|
| `T04_main` | none (re-confirmed in my probe: μ, instance, h all USED) | no external parameter exists |
| `T04_S4z` | `hx`, `hy` | harmless positivity premises in a step obligation, specified by the gate; not external parameters |
| `T04_S5` | `[IsProbabilityMeasure μ]` | harmless; not an external parameter |
| S1, S2, S3, S4 | none | — |

No `def … : Prop` tools and no consumed predecessor clauses. Conditions: none.

## 3. Infrastructure (item 8, item 9)

| Constant | Record | Check |
|---|---|---|
| `Paper.L01.F`, `IsInvSub`, `SubadditiveOn`, `invDist` | `L01_gate.md` (named individually, fingerprints lines 92-96; STATEMENT GATE: PASS) | definitions only; I re-read them against F:111, F:113, F:121-124: faithful |
| `Paper.L02.IsSuperHeavyTailed`, `SubadditiveOnE`, `negLogInv` | `L02_gate_r2.md` (fingerprints lines 39-41; PASS) and `L02_final.md` | definitions only; re-read against F:344-349: faithful, EReal `+∞` for `-Log 0` |
| private `F_le_one`, `F_nonneg` (helpers, item 9) | audited here | one-line wrappers of `ProbabilityTheory.cdf_le_one` / `cdf_nonneg`; true, technical, no new mathematics |

No project theorem is consumed (only definitions). No constant without an individual record remains.

## 4. Route fidelity (sentence by sentence)

| Source | Lean | Assessment |
|---|---|---|
| F:381 "super-heavy-tailed means `Log F_X(1/x)` superadditive, that is `Log F(1/(x+y)) ≥ Log F(1/x)+Log F(1/y)`" | `T04_S1`: unfold `negLogInv` in `h.2 x y`; if `F(1/(x+y))=0` the LHS is `⊤` against a finite RHS (contradiction), otherwise `EReal.coe_le_coe_iff` + `linarith` | faithful. FAIR_IMPLICIT_STEP: "-Log subadditive ⟺ Log superadditive" (negation) and the positivity of `F(1/(x+y))`, which follows from finiteness of the RHS |
| F:381-382 "which implies `F(1/(x+y)) ≥ exp(Log F(1/x)+Log F(1/y))`" | `T04_S2`: `exp_le_exp` + `exp_log` | faithful |
| F:383 "`≥ F(1/x)+F(1/y)-1`, as the exponential is superadditive" | `T04_S3` (`e^a+e^b-1 ≤ e^{a+b}` for `a,b ≤ 0`, via `(1-e^a)(1-e^b) ≥ 0`) and `T04_S4` (apply with `a,b = log F ≤ 0`, `exp_log`) | faithful to the inequality the source uses. EDITORIAL: "exponential is superadditive" literally means `e^{a+b} ≥ e^a+e^b`, false at `a=b=0`; the intended fact is superadditivity of `t ↦ e^t-1` on `(-∞,0]`. Filled in fairly (FAIR_IMPLICIT_STEP) |
| zero case `F(1/x)=0` or `F(1/y)=0` (source chain read with `Log 0 = -∞`, `exp(-∞)=0`) | `T04_S4z`: `0 ≤ F ≤ 1`, `linarith` | FAIR_IMPLICIT_STEP (gate ruling, I concur). Additionally I note: under super-heavy-tailedness this case never occurs for `x,y>0` (if `a = inf{x>0: F(1/x)=0}` existed it would be `>0`, and `x=y=0.6a` would give `⊤ ≤ finite`), so the branch is dead code under `h`; no gap either way |
| F:384-385 "going to the complementary sets … `Fbar(1/x)` subadditive, that is, X is ITS" | `T04_S5`: `F(0)=0` from `h.1` (the qualifier in Def 4.9, F:346, same as Def 2.2, F:124); subadditivity of `invDist` is `hchain` rewritten by `linarith` | faithful. FAIR_IMPLICIT_STEP: `F_X(0)=0` carried over from the definition |
| assembly | `T04_main`: case split on positivity of `F(1/x)`, `F(1/y)`; S4+S2 or S4z; then S5 | matches the source chain |

No change of route, no stronger result used, no cited result. Private helpers are technical only.

## 5. Non-vacuity

Probe `pv_work/probes/auditor/T04/aud_T04_final.lean` (`RESULT aud_T04_final mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log `pv_work/logs/aud_T04_final_1.log`):
- nontrivial law ν with cdf `x⁺/(1+x⁺)` (built as `StieltjesFunction.measure`, as in the L02 final audit), `IsSuperHeavyTailed ν` via `L02_S3` (audited in `L02_final.md`), then `T04_main ν` gives `IsInvSub ν`; S1, S2, S4, S5 instantiated on ν, S3 at `a=-1, b=-2`;
- S4z hypothesis satisfied by `dirac 1`, `x=y=2` (`F(1/2)=0`, proved via `cdf_eq_real`);
- `#print axioms` of `ν_ITS` and `dirac_F_half`: propext, Classical.choice, Quot.sound.

## 6. Status for the authors

Verified: Theorem 4.12 (super-heavy-tailed ⇒ ITS) in full, along the printed proof, with no external parameters or predecessor clauses.
Depends on: nothing beyond Mathlib (definitions Def 2.2, Def 4.9 only).
Source: correct; one EDITORIAL slip at F:383 ("the exponential is superadditive" should read "e^t−1 is superadditive on (−∞,0]"); the `Log 0` case is a fair implicit step.

## FAIL items

None.

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
CONDITIONS: none
