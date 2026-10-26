# L03 reconnection audit r1 (Lemma 5.17 reconnected to L02 = Lemma 5.16, closed via L01)

- Auditor: pv-auditor (independent subagent, Claude Opus 5.5); not the prover of `L03Closed_r1.lean`.
- Date: Tue Oct 13 11:07:05 EDT 2026 (`date`).
- Audited object: `pv_work/L03Closed_r1.lean` (last writer pv-prover, mech item 12).
- Inputs read: `pv_work/L03Closed_r1.lean`, `pv_work/L02Closed_r1.lean`, `pv_work/L03Stmt.lean`, signature of `L03_main` (L03.lean:345-348), `L03_final.md` (PASS, CONDITIONAL, `L03_L02Consumed`), `L02_reconnect_r1.md` (PASS, conditions none), its probe.

## 1. Mechanical checks (run by me)

`python3 scripts/pv_audit_mech.py L03 --module L03Closed_r1 --skip-statement` -> `verification/audits/L03_mech_r2.md`, `MECH CHECKS: PASS`.

| # | Check | Result |
|---|---|---|
| 1 | compile `L03Closed_r1` | PASS (0 errors, 0 sorry) |
| 2 | private rebuild sha256 | IDENTICAL (c6b5f0b0…) |
| 3 | PVTools hash | PASS |
| 5 | Defs vs DEFS snapshot | identical |
| 6-7 | `#pv_axioms`, `#pv_walk` | ALL STANDARD; sorryAx not reached |
| 8 | project modules reached | Defs, L01, L01Stmt, L02, L02Stmt, L03, L03Stmt covered by gate/final records; `L02Closed_r1` flagged "no record" by the script, but both its constants (`Paper.L02.L02_L01Consumed_holds`, `Paper.L02.main_closed`) are individually audited in `L02_reconnect_r1.md` §2-§3 (PASS) |
| 9 | new helpers | none beyond `L03_L02Consumed_holds`, `main_closed` (reviewed below) |
| 11 | traced conditions | none; `L03_L02Consumed` registered but no longer reached |

## 2. rfl checks (probe `pv_work/probes/auditor/L03/reconnect_r1_probe.lean`, log `pv_work/logs/reconnect_r1_probe_3.log`, exit 0, 0 errors)

L02 (closed) has no conditions, so the example has no predecessor-condition parameters; the predecessor slot is filled only by L02-closed's printed hypotheses.

| # | `example … := rfl` | Result |
|---|---|---|
| a | `type_of% @Paper.L02.main_closed = type_of% @L03_L02Consumed_holds` | PASS: `_holds` is exactly L02's closed main theorem (consumed clause unfolds to `∀ δ<1, Paper.L02.Concl gU eps L δ`) |
| b | `type_of% @L03_main = ∀ {d} U gU eps L, L03_L02Consumed gU eps L → (0<eps → 1≤L → (17) → (18 rev) → (19) → ∀ δ<1, Concl …)` | PASS |
| c | `type_of% @main_closed = ∀ {d} U gU eps L, 0<eps → (17) → 0<eps → (17) → (same tail as b)` | PASS |
| d | per instance: `type_of% (L03_main U gU eps L) = (L03_L02Consumed gU eps L → type_of% (main_closed U gU eps L h1 h2 h3 h4))` | PASS |
| e | deduplicated statement (single ε>0, (17)) from `main_closed` | PASS |

Parameter order follows the convention: predecessor's inputs (`heps1 hexp1` for L01, `heps2 hexp2` for L02) first, then L03's own premises.

## 3. `_holds`, usage, axioms

- `L03_L02Consumed_holds … := Paper.L02.main_closed gU eps L heps1 hexp1 heps2 hexp2`: really follows from L02's (closed) main theorem (check a). `#pv_hyp_usage`: all 4 premises USED.
- `#pv_hyp_usage Paper.L03.main_closed`: all 14 binders USED (`heps1..hexp2` via `_holds`; `heps hL hexp hosc hosc2` via `L03_main`). The "16 vs 14" warning concerns `δ`, `δ < 1` of the conclusion.
- `#print axioms`: `main_closed`, `L03_L02Consumed_holds`, probe `L03_closed_dedup`: propext, Classical.choice, Quot.sound only.

## 4. Advisory (not a FAIL)

`main_closed` carries `0 < eps` three times and `HypExplode gU` three times (L01, L02, L03 copies). All are printed hypotheses of the respective lemmas (same ε, same ∇U; TEX:336, 897-899), not external conditions; check (e) shows the single-copy statement follows at once.

## 5. Conditions after reconnection

L03's remaining conditions after removing `L03_L02Consumed`: none (L03_final.md: the only condition was `L03_L02Consumed`). L02-closed's conditions: none (L02_reconnect_r1.md; L01 UNCONDITIONAL). Union: **none**. Registered input `L03_L02Consumed` is discharged by L02 (`main_closed`) and should be marked so; L03 may be recorded UNCONDITIONAL with `lean_main` -> `Paper.L03.main_closed`.

## FAIL items

None.

RECONNECT AUDIT: PASS
CONDITIONS: none
