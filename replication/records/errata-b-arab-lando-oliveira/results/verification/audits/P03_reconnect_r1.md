# Reconnection audit r1 — P03 (predecessor T02)

Auditor: pv-auditor, 2026-10-13 11:29. Audited file: `pv_work/P03Closed_r1.lean` (not modified).
Probe: `pv_work/probes/auditor/P03/auditor_P03_reconnect_r1.lean` (RESULT exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0, log `pv_work/logs/auditor_P03_reconnect_r1_1.log`).
Mechanical report: `verification/audits/P03_mech_r3.md` (`pv_audit_mech.py P03 --module P03Closed_r1 --skip-statement`), MECH CHECKS: PASS.

## Predecessor status

| Predecessor | Final audit | Verdict | Action |
|---|---|---|---|
| T02 (Thm 3.1) | `T02_final.md` PASS | CONDITIONAL on `T02_L01Consumed` | reconnected here |
| P02 (Prop 3.2) | `P02_final.md` PASS | ISSUE | not reconnected (PIPELINE Stage 6b item 5); `P03_P02Consumed` stays a parameter |

Delivered `.olean` hashes equal the audited ones: `T02.olean` e63013a0… = `T02_mech.md`; `P03.olean` ca7f27a5… = `P03_mech.md`.

## Checks

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | compile + private rebuild sha256 of `P03Closed_r1` | PASS | mech items 1–2, IDENTICAL dbf0445a… |
| 2 | axioms (`#pv_axioms`, `#pv_walk`; `#print axioms` on `main_closed`, `P03_T02Consumed_holds`) | PASS | propext, Classical.choice, Quot.sound; sorryAx not reached |
| 3 | `rfl` check, template form with T02's condition as argument: `example (hL01) : type_of% (P03_main hL01) = (P03_T02Consumed → type_of% (main_closed hL01)) := rfl` | PASS | compiles |
| 4 | `rfl` check, full type: `type_of% @P03_main = (∀ hL01, P03_T02Consumed → type_of% (main_closed hL01))` | PASS | compiles |
| 5 | parameter order: `main_closed (hL01 : T02_L01Consumed) (hP02 : P03_P02Consumed) …` | PASS | predecessor T02's condition first, then X's remaining condition |
| 6 | `P03_T02Consumed_holds` follows from `T02.T02_main` | PASS | instance n = 2, θ ≡ 1/2 (θ ≥ 0 by `norm_num`, Σθ = 1 by `simp`); `T02_main` is the gated main theorem of T02, covered by `T02_final.md` PASS |
| 7 | project constants in closure (mech item 8) | PASS | L01Stmt, P02Stmt, P03Stmt, T02Stmt (gate records), P03 (`P03_final.md`), T02 (`T02_final.md`); no new helpers (item 9: none) |
| 8 | statement unchanged | PASS | `main_closed` conclusion and data hypotheses are those of `P03_main` (rfl checks 3–4) |

Note on `P03_T02Consumed_holds`: `#pv_hyp_usage` reports the outer `hL01` USED and the inner antecedent of `P03_T02Consumed` (also of type `T02_L01Consumed`) UNUSED. Harmless: both are the same Prop, and the outer `hL01` is anyway a parameter of `main_closed`. (Editorial: the outer hypothesis is redundant, since the clause carries its own antecedent; no effect on conditions.)

## Condition tracing (mech item 11 shows "none" only because `--skip-statement` leaves no gated theorem in this module; traced by hand)

| Parameter of `main_closed` | `#pv_hyp_usage` | Where it is really used |
|---|---|---|
| `hL01 : T02_L01Consumed` | USED | `main_closed` → `P03_T02Consumed_holds hL01` → `T02_main hL01` (USED) → `pos_all hL01` → T02 step S3 ("only if" half of L01, eq:sub-1x), per `T02_final.md`; also passed by `P03_main` to S4 (source :269, "As a consequence of Theorem 3.1") |
| `hP02 : P03_P02Consumed` | USED | `P03_main` → `P03_S6` (source :269, "and Proposition 3.2"), per `P03_final.md` |

`P03_T02Consumed` is discharged (no longer a parameter of `main_closed`).

## Full set of conditions after reconnection

- `T02_L01Consumed` (T02's condition, inherited; L01 "only if" clause, source :128-135) — used at T02 S3 via P03 S4.
- `P03_P02Consumed` (P02 consumed clause, source :261-264) — used at P03 S6; P02 is ISSUE, so this is reported as a (iv)-type condition needing human check.

## Status for the authors

P03 (Prop 3.3) is proved along the source route with Theorem 3.1 now discharged by the verified T02 proof. It still depends on L01's "only if" clause (via T02) and on Proposition 3.2, which has a recorded issue. No new source issue found in this reconnection.

RECONNECT AUDIT: PASS
CONDITIONS: T02_L01Consumed, P03_P02Consumed
