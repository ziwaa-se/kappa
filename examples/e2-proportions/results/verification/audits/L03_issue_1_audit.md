# L03 issue 1: counterexample review (pv-auditor)

- Date: Mon Oct 12 22:27:29 EDT 2026
- Audited: `pv_work/L03_Counterexample1.lean`, ruling `verification/audits/L03_issue_1.md`
- Source read directly: main.tex:22-29 (setting, `def:vp`), 38-45 (`lem:quarter`), 65-71 (`lem:linear` and its proof)
- Auditor probe: `pv_work/probes/auditor/L03/aud_L03_cex1.lean`, log `pv_work/logs/aud_L03_cex1_1.log` (exit=0, 0 errors, 0 sorry)

## 0. File identity (sha256, `python3 scripts/pv_snapshot.py hash`)

| File | sha256 | Matches |
|---|---|---|
| `pv_work/L03_Counterexample1.lean` | 584c6d2a…a440 | ruling §5 |
| `pv_work/L03Stmt.lean` | bea10783…d3c0 | gate snapshot |
| `pv_work/Defs.lean` | 0259b9aa…1b67 | gate snapshot |
| `pv_work/L01.lean` | 2de3dbc0…c44b | gate snapshot |
| `source/main.tex` | e1df515b…cb8 | gate snapshot |

## 1. Encoding fidelity (decisive item)

| Check | Result |
|---|---|
| Gated statement fingerprint, through the counterexample's import | `Paper.L03.L03Claim|def|th=1224325432|vh=2238774786|bi=ee`, identical to the gate snapshot (L03_gate.md:80) |
| `gated_eq_printed` | `Iff.rfl` compiles: the refuted `PrintedClauseOpen` is definitionally the gated `∀ n, 1 ≤ n → ∀ p, L03Claim n p` |
| Auditor's independent unfolded restatement | `example … Iff.rfl` in the probe: gated statement ⇔ `∀ n ≥ 1, ∀ p, 0<p∧p<1 → p(1-p)/n ≤ p/(4n)`; `PrintedClauseClosed` ⇔ the same with `0≤p∧p≤1`. Both compile. |
| Word-for-word vs main.tex:66 + :24 + :27 | "For every p ∈ I, V_n(p) ≤ p/(4n)", n ≥ 1 integer, V_n(p)=p(1-p)/n. Matches; `n : ℕ` with `1 ≤ n`, cast to ℝ, real division (no truncation). |
| Not stronger than the source | Open clause: same premises as printed (I read as (0,1), the weaker reading), same conclusion. Closed clause: same premises under the other reading. No premise dropped, no conclusion strengthened. |
| Parameters vs global objects | `n` is the global convention (main.tex:24), universally quantified with `1 ≤ n`; `I` is a global fixed set; `V` is the global definition (main.tex:27). Nothing is constructed from parameters. |

Since IOpen ⊆ IClosed, refuting the open reading also refutes the closed one (`closed_implies_open`); the file additionally refutes the closed reading directly. So the open/closed ambiguity of I (L02 issue 1) cannot affect this ruling.

## 2. The instance satisfies every printed hypothesis

- Witness n = 1, p = 1/10. n = 1 is an integer ≥ 1 (main.tex:24). p = 1/10 ∈ (0,1) ⊆ [0,1] (`tenth_mem_open`, `tenth_mem_closed`).
- No definition or convention excludes it: main.tex:24 only fixes n ≥ 1 and I; main.tex:27 defines V_n for all real p; Lemma lem:linear has no further hypothesis. I read the whole statement area (lines 22-71); there is no other restriction.
- Arithmetic (also by hand): V_1(1/10) = (1/10)(9/10) = 9/100 > 1/40 = p/(4n).
- Auditor's independent re-derivation (probe, not using the checker's lemmas) refutes the gated statement at the same witness; a second witness n = 7, p = 1/2 refutes the closed clause (1/28 > 1/56).

## 3. The counterexample is proved

| Check | Result |
|---|---|
| Compile (auditor ran) | `scripts/pv_lean.sh build L03_Counterexample1`: exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0, log `pv_work/logs/L03_Counterexample1_2.log` |
| `#pv_axioms L03_Counterexample1` | ALL STANDARD (13 declarations), each `[propext, Classical.choice, Quot.sound]` |
| `#pv_walk L03_Counterexample1` | axioms in closure standard; `sorryAx reached: false` |
| `#pv_walk_decl gated_statement_false` | standard axioms, no sorryAx; project constants reached: only `Defs.IOpen`, `Defs.V`, `L03Stmt.L03Claim` and the file's own lemmas. It does **not** depend on L01. |
| `#pv_walk_decl counterexample_closed` | standard axioms, no sorryAx; only `Defs.IClosed`, `Defs.V` and own lemmas. |
| Earlier theorems used | Only `step_fails_with_L01` uses `Paper.L01.L01_main` (with L01_S1, L01_S2); L01 has an individual final audit `verification/audits/L01_final.md` (FINAL AUDIT: PASS, UNCONDITIONAL). The refutations themselves use no earlier theorem. |

## 4. Scope

- Refuted: the printed clause main.tex:66 under both readings of I, for n = 1; by `fails_every_n` (Lean, standard axioms) for **every** n ≥ 1 at p = 1/10. By `open_iff` (Lean), on (0,1) the inequality holds exactly for p ≥ 3/4, so the failure set is (0, 3/4) for every n. This is correctly used only as a scope description.
- Classification `ERROR` (primary) is correct: the printed conclusion is false, not merely unjustified. The step main.tex:70 is also unjustified (`step_fails_with_L01`: L01's full conclusion and p ∈ I hold at the witness, the step fails), correctly recorded as a subsumed `PAPER_ARGUMENT_GAP` aspect. The ruling's rejection of DOMAIN_CLARIFICATION, PAPER_ASSUMPTION_GAP, EXPOSITION_GAP and ENCODING_ERROR is sound for the reasons given.
- Not refuted / not affected: Lemma lem:quarter (L01) and its bound V_n(p) ≤ 1/(4n); the true endpoint cases p = 0, 1 of the closed reading; any other result. Downstream: I did not independently re-verify the inventory claim that no result cites lem:linear, but in main.tex:36-88 the only `\ref` uses are `lem:quarter` (lines 70, 78); no `\ref{lem:linear}` occurs, so no downstream use exists.

## 5. Suggested fixes (checked by hand)

- (a) V_n(p) ≤ p/n: p(1-p) ≤ p ⇔ p² ≥ 0, true for all real p, n > 0. Correct; and correctly noted that the proof must then cite this, not lem:quarter (which only gives 1/(4n) and does not imply p/n for p < 1/4).
- (b) Keep p/(4n) with p ∈ [3/4, 1]: correct on [3/4,1) by `open_iff`, and at p = 1 (0 ≤ 1/(4n)). Justification at main.tex:70 must still change. Correct.
- (c) Delete the lemma: removes the problem; nothing cites it.
These remain suggestions to the authors only.

## 6. Conclusion

The counterexample targets exactly the gated (and printed) clause, satisfies every printed hypothesis under both readings of I, compiles cleanly with only standard axioms and no sorry, and its core refutation depends on no earlier theorem. The ruling's classification (`ERROR`, with the argument-gap aspect subsumed) and scope are confirmed.

COUNTEREXAMPLE VALID (n = 1, p = 1/10 satisfies all printed hypotheses (I open or closed) and V_1(1/10) = 9/100 > 1/40; the refuted clause is fingerprint-identical to the gated L03 statement; clean build, standard axioms only.)
