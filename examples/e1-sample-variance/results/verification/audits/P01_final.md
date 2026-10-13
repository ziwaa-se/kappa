# Final audit: P01 (Proposition prop:popoviciu, source/main.tex:58-69)

- Auditor: pv-auditor (independent; did not draft, gate or prove P01)
- Date: Mon Oct 12 22:13:59 EDT 2026 (from `date`)
- Audited object: `pv_work/P01.lean` (no gap file; prover notes say no gaps, confirmed: no `P01ModGaps.lean` exists)
- Inputs read directly: `source/main.tex:1-80` (setting, defs :26-37, statement :58-63, proof :65-69),
  `pv_work/P01.lean`, `pv_work/P01Stmt.lean`, `pv_work/Defs.lean`, `verification/audits/P01_gate_r2.md`,
  `pv_work/notes/P01_prover_notes.md` (leads only)
- Mechanical report: `verification/audits/P01_mech.md` (run by me, `python3 scripts/pv_audit_mech.py P01`): **MECH CHECKS: PASS**
- Auditor probe: `pv_work/probes/auditor/P01/auditor_P01_nonvac.lean` -> exit=0, errors=0, sorry_warnings=0, log `pv_work/logs/auditor_P01_nonvac_2.log`

## 1. Mechanical checks (from `P01_mech.md`)

| # | Check | Result |
|---|---|---|
| 1 | compile `P01` | PASS (exit 0, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL |
| 3 | PVTools hash | PASS |
| 4 | fingerprints vs `P01_gate_r2.md` (S1 565281750, S2 2016942701, P01 1195702439, Popoviciu 3944470172) | PASS |
| 5 | Defs vs `DEFS_gate.md` | PASS |
| 6-7 | `#pv_axioms` / `#pv_walk`: propext, Classical.choice, Quot.sound; sorryAx not reached | PASS |
| 9 | helpers not in snapshot | none |
| 10 | hypothesis usage: no UNUSED in P01, P01_S1, P01_S2 | PASS |
| 11 | TRACED CONDITIONS | Popoviciu |

## 2. Gap files
Not applicable (no gaps).

## 3. Per-theorem conditionality

| Theorem | External param | Where actually used |
|---|---|---|
| `P01` | `hP : Popoviciu` | passed to `P01_S1` (USED) |
| `P01_S1` | `hP : Popoviciu` | USED directly: proof term `hP n a b x (by omega) hx` (main.tex:66-67) |
| `P01_S2` | none | pure algebra (main.tex:68) |

Confirmed with `#pv_hyp_usage Paper.P01.P01_S1` / `P01_S2` in the auditor probe (log lines 12-26).
Condition: **Popoviciu -> step S1, main.tex:66-67** (the cited inequality).

## 4. Infrastructure (item 8)

| Constant | Record | Auditor check |
|---|---|---|
| `Paper.Sample`, `Paper.sampleMean`, `Paper.sampleVar` | `DEFS_gate.md` | definitions match main.tex:26-37; `sampleVar` uses real `(n:ℝ)-1`, correct for `n ≥ 2` assumed in P01 |
| `Paper.P01.Popoviciu` | `P01_gate_r2.md` (approved external parameter) | closed Prop, not goal-shaped, matches main.tex:66-67; requires only `1 ≤ n`; true (see §6) |
| `Paper.P01.Popoviciu._proof_1` | `P01_gate_r2.md` (module) | compiler-generated auxiliary proof inside the definition of `Popoviciu`; carries no mathematical content of its own |

No helpers outside the snapshot.

## 5. Statement and route fidelity

Statement (main.tex:59-62): `n ≥ 2`, `a ≤ x_i ≤ b` for all i ⟹ `s² ≤ n/(n-1)·(b-a)²/4`.
Lean `P01`: `2 ≤ n`, `∀ i, a ≤ x i ∧ x i ≤ b`, `hP` ⟹ `sampleVar x ≤ n/(n-1) * ((b-a)^2/4)`. Faithful.

| Source sentence | Lean | Classification |
|---|---|---|
| :66-67 Popoviciu gives `(1/n)∑(x_i-x̄)² ≤ (b-a)²/4` | `P01_S1` = instance of `hP` | faithful; `1 ≤ n` from `2 ≤ n` by `omega`: FAIR_IMPLICIT_STEP |
| :68 multiply both sides by `n/(n-1)` gives the claim | `P01_S2`: `mul_le_mul_of_nonneg_left` with `0 < n/(n-1)`, then identity `n/(n-1)·(1/n)·S = s²` by `field_simp; ring` | faithful; positivity of `n/(n-1)` (from `n ≥ 2`) and the identification with `s²` (Definition def:var) are FAIR_IMPLICIT_STEPs |

No route change, no stronger result used, no new mathematics.

## 6. Non-vacuity (auditor probe)

- Witness `n = 3`, `a = 0`, `b = 1`, `x = (0, 1, 1/2)` (nonconstant) satisfies `hx`; `P01` instantiates on it. Compiles.
- Consistency of the external parameter: the probe contains `popoviciu_holds : Popoviciu`, proved in Lean
  (walk: axioms propext/Classical.choice/Quot.sound, sorryAx not reached), and an instance of `P01` with
  no hypotheses left. Hence `hP` is not contradictory and P01 is not vacuous through it.
  This is an auditor's consistency check only; it does not change the verdict (the source proves nothing here and
  cites the result). It is information for the coordinator/authors: the condition is mathlib-provable in ~30 lines.

## 7. Status for the authors

Verified: Proposition prop:popoviciu (main.tex:58-63) along the source route, given Popoviciu's inequality as cited at main.tex:66-67.
Depends on: external parameter `Popoviciu` (cited result, [popoviciu]).
Source assessment: no errors, gaps or ambiguities found in :58-69; the two-line proof is complete given the citation.

FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
CONDITIONS: Popoviciu
