# L02 final audit (Lemma `lem:positive`, main.tex:47-53)

- Auditor: pv-auditor (independent subagent, claude-opus-5-5), session 0a40983b
- Date: Mon Oct 12 22:12:09 EDT 2026 (from `date`)
- Audited object: `pv_work/L02.lean` (no gap file; prover notes report no gaps)
- Read directly: main.tex:1-80 (conventions main.tex:24, Def `def:vp` main.tex:26-29, statement 47-49, proof 51-53); `pv_work/L02.lean`, `pv_work/L02Stmt.lean`, `pv_work/Defs.lean` (full text); `verification/audits/L02_gate.md`, `verification/audits/DEFS_gate.md`, `pv_work/notes/L02_prover_notes.md`.
- Not ruled here: the open/closed reading of $I$ (pending in `verification/audits/L02_issue_1.md`, pv-issue-checker).

## 1. Mechanical checks (run by me: `python3 scripts/pv_audit_mech.py L02`)

Report: `verification/audits/L02_mech.md`, `MECH CHECKS: PASS`.

| # | Check | Result |
|---|---|---|
| 1 | compile `L02` | PASS (exit=0, errors=0, sorry_warnings=0) |
| 2 | private rebuild, sha256 | PASS, IDENTICAL (dd4e7282…bec3) |
| 3 | PVTools.lean hash | PASS |
| 4 | gated fingerprints vs L02_gate.md (4 decls) | PASS |
| 5 | Defs vs DEFS_gate.md | PASS |
| 6 | `#pv_axioms L02` | ALL STANDARD |
| 7 | `#pv_walk L02` | sorryAx not reached; axioms propext, Classical.choice, Quot.sound |
| 9 | helpers not in snapshot | none |
| 10 | `#pv_hyp_usage` | no UNUSED hypothesis in S1, S2, main |
| 11 | traced conditions | none |
| 12 | last writers | L02.lean: pv-prover; L02Stmt.lean: pv-drafter |

## 2. Hash comparison requested by coordinator (S1, S2 explicitly)

Source of current values: `pv_work/logs/auditor_L02_mech1_1.log` (my run). Gate values: `L02_gate.md` lines 74, 81-83.

| Declaration | Gate | Current | Match |
|---|---|---|---|
| `Paper.L02.L02Claim` | th=1224325432 vh=145004741 bi=ee | th=1224325432 vh=145004741 bi=ee | yes |
| `Paper.L02.L02_S1` | th=618443327 bi=ee | th=618443327 bi=ee | yes |
| `Paper.L02.L02_S2` | th=3284042729 bi=ee | th=3284042729 bi=ee | yes |
| `Paper.L02.L02_main` | th=2541145649 bi=eee | th=2541145649 bi=eee | yes |
| `Paper.DEFS.IOpen` | th=1707065593 vh=3179713877 | same | yes |
| `Paper.DEFS.V` | th=869665623 vh=2666805293 | same | yes |

The prover notes said S1/S2 were "not separately compared"; they are now compared and identical.

## 3. Gap files

None (no `L02ModGaps.lean`; no stopped obligations).

## 4. Per-theorem conditionality

No external parameters (`def … : Prop`) appear in any gated statement. The hypotheses are `hn : 1 ≤ n` (main.tex:24) and `p ∈ IOpen` (main.tex:48). Both are used: `hp` in S1, `hn` in S2, and both in main. CONDITIONS: none.

## 5. Infrastructure (item 8 constants)

| Constant | Record | Individually covered | Comment |
|---|---|---|---|
| `Paper.DEFS.IOpen` | DEFS_gate.md (named in snapshot line 47, ruling item 4) | yes | `Set.Ioo 0 1`; plain def |
| `Paper.DEFS.V` | DEFS_gate.md (snapshot line 48, ruling item 2) | yes | `p*(1-p)/(n:ℝ)`, matches main.tex:27 |
| `Paper.L02.L02Claim` | L02_gate.md | yes | `p ∈ IOpen → 0 < V n p` |

No in-project theorems are consumed. There are no helpers to review.

## 6. Route fidelity (sentence by sentence)

| Source (main.tex:52) | Lean | Ruling |
|---|---|---|
| "For $p\in I$ both $p$ and $1-p$ are positive" | `L02_S1`: destructure `Ioo` membership, `linarith` for `0 < 1 - p` | faithful (pure conversion) |
| "and $n>0$" (with $n\ge1$, main.tex:24) | `L02_S2`: `exact_mod_cast hn` | faithful (cast) |
| (unwritten) hence $p(1-p)/n>0$ | `L02_main`: `unfold V; div_pos (mul_pos h1 h2) h3` | FAIR_IMPLICIT_STEP: positivity of product and quotient of positives, filled with `mul_pos`, `div_pos` |

The route is unchanged, no stronger result is used, no helpers are added, and no mathematical content is added.

## 7. Non-vacuity

Probe: `pv_work/probes/auditor/L02/auditor_L02_nonvac.lean`, `scripts/pv_lean.sh probe` gives exit=0, errors=0, sorry_warnings=0, nonstandard_axiom_lines=0 (log `pv_work/logs/auditor_L02_nonvac_2.log`). It shows:
- `(1/2) ∈ IOpen`, and `L02_main 3 _ (1/2) _ : 0 < V 3 (1/2)`, with `V 3 (1/2) = 1/12` (a nontrivial witness);
- `∃ n p, 1 ≤ n ∧ p ∈ IOpen` (the hypotheses are jointly satisfiable).
- Reading record only, not a ruling: `0 ∈ IClosed ∧ V 1 0 = 0` compiles. Under the closed reading the printed clause fails at the endpoint. This is the question pending in `L02_issue_1.md`.

## 8. Reading recorded (not ruled)

$I$ is read as the open interval `IOpen = (0,1)`. The gate approved this reading because the source's own proof (main.tex:52) asserts $p>0$ and $1-p>0$ for $p\in I$. The source never says whether $I$ is open or closed (main.tex:24), and main.tex:27-28 suggests the closed reading. The verdict below holds for the open reading. The classification of the ambiguity belongs to `L02_issue_1.md`. If that ruling confirms a paper-side issue in L02, the coordinator should apply VERDICTS §1 for the mixed case instead of this suggested verdict.

## 9. Status for the authors

The lemma is verified exactly as the source proves it, under the reading $I=(0,1)$, with no external dependencies. Source assessment: the proof is correct for the open interval. Whether $I$ means the open or the closed unit interval is undefined (main.tex:24), and the lemma is false at $p\in\{0,1\}$ under the closed reading. This is under separate ruling.

FAIL items: none.

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
CONDITIONS: none
