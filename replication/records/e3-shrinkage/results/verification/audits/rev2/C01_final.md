# C01 final audit (Corollary cor:half, main.tex:69-76)

- Auditor: pv-auditor (independent subagent, Opus 5.5)
- Started: Mon Oct 12 22:39:30 EDT 2026; finished Mon Oct 12 22:45:00 EDT 2026 (`date`)
- Audited object: `pv_work/C01.lean` (no gap file; all obligations S1-S4 and the main theorem are proved)
- Read in full: main.tex:1-79 (the whole file: setting l.25, Definition l.27-34, lem:square l.38-46, lem:min l.48-56, cor:half l.69-76), `pv_work/C01.lean`, `pv_work/C01Stmt.lean`, `pv_work/Defs.lean`, `pv_work/L01.lean`, `pv_work/L02Stmt.lean`, `C01_gate.md`, `C01_prover_notes.md`; verdict lines of `L01_final.md`, `L02_final.md`

## 1. Mechanical checks (`python3 scripts/pv_audit_mech.py C01`, run by me) -> `verification/audits/C01_mech.md`

| # | Check | Result |
|---|---|---|
| 1 | check `C01` | PASS (exit 0, 0 sorry) |
| 2 | private rebuild, sha256 | PASS, IDENTICAL (685e36b3...) |
| 3 | PVTools.lean hash | PASS |
| 4 | fingerprints vs `C01_gate.md` (7 gated decls) | PASS, all identical |
| 5 | `Defs` vs `DEFS_gate.md` | PASS |
| 6 | `#pv_axioms C01` | PASS, ALL STANDARD |
| 7 | `#pv_walk C01` | PASS, no sorryAx; propext, Classical.choice, Quot.sound only |
| 9 | undeclared helpers | none |
| 10 | hyp usage | no UNUSED premise in any gated theorem |
| 11 | TRACED CONDITIONS | none (confirmed below, item 4) |
| | MECH CHECKS | **PASS** |

Remark on the run: the script's own probe produced no output for about 15 minutes, so I reran its probe content by hand (`pv_work/probes/auditor/C01/auditor_C01_manualmech.lean`, log `pv_work/logs/auditor_C01_manualmech_1.log`: ALL STANDARD, 5 decls; closure axioms the three standard ones; sorryAx false; EXIT=0). The script then completed with exit 0 and `MECH CHECKS: PASS`; both runs agree. The header timestamp in `C01_mech.md` (22:28) precedes the actual run start (log created 22:33); cosmetic, no effect on results.

## 2. Gap file

None (`C01ModGaps.lean` does not exist; the prover notes say no gaps). Not applicable.

## 3. Axioms and sorry

Mech items 6-7 PASS, confirmed by my manual rerun and by the declaration walks below.

## 4. Per-theorem conditionality

Probe `pv_work/probes/auditor/C01/auditor_C01_audit.lean` (log `pv_work/logs/auditor_C01_audit_1.log`, exit 0):

| Walk / usage | Result |
|---|---|
| Positive control: `#pv_walk_decl Paper.C01.C01_S4` | reaches `Paper.C01.C01_L02Consumed` and `Paper.L02.Conclusion` (module L02Stmt): use detected |
| `#pv_walk_decl Paper.C01.C01` (main theorem) | modules C01 (C01, C01_S1, C01_S2), C01Stmt (Conclusion, Conclusion._proof_1), Defs, L01 (L01, L01_S1..S3, pos_of_setting). **Does not reach `C01_L02Consumed` nor any L02 constant.** No sorryAx; standard axioms |
| `#pv_hyp_usage` C01, C01_S1, C01_S2 | θ, σ, h all USED; no external parameter in these signatures |

Conclusion: the main theorem `C01` has no external parameter in its signature and its closure does not touch the parameter `C01_L02Consumed`. That parameter is used only by `C01_S4`, which encodes the second proof sentence (main.tex:75-76), a remark that the printed statement does not need. Per VERDICTS §1.1 item 4 (signature of the theorem), it is **not a condition of C01**; it is "remark only". `C01_L02Consumed` is also not registered in `EXTERNAL_TOOLS.md`, which is why item 11 reports none; this does not matter for C01's verdict, since the main theorem does not reach it.

## 5. Infrastructure

| Constant(s) in the closure of C01 | Module | Record | Status |
|---|---|---|---|
| `Paper.Setting`, `.mk`, `.sigma_pos`, `risk`, `oracleFactor`, `oracleRisk` | Defs | `DEFS_gate.md` (fingerprints identical, mech item 5) | covered |
| `Paper.L01.L01`, `L01_S1`, `L01_S2`, `L01_S3`, `pos_of_setting` | L01 | `L01_final.md`: FINAL AUDIT PASS, UNCONDITIONAL; names L01_S1..S3, L01 and audits `pos_of_setting` individually (its line 38) | covered |
| `Paper.C01.Conclusion`, `C01_L02Consumed` | C01Stmt | `C01_gate.md` (gated, identical fingerprints) | covered |
| `Paper.C01.Conclusion._proof_1` | C01Stmt | audited here | auto-generated auxiliary proof term inside the gated def `Conclusion` (its `vh` is covered by the gate fingerprint of `Conclusion`); within the clean axiom closure; not a mathematical statement of its own. PASS |
| `Paper.L02.Conclusion` (only via S4) | L02Stmt | `L02_gate.md`, `L02_final.md` line 56 (named, PASS) | covered; not in the main theorem's closure |
| item 9 helpers | - | none | - |

Every in-project constant in the closure has an individual record.

## 6. Route fidelity

| Source sentence | Lean | Ruling |
|---|---|---|
| main.tex:74 "By Lemma lem:square, R(1/2) - R(c*) = (θ²+σ²)(1/2 - c*)²" | `C01_S1`: `L01` at c=1/2 and at c=c* (the latter has square (c*-c*)²=0), then `linarith` subtracts | faithful; `FAIR_IMPLICIT_STEP`: the source applies lem:square to the difference directly; filled in as lem:square at both points (the c=c* instance gives R(c*)=ρ) and subtraction. No stronger result used. |
| main.tex:74 "≥ 0" | `C01_S2`: `positivity` with `sigma_pos` | `FAIR_IMPLICIT_STEP`: (θ²+σ²) ≥ 0 times a square; standard |
| (statement l.70) | `C01`: `linarith` from S1, S2 | pure assembly |
| main.tex:75 "R(c*) = ρ" | `C01_S3`: L01 at c=c* | faithful (lem:square, not lem:min; see source assessment); not used by the main theorem |
| main.tex:75 "By Lemma lem:min, ... ρ ≤ min{θ², σ²}" | `C01_S4`: applies `C01_L02Consumed` | faithful; remark only; not used by the main theorem |

No route change, no helper lemmas, no new mathematics. The main theorem follows exactly the first proof sentence, which alone proves the corollary.

## 7. Non-vacuity

Compiled in `auditor_C01_audit.lean`: `Setting 3 2` and `Setting (-1) (1/10)` inhabited; `C01` applied to both gives `Conclusion`; at θ=3, σ=2, `R(c*) = 36/13` and `R(1/2) = 13/4` (proved by `norm_num`), so the conclusion is a nontrivial strict comparison there. `rfl` check: `Conclusion = fun θ σ => risk θ σ (θ²/(θ²+σ²)) ≤ risk θ σ (1/2)`, i.e. main.tex:70 with Definition l.30-31 unfolded.

## 8. Status for the authors

Corollary cor:half (R(c*) ≤ R(1/2)) is verified along its first proof sentence (main.tex:74), with no external parameter; it depends only on Lemma lem:square (L01, UNCONDITIONAL).
The second proof sentence (l.75-76) is not needed. It rests on lem:min (L02, whose proof has a recorded PAPER_ARGUMENT_GAP, L02_issue_1; its conclusion is true), and it cites lem:min for "R(c*) = ρ", which actually comes from lem:square at c = c*: `EDITORIAL`, not a paper issue of C01.

Records to update: C01 has no `upstream_issues` dependence through its statement; L02_issue_1 touches only the remark (S4). `C01_L02Consumed` is unregistered in `EXTERNAL_TOOLS.md`; register it as "remark only, not a condition" if the coordinator tracks it.

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
CONDITIONS: none
