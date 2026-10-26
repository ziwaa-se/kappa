# Mechanical audit checks — L03 (`L03`)

Run by: pv-auditor (agent a113a2d8, session 094f9f86), with `python3 scripts/pv_audit_mech.py L03` on 2026-10-13 01:05. Probes: `pv_work/probes/auditor/L03/auditor_L03_mech1.lean`, `pv_work/probes/auditor/L03/auditor_L03_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `L03` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/L03_5.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD L03 exit=0 delivered=08adbb31fd0767c3ac29b8541cb61380f07824a27fe24bf43beba79ac6c95792 rebuilt=08adbb31fd0767c3ac29b8541cb61380f07824a27fe24bf43beba79ac6c95792 IDENTICAL log=pv_work/probes/auditor/L03/rebuild/L03.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/L03_gate.md` (15 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms L03` | PASS | ALL STANDARD |
| 7 | `#pv_walk L03`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/L03.lean` | PASS | pv-prover (agent a3dbe8a9), 2026-10-12 22:48:38 |
| 12 | last writer of `pv_work/L03Stmt.lean` | PASS | pv-drafter (agent af5e21b1), 2026-10-12 22:28:27 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 14 | `verification/audits/DEFS_gate.md` | `Paper.Defs.E`, `Paper.Defs.H._proof_1`, `Paper.Defs.HypExplode`, `Paper.Defs.HypOscillation2`, `Paper.Defs.HypOscillations`, `Paper.Defs.HypOscillations._proof_3`, `Paper.Defs.accProb`, `Paper.Defs.leapfrogState`, `Paper.Defs.leapfrogState.match_1`, `Paper.Defs.leapfrogStep`, `Paper.Defs.pLF`, `Paper.Defs.piDens` … |
| `L02Stmt` | 2 | `verification/audits/L02_gate_r2.md` | `Paper.L02.Concl._proof_1`, `Paper.L02.ConclFixedDelta` |
| `L03Stmt` | 2 | `verification/audits/L03_gate.md` | `Paper.L03.L03_L02Consumed`, `Paper.L03.L03_L02Consumed._proof_1` |

## Declarations in `pv_work/L03.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`theorem ev_tail`, `theorem geom_third`, `theorem pLF_succ`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.L03.L03_S1` | 7 | — |  |
| `Paper.L03.L03_S10` | 11 | — |  |
| `Paper.L03.L03_S11` | 11 | — |  |
| `Paper.L03.L03_S12` | 7 | — |  |
| `Paper.L03.L03_S2` | 7 | — |  |
| `Paper.L03.L03_S3` | 8 | — |  |
| `Paper.L03.L03_S4a` | 8 | — |  |
| `Paper.L03.L03_S4b` | 14 | hδ: LT.lt.{0} Real Real.instLT #0 (OfNat.ofNat.{0} Real 1 (One.t |  |
| `Paper.L03.L03_S5` | 3 | — |  |
| `Paper.L03.L03_S6` | 6 | hb: LE.le.{0} Real Real.instLE (OfNat.ofNat.{0} Real 0 (Zero.toO |  |
| `Paper.L03.L03_S7` | 4 | — |  |
| `Paper.L03.L03_S8` | 6 | — |  |
| `Paper.L03.L03_S9` | 11 | — |  |
| `Paper.L03.L03_main` | 13 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS
