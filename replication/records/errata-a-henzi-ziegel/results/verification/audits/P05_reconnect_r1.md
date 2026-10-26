# Reconnection audit — P05 (`pv_work/P05Closed_r1.lean`, predecessor P04), r1

Auditor: pv-auditor, 2026-10-13 11:14. Audited file read in full (44 lines). Probe: `pv_work/probes/auditor/P05/reconnect_r1_check.lean` (log `pv_work/logs/reconnect_r1_check_2.log`, exit 0, errors 0). Mechanical report: `verification/audits/P05_mech_r3.md` (run by me, `--module P05Closed_r1 --skip-statement`), `MECH CHECKS: PASS`.

Inputs: P05 gate `P05_gate_r2.md` (STATEMENT GATE: PASS; `P05_P04Consumed` approved as "P04 proof l.452 = `P04_S10` with c := 1"), P05 final `P05_final_r2.md` (PASS, CONDITIONAL, CONDITIONS: P05_P04Consumed), P04 gate `P04_gate_r2.md` (PASS; `P04_S10` is a gated obligation, `th=366264087`), P04 final `P04_final.md` (PASS, CONDITIONAL, CONDITIONS: P04_T01Consumed, P04_MixingOfStrict; S10 audited individually, route table l.75).

## 1. Mechanical checks (from `P05_mech_r3.md`)

| # | Check | Result |
|---|---|---|
| 1 | compile `P05Closed_r1` | PASS (0 errors, 0 sorry) |
| 2 | private rebuild sha256 | IDENTICAL |
| 3 | PVTools hash | PASS |
| 5 | Defs vs DEFS_gate_r2 | identical |
| 6 | `#pv_axioms P05Closed_r1` | ALL STANDARD (also re-run in my probe: 2 declarations, ALL STANDARD) |
| 7 | `#pv_walk`: sorryAx | not reached; axioms propext, Classical.choice, Quot.sound |
| 8 | project modules in closure | Defs (DEFS_gate_r2), P04 (P04_final), P04Stmt (P04_gate_r2), P05 (P05_final_r2), P05Stmt (P05_gate_r2), T01Stmt (T01_gate) — all covered |
| 9 | helpers not in snapshot | none (the two declarations `P05_P04Consumed_holds`, `main_closed` are the reconnection pair itself, reviewed below) |
| 11 | TRACED CONDITIONS | "none" — artefact of `--skip-statement` (no gated theorem in this module); corrected in §4 below |

## 2. Statement match (rfl method, VERIFICATION_METHODS §2b)

The template `type_of% @P05_main = (P05_P04Consumed → type_of% (main_closed hT01 hMix))` cannot be written literally: `P05_P04Consumed` and both P04 conditions are parametrised by `S` (and the clause by `ν h ℱ Y c p q lam`), which are binders of `P05_main`. So `S` necessarily comes first in `main_closed`, followed by `hT01 hMix`; this is the convention "predecessor conditions first" up to the dependency on `S`. I checked instead (all compile, `rfl`):

| Probe | Statement checked | Result |
|---|---|---|
| (A) pointwise | for all `S hT01 hMix ν hrep h hh ℱ Y c p q lam`: `type_of% (P05_main S ν hrep h hh ℱ Y c p q lam) = (P05_P04Consumed S ν h ℱ Y c p q lam → type_of% (main_closed S hT01 hMix ν hrep h hh ℱ Y c p q lam))` | rfl OK |
| (B) full type of `main_closed` | `∀ S, P04_T01Consumed S → P04_MixingOfStrict S → ∀ ν, MixtureRep S ν → ∀ h, 1 ≤ h → ∀ ℱ Y c p q lam, SeqSetting … → IsStrictlyConsistent S → ∀ τ, IsStopTime ℱ τ → P05Conclusion S h ℱ Y p q lam τ` | rfl OK |
| (C) full type of `P05_main` | same binders with `hP04 : P05_P04Consumed …` after `lam` and no P04 conditions | rfl OK |
| (D) type of `P05_P04Consumed_holds` | `∀ S ν h ℱ Y c p q lam, P04_T01Consumed S → P04_MixingOfStrict S → P05_P04Consumed S ν h ℱ Y c p q lam` | rfl OK |

(A)+(B)+(C) show that `main_closed` is exactly `P05_main` with `hP04` removed and P04's two conditions inserted after `S`; conclusion unchanged, no other premise added or dropped. `P05_main` itself is the audited module `P05.olean` (P05_final_r2, statement fingerprint checked there).

## 3. Derivation of `P05_P04Consumed` (faithfulness)

| Point | Finding |
|---|---|
| Source of the clause | `P04_S10` (gated P04 obligation, source l.452, audited in `P04_final.md` with route FAIR_IMPLICIT_STEP for optional stopping), not a new argument. Gate r2 approved exactly this derivation route. |
| Instantiation `c := fun _ _ => 1` | `P04_S10`'s conclusion for `Q ∈ HScInt S h ℱ Y 1 p q` is literally the clause body (`HScInt … (fun _ _ => 1)`, `Mk S h Y p q lam k (τ' ω) ω`, same `filtK ℱ h k` stopping condition). Type-checks without conversion. |
| `SeqSetting ℱ Y 1 p q lam` from `hset` | Y/p/q/lam fields copied; `c_adapted` = `measurable_const`; `c_mem` = `Or.inr rfl`; `lam_zero` vacuous (`1 = 0` refuted by `one_ne_zero`). Pure technical conversion, no new mathematics; it only weakens `hset` (drops the original `c`). |
| Other premises | `hrep`, `hS`, `1 < h`, `Q, hQ, k, hk, τ', hτ'` passed through unchanged from the clause's own premises. |
| P04 conditions | `hT01`, `hMix` passed to `P04_S10`; `#pv_hyp_usage Paper.P04.P04_S10` reports both USED (agrees with P04_final). `#pv_hyp_usage` on `P05_P04Consumed_holds` and `main_closed`: every hypothesis USED. |
| Uses P04_main? | No: P04's main theorem (`P04Conclusion`, e-value at fixed T) is not the clause P05 consumes; the consumed clause is P04's proof step l.452 = S10, which is gated and individually audited in P04_final. This is the arrangement approved in P05_gate_r2, so "follows from P's main theorem" is satisfied in the sense of "follows from P's gated, audited obligation". |

## 4. Conditions after reconnection

- X's remaining conditions: P05 had only `P05_P04Consumed`; it is now discharged by `P05_P04Consumed_holds` and no longer a premise of `main_closed`.
- P04's conditions, both used by `main_closed` (USED, through `P05_P04Consumed_holds` → `P04_S10`):
  - `P04_T01Consumed` → P04 S1 / pointwise bound (T01 e-value clause), reached via S9b-S9c-S10 (h > 1 branch used by P05 S7/S8);
  - `P04_MixingOfStrict` → P04 S1 (positive mass of ν), reached via S10.
- Not conditions: `T01.MixtureRep S ν` (`hrep`) is a hypothesis of the printed setting (TFA-2 of P04, as at P05 gate), not an external parameter. X03 is not reached.
- Note for records: P04_T01Consumed depends on T01 which is ISSUE (l.419, λ = 1 edge); P05 after reconnection inherits that condition, not the issue.

## 5. Status for the authors

Proposition 3.5 (P05) is verified along the source route, now relative only to P04's two inputs: the e-value clause of Theorem 3.1 (T01, itself with a recorded issue) and the positive-mass regularity of the mixing measure (l.106). No new source issue found in reconnection.

RECONNECT AUDIT: PASS
CONDITIONS: P04_T01Consumed, P04_MixingOfStrict
