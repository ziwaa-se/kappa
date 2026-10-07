# P01 — independent final audit

- **Auditor**: `pv-auditor` (independent of drafter and prover; opus), Wed Sep 30 20:17:36 EDT 2026 (`date`).
- **Audited object**: `pv_work/P01.lean` (no gaps reported, so no `P01ModGaps.lean`).
- **Result**: P01 = PDF 2.2, `\begin{proposition}\label{prop:nesbitt}`, statement `source/main.tex:52-57`, proof `source/main.tex:59-69`.
- **Source read directly by me**: `source/main.tex:1-90` (whole note: Notation 26-33 with `\Rpos` 10-11, L01 37-50, the P01 statement 52-57 and proof 59-69, the remark 83-85, bibliography 87-90). Gate report, prover notes and `EXTERNAL_TOOLS.md` were read, but every ruling below rests on the `.tex` text, on the Lean sources I read in full, and on my own compiles.
- **Files read in full**: `pv_work/P01.lean` (149 lines), `pv_work/P01Stmt.lean`, `pv_work/L01Stmt.lean`, `verification/audits/P01_gate.md`, `verification/audits/P01_mech.md`, `pv_work/notes/P01_prover_notes.md`, `verification/EXTERNAL_TOOLS.md`, and the relevant parts of `verification/audits/L01_final.md`.
- **My probes** (written by me; no audited file was modified): `pv_work/probes/auditor/P01/aud_P01_fidelity.lean`, `aud_P01_extsat.lean`, `aud_P01_divname.lean`, `aud_P01_proofaux.lean`.

## 1. Mechanical checks (run by me)

`python3 scripts/pv_audit_mech.py P01` → report `verification/audits/P01_mech.md`, last line **`MECH CHECKS: PASS`**. No item re-done by hand; nothing in the output looked inconsistent.

| # | Check | Result |
|---|---|---|
| 1 | `check P01` | PASS exit=0 errors=0 sorry_warnings=0 (`pv_work/logs/P01_4.log`) |
| 2 | private rebuild + sha256 | PASS `IDENTICAL` (`bcb9ed75…82d1`) |
| 3 | `PVTools.lean` sha256 | PASS `445fe54f…` |
| 4 | statement fingerprints vs `P01_gate.md` | PASS, all 9 gated declarations `th`/`vh`/`bi` identical (7 theorems + `NesbittInequality` `vh=2317600716`, `P01Conclusion` `vh=790660802`) |
| 6 | `#pv_axioms P01` | PASS `ALL STANDARD` |
| 7 | `#pv_walk P01` | PASS `sorryAx reached: False`; axioms `[propext, Classical.choice, Quot.sound]` |
| 8 | project constants reached | 3 modules, all with records (see §4) |
| 9 | declarations not in the snapshot | **None** (no private helper lemmas at all) |
| 10 | `#pv_hyp_usage` on the 7 gated theorems | no `UNUSED` hypothesis anywhere |

DEFS snapshot: not applicable (`RESULTS.json` defs = NONE; `P01Stmt.lean` inlines `S`, which I checked against `main.tex:31` term by term).
No gap file, so §2 of the final-audit checklist (gap `vh` = snapshot `th`, `*_mod_gaps` copy-and-`example`) does not apply; I confirmed there is no `pv_work/P01ModGaps.lean` and no `<ID>_S<k>_Gap` declaration in the closure (walk item 8 reaches only `L01`, `L01Stmt`, `P01Stmt`, `P01`).

## 2. Axioms and `sorry`

Only `propext`, `Classical.choice`, `Quot.sound`, in every declaration and in the whole closure of `P01_main` (items 6-7 above, plus my own `#pv_walk_decl Paper.P01.P01_main`, log `pv_work/logs/aud_P01_fidelity_2.log:76-77`: `AXIOMS in closure: [propext, Classical.choice, Quot.sound]; sorryAx reached: false`). No `axiom`, `admit`, `native_decide`, `unsafe`, `implemented_by`, `@[extern]`, `debug.skipKernelTC`. Judged with PVTools, not grep.

**Conclusion-as-hypothesis: none.** The only non-domain premise is `hN : NesbittInequality` = `∀ x y z : ℝ, 0<x→0<y→0<z→ x/(y+z)+y/(z+x)+z/(x+y) ≥ 3/2` (printed form checked with `#print`, log `aud_P01_proofaux_1.log:7-8`). It is neither `P01Conclusion` nor an equivalent: `P01Conclusion` does not imply `S ≥ 3/2`. It *is* logically stronger than `P01Conclusion` on the domain (because `3(xy+yz+zx)/(2(x²+y²+z²)) ≤ 3/2` always holds there) — but that is the paper's own architecture at `main.tex:60`, where the bound is attributed to `\cite[Theorem~1]{Nesbitt1903}`, i.e. to literature this project does not prove. Writing it as a visible parameter is the faithful treatment (CLAUDE.md rule 2, VERDICTS §4.2); it caps P01 at CONDITIONAL.

## 3. Per-theorem conditionality (my own probes)

| question | method | result |
|---|---|---|
| is `hN` an unused premise? | `#pv_hyp_usage Paper.P01.P01_main` | `HYP|0|hN|USED` — not a removable premise |
| where is `hN` *actually* used? | `#pv_hyp_usage Paper.P01.P01_S2` | `HYP|0|hN|USED`; the proof body is `exact hN x y z hx hy hz` (`P01.lean:74`), i.e. the step of `main.tex:60` |
| "`NesbittInequality` enters only through S2" — negative tests | `#pv_walk_decl` on `P01_S3`, `P01_S5`, `P01_S6` | none of the three closures reaches `P01Stmt` at all (modules reached: `L01`, `L01Stmt`, `P01` only) |
| same claim — **positive control** | `#pv_walk_decl Paper.P01.P01_S2`, and on `P01_main` | both detect it: `REACHED|P01Stmt|Paper.P01.NesbittInequality|def|…|via=[Paper.P01.P01_S2]` resp. `via=[Paper.P01.P01_main, Paper.P01.P01_S2]` |
| other hypotheses | item 10 | `x,y,z,hx,hy,hz` all `USED` in every theorem that takes them |

So the arithmetic chain S3→S4→S5→S6 is **unconditional** (it depends only on L01 and mathlib), and the single condition enters at exactly one step: `main.tex:60`. `P01_S1` is stated and proved but is not in the term-level closure of `P01_main` (walk item 8 of my probe lists `P01` constants `S2,S3,S4,S5,S6,main` only) — correct and harmless: S1 discharges the Notation proviso (`main.tex:33`) on this domain, and Lean's total `/` means the chain does not need it. It cannot weaken the result.

**Interface fix `div_le_iff` → `div_le_iff₀`: pure interface, no provenance debt.** My own `#check` evidence (LESSONS 1): `aud_P01_divname.lean` → `unknown identifier 'div_le_iff'` in this linked snapshot (`pv_work/logs/aud_P01_divname_1.log`), while `#check @div_le_iff₀` gives `0 < c → (b / c ≤ a ↔ b ≤ a * c)` (`aud_P01_fidelity_2.log:99-100`) — the same mathematical content and direction as the classical `div_le_iff`. A renamed mathlib API, no mathematical content change, nothing to record as a debt.

## 4. Infrastructure check (every in-project constant in the closure)

| Module | Constant | Record | My own check |
|---|---|---|---|
| `L01` | `L01_main`, `L01_S2`, `L01_S3`, `L01_S4` | `verification/audits/L01_final.md` (FINAL AUDIT: PASS, UNCONDITIONAL; §6 of that report names each of these four individually) | Not re-derived (per task). Confirmed P01 *uses* it correctly: `P01_S3` calls `(Paper.L01.L01_main x y).ineq`, `(… y z).ineq`, `(… z x).ineq` — exactly the three pairs of `main.tex:61-62`, only the `ineq` field, no `equality_iff`; axioms of the L01 part of the closure are standard |
| `L01Stmt` | `L01Conclusion`, `.ineq`, `.mk` | `L01_gate.md` + `L01_final.md` (which names the structure and both fields) | Read `L01Stmt.lean` in full: the two fields transcribe `main.tex:38-42`. **Not redeclared** in any P01 file: `P01.lean:2` has `import L01`, `P01Stmt.lean` declares only `NesbittInequality` and `P01Conclusion` |
| `P01Stmt` | `NesbittInequality`, `P01Conclusion` | `P01_gate.md` (items 2 and 6; fingerprints identical, mech item 4) | Read and `#print`ed both; see §2 and §5 |
| `P01Stmt` | `NesbittInequality._proof_1`, `._proof_2` | not individually in the gate snapshot | Audited here on the spot: `#print` shows they are `(1+2).AtLeastTwo` resp. `(0+2).AtLeastTwo`, both `:= instNatAtLeastTwo`, `does not depend on any axioms` (`aud_P01_proofaux_1.log:1-6`). Elaboration auxiliaries for the numerals `3` and `2`; no mathematical content, nothing smuggled |

No helper outside the snapshot (mech item 9: none), no private lemma to review, and the walk stopped at no interface (it is a full walk, `stopping []`). Every mathlib constant used is library infrastructure, not project infrastructure.

## 5. Route fidelity, sentence by sentence (`main.tex:59-69`)

| source sentence | Lean | ruling |
|---|---|---|
| "By Nesbitt's inequality \cite[Theorem~1]{Nesbitt1903}, $S(x,y,z)\ge 3/2$ for all $x,y,z\in\Rpos$" (60) | `P01_S2` := `hN x y z hx hy hz` (71-74) | faithful; the parameter is that sentence verbatim with `S` inlined per `main.tex:31` and `\Rpos` as positivity premises; not stronger than the printed clause |
| "Applying Lemma~\ref{lem:amgm} to the pairs $(x,y)$, $(y,z)$ and $(z,x)$ and adding the three inequalities gives $xy+yz+zx \le x^2+y^2+z^2$" (61-65) | `P01_S3` := three `(Paper.L01.L01_main · ·).ineq` + `linarith` (88-93) | faithful; same three ordered pairs, same order; only L01's `ineq` clause, as the source does. The ring step `(x²+y²)/2+(y²+z²)/2+(z²+x²)/2 = x²+y²+z²` performed inside `linarith` is the source's own "adding" — `FAIR_IMPLICIT_STEP`. Stating S3 for all reals (no positivity) is not a strengthening: L01 holds for all reals (`main.tex:38`), which is exactly the strength the source uses |
| "Since $x^2+y^2+z^2>0$" (66) | `P01_S4` := `positivity` (101-103) | faithful; the source asserts the fact without proof, it is immediate from `0<x,0<y,0<z` — `FAIR_IMPLICIT_STEP` (filled in by `positivity`, i.e. sum of squares of nonzero reals) |
| "dividing by it yields $\frac{xy+yz+zx}{x^2+y^2+z^2}\le 1$" (66-67) | `P01_S5` := `rw [div_le_one h4]; linarith [h3]` (112-117) | faithful; `div_le_one` *is* "divide the inequality by the positive quantity", using S3 and S4 and nothing else |
| "and hence $\frac{3(xy+yz+zx)}{2(x^2+y^2+z^2)} \le \frac{3}{2}$" (67-68, first `≤`) | `P01_S6` := `rw [div_le_iff₀ …]; rw [div_le_one h4] at h5; linarith [h5]` (127-133) | faithful; scaling the ratio bound by `3/2`, with the positivity of `2(x²+y²+z²)` from S4 via `linarith`. No new mathematics; the clearing of the denominator is the `FAIR_IMPLICIT_STEP` implicit in "and hence" |
| "$\frac{3(xy+yz+zx)}{2(x^2+y^2+z^2)} \le \frac{3}{2} \le S(x,y,z)$" (67-68, the chain) | `P01_main` := `linarith [h6, h2]` after `unfold P01Conclusion` (142-147) | faithful; transitivity of the printed chain, same direction, nothing added |
| Notation proviso "whenever the three denominators are nonzero" (33) + domain (53) | `P01_S1` (59-61) | faithful bookkeeping of a convention; recorded, not consumed (see §3) |

- **Route changed?** No. **Stronger result used than in the source?** No (checked for L01: only `ineq`; for the parameter: exactly the cited clause; for S3: same strength as the source's own step).
- **Private helpers performing more than conversions?** There are none.
- **Statement actually delivered.** My probe (C) derives, from `P01_main` alone, the literal printed inequality for every positive triple:
  `∀ hN x y z, 0<x → 0<y → 0<z → x/(y+z)+y/(z+x)+z/(x+y) ≥ 3*(x*y+y*z+z*x)/(2*(x^2+y^2+z^2))` — compiled, exit=0. So the whole statement of `main.tex:52-57` is proved, modulo `hN`, with no structure bundling hiding a clause (there is only one printed clause).

## 6. Non-vacuity (my probe `aud_P01_fidelity.lean`, exit=0)

| witness | what it shows |
|---|---|
| `P01_main hN 1 1 1 …` | the hypothesis class is inhabited at the equality case `x=y=z` |
| `P01_main hN 2 1 1 …`, `P01_main hN 5 3 1 …` | **non-trivial** (asymmetric) witnesses; the theorem has content away from the symmetric point |
| `P01Conclusion 1 1 1`, `P01Conclusion 5 3 1` proved outright (`norm_num`) | the conclusion instances are genuinely true, not vacuous consequences of a false premise |
| `¬ P01Conclusion 1 1 (-2)` (`norm_num`) | the positivity premises carry real content: the conclusion is false off the printed domain, so the encoded statement is not a tautology |
| `theorem auditor_nesbitt_sat : Paper.P01.NesbittInequality` proved in `aud_P01_extsat.lean` (`nlinarith` after clearing denominators); `#print axioms` → `[propext, Classical.choice, Quot.sound]` | the **single condition is satisfiable and in fact true**, so the conditional theorem is not vacuous and the paper's conclusion is unconditionally true mathematically |

The last line is a **reviewer-constructed argument**: it is only an observation (and, if the coordinator wants, a suggestion for a later pass), never evidence about the paper and not part of the audited proof. The audited `P01.lean` still carries `hN` as a visible parameter, so the verdict stays CONDITIONAL (`#print axioms` does not remove a parameter).

## 7. Source assessment

| finding | class | note |
|---|---|---|
| route `main.tex:59-69` | sound | every printed step follows; no false step, no missing hypothesis, printed conclusion true (and, with my §6 probe, verified true in Lean) |
| `\cite[Theorem~1]{Nesbitt1903}` vs. the bibliography entry "Problem 15114, *Educational Times* 55 (1903), 37" (`main.tex:60`, 88-89) | `EDITORIAL` (not an issue) | a problem-column item does not naturally carry a numbered "Theorem 1"; citation-precision only. I independently agree with the gate's classification; it belongs on the human-check worksheet (priority B, attribution/numbering), and my §6 probe shows the *mathematical* content of the citation is correct |
| EXT-2 (`x²+y²+z²>0`) and EXT-3 (well-definedness of `S`) silently used | `FAIR_IMPLICIT_STEP` | both immediate from the printed domain; proved as S4/S1. Not `PAPER_ASSUMPTION_GAP` |
| no gaps, no unencoded part, no provenance debt | — | `EXTERNAL_TOOLS.md` records exactly one parameter for P01 and an empty debt table, consistent with what I found in the closure |

## 8. Status for the authors (≤3 lines)

Proposition 2.2 (`prop:nesbitt`) is fully machine-checked along the paper's own route (cited Nesbitt bound + Lemma 2.1 on the three pairs + division by `x²+y²+z²>0` + transitivity), with no `sorry`, only the three standard axioms, and a reproducible byte-identical rebuild.
It depends on exactly one visible condition, the cited inequality `S(x,y,z) ≥ 3/2` for positive reals (`main.tex:60`, `\cite[Theorem~1]{Nesbitt1903}`), used only at the proof's first sentence; everything else in the proof is unconditional. A separate check of ours confirms this condition is itself a true statement, so the proposition's conclusion is not in doubt.
No mathematical error or gap found in `main.tex:52-69`; the only remark is editorial — the bibliography entry (a 1903 problem column) does not carry a "Theorem 1", so the citation's numbering should be re-checked.

## 9. FAIL items

None.

```
FINAL AUDIT: PASS
SUGGESTED VERDICT: CONDITIONAL
```

Condition to list in the records: `Paper.P01.NesbittInequality` (provenance (i), `pv_work/P01Stmt.lean:39-41`) → used at step `P01_S2` = `source/main.tex:60`, first sentence of the proof, and threaded through `P01_main`; no other condition, no gap, no consumed-clause parameter (L01 is imported as a proved module, `L01Conclusion` is not redeclared).
