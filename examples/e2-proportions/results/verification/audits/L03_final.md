# L03 final audit (Lemma `lem:linear`, main.tex:65-71)

- Auditor: pv-auditor (independent subagent; not drafter, gate, prover or issue checker for this result)
- Date: Mon Oct 12 22:47:21 EDT 2026
- Audited object: `pv_work/L03ModGaps.lean` (gap file; stopped obligation S2), with `pv_work/L03.lean` compared against it
- Source read directly: main.tex:22-34 (setting, definitions), 38-45 (`lem:quarter`), 65-71 (`lem:linear` and proof)
- Read: gate report `L03_gate.md`, `DEFS_gate.md` (relevant lines), `L03_issue_1_audit.md`, `L01_final.md` (verdict lines and step table), prover notes, `L03Stmt.lean`, `L03Draft.lean`, `L03.lean`, `L03ModGaps.lean`, `L01Stmt.lean`
- Mechanical report: `verification/audits/L03_mech.md` (run by me: `python3 scripts/pv_audit_mech.py L03 --module L03ModGaps`), `MECH CHECKS: PASS (2 manual checks listed above)`
- Auditor probe: `pv_work/probes/auditor/L03/aud_L03_final_gap.lean`, `scripts/pv_lean.sh probe`: exit=0 errors=0 sorry_warnings=2 (the two verbatim gated copies, by design) nonstandard_axiom_lines=0; log `pv_work/logs/aud_L03_final_gap_1.log`

## 1. Mechanical checks (from the script, run by me)

| # | Check | Result |
|---|---|---|
| 1 | compile `L03ModGaps` | PASS (0 errors, 0 sorry) |
| 2 | private rebuild sha256 | PASS, IDENTICAL (e9db4b40…2e46) |
| 3 | PVTools hash | PASS |
| 4 | gated fingerprints (4 decls) | PASS |
| 4b | `L03_S2_Gap` vh vs S2 th | MANUAL, resolved in §2 below: PASS |
| 5 | Defs vs DEFS snapshot | PASS |
| 6 | `#pv_axioms L03ModGaps` | PASS, ALL STANDARD |
| 7 | `#pv_walk L03ModGaps` | PASS, sorryAx not reached; propext, Classical.choice, Quot.sound only |
| 9 | helpers not in snapshot | none |
| 10 | `#pv_hyp_usage` | no UNUSED premise in `L03_S1`, `L03_main_mod_gaps` |
| 11 | traced conditions | none |
| 12 | last writers | prover (gap file), drafter (Stmt): PASS |

## 2. Gap-file exact-statement check (VERIFICATION_METHODS §2b, numeral exception)

Probe redeclares, under their original full names, `Paper.L03.L03_S2` and `Paper.L03.L03_main` verbatim from `L03Draft.lean:17-19, 22-23`.

| Check | Result |
|---|---|
| `#pv_type_hashes_here`: `L03_S2` th | 757243603 = gate snapshot (L03_gate.md:89) |
| `#pv_type_hashes_here`: `L03_main` th | 4183471981 = gate snapshot (L03_gate.md:90) |
| `example : L03_S2_Gap = type_of% @L03_S2 := rfl` | compiles. The vh/th difference is only the `instOfNatAtLeastTwo … _proof_1` naming of the real numeral `4` (confirmed: `L03_S2_Gap._proof_1` is reached in the walk) |
| `example (g2 : L03_S2_Gap) : type_of% @L03_main := L03_main_mod_gaps g2` | compiles |
| `L03.lean` vs `L03ModGaps.lean` | identical except the stopped S2 (`sorry` theorem → `def L03_S2_Gap`) and the main theorem renamed `_mod_gaps` with premise `hGap_2`; proof body identical. `L03.lean` is not built (contains `sorry`), as intended |

Only the main theorem is gap-dependent; S1 does not depend on S2.

## 3. Conditionality

`#pv_hyp_usage L03_main_mod_gaps` (probe): `hGap_2`, `n`, `hn`, `p`, `hp` all USED. `hGap_2` is the gap premise (S2, main.tex:70), not an external parameter. No `def … : Prop` tool, no consumed predecessor clause: L01 enters as a proved, audited module (`L01_main`, used in S1). TRACED CONDITIONS: none, confirmed.

## 4. Infrastructure (item 8)

| Constant | Record | Status |
|---|---|---|
| `Paper.DEFS.IOpen`, `Paper.DEFS.V` | `DEFS_gate.md` (IOpen fingerprint line 47; V content item 2) | PASS |
| `Paper.L01.L01_S1`, `L01_S2`, `L01_main` | `L01_final.md` (each named in its step table; FINAL AUDIT: PASS, UNCONDITIONAL) | PASS |
| `Paper.L01.Conclusion`, `.mk` | `L01_gate.md` (structure of the L01 statement; I read `L01Stmt.lean`: two fields, identity and bound, faithful to main.tex:39) | PASS |
| `Paper.L03.L03Claim`, `._proof_1` | `L03_gate.md` (gated def and its numeral auxiliary) | PASS |

No constant without a record; no helpers.

## 5. Route fidelity

| Source | Lean | Ruling |
|---|---|---|
| main.tex:70 "By Lemma~\ref{lem:quarter}" | `L03_S1 := L01_main n hn p` | faithful; uses exactly the cited lemma, not a stronger one |
| main.tex:70 "$V_n(p) = \frac{p(1-p)}{n}$" | definitional unfolding of `Defs.V` in the `exact` | FAIR_IMPLICIT_STEP (definition of V, main.tex:27; filled by `rfl`-level unfolding) |
| main.tex:70 "$\le \frac{p}{4n}$" | S2, stopped; `L03_S2_Gap` | stopped at the first unjustified step; not repaired, no alternative route |
| assembly | `intro hp; exact hGap_2 n hn p hp (L03_S1 …)` | faithful |

## 6. Non-vacuity

Probe: `L03_S1 3 _ (1/10)` gives `L01.Conclusion 3 (1/10)` (non-gap part runs at a nontrivial point); the premises `1 ≤ n`, `p ∈ IOpen` are jointly satisfiable (n = 1, p = 1/10). The gap premise itself is refuted in the probe, `aud_gap_false : ¬ L03_S2_Gap` (witness n = 1, p = 1/10 with L01's conclusion supplied; walk: standard axioms, no sorryAx). So `L03_main_mod_gaps` says nothing about the printed claim; this is the expected consequence of the confirmed ERROR, not a formalization defect.

## 7. Source assessment

S2 (main.tex:70) and the printed claim (main.tex:66) are false: `ERROR`, confirmed in `L03_issue_1_audit.md` (COUNTEREXAMPLE VALID, n = 1, p = 1/10; failure set p ∈ (0, 3/4) for every n), with the step being a subsumed `PAPER_ARGUMENT_GAP`. The issue is in this result itself, so the verdict is ISSUE. The open/closed reading of I (L02 issue 1) does not affect this.

## Status for the authors

Verified: the proof's first step (citing Lemma quarter, L01) and the assembly, exactly as gated; no external inputs.
Depends on: nothing beyond the audited L01.
Assessment: Lemma lem:linear is false as printed (V_1(1/10) = 9/100 > 1/40); the step at main.tex:70 does not follow from Lemma quarter. ERROR.

FINAL AUDIT: PASS
SUGGESTED VERDICT: ISSUE
CONDITIONS: none
