# Mechanical audit checks — T03 (`T03`)

Run by: pv-auditor (agent af2f5f9c, session a80accfd), with `python3 scripts/pv_audit_mech.py T03` on 2026-10-12 22:18. Probes: `pv_work/probes/auditor/T03/auditor_T03_mech1.lean`, `pv_work/probes/auditor/T03/auditor_T03_mech2.lean`.

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | check `T03` | PASS | exit=0 errors=0 sorry_warnings=0 log `pv_work/logs/T03_3.log` |
| 2 | private rebuild + sha256 | PASS | REBUILD T03 exit=0 delivered=1536ae9e500fb7ab02283412bced71c446979f22c774bbc44c861fbdf3a9431e rebuilt=1536ae9e500fb7ab02283412bced71c446979f22c774bbc44c861fbdf3a9431e IDENTICAL log=pv_work/probes/auditor/T03/rebuild/T03.rebuild.log |
| 3 | PVTools.lean sha256 | PASS | 445fe54fd278873b… |
| 4 | statement fingerprints vs `verification/audits/T03_gate.md` (10 gated declarations) | PASS | all gated th/vh/bi identical |
| 5 | `Defs` vs `verification/audits/DEFS_gate_r2.md` | PASS | identical |
| 6 | `#pv_axioms T03` | PASS | ALL STANDARD |
| 7 | `#pv_walk T03`: sorryAx and closure axioms | PASS | sorryAx reached: False; axioms: ['propext', 'Classical.choice', 'Quot.sound'] |
| 11 | conditions traced from the gated theorems | INFO | conditions: none |
| 12 | last writer of `pv_work/T03.lean` | PASS | pv-prover (agent a0f96e1e), 2026-10-12 22:17:27 |
| 12 | last writer of `pv_work/T03Stmt.lean` | PASS | pv-drafter (agent a1d358df), 2026-10-12 22:12:43 |

## Project constants reached (item 8)

| Module | Constants | Audit record covering the module | Names |
|---|---:|---|---|
| `Defs` | 5 | `verification/audits/DEFS_gate_r2.md` | `Paper.EGrowAll`, `Paper.HAll`, `Paper.IsEValue`, `Paper.elemScore`, `Paper.expPi` |
| `T03Stmt` | 4 | `verification/audits/T03_gate.md` | `Paper.T03.GrowIs`, `Paper.T03.GruenwaldThm1`, `Paper.T03.IsGrowEValue`, `Paper.T03.LogFinite` |

## Declarations in `pv_work/T03.lean` that are not in the gate snapshot (item 9: helpers to review)

Read from the source file, so private helpers are included.

`lemma HAll_self`, `lemma S34`, `lemma expPi_diff`, `lemma expPi_grow`

## Hypothesis usage of gated theorems (item 10)

| Theorem | Hypotheses | UNUSED | Warning |
|---|---:|---|---|
| `Paper.T03.T03_S1` | 5 | — |  |
| `Paper.T03.T03_S2` | 5 | — |  |
| `Paper.T03.T03_S3` | 9 | — |  |
| `Paper.T03.T03_S4` | 10 | — |  |
| `Paper.T03.T03_S5` | 10 | hq: Membership.mem.{0, 0} Real (Set.{0} Real) (Set.instMembershi |  |
| `Paper.T03.T03_main` | 8 | — |  |

## Conditions traced (item 11)

TRACED CONDITIONS: none

## For the auditor (judgement not done by this script)

- trace every USED external parameter to the step that really uses it (`#pv_hyp_usage` on helpers)
- review each helper listed under item 9: technical conversion only, no new mathematics
- route fidelity sentence by sentence; FAIR_IMPLICIT_STEP fill-ins; non-vacuity witness

MECH CHECKS: PASS
