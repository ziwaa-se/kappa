# L02 reconnection audit r1 (Lemma 5.16 reconnected to L01 = Lemma 5.15)

- Auditor: pv-auditor (independent subagent, Claude Opus 5.5); not the prover of `L02Closed_r1.lean`.
- Date: Tue Oct 13 10:57:56 EDT 2026 (`date`).
- Audited object: `pv_work/L02Closed_r1.lean` (last writer pv-prover, mech item 12).
- Inputs read: `pv_work/L02Closed_r1.lean`, `pv_work/L02Stmt.lean`, `pv_work/L01Stmt.lean`, signatures of `L02_main` (L02.lean:150-152) and `L01_main` (L01.lean:88-89), `L02_final.md` (PASS, CONDITIONAL, `L02_L01Consumed`), `L01_final.md` (PASS, UNCONDITIONAL, conditions none), VERIFICATION_METHODS §2b, PIPELINE stage 6b.

## 1. Mechanical checks (run by me)

`python3 scripts/pv_audit_mech.py L02 --module L02Closed_r1 --skip-statement` → `verification/audits/L02_mech_r2.md`, `MECH CHECKS: PASS`.

| # | Check | Result |
|---|---|---|
| 1 | compile `L02Closed_r1` | PASS (0 errors, 0 sorry) |
| 2 | private rebuild sha256 | IDENTICAL (c7d9acfb…) |
| 3 | PVTools hash | PASS |
| 5 | Defs vs DEFS snapshot | identical |
| 6-7 | `#pv_axioms`, `#pv_walk` | ALL STANDARD; sorryAx not reached |
| 8 | project constants reached | Defs, L01, L01Stmt, L02, L02Stmt, each covered by its final audit / gate record (L01_final.md, L02_final.md, L01_gate.md, L02_gate.md, DEFS_gate.md) |
| 9 | new helpers | none (only `L02_L01Consumed_holds`, `main_closed`, both reviewed below) |
| 11 | traced conditions | none (`L02_L01Consumed` no longer reached) |

## 2. rfl checks (probe `pv_work/probes/auditor/L02/reconnect_r1_probe.lean`, log `pv_work/logs/reconnect_r1_probe_2.log`, exit 0, 0 errors)

L01 is UNCONDITIONAL, so the example has no predecessor-condition arguments; since `L02_L01Consumed gU eps` depends on `gU, eps`, the kit form is checked per instance (d) plus whole-type checks (a)-(c).

| # | `example … := rfl` | Result |
|---|---|---|
| a | `type_of% @L01_main = type_of% @L02_L01Consumed_holds` | PASS: `_holds` is exactly L01's main theorem (consumed clause unfolds to `∀ δ<1, Paper.L01.Concl gU eps δ`) |
| b | `type_of% @L02_main = ∀ {d} gU eps L, L02_L01Consumed gU eps → (0<eps → HypExplode gU → ∀ δ<1, Concl gU eps L δ)` | PASS |
| c | `type_of% @main_closed = ∀ {d} gU eps L, 0<eps → HypExplode gU → (0<eps → HypExplode gU → ∀ δ<1, Concl gU eps L δ)` | PASS: tail identical to (b) |
| d | `∀ gU eps L h1 h2, type_of% (L02_main gU eps L) = (L02_L01Consumed gU eps → type_of% (main_closed gU eps L h1 h2))` | PASS |
| e | deduplicated `∀ gU eps L, 0<eps → HypExplode gU → ∀ δ<1, Concl gU eps L δ` from `main_closed … heps hexp heps hexp` | PASS |

So `main_closed` = L02's gated statement with the (p) slot replaced by L01's own printed hypotheses (ε > 0, (17)). Parameter order follows the convention (predecessor's inputs first, then X's).

## 3. `_holds` and usage

- `L02_L01Consumed_holds gU eps heps1 hexp1 := Paper.L01.L01_main gU eps heps1 hexp1`: really follows from L01's main theorem (check a); `#pv_hyp_usage`: heps1, hexp1 USED.
- `#pv_hyp_usage main_closed`: all 8 premises USED (heps1/hexp1 via `_holds`; heps/hexp via `L02_main`). The warning "10 binders vs 8" concerns `δ`, `δ < 1` of the conclusion, not premises.
- Axioms (`#print axioms`): `main_closed`, `L02_L01Consumed_holds`, probe `L02_closed_dedup`: propext, Classical.choice, Quot.sound only.

## 4. Advisory (not a FAIL)

`main_closed` carries `0 < eps` and `HypExplode gU` twice (L01's copies `heps1, hexp1` and L02's `heps, hexp`). These are printed hypotheses of both lemmas (same ε, same ∇U, TEX:336, TEX:897-899), not external conditions; the duplication is cosmetic and check (e) shows the single-copy statement follows immediately. The coordinator may cite `main_closed` as is.

## 5. Conditions after reconnection

L02's remaining conditions after removing `L02_L01Consumed`: none. L01's conditions: none (L01_final.md). Union: **none**. `L02_L01Consumed` is now discharged (no longer reached; registered input should be marked discharged by L01). With all conditions gone, L02 becomes UNCONDITIONAL per PIPELINE stage 6b step 3 (`lean_main` → `Paper.L02.main_closed`).

## FAIL items

None.

RECONNECT AUDIT: PASS
CONDITIONS: none
