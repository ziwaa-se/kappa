# P02 final audit

- Auditor: pv-auditor (independent subagent, new session)
- Date: Mon Oct 12 22:22:15 EDT 2026
- Result: P02 = Proposition `prop:uniform`, source/main.tex:73-75 (statement), 77-79 (proof)
- Audited object: `pv_work/P02.lean` (no gap file)
- Mechanical report: `verification/audits/P02_mech.md`, run by me (`python3 scripts/pv_audit_mech.py P02`): **MECH CHECKS: PASS**

## Mechanical checks (from the mech report)

| # | Check | Result |
|---|---|---|
| 1 | compile `P02` | PASS (exit=0, 0 errors, 0 sorry) |
| 2 | private rebuild, sha256 | PASS, IDENTICAL |
| 3 | PVTools hash | PASS |
| 4 | gated fingerprints vs `P02_gate.md` (4 decls) | PASS, identical |
| 5 | `Defs` vs `DEFS_gate.md` | PASS, identical |
| 6 | `#pv_axioms P02` | PASS, all standard |
| 7 | `#pv_walk P02` | PASS, no sorryAx; axioms propext, Classical.choice, Quot.sound |
| 9 | helpers not in snapshot | none |
| 10 | `#pv_hyp_usage` | no UNUSED hypotheses (S1: n, hn, p all used; S2/main: none) |
| 11 | traced conditions | none |
| 12 | last writers | prover for `P02.lean`, drafter for `P02Stmt.lean` |

## Infrastructure (item 8)

| Constant | Record | Individual coverage |
|---|---|---|
| `Paper.DEFS.V` | `DEFS_gate.md` | defined p*(1-p)/n, matches main.tex:27 |
| `Paper.L01.L01_S1`, `L01_S2`, `L01_main` | `L01_final.md` (FINAL AUDIT: PASS) | each named individually (lines 44-46) |
| `Paper.L01.Conclusion` (+ `.bound`, `.mk`) | `L01_gate.md` | L01 statement structure |
| `Paper.P02.Conclusion` | `P02_gate.md` | gated statement |

No constant without a record. Interface consumed: `L01_main` (.bound field) only; individually audited.

## Per-theorem conditionality

No external parameters, no `def … : Prop` tools, no recorded debt. Hypotheses `hn : 1 ≤ n` in `P02_S1` are the source's own hypothesis (main.tex:24, 74), passed to `L01_main`. CONDITIONS: none.

## Route fidelity

| Source | Lean | Ruling |
|---|---|---|
| main.tex:78 "By Lemma lem:quarter" | `P02_S1 := (L01_main n hn p).2`, i.e. V_n(p) ≤ 1/(4n) | faithful; uses exactly lem:quarter (main.tex:39), which is stated for all real p, so the range p ∈ ℝ of main.tex:74 is covered |
| main.tex:78 "C = 1/4 works" | `P02_S2`: C := 1/4, `div_div` rewrites (1/4)/n = 1/(4n), then S1 | faithful; FAIR_IMPLICIT_STEP: the identity (1/4)/n = 1/(4n), filled by `div_div` |
| assembly | `P02_main`: drop the `C = 1/4` conjunct of S2 | faithful |

No route change, no stronger result used, no helper lemmas.

## Non-vacuity

Probe `pv_work/probes/auditor/P02/auditor_P02_nonvac.lean` (`scripts/pv_lean.sh probe`, exit=0, 0 errors, 0 sorry; log `pv_work/logs/auditor_P02_nonvac_2.log`): (a) instance at n = 3, p = 1/2 obtained from `P02_main`; (b) C = 0 fails (not a tautology); (c) every working C satisfies C ≥ 1/4, so the source's witness 1/4 is sharp.

## Status for the authors

Prop. prop:uniform (main.tex:73-79) is verified in Lean along the source route, from Lemma lem:quarter (L01, itself verified unconditionally); no external inputs.
Source assessment: correct as stated; no errors, gaps or ambiguities found.

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
CONDITIONS: none
