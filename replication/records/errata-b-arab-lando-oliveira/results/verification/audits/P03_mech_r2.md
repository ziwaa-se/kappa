# Mechanical audit checks — P03 (`P03`)

Run by: pv-auditor (agent a69afabf, session a091d246), with `python3 scripts/pv_audit_mech.py P03` on 2026-10-13 11:25. Probes: `pv_work/probes/auditor/P03/auditor_P03_mech1.lean`, `pv_work/probes/auditor/P03/auditor_P03_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `P03` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/P03_9.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD P03 exit=0 delivered=ca7f27a59652fa7ce84fd603e6355b17f4b4a76af539bc27989d0fc6a19ba621 rebuilt=ca7f27a59652fa7ce84fd603e6355b17f4b4a76af539bc27989d0fc6a19ba621 IDENTICAL log=pv_work/probes/auditor/P03/rebuild/P03.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/P03_gate.md` (10 gated declarations) | PASS | all gated th/vh/bi identical |
| 6 | `#pv_axioms P03` | PASS | ALL STANDARD |
| 7 | `#pv_walk P03`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: P03_P02Consumed, P03_T02Consumed, T02_L01Consumed |
| 12 | last writer of `pv_work/P03.lean` | PASS | pv-prover (agent aa08cffd), 2026-10-13 01:47:15 |
| 12 | last writer of `pv_work/P03Stmt.lean` | PASS | pv-drafter (agent a793cf72), 2026-10-13 01:38:10 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `L01Stmt` | 5 | `verification/audits/L01_gate.md` | `Paper.L01.F`, `Paper.L01.IsInvSub`, `Paper.L01.SubCond`, `Paper.L01.SubadditiveOn`, `Paper.L01.invDist` |
| `P02Stmt` | 2 | `verification/audits/P02_gate_r2.md` | `Paper.P02.InfiniteMean`, `Paper.P02.StDom` |
| `P03Stmt` | 3 | `verification/audits/P03_gate.md` | `Paper.P03.P03_P02Consumed`, `Paper.P03.P03_T02Consumed`, `Paper.P03.P03_T02Consumed._proof_1` |
| `T02Stmt` | 8 | `verification/audits/T02_gate.md` | `Paper.T02.IIDCopies`, `Paper.T02.IIDCopies.ident`, `Paper.T02.IIDCopies.indep`, `Paper.T02.IIDCopies.meas`, `Paper.T02.IIDCopies.measXs`, `Paper.T02.IIDCopies.mk`, `Paper.T02.StDom`, `Paper.T02.T02_L01Consumed` |

## Declarations in `pv_work/P03.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`lemma exists_mid`, `lemma halve`, `lemma law_fst`, `lemma law_snd`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.P03.P03_S1` | 6 | — |  |
| `Paper.P03.P03_S2` | 7 | — |  |
| `Paper.P03.P03_S3` | 7 | — |  |
| `Paper.P03.P03_S4` | 9 | — |  |
| `Paper.P03.P03_S5` | 5 | — |  |
| `Paper.P03.P03_S6` | 10 | — |  |
| `Paper.P03.P03_S7` | 8 | — |  |
| `Paper.P03.P03_main` | 10 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: P03_P02Consumed, P03_T02Consumed, T02_L01Consumed

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS
