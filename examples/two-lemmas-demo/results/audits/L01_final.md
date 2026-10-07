# Final audit — L01 (Lemma 1, `lem:square`, `source/demo.tex:12-14`)

- **Auditor**: `pv-auditor` (independent final audit, Opus-class session)
- **Date**: Thu Oct  1 00:24:11 EDT 2026 (`date`)
- **Audited object**: `pv_work/L01.lean` (sha256 `e0d0190d24ccad7b4cc6590eb6f75502520accb73a4d2cd9b1d0ba0b5e1537c9`), read in full by me. No gap file exists (none needed: no obligation was stopped), so item 2 of the final-audit checklist is not applicable.
- **Also read directly**: `source/demo.tex` lines 1–29 (whole file: statement 12–14, proof 16–18, preamble 1–11), `pv_work/L01Stmt.lean` (sha256 `9aab139358f5d69dd92ebde1c6f2821b1ce3809367557e44069757ac473ad550` — **identical** to the hash the gate reviewed), `verification/audits/L01_gate.md`, `pv_work/notes/L01_prover_notes.md`, `pv_work/PVTools.lean` (sha256 `445fe54f…`, unchanged). The prover's and gate's claims were used as leads only; every machine check below was re-run by me.
- **Mechanical report**: `verification/audits/L01_mech.md` (written by `python3 scripts/pv_audit_mech.py L01`, run by me), last line `MECH CHECKS: FAIL (probe)` — see item 1 for the resolution of that single FAIL.
- **My own probes**: `pv_work/probes/auditor/L01/auditor_L01_infra.lean` (log `pv_work/logs/auditor_L01_infra_1.log`, `exit=0`), `pv_work/probes/auditor/L01/auditor_L01_stmtcopy.lean` (log `pv_work/logs/auditor_L01_stmtcopy_2.log`, `exit=0`).

## Source text (read by me, not quoted from anyone's summary)

`source/demo.tex:12-14` (statement):

> `\begin{lemma}\label{lem:square}`
> `For all real numbers $a$ and $b$ we have $a^2 + b^2 \ge 2ab$.`
> `\end{lemma}`

`source/demo.tex:16-18` (proof):

> `\begin{proof}`
> `We have $a^2 + b^2 - 2ab = (a-b)^2 \ge 0$.`
> `\end{proof}`

Preamble `1-11`: `amsmath, amssymb, amsthm`, `\newtheorem{lemma}{Lemma}`, title/author/date. **No standing convention** on constants, domains or notation anywhere in the file, so `a, b` range over all of `ℝ`, unrestricted. (Lines 20–27 are Lemma 2, outside this audit; L01 does not depend on them and nothing from them is imported.)

## 1. Mechanical checks (script run by me)

| # | Check | Result | Detail |
|---|---|---|---|
| 1 | `check L01` | PASS | `exit=0 errors=0 sorry_warnings=0`, log `pv_work/logs/L01_4.log` |
| 2 | private rebuild + sha256 | PASS | delivered = rebuilt = `8afce8ba92b8bd57…` → `IDENTICAL` |
| 3 | `PVTools.lean` sha256 | PASS | `445fe54fd278873b…` (tool unmodified) |
| 4 | statement fingerprints vs gate snapshot | PASS | 3 gated declarations, all `th`/`vh`/`bi` identical |
| 6 | `#pv_axioms L01` | PASS | `ALL STANDARD` (3 declarations) |
| 7 | `#pv_walk L01` | PASS | `sorryAx reached: False`; axioms `[propext, Classical.choice, Quot.sound]` |
| 8 | project constants reached | PASS | 0 project modules besides `L01` itself (see item 5 below) |
| 9 | declarations not in the snapshot | PASS | none — no private helper lemma exists |
| 10 | `#pv_hyp_usage` on the 3 gated theorems | PASS | 2 binders each (`a b : ℝ`), both `USED`, 0 `UNUSED` |

**The script's single FAIL, and why it is not a FAIL of this audit.** `MECH CHECKS: FAIL (probe)` is caused by exactly one line of the script's own probe `auditor_L01_mech1.lean`, namely `#pv_type_hashes L01Stmt`, which throws `no constants found for module L01Stmt`. `L01Stmt.lean` legitimately declares **nothing** (no `def Tool : Prop`, no `structure`, no `variable`, no `theorem`) — that is the correct state for a result with zero external parameters — and `#pv_type_hashes` raises an error rather than printing "0 declarations" for an empty module. The output was inconsistent with the substantive result (item 4 of the same report compared all three gated fingerprints and PASSed), so, as the rule card allows, I completed the underlying check by hand and say so here:

- `pv_work/L01Stmt.lean` sha256 is `9aab1393…`, **bit-identical** to the file the gate reviewed and snapshotted as "0 declarations";
- my own copy probe `auditor_L01_stmtcopy.lean` with `#pv_type_hashes_here` prints `TYPE HASHES (current file, 0 declarations)` (`exit=0`), reproducing the gate's statement snapshot for the `Stmt` file from fresh evidence.

So the `Stmt` fingerprint comparison is complete with result PASS (0 = 0 declarations). This is a **tooling artifact of `pv_audit_mech.py`** (suggested fix for the kit, not for this result: treat an empty `<ID>Stmt` module as 0 declarations instead of an error). It is not a formalization defect and certainly not a paper issue. No other FAIL appears in the mechanical report.

## 2. Gap file

Not applicable: no obligation was stopped, `pv_work/L01ModGaps.lean` does not exist, and `#pv_walk L01` shows `sorryAx reached: False`. Nothing to copy-and-`example`.

## 3. Axioms and `sorry`

| Declaration | Axioms | `sorryAx` |
|---|---|---|
| `Paper.L01.L01_S1` | `propext, Classical.choice, Quot.sound` | no |
| `Paper.L01.L01_S2` | `propext, Classical.choice, Quot.sound` | no |
| `Paper.L01.L01_main` | `propext, Classical.choice, Quot.sound` | no |
| closure of `L01_main` (my own `#pv_walk_decl`, 5001 constants) | `propext, Classical.choice, Quot.sound` | `sorryAx reached: false` |

Only the three allowed axioms. No `admit`, `axiom`, `unsafe`, `native_decide`, `implemented_by`, `@[extern]`, `debug.skipKernelTC` (`nonstandard_axiom_lines=0` in every compile; no such construct in the text I read in full).

## 4. Per-theorem conditionality

- **External parameters: none exist.** `L01Stmt.lean` declares 0 constants (machine-confirmed twice above), so there is no `def Tool : Prop`, no consumed predecessor clause, no recorded debt, and no unencoded part. L01 has no predecessors (`depends_on` empty).
- The two binders of each theorem are `(a : ℝ)` and `(b : ℝ)` — object variables, not hypotheses; `#pv_hyp_usage` reports both `USED` in all three theorems, so there is no superfluous premise to remove and nothing to trace into a helper (there are no helpers).
- **No hypothesis is the conclusion in disguise**: none of the three theorems takes any `Prop`-valued hypothesis at all, so the target `a^2+b^2 ≥ 2ab` cannot be assumed. `L01_main` does *not* take `L01_S1`/`L01_S2` as premises; it calls them.
- Citation structure, checked with my own probe (direct used-constants of each proof term), **with the positive control it demands**: `DIRECT|L01_S2|sq_nonneg=true` (control: the declaration known to use it is detected) versus `DIRECT|L01_S1|sq_nonneg=false` and `DIRECT|L01_main|sq_nonneg=false|L01_S1=true|L01_S2=true`. So `sq_nonneg` enters only through `L01_S2`, and `L01_main` reaches the source's two steps and nothing else of our own. `#pv_walk_decl Paper.L01.L01_main stopping L01` reaches 1 constant with axioms `[]` (the stop is effective), and the unrestricted walk reaches the 3 `L01` declarations plus library constants only.

## 5. Infrastructure review (item-by-item, done by me on the spot)

Item 8 of the mechanical report lists **0 project modules** reached besides `L01` itself, and my `#pv_walk_decl Paper.L01.L01_main` confirms `MODULE|L01|3` as the only non-library module. So there is no in-project infrastructure needing a prior audit record, and the walk stops at no interface. The two non-project ingredients named in my task were audited individually:

| Ingredient | Where used | What I checked | Verdict |
|---|---|---|---|
| mathlib `sq_nonneg` | `L01_S2` (`L01.lean:43`) | my own `#check @sq_nonneg` and `#check (sq_nonneg : ∀ a : ℝ, 0 ≤ a ^ 2)` elaborate; `#print axioms sq_nonneg` → `[propext]`; statement is the true, non-vacuous standard fact "a real square is `≥ 0`", applies to arbitrary `a - b` with no side condition; it does **not** contain or imply the target inequality on its own (it says nothing about `a^2+b^2`) | PASS — pinned-mathlib interface exists, so correctly cited directly and correctly **not** registered as a visible parameter (`VERDICTS.md` §4.1: a (v) item is a standard fact with *no* interface) |
| the `ring` identity `a^2+b^2-2ab=(a-b)^2` (`L01_S1`) | `L01_S1` (`L01.lean:30-31`) | `ring` produces a kernel-checked term (axioms standard, `#pv_axioms`); I additionally sanity-checked the *printed* identity numerically against a sign slip: `(2)^2+(5)^2-2·2·5 = (2-5)^2` and `(-3)^2+(2)^2-2(-3)(2) = (-3-2)^2`, both `norm_num`-closed in my probe | PASS — true commutative-ring identity, no side condition, no hidden case split |
| mathlib `linarith` / `norm_num` tactic machinery | `L01_main` (`L01.lean:56`), my probes | tactics, not mathematical inputs; closure axioms remain the three standard ones; `rebuild IDENTICAL` | PASS |

Helpers to review (item 9): **none** — `L01.lean` contains exactly the three gated declarations and no private lemma.

## 6. Route fidelity (sentence by sentence)

| Source sentence (`demo.tex`) | Lean | Judgement |
|---|---|---|
| 17, first half: "$a^2+b^2-2ab = (a-b)^2$" | `L01_S1 : a ^ 2 + b ^ 2 - 2 * a * b = (a - b) ^ 2`, `by ring` | exact correspondence, same direction of the rewrite, same expressions; `2ab → 2 * a * b` is notation only |
| 17, second half: "$\dots \ge 0$" | `L01_S2 : (a - b) ^ 2 ≥ 0`, `exact sq_nonneg (a - b)` | exact; the subject is literally the square the source writes. The source asserts this without justification; filled in by the standard fact — `FAIR_IMPLICIT_STEP` (A), see below |
| 12–14 (the lemma) + the chain read off | `L01_main : a ^ 2 + b ^ 2 ≥ 2 * a * b`, assembled as `h1 := L01_S1`, `h2 := L01_S2`, `h3 : difference ≥ 0 := by rw [h1]; exact h2`, then `linarith` | the assembly is the printed chain; the last move ("difference `≥ 0`" ⟺ "sum `≥ 2ab`") is the only thing the source leaves to the reader — `FAIR_IMPLICIT_STEP` (B) |

- **Route changed?** No. The Lean proof is the source's one-line argument, split into its two printed halves and recombined; no alternative route (e.g. AM–GM, `nlinarith` brute force, `two_mul_le_add_sq`) was substituted.
- **Stronger result used than in the source?** No. `sq_nonneg` specialized at `a - b` is exactly the "$\ge 0$" the source writes; nothing stronger (no strict inequality, no case analysis, no general inequality lemma) enters.
- **Private helpers doing mathematics?** None exist.
- **Statements unchanged from the gated draft?** Yes: `th`/`vh`/`bi` of all three declarations equal the gate snapshot line for line (`1311506106`, `1002552111`, `86406052`), re-derived in my own walk output.
- **Interface-only changes by the prover**: `import Mathlib.Tactic.Ring` and `import Mathlib.Tactic.Linarith` added to `L01.lean`. These change only tactic availability; no statement, binder or definition changed (fingerprints prove it). Acceptable, not a mathematical addition.

### `FAIR_IMPLICIT_STEP`s, and how each was filled in

| # | Step the source does not write out | How it was filled in | Fair? |
|---|---|---|---|
| A | *why* $(a-b)^2 \ge 0$ | mathlib `sq_nonneg (a - b)` — the elementary standard fact about real squares, with no extra hypothesis | Yes. A paper may use "a real square is nonnegative" silently; it is standard, universally valid here, and adds no assumption. |
| B | from "$a^2+b^2-2ab \ge 0$" to the printed "$a^2+b^2 \ge 2ab$" | `linarith` from `h3` (equivalently `sub_nonneg`): a linear rearrangement over `ℝ` | Yes. The source itself writes the chain whose left end is the *difference*, so reading off the inequality is the printed argument, not a repair. |

Nothing else was filled in; no step was stopped, so there is no debt and nothing excluded from the proved statement.

## 7. Non-vacuity (my probe, `exit=0`)

The hypothesis class is just `(a b : ℝ)`, which is inhabited, and the proved theorem was instantiated at concrete witnesses:

| Witness | Instance | Note |
|---|---|---|
| `a=1, b=3` | `L01_main 1 3 : 1^2+3^2 ≥ 2·1·3` | nontrivial: the instance is `10 ≥ 6`, strict (`norm_num`-checked separately) |
| `a=-3, b=2` | `L01_main (-3) 2` | negative value, RHS negative |
| `a=b=2` | `2^2+2^2 = 2·2·2` (`norm_num`) | the bound is **tight**, so the statement is not a weakened form |
| `a=b=0` | `L01_main 0 0` | degenerate case covered |
| positive control | `¬ ∀ a b : ℝ, a^2+b^2 ≥ 2ab + 1` is proved (at `a=b=2`) | confirms the conclusion encoded is the sharp printed one, not a slack variant that would be true for a weaker reason |

## 8. Status for the authors

Lemma 1 (`source/demo.tex:12-14`) and its one-line proof (`16-18`) are fully verified in Lean 4 with no external input, no predecessor, no gap and only the three standard axioms; the statement is non-vacuous and the inequality is tight (equality at `a=b`). It depends on nothing beyond pinned mathlib (one standard citation, `sq_nonneg`, which has a direct interface and is therefore not a condition). No error, no gap, no ambiguity and no editorial slip found in the source for this lemma; the two steps the text leaves implicit (nonnegativity of a real square; moving `2ab` across the inequality) are fair standard steps.

## FAIL items

None of substance. The one FAIL line in `verification/audits/L01_mech.md` (`MECH CHECKS: FAIL (probe)`) is a `pv_audit_mech.py` artifact — `#pv_type_hashes L01Stmt` errors on an intentionally empty `Stmt` module — and the check it stood for was completed by hand with result PASS (item 1 above: identical file hash plus my own `#pv_type_hashes_here` → 0 declarations). Recorded for the kit's maintainers; no paper-side or formalization-side defect.

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
