# L01 final audit (Lemma lem:square, source/main.tex:39-52)

- Auditor: pv-auditor (claude-opus-5-5), fresh subagent; did not draft, gate or prove L01.
- Date: Tue Oct 13 01:14:30 EDT 2026 (from `date`).
- Audited object: `pv_work/L01.lean` (no gap file; no `L01ModGaps.lean`).
- Source read directly: main.tex:25 (standing assumption), :27-35 (Definition def:risk), :39-41 (statement), :43-52 (proof).
- Read: gate report `verification/audits/L01_gate.md`, `verification/audits/DEFS_gate.md`, prover notes `pv_work/notes/L01_prover_notes.md`, full text of `pv_work/L01.lean`, `pv_work/L01Stmt.lean`, `pv_work/Defs.lean`.

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py L01`)

Report `verification/audits/L01_mech.md`: **MECH CHECKS: PASS**.

| # | Check | Result |
|---|---|---|
| 1 | compile `L01` | PASS (exit 0, 0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL (a464e835…) |
| 3 | PVTools hash | PASS |
| 4 | gated fingerprints vs gate snapshot | PASS, **all 6** gated declarations (S1, S2, S3, S4, S5, main) th/vh/bi identical. This covers S1-S4, which the prover had not compared. |
| 5 | Defs vs DEFS snapshot | PASS |
| 6-7 | `#pv_axioms` / `#pv_walk` | ALL STANDARD; sorryAx not reached; closure axioms propext, Classical.choice, Quot.sound |
| 10 | `#pv_hyp_usage` | no UNUSED hypotheses in any gated theorem |
| 11 | traced conditions | none |

Independent confirmation in my probe `pv_work/probes/auditor/L01/auditor_L01_nonvac.lean` (log `pv_work/logs/auditor_L01_nonvac_3.log`, exit 0): `#pv_axioms L01: ALL STANDARD (6 declarations checked)`; `#print axioms` for L01, S1, S3, S4 = [propext, Classical.choice, Quot.sound].

## 2. Gap file
None. All obligations proved; not applicable.

## 3. Per-theorem conditionality
No external parameters. The only hypothesis besides real variables is `h : Setting θ σ` (= main.tex:25), reported USED in S1, S3, S4, S5 and main (S2 correctly has none). It enters through `s_ne` (θ²+σ² ≠ 0), needed for the divisions in c* and ρ. Not a condition.

## 4. Infrastructure (item 8, item 9)

| Constant | Module | Record | Ruling |
|---|---|---|---|
| `Paper.Setting`, `.mk`, `.theta_ne`, `.sigma_pos` | Defs | DEFS_gate.md (names D04 individually, PASS) | matches main.tex:25 |
| `Paper.risk` | Defs | DEFS_gate.md (D01, PASS) | matches :29 |
| `Paper.oracleFactor` | Defs | DEFS_gate.md (D02, PASS) | matches :31 |
| `Paper.oracleRisk` | Defs | DEFS_gate.md (D03, PASS) | matches :33 |
| `s_ne` (private, L01.lean:7-10) | L01 | audited here | PASS |

`s_ne` review: statement `Setting θ σ → θ^2 + σ^2 ≠ 0`; true (θ ≠ 0 gives θ² > 0, σ > 0 gives σ² > 0, sum > 0); non-vacuous (Setting is inhabited, see §6); proof uses only mathlib `sq_pos_of_ne_zero`, `sq_pos_of_pos`, `add_pos`, `ne_of_gt`; axioms standard (covered by the closure walk of the gated theorems); it does not contain or imply the target identity. Purely technical domain fact.

## 5. Route fidelity (sentence by sentence)

| Source | Lean | Ruling |
|---|---|---|
| :44 "Write s = θ²+σ², so that c* = θ²/s and 1-c* = σ²/s" | `L01_S1` (unfold, `rfl` + `field_simp`) | faithful. S1 is proved but not consumed by S5; the source likewise only uses these facts inside the expansion at :48. No issue. |
| :44-47 "For c = c*+d, R(c) = (c*+d)²σ² + (1-c*-d)²θ²" | `L01_S2` (unfold `risk`, `ring`) | faithful; substitution into the definition |
| :48 first equality (expansion) | `L01_S3` (unfold, `field_simp`, `ring`) | faithful; the expansion is routine algebra: FAIR_IMPLICIT_STEP (filled by `field_simp; ring` using s ≠ 0 from :25) |
| :48-49 second equality "= ρ + s d²" | `L01_S4` (unfold, `field_simp`, `ring`) | faithful; (θ⁴σ²+σ⁴θ²)/s² = θ²σ²/s and the bracket is 0: FAIR_IMPLICIT_STEP (algebra, s ≠ 0) |
| :49-51 "= ρ + s d², which is the claim" | `L01_S5` (chain S2, S3, S4 at d = c - c*, rewriting c*+(c-c*) = c) | faithful; d = c - c* is the source's own substitution |
| :40 statement | `L01` (`linarith` from S5) | subtraction of ρ, a notation-level rearrangement |

No route change, no stronger result used, no mathlib theorem beyond ring/field arithmetic. FAIR_IMPLICIT_STEPs: use of s ≠ 0 (from θ ≠ 0, σ > 0 at :25) to clear denominators; the polynomial expansions at :48.

## 6. Non-vacuity
Probe `auditor_L01_nonvac.lean` (exit 0): `Setting 1 1` and `Setting (-3) 2` inhabited; main theorem instantiated at θ = -3, σ = 2, c = 0 and checked against direct computation (R(0) = 9, ρ = 36/13, c* = 9/13; 9 - 36/13 = 13·(9/13)²). The main type was also checked against the source shape `∀ θ σ, Setting θ σ → ∀ c, R(c) - ρ = (θ²+σ²)(c - c*)²` by term ascription.

## 7. Notes
- Docstring slip (already noted by the gate): `pv_work/L01Stmt.lean:3` cites main.tex:38-40; the lemma is at :39-41. Comment only; for `verification/DOC_ERRATA.md`, not an audit failure.

## Status for the authors
Lemma lem:square (main.tex:39-41) is verified along the printed proof, with only the standing assumption θ ≠ 0, σ > 0 (:25). No external inputs.
Source assessment: the displayed computation at :47-49 is correct; no errors, gaps or ambiguities found.

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
CONDITIONS: none
