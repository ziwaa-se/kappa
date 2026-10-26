# T02 reconnection audit r1 (Theorem 5.14 reconnected to L03 = Lemma 5.17, closed)

- Auditor: pv-auditor (independent subagent, opus), session 13bf576d. I am not the prover of `T02Closed_r1.lean` (last writer: pv-prover agent a0910928, mech item 12).
- Date: Tue Oct 13 11:30:25 EDT 2026 (from `date`).
- Audited object: `pv_work/T02Closed_r1.lean` (`T02_L03Consumed_holds`, `main_closed`, `main_randL_closed`).
- Inputs read: `pv_work/T02Closed_r1.lean`, `pv_work/L03Closed_r1.lean`, `pv_work/T02Stmt.lean`, the signatures of `T02_main` and `T02_main_randL` (`T02.lean:340-345`, `490-497`), `T02_final.md` (PASS, CONDITIONAL; conditions T02_L03Consumed, T02_Prop35, T02_GaussFacts, T02_Prop35Rand), `L03_reconnect_r1.md` (PASS, conditions none).
- Probe (mine): `pv_work/probes/auditor/T02/reconnect_r1_probe.lean`; `RESULT exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`; log `pv_work/logs/reconnect_r1_probe_4.log`.

## 1. Mechanical checks (run by me)

`python3 scripts/pv_audit_mech.py T02 --module T02Closed_r1 --skip-statement` wrote `verification/audits/T02_mech_r2.md`, ending in `MECH CHECKS: PASS`.

| # | Check | Result |
|---|---|---|
| 1 | compile `T02Closed_r1` | PASS (0 errors, 0 sorry) |
| 2 | private rebuild sha256 | IDENTICAL (`215b9927…`) |
| 3 | PVTools hash | PASS |
| 5 | Defs vs DEFS snapshot | identical |
| 6-7 | `#pv_axioms`, `#pv_walk` | ALL STANDARD; `sorryAx` not reached |
| 8 | project modules reached | all covered by gate/final records except `L02Closed_r1` and `L03Closed_r1`, flagged "no record". Their constants are audited individually: `Paper.L02.L02_L01Consumed_holds` and `Paper.L02.main_closed` in `L02_reconnect_r1.md`; `Paper.L03.L03_L02Consumed_holds` and `Paper.L03.main_closed` in `L03_reconnect_r1.md` §2-§3 (PASS). `T02Closed_r1` constants: audited here (§2-§3) |
| 9 | new helpers | none beyond the three reviewed below |
| 11 | traced conditions | script: none. **Under-traced, corrected in §4** (the same known script issue as in `T02_final.md` §1) |

## 2. rfl checks (probe, all compile)

L03-closed has no conditions (`L03_reconnect_r1.md`), so the examples have no predecessor-condition parameters. The predecessor slot is filled only by L03-closed's printed hypotheses.

| # | `example … := rfl` | Result |
|---|---|---|
| a | `type_of% @Paper.L03.main_closed = type_of% @T02_L03Consumed_holds` | PASS: `_holds` is exactly L03's closed main theorem (`T02_L03Consumed` unfolds to `∀ δ<1, Paper.L03.Concl …`) |
| b1 | `type_of% (@T02_main d U gU eps L) = (T02_L03Consumed … → Prop35 → GaussFacts → 0<d → IsGradField → Z<⊤ → 0<eps → 1≤L → (17) → (18 rev) → (19) → ¬GeomErgodic)` | PASS |
| b2 | `type_of% (@main_closed d U gU eps L) = (0<eps → (17) → 0<eps → (17) → ` same tail as b1 `)` | PASS |
| c1 | `type_of% (@T02_main_randL …) = ((∀ l≥1, 𝔏{l}≠0 → T02_L03Consumed … l) → Prop35Rand → GaussFacts → … → A1Law → (17) → (18 rev) → (∀ l, … (19)_l) → ¬GeomErgodicRand)` | PASS |
| c2 | `type_of% (@main_randL_closed …) = (0<eps → (17) → 0<eps → (17) → ` same tail as c1 `)` | PASS |
| d | deduplicated fixed-`L` statement (`T02_closed_dedup`: one `ε>0`, one (17)) follows from `main_closed` | PASS |

So each closed theorem has exactly "L03-closed's hypotheses → the type of `T02_main` / `T02_main_randL` with the consumed-clause slot removed". The parameter order follows the convention: the predecessor's inputs come first (`heps1 hexp1` for L01, `heps2 hexp2` for L02, as in `L03.main_closed`), then T02's own premises, unchanged. The external conditions `Prop35` / `Prop35Rand` / `GaussFacts` stay in T02's own positions. They are T02's own conditions, not predecessor conditions, so this is not a convention violation.

## 3. `_holds`, the random-`L` discharge, usage, axioms

- `T02_L03Consumed_holds … := Paper.L03.main_closed U gU eps L heps1 hexp1 heps2 hexp2 heps hL hexp hosc hosc2`. This really follows from L03's closed main theorem (check a). `#pv_hyp_usage`: all 14 binders USED.
- In `main_randL_closed`, the predecessor slot `∀ l ≥ 1, 𝔏{l} ≠ 0 → T02_L03Consumed … l` is discharged pointwise by `_holds` at `l`, with `hosc2 l hl hl0`. `hosc2` is T02's own premise (TFA-6, gate-approved). No new hypothesis is introduced.
- `#pv_hyp_usage Paper.T02.main_closed`: all 19 binders USED. `#pv_hyp_usage Paper.T02.main_randL_closed`: all 19 binders USED. So `hexp`, `hosc` and `hosc2`, which were reported UNUSED in `T02_main`, are now consumed through L03, as `T02_final.md` §3 predicted.
- `#print axioms` gives propext, Classical.choice, Quot.sound only, for `main_closed`, `main_randL_closed`, `T02_L03Consumed_holds` and the probe `T02_closed_dedup`.

## 4. Conditions per theorem (walk with positive control)

Positive control: `#pv_walk_decl Paper.T02.T02_S9` reaches `Paper.T02.Prop35` (log line 78), so the walk detects use of an external `Prop` definition.

| Theorem | External parameters reached (walk) and USED (hyp_usage) | Not reached |
|---|---|---|
| `main_closed` | `Prop35` (via `T02_main` → `T02_S9`, log line 200), `GaussFacts` (via `T02_S5`, line 197) | `Prop35Rand`, `A1Law` |
| `main_randL_closed` | `Prop35Rand` (via `T02_SR6`, line 337), `GaussFacts` (via `T02_SR3`, `J01`, line 334) | `Prop35` |

`T02_L03Consumed` is still reached as a definition (it is the type of `_holds` and of the slot of `T02_main`; log lines 201, 338). It is no longer a hypothesis of either closed theorem: it is proved by `_holds`, so it is discharged and is not a condition. The steps that use the conditions are unchanged from `T02_final.md` §3:
- `Prop35` → S9 (TEX:932);
- `Prop35Rand` → SR6 (TEX:935-936);
- `GaussFacts` → S2 (clause (b)) and S4 (clause (a)) (TEX:917-931), and J01/SR1 (TEX:938).

## 5. Advisory (not a FAIL)

Both closed theorems carry `0 < eps` three times and `HypExplode gU` three times (the L01, L02 and L03/T02 copies). All are printed hypotheses (same ε, same ∇U), not external conditions. Check (d) shows that the single-copy statement follows at once.

## 6. Conditions after reconnection

The conditions T02 keeps after removing `T02_L03Consumed` are `T02_Prop35`, `T02_GaussFacts` and `T02_Prop35Rand`. L03-closed's conditions are none (`L03_reconnect_r1.md`; L02-closed none, L01 UNCONDITIONAL). The union is `T02_Prop35`, `T02_GaussFacts`, `T02_Prop35Rand`. Per theorem:
- `main_closed` (fixed `L`) uses `T02_Prop35` and `T02_GaussFacts`;
- `main_randL_closed` (random `L`) uses `T02_Prop35Rand` and `T02_GaussFacts`.

Records: mark `T02_L03Consumed` as discharged by L03 (`Paper.T02.T02_L03Consumed_holds`). Set T02's `lean_main` to `Paper.T02.main_closed` (and `main_randL_closed` for the random-`L` part). T02 stays CONDITIONAL.

## FAIL items

None.

RECONNECT AUDIT: PASS
CONDITIONS: T02_Prop35, T02_GaussFacts, T02_Prop35Rand
