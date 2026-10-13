# Final audit: P01 (Proposition prop:concave, main.tex:55-63)

- Auditor: pv-auditor (independent subagent, Opus), 2026-10-12 22:14 EDT
- Audited object: `pv_work/P01.lean` (no gap file; no `P01ModGaps.lean`)
- Inputs read in full: `source/main.tex:1-80` (statement 55-58, proof 60-63, conventions 24-34), `pv_work/P01.lean`, `pv_work/P01Stmt.lean`, `pv_work/Defs.lean`, `verification/audits/P01_gate.md`, `P01_gate_r2.md`, `DEFS_gate.md`, `pv_work/notes/P01_prover_notes.md`
- Mechanical report: `verification/audits/P01_mech.md` (run by me, `python3 scripts/pv_audit_mech.py P01`) — `MECH CHECKS: PASS`
- Probe: `pv_work/probes/auditor/P01/auditor_P01_nonvac.lean`, `scripts/pv_lean.sh probe …` -> exit=0 errors=0 sorry_warnings=0, log `pv_work/logs/auditor_P01_nonvac_1.log` (`#pv_axioms P01: ALL STANDARD`)

## 1. Mechanical checks (script, run by the auditor)

| # | Check | Result |
|---|---|---|
| 1 | compile `P01` | PASS (exit=0, 0 errors, 0 sorry) |
| 2 | private rebuild, sha256 | PASS, IDENTICAL `384504…4bbf` |
| 3 | PVTools.lean hash | PASS |
| 4 | fingerprints vs `P01_gate_r2.md` (7 gated decls) | PASS, all th/vh/bi identical |
| 5 | `Defs` vs `DEFS_gate.md` | PASS |
| 6 | `#pv_axioms P01` | ALL STANDARD |
| 7 | `#pv_walk P01` | sorryAx not reached; axioms propext, Classical.choice, Quot.sound |
| 9 | helpers not in snapshot | none |
| 10 | `#pv_hyp_usage` | no UNUSED hypotheses in S0–S3, main |
| 11 | traced conditions | none |

**Hash comparison against the gate (the prover did not do it).** Done here:
- `python3 scripts/pv_snapshot.py hash pv_work/P01Stmt.lean` = `18d6929b…2b25e`, identical to the file hash recorded in `P01_gate_r2.md:7`.
- Type hashes of the proved file (script item 4) equal the r2 snapshot: S0 2738458216, S1 3452030608, S2 3541686319, S3 1121683978, main 1121683978, `P01Claim` 1771785297/3019997781, `SqrtConcave` 3944470172/182622040. The prover's self-reported values (notes:12) also match, but are not relied on.

## 2. Gap file
None. All obligations proved; not applicable.

## 3. Axioms / sorry
Only the three standard axioms; no `sorryAx` in the closure (items 6–7; reconfirmed in the probe log).

## 4. Per-theorem conditionality
`P01_main (n : ℕ) (hn : 1 ≤ n) : ∀ p q, P01Claim n p q`. No external parameters (`SqrtConcave` was discharged as step S0 per gate r1 option A, r2 confirmed). Hypotheses are only the printed convention `n ≥ 1` (main.tex:24) and `p, q ∈ I` (inside `P01Claim`). No condition to trace.

## 5. Infrastructure (item 8)

| Constant | Module | Record | Judgement |
|---|---|---|---|
| `Paper.DEFS.IClosed` | Defs | `DEFS_gate.md` (named, snapshot line 46) | PASS |
| `Paper.DEFS.V` | Defs | `DEFS_gate.md` (named, snapshot line 48) | PASS |
| `Paper.P01.P01Claim` | P01Stmt | `P01_gate_r2.md` (snapshot line 38) | PASS |
| `Paper.P01.P01Claim._proof_1` | P01Stmt | auxiliary term auto-generated inside the gated `P01Claim` body; covered by its `vh` | PASS |
| `Paper.P01.SqrtConcave` | P01Stmt | `P01_gate_r2.md` (snapshot line 39) | PASS (it is the statement of S0, proved, not an input) |

No helper lemmas outside the snapshot.

## 6. Route fidelity

| Source (main.tex) | Lean | Ruling |
|---|---|---|
| 61 "It is well known that $p\mapsto\sqrt{p(1-p)}$ is concave on $I$" | `P01_S0 : SqrtConcave` proved from mathlib `Real.strictConcaveOn_sqrt` + `Real.sqrt_le_sqrt` + `nlinarith` (concavity of $p(1-p)$, monotone concave outer function) | `FAIR_IMPLICIT_STEP`: the source asserts a standard true fact without proof; filled in by the standard composition argument; no stronger statement used than the one the source invokes |
| 61-62 "the inequality defining concavity at the midpoint of $p$ and $q$" | `P01_S1`: S0 with weights $a=b=\tfrac12$, `(1/2)p+(1/2)q=(p+q)/2` by `ring` | faithful |
| 62 "divided by $\sqrt n$" | `P01_S2`: $\sqrt{x(1-x)/n}=\sqrt{x(1-x)}/\sqrt n$ (`Real.sqrt_div'`); `P01_S3`: rewrite with S2, divide S1 by $\sqrt n>0$ | faithful; `FAIR_IMPLICIT_STEP` for $\sqrt{a/n}=\sqrt a/\sqrt n$ and $\sqrt n>0$ from $n\ge1$ |
| 55-57 statement | `P01_main` from S3 | faithful |

Route unchanged; no stronger result used; no new mathematics beyond the standard fill-in of the "well known" fact.

**Reading $I$ = `IClosed` = $[0,1]$.** The source (main.tex:24) does not say open or closed. For P01 the closed reading is the stronger one for the conclusion, and the same $I$ is used for the invoked fact on line 61, which is true on $[0,1]$ (proved here). The probe derives the open-interval version from `P01_main` via `Set.Ioo_subset_Icc_self`, so P01 is verified under both readings and the ambiguity cannot manufacture or hide a paper error here. (The ambiguity matters for lem:positive, main.tex:48/52, handled under L02, not in this result.)

## 7. Non-vacuity (probe compiled, exit=0)
- nontrivial witness $n=3$, $p=\tfrac14$, $q=\tfrac34$: `P01_main` applies (hypotheses satisfiable);
- boundary witness $n=1$, $p=0$, $q=1$ of the closed reading;
- open-reading corollary for all $n\ge1$, $p,q\in(0,1)$;
- `rfl` check: `P01Claim n p q` unfolds definitionally to the printed clause of main.tex:56-57 with $V_n(p)=p(1-p)/n$ and $I=[0,1]$.

## 8. Status for the authors
Proposition prop:concave (main.tex:55-58) is verified in full along the printed route, with no external inputs, for $I=[0,1]$ and hence also for $I=(0,1)$.
Depends only on mathlib (concavity of $\sqrt{\cdot}$). Source assessment: no error or gap; "well known" (line 61) is a fair implicit step; the open/closed ambiguity of $I$ (line 24) does not affect this result.

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
CONDITIONS: none
