# Mechanical audit checks — L03 (`L03`)

Run by: pv-auditor (agent aa4019c1, session 13bf576d), with `python3 scripts/pv_audit_mech.py L03` on 2026-10-13 11:00. Probes: `pv_work/probes/auditor/L03/auditor_L03_mech1.lean`, `pv_work/probes/auditor/L03/auditor_L03_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `L03` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/L03_9.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD L03 exit=0 delivered=0a045055c9342aa3fff81d5ef8593f16299983dc734a63ea5fe41eb2f0303502 rebuilt=0a045055c9342aa3fff81d5ef8593f16299983dc734a63ea5fe41eb2f0303502 IDENTICAL log=pv_work/probes/auditor/L03/rebuild/L03.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/L03_gate.md` (19 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms L03` | PASS | ALL STANDARD |
| 7 | `#pv_walk L03`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: L03_L02Consumed |
| 12 | last writer of `pv_work/L03.lean` | PASS | pv-prover (agent a97eae21), 2026-10-13 10:58:50 |
| 12 | last writer of `pv_work/L03Stmt.lean` | PASS | pv-drafter (agent a98c1e6d), 2026-10-13 10:51:45 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 12 | `verification/audits/DEFS_gate.md` | `Paper.Defs.E`, `Paper.Defs.H._proof_1`, `Paper.Defs.HypExplode`, `Paper.Defs.HypOscillation2`, `Paper.Defs.accProb`, `Paper.Defs.leapfrogState`, `Paper.Defs.leapfrogState.match_1`, `Paper.Defs.leapfrogStep`, `Paper.Defs.pLF`, `Paper.Defs.piDens`, `Paper.Defs.tailMomFilter`, `Paper.Defs.xLF` |
| `L02Stmt` | 2 | `verification/audits/L02_gate.md` | `Paper.L02.Concl`, `Paper.L02.Concl._proof_1` |
| `L03Stmt` | 4 | `verification/audits/L03_gate.md` | `Paper.L03.Concl`, `Paper.L03.HypOscillations3`, `Paper.L03.HypOscillations3._proof_1`, `Paper.L03.L03_L02Consumed` |

## Declarations in `pv_work/L03.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`theorem core`, `theorem ev_tail`, `theorem explode_thresh`, `theorem geom_third`, `theorem pLF_succ`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.L03.L03_S1` | 7 | — |  |
| `Paper.L03.L03_S10` | 9 | — |  |
| `Paper.L03.L03_S11` | 10 | heps: LT.lt.{0} Real Real.instLT (OfNat.ofNat.{0} Real 0 (Zero.toO, hγ: LT.lt.{0} Real Real.instLT (OfNat.ofNat.{0} Real 0 (Zero.toO |  |
| `Paper.L03.L03_S12` | 8 | — |  |
| `Paper.L03.L03_S13` | 9 | — |  |
| `Paper.L03.L03_S14` | 8 | — |  |
| `Paper.L03.L03_S2` | 7 | — |  |
| `Paper.L03.L03_S3` | 8 | — |  |
| `Paper.L03.L03_S4a` | 8 | — |  |
| `Paper.L03.L03_S4b` | 9 | — | WARNING: the type has 11 leading binders but the proof term binds only 9; usage of the remaining 2 hypotheses is unknown |
| `Paper.L03.L03_S5` | 9 | — |  |
| `Paper.L03.L03_S6` | 3 | — |  |
| `Paper.L03.L03_S7` | 9 | — |  |
| `Paper.L03.L03_S8` | 7 | — |  |
| `Paper.L03.L03_S9` | 6 | — |  |
| `Paper.L03.L03_main` | 13 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: L03_L02Consumed

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS
