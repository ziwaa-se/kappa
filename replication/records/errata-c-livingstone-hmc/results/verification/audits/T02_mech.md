# Mechanical audit checks — T02 (`T02`)

Run by: pv-auditor (agent a30fb1d8, session 13bf576d), with `python3 scripts/pv_audit_mech.py T02` on 2026-10-13 11:15. Probes: `pv_work/probes/auditor/T02/auditor_T02_mech1.lean`, `pv_work/probes/auditor/T02/auditor_T02_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `T02` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/T02_9.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD T02 exit=0 delivered=be37120cfe364f5f319cdb8cee897bd177697ed020d346523b414a41389c2819 rebuilt=be37120cfe364f5f319cdb8cee897bd177697ed020d346523b414a41389c2819 IDENTICAL log=pv_work/probes/auditor/T02/rebuild/T02.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/T02_gate_r2.md` (35 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate.md` | PASS | identical |
| 6 | `#pv_axioms T02` | PASS | ALL STANDARD |
| 7 | `#pv_walk T02`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: T02_L03Consumed; registered for this result but not reached: T02_GaussFacts, T02_Prop35, T02_Prop35Rand |
| 12 | last writer of `pv_work/T02.lean` | PASS | pv-prover (agent a083e997), 2026-10-13 11:13:38 |
| 12 | last writer of `pv_work/T02Stmt.lean` | PASS | pv-drafter (agent a9350b7c), 2026-10-13 11:06:53 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 14 | `verification/audits/DEFS_gate.md` | `Paper.Defs.E`, `Paper.Defs.H._proof_1`, `Paper.Defs.HypExplode`, `Paper.Defs.HypOscillation2`, `Paper.Defs.IsGradField`, `Paper.Defs.IsGradField._proof_2`, `Paper.Defs.accProb`, `Paper.Defs.leapfrogState`, `Paper.Defs.leapfrogState.match_1`, `Paper.Defs.leapfrogStep`, `Paper.Defs.pLF`, `Paper.Defs.piDens` … |
| `L03Stmt` | 3 | `verification/audits/L03_gate.md` | `Paper.L03.Concl`, `Paper.L03.HypOscillations3`, `Paper.L03.HypOscillations3._proof_1` |
| `T02Stmt` | 22 | `verification/audits/T02_gate_r2.md` | `Paper.T02.A1Law`, `Paper.T02.GaussFacts`, `Paper.T02.GeomErgodic`, `Paper.T02.GeomErgodic._proof_5`, `Paper.T02.GeomErgodicRand`, `Paper.T02.Prop35`, `Paper.T02.Prop35Rand`, `Paper.T02.T02_L03Consumed`, `Paper.T02.gaussMeas`, `Paper.T02.gaussMeas._proof_1`, `Paper.T02.gaussMeas._proof_2`, `Paper.T02.gaussMeas._proof_3` … |

## Declarations in `pv_work/T02.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`lemma J01`, `lemma acc_le_one`, `lemma acc_meas`, `lemma acc_nonneg`, `lemma essSup_one_of`, `lemma gU_meas`, `lemma intg01`, `lemma lf_meas`, `lemma step_apply`, `lemma step_le_one`, `lemma step_meas`, `lemma tail_ne_zero`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.T02.T02_S1` | 10 | — |  |
| `Paper.T02.T02_S2` | 4 | — |  |
| `Paper.T02.T02_S3` | 6 | — |  |
| `Paper.T02.T02_S4` | 10 | — |  |
| `Paper.T02.T02_S5` | 12 | hδ: LT.lt.{0} Real Real.instLT #1 (OfNat.ofNat.{0} Real 1 (One.t |  |
| `Paper.T02.T02_S6` | 10 | — |  |
| `Paper.T02.T02_S7` | 6 | — |  |
| `Paper.T02.T02_S8` | 10 | — |  |
| `Paper.T02.T02_S9` | 12 | — |  |
| `Paper.T02.T02_SR1` | 7 | — |  |
| `Paper.T02.T02_SR2` | 7 | — |  |
| `Paper.T02.T02_SR3` | 10 | hE6: Paper.T02.GaussFacts, hA1: Paper.T02.A1Law #5 #3 #2 #1 |  |
| `Paper.T02.T02_SR4` | 11 | — |  |
| `Paper.T02.T02_SR5` | 11 | hA1: Paper.T02.A1Law #6 #4 #3 #2 |  |
| `Paper.T02.T02_SR5'` | 7 | hA1: Paper.T02.A1Law #4 #2 #1 #0 |  |
| `Paper.T02.T02_SR6` | 12 | — |  |
| `Paper.T02.T02_main` | 16 | hexp: Paper.Defs.HypExplode #12 #10, hosc: Paper.L03.HypOscillations3 #13 #11, hosc2: Paper.Defs.HypOscillation2 #14 #13 #10 |  |
| `Paper.T02.T02_main_randL` | 16 | hexp: Paper.Defs.HypExplode #12 #10, hosc: Paper.L03.HypOscillations3 #13 #11, hosc2: forall (l : Nat), (LE.le.{0} Nat instLENat (OfNat.ofNat.{0}  |  |

## Conditions traced (item 11)

TRACED CONDITIONS: T02_L03Consumed

## For the auditor (judgement not done by this script)

- external inputs registered for T02 but not reached by any gated theorem (T02_GaussFacts, T02_Prop35, T02_Prop35Rand): they are not conditions; say so in the report so that the records are corrected
- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS (1 manual checks listed above)
