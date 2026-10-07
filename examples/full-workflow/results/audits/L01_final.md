# Final audit — L01 (PDF 2.1, Lemma, `lem:amgm`)

- **Auditor**: `pv-auditor` (independent final audit; model Opus 5, 1M context)
- **Date**: 2026-09-30 19:57 EDT (`date` → `Wed Sep 30 19:57:19 EDT 2026`)
- **Audited object**: `pv_work/L01.lean` (no gap file exists; the prover reports 0 stopped obligations)
  - `sha256 pv_work/L01.lean = 44eb4c84d4a063960479cf6628146be31e6b090314511c13a0536e6a74423207`
  - `sha256 pv_work/L01Stmt.lean = 0d6e1b15c197913cc7b29a6d113fdcff5091490ca7e938154459ef993d8cacf3`, **identical to the hash the gate reviewed** (`verification/audits/L01_gate.md:14`) — the statement file was not touched after the gate.
- **Source read by me directly**: `source/main.tex:1-93` (statement `37-43`, proof `45-50`, notation `26-33`, and the downstream uses at `52-85`). I did not rely on the gate's or the prover's quotations.
- **Also read in full**: `pv_work/L01.lean`, `pv_work/L01Stmt.lean` (the only imported project module; it has a gate record), `verification/audits/L01_gate.md`, `pv_work/notes/L01_prover_notes.md`.
- **Environment**: `scripts/pv_lean.sh packages` → `PACKAGES linked … mathlib modules compiled: 2452 of 6305; linked: do NOT run 'lake build'`. No `lake build` / `lake update` / `lake exe cache get` was run by me; no network access.

## 1. Mechanical checks (run by me)

`python3 scripts/pv_audit_mech.py L01` → report `verification/audits/L01_mech.md`, last line **`MECH CHECKS: PASS`**. Summary of its items:

| # | Check | Result |
|---|---|---|
| 1 | `check L01` | PASS (exit=0, errors=0, sorry_warnings=0, log `pv_work/logs/L01_3.log`) |
| 2 | private rebuild + sha256 | PASS (`IDENTICAL`, `07a93f25…`) |
| 3 | `PVTools.lean` sha256 | PASS (`445fe54f…`, unmodified) |
| 4 | statement fingerprints vs gate snapshot (14 gated declarations) | PASS (all `th`/`vh`/`bi` identical) |
| 6 | `#pv_axioms L01` | PASS (ALL STANDARD, 5 declarations) |
| 7 | `#pv_walk L01` | PASS (`sorryAx reached: false`; axioms `propext, Classical.choice, Quot.sound`) |
| 8 | project constants reached | 1 module (`L01Stmt`, 2 constants) — see §4 |
| 9 | declarations not in the snapshot | none (no private helpers at all) |
| 10 | `#pv_hyp_usage` on the 7 gated theorems | no `UNUSED` hypothesis |

No FAIL item. I did not re-run these by hand; I did, independently, reproduce item 4 and item 6 in my own probe (below), which agree line for line.

**My own probes** (`pv_work/probes/auditor/L01/`, written with Write, audited files untouched):

| Probe | Command | Result |
|---|---|---|
| `auditor_L01_nonvac.lean` | `scripts/pv_lean.sh probe …` | `exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log `pv_work/logs/auditor_L01_nonvac_1.log` |
| `auditor_L01_walk.lean` | `scripts/pv_lean.sh probe …` | `exit=0`, log `pv_work/logs/auditor_L01_walk_1.log` |

`#pv_type_hashes L01` in my probe reproduces the gate's draft snapshot exactly: `L01_S1 th=1002552111`, `L01_S2 th=72149719`, `L01_S3 th=740771191`, `L01_S4 th=3407856599`, `L01_main th=3116722683`, all `bi=ee`.

## 2. Gap file

Not applicable: there is no `pv_work/L01ModGaps.lean` and no `<ID>_S<k>_Gap` declaration, because no obligation was stopped. All five obligations are proved inside `pv_work/L01.lean` and `#pv_walk L01` reports `sorryAx reached: false`, so nothing is left open. Nothing is deferred to a gap hypothesis.

## 3. Axioms and `sorry`

`#pv_axioms L01` (mech item 6 and my own probe): each of `L01_S1`…`L01_S4`, `L01_main` carries exactly `[propext, Classical.choice, Quot.sound]`. Closure walk of `Paper.L01.L01_main` (5184 constants reached): `AXIOMS in closure: [propext, Classical.choice, Quot.sound]; sorryAx reached: false`. Only the three allowed axioms; no `sorry`/`admit`/`axiom`/`native_decide`/`unsafe`/`implemented_by`/`@[extern]`/`debug.skipKernelTC` (also `nonstandard_axiom_lines=0` in every compile). Judged with the PVTools commands, not grep.

## 4. Per-theorem conditionality

There is **no external parameter of any kind**: `pv_work/L01Stmt.lean` (read in full, 29 lines) declares only `structure L01Conclusion (a b : ℝ) : Prop` with fields `ineq`, `equality_iff`; there is no `def … : Prop`, no `<ID>_<Pred>Consumed`, no `variable`, no type class, and L01 has no predecessor.

`#pv_hyp_usage` (my probe, log lines 11-19) on `L01_main`, `L01_S4`, `L01_S3`: the leading binders are exactly `a : Real`, `b : Real`, both `USED`. These are the source's universally quantified reals (`main.tex:38`), not premises, so there is nothing to trace into a helper and nothing to report as a removable premise. No theorem in the file takes any hypothesis, hence no possibility of the conclusion (or an equivalent) appearing as a hypothesis — I verified this by reading every one of the five signatures.

Conclusion: **no conditions, no recorded debt, no unencoded part.**

## 5. Infrastructure check (project constants in the closure)

Item 8 lists one project module besides `L01` itself.

| Constant | Module | Record | My on-the-spot audit |
|---|---|---|---|
| `Paper.L01.L01Conclusion` | `L01Stmt` | `verification/audits/L01_gate.md` §2, which names the constant and both fields | Read the source code: a `Prop`-valued structure over `(a b : ℝ)` with exactly the two fields transcribing `main.tex:39-42`. Carries no hypothesis, no class, no hidden premise; does not smuggle the target (it *is* the target conclusion, which is correct for a statement file). Non-vacuous: `L01Conclusion 0 0` is inhabited (probe (E)). |
| `Paper.L01.L01Conclusion.mk` | `L01Stmt` | same | Auto-generated constructor; its `th=838139543|bi=iiee` matches the gate snapshot. No content of its own. |

In-project theorems in the closure are only `L01_S2`, `L01_S3`, `L01_S4`, `L01_main` — all inside the audited file and all covered by this audit individually (§6). Item 9 lists **no** helper outside the snapshot, so there is no unreviewed private lemma. Every mathlib constant used (`sq_nonneg`, `sq_eq_zero_iff`, the `linarith`/`nlinarith`/`ring` certificates) is library infrastructure, not project infrastructure; the walk did not need to stop at any interface.

Note from the walk (log line 7): `L01_S1` does **not** appear in the term-level closure of `L01_main`. `L01_S2`'s proof `nlinarith [L01_S1 a b]` did not need the supplied hint — `nlinarith` produced its own square-nonnegativity certificate. This is not a defect: `L01_S1` is separately stated, proved and axiom-clean, and the step S1→S2 that the source prints ("since `(a-b)^2 ≥ 0`, expanding the square …") is discharged by exactly the same algebraic fact inside `nlinarith`. I record it so that nobody later reads the S1 obligation as a *used* link in the certified chain.

## 6. Route fidelity, sentence by sentence

Source proof, `main.tex:45-50`, three sentences; the Lean file follows them in order with no reordering, no stronger tool and no alternative route.

| Source sentence (line) | Lean | Ruling |
|---|---|---|
| "Since $(a-b)^2 \ge 0$" (46) | `L01_S1 : (a - b) ^ 2 ≥ 0`, by `nlinarith [sq_nonneg (a - b)]` (L01.lean:30-31) | faithful; the source asserts nonnegativity of a real square as evident, mathlib's `sq_nonneg` is that fact — `FAIR_IMPLICIT_STEP` (filled in by the library lemma named in the draft docstring) |
| "expanding the square gives $a^2-2ab+b^2\ge0$, that is, $2ab \le a^2+b^2$" (46-47) | `L01_S2 : 2 * (a * b) ≤ a ^ 2 + b ^ 2`, by `nlinarith [L01_S1 a b]` (38-39) | faithful; the obligation is the sentence's own end form. The binomial expansion + rearrangement is done by `nlinarith` — `FAIR_IMPLICIT_STEP` (ring normalisation of `(a-b)^2 = a^2-2ab+b^2`, which the source itself calls "expanding"). See the §5 note that the certificate is `nlinarith`'s own rather than the S1 hint |
| "Dividing by $2$ gives the inequality." (47) | `L01_S3 : a * b ≤ (a ^ 2 + b ^ 2) / 2`, by `linarith [L01_S2 a b]` (45-46) | faithful; division of a linear inequality by the positive constant 2, literally the printed move; S3 is verbatim the `ineq` field |
| "equality holds if and only if $(a-b)^2 = 0$, that is, if and only if $a = b$" (48-49) | `L01_S4 : a * b = (a^2+b^2)/2 ↔ a = b` (56-66): forward `h → (a-b)^2 = 0` (`nlinarith [h]`) → `sq_eq_zero_iff.mp` → `a = b`; backward `subst h; ring` | faithful, and it follows the source's own two links in the source's own order (equality ⟺ `(a-b)^2=0` ⟺ `a=b`). The composite is recorded as one obligation, as the gate allowed. `sq_eq_zero_iff` on `ℝ` is the "a square vanishes iff its base does" step the source writes as "that is" — `FAIR_IMPLICIT_STEP`. The trivial backward direction is closed by `ring`, an identity |
| the lemma (37-43) | `L01_main : L01Conclusion a b := ⟨L01_S3 a b, L01_S4 a b⟩` (71-72) | faithful assembly of the two printed clauses; no third field, no extra content |

- **Route changed?** No. Same square-completion route, same order.
- **Stronger result used than in the source?** No. Nothing outside elementary `ℝ` ring/order arithmetic enters; no quantitative gap identity, no AM-GM from the library, no appeal to Nesbitt (that citation belongs to P01, `main.tex:60`).
- **Private helpers?** None exist (mech item 9), so none can add mathematics.
- **"Standard" steps filled in fairly?** Yes — the three `FAIR_IMPLICIT_STEP`s above (square nonnegativity, ring expansion, `x^2=0 ↔ x=0`) are each named in the printed proof as an evident move and are filled in by mathlib lemmas / ring normalisation only.
- **Domain fidelity**: the source quantifies over all of `\R` (`main.tex:28, 38`); the Lean form has `(a b : ℝ)` with no positivity or `a ≠ b` premise. I checked the whole `.tex` for a convention that could restrict the domain: only `\Rpos` at `main.tex:28` and the `S(x,y,z)` nonzero-denominator convention at `33`, neither of which applies to L01. The downstream uses (`main.tex:61-62`, `84`) only ever instantiate L01 at positive values, so the Lean form is at least as strong as needed — the correct direction.

No step of the Lean proof lacks a `main.tex` line, and no paper-side issue arises in `main.tex:37-50`: the statement is true as printed, the printed proof justifies both clauses, and no hypothesis is missing (the equality case `a = b` is exactly the one the lemma names).

## 7. Non-vacuity

Probe `pv_work/probes/auditor/L01/auditor_L01_nonvac.lean`, `exit=0 errors=0`:

| Witness | What it shows |
|---|---|
| (A) `∀ a b : ℝ, a*b ≤ (a^2+b^2)/2 ∧ (a*b = (a^2+b^2)/2 ↔ a = b)`, derived from `L01_main` alone | the statement I wrote out myself from `main.tex:37-43` is delivered by the audited theorem (the structure bundling hides nothing) |
| (B) `a=2, b=3`: `6 ≤ 6.5`, **and** `¬(2*3 = (2^2+3^2)/2)` obtained from `equality_iff.mp` | nontrivial instance; the `iff` has real content in the strict direction (it is not satisfied vacuously) |
| (C) `a=b=5`: `5*5 = (5^2+5^2)/2` via `equality_iff.mpr` | the equality case is attained, so `ineq` is sharp and `equality_iff` is not vacuously false-left |
| (D) `a=-3, b=2` | the theorem applies outside the positive range used downstream |
| (E) `L01Conclusion 0 0` | the hypothesis-free conclusion class is inhabited |

There is no hypothesis class to instantiate beyond the two real variables, so no hypothesis set can be empty; (B)-(D) give nontrivial witnesses in all three regimes (strict, equality, negative).

## 8. Status for the authors

Lemma 2.1 (`lem:amgm`, `main.tex:37-43`) is verified in full — both the inequality and the "equality iff $a=b$" clause, for all real $a,b$ — along the printed square-completion proof of `main.tex:45-50`, with no external parameter, no cited result, no gap and only the three standard Lean axioms. It depends on nothing: no predecessor, no literature input, nothing left for a human to check. Source assessment: no error, no gap, no missing hypothesis, no ambiguity; the three "evident" moves (nonnegativity of a square, binomial expansion, $x^2=0\iff x=0$) are fair implicit steps that we filled in from the standard library.

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
