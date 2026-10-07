# L02 — final audit (revision 1)

- **Auditor**: `pv-auditor` (independent subagent; not the drafter, gate reviewer or prover)
- **Date**: Wed Sep 30 20:51:40 EDT 2026 (`date`)
- **Result**: L02 = Lemma 2.3 (`lem:quot`), statement `source/main.tex:71-76`, proof `source/main.tex:78-81` (current, revision 1)
- **Audited object**: `pv_work/L02.lean` (no gaps, so no `L02ModGaps.lean`; the prover reports none and none exists)
- **Mechanical report**: `verification/audits/L02_mech.md` (`MECH CHECKS: FAIL (probe)` — the single FAIL item is a script-probe artifact, adjudicated in §1 below)
- **Auditor probe**: `pv_work/probes/auditor/L02/auditor_L02_fidelity.lean`, log `pv_work/logs/auditor_L02_fidelity_1.log`

Files read in full by this auditor: `source/main.tex:55-93` (statement, proof, the
following Remark, bibliography), `pv_work/L02.lean`, `pv_work/L02Stmt.lean`,
`verification/audits/L02_gate.md`, `pv_work/notes/L02_prover_notes.md`,
`verification/audits/L02_mech.md`. The source was read directly with `Read`
(offset/limit), not through anyone's summary.

File hashes (`python3 scripts/pv_snapshot.py hash`), matching the gate's recorded
hashes for the two gated files:

| File | sha256 | vs gate report |
|---|---|---|
| `pv_work/L02Stmt.lean` | `28e672e9…3c86ddea` | identical |
| `pv_work/L02Draft.lean` | `07271edb…6fec67d` (trailing chars per gate) | identical |
| `pv_work/L02.lean` | `84d3fbe7…4a6bb37` | (new file, audited here) |

## 1. Mechanical checks (run by me with one command)

`python3 scripts/pv_audit_mech.py L02`:

| # | Check | Result |
|---|---|---|
| 1 | `check L02` | PASS (exit=0, errors=0, sorry_warnings=0, `pv_work/logs/L02_4.log`) |
| 2 | private rebuild + sha256 | PASS (`IDENTICAL`, add4d823…aed6821) |
| 3 | `PVTools.lean` sha256 | PASS (unmodified, 445fe54f…) |
| 4 | statement fingerprints vs `L02_gate.md` snapshot (5 gated declarations) | PASS (all `th`/`vh`/`bi` identical) |
| 6 | `#pv_axioms L02` | PASS (ALL STANDARD, 5 declarations) |
| 7 | `#pv_walk L02` | PASS (`sorryAx reached: False`; axioms `propext, Classical.choice, Quot.sound`) |
| 8 | project constants reached outside L02 | 0 (`MODULE|L02|5` only) |
| 9 | declarations not in the gate snapshot (helpers) | none |
| 10 | `#pv_hyp_usage` on the 5 gated theorems | no `UNUSED` hypothesis |

**The `MECH CHECKS: FAIL (probe)` item.** The only failure is inside the script's
own probe `auditor_L02_mech1.lean`, at line 3, `#pv_type_hashes L02Stmt`:
`no constants found for module L02Stmt`. I adjudicate this as a **script-probe
artifact, not a defect of the audited work**, on independent evidence:

- I read `pv_work/L02Stmt.lean` in full: it contains only header comments and
  `namespace Paper.L02` / `end Paper.L02` — **zero declarations**. The command
  necessarily errors on a declaration-free module.
- The gate snapshot records exactly this: `TYPE HASHES (current file, 0 declarations)`
  for `L02Stmt`. So "0 declarations" is the *expected* snapshot value, and the
  file's sha256 is byte-identical to the gate's recorded hash (table above), i.e.
  nothing was added to `L02Stmt.lean` after the gate.
- The error did not suppress the checks that matter: the same probe still printed
  the five `L02` type hashes and the axiom lines (visible in the mech report), and
  items 4, 6, 7 are PASS.

I therefore do **not** count this as a FAIL item of the audit, and I note it as a
tooling observation only (candidate `DOC_ERRATA`/script nit: `pv_audit_mech.py`
should treat a declaration-free `Stmt` module whose snapshot says
"0 declarations" as PASS rather than probe-FAIL). I did not modify the script.

## 2. Gap files

Not applicable: there is no `pv_work/L02ModGaps.lean`, all four step obligations
are proved, and `#pv_walk` confirms `sorryAx` is not reached. Nothing in the file
is stopped or deferred.

## 3. Axioms and `sorry`

`#pv_axioms L02`: `ALL STANDARD (5 declarations checked)`; each of
`L02_S1 … L02_S4`, `L02_main` reports exactly
`[propext, Classical.choice, Quot.sound]`. `#pv_walk L02` over 5 roots / 5029
constants: `sorryAx reached: false`, closure axioms the same three. I re-ran both
myself in `auditor_L02_fidelity.lean` (log lines 10–17), independently of the
prover's and the script's runs. The audited file contains no `sorry`, `admit`,
`axiom`, `unsafe`, `native_decide`, `implemented_by`, `@[extern]` or
`debug.skipKernelTC` (file read in full), and judged by the PVTools commands, not
by grep.

## 4. Per-theorem conditionality

There are **no external parameters** (`L02Stmt.lean` declares nothing; no
`def … : Prop` anywhere; `verification/EXTERNAL_TOOLS.md` is owed no entry for
L02) and **no predecessor conditions** (the printed proof cites no earlier result;
contrast `main.tex:60-62`). So there is nothing to be conditional on.

Hypothesis tracing (`#pv_hyp_usage`, my own run, log lines 1–9), following the one
real hypothesis `hx : x > -1` down to the step that actually consumes it:

| Theorem | `x` | `hx` | where `hx` is really used |
|---|---|---|---|
| `L02_main` | USED | USED | passed to `L02_S2` |
| `L02_S2` | USED | USED | passed to `L02_S1`, whose output `0 < 1 + x` is the side condition of `le_div_iff₀` |
| `L02_S1` | USED | USED | consumed here by `linarith` (`x > -1 ⊢ 1 + x > 0`) |
| `L02_S3`, `L02_S4` | USED | (no `hx`; unconditional over ℝ) | — |

So `hx` is genuinely load-bearing and terminates at the source's own clause
"Since $1+x>0$" (`main.tex:79`). No `UNUSED` premise anywhere, hence no premise
that should be removed. No "X enters only through Y" claim is made, so no
`#pv_walk_decl` positive control is owed.

## 5. Infrastructure check

Item 8 of the mech report: **0 project constants reached outside the module under
audit**; the walk's module tally is `MODULE|L02|5`, i.e. only the five gated
declarations of `L02.lean` itself, everything else being mathlib. Item 9: **no
declaration in `pv_work/L02.lean` is absent from the gate snapshot** — there are
no private helper lemmas at all, so there is no helper to review and no
unaudited in-project constant to audit on the spot. The walk stops at no
interface. Consequently every in-project constant in the closure is covered by an
individual record: the five are gated in `L02_gate.md` (fingerprints identical)
and audited here one by one (§6).

The one named mathlib lemma in the proof, `le_div_iff₀`, is mathlib
infrastructure, not project infrastructure; its existence and signature
(`0 < c → (a ≤ b / c ↔ a * c ≤ b)`) are confirmed by the gate's `#check` log
`pv_work/logs/gate_L02_names_1.log`, and my probe compiles against it.

## 6. Route fidelity, sentence by sentence

Printed proof, `source/main.tex:78-81` (quoted verbatim from my own read):

> Since $1+x > 0$, multiplying both sides by $1+x$ preserves the inequality, so the claim
> is equivalent to $x^2 \ge (x-1)(x+1) = x^2 - 1$, which is obvious.

| Source clause (`file:line`) | Lean step | Ruling |
|---|---|---|
| "Since $1+x>0$" — `main.tex:79` | `L02_S1 : x > -1 → 1 + x > 0` (`L02.lean:37-38`, `linarith`) | Faithful. The source asserts the sign fact; deriving it from the printed hypothesis is one linear step. |
| "multiplying both sides by $1+x$ preserves the inequality, so the claim is equivalent to $x^2 \ge (x-1)(x+1)$" — `main.tex:79-80` | `L02_S2 : x^2/(1+x) ≥ x-1 ↔ x^2 ≥ (x-1)*(x+1)` (`L02.lean:49-55`), via `ge_iff_le` + `le_div_iff₀ (L02_S1 x hx)` | Faithful, including the `↔` ("equivalent to", not "it suffices"). The positivity side condition is supplied by S1, exactly the source's licence. |
| "$(x-1)(x+1) = x^2-1$" — `main.tex:80` | `L02_S3 : (x-1)*(x+1) = x^2-1` (`L02.lean:63-64`, `ring`) | Faithful; the printed equality. |
| "which is obvious" applied to $x^2 \ge x^2-1$ — `main.tex:80` | `L02_S4 : x^2 ≥ x^2-1` (`L02.lean:76-77`, `linarith`) | Faithful; precisely the assertion the source calls obvious, discharged rather than assumed. |
| conclusion `main.tex:71-76` | `L02_main` = `(L02_S2 x hx).mpr` after `rw [L02_S3 x]`, closed by `L02_S4 x` (`L02.lean:92-98`) | Faithful assembly in the source's own order. |

- **Route changed?** No. The Lean proof follows the single printed sentence clause
  by clause; no alternative route (e.g. `div_nonneg` tricks, AM–GM, completing a
  square) is substituted.
- **Stronger result used?** No. Nothing beyond `le_div_iff₀` (an equivalence
  weaker in content than the printed "multiplying preserves the inequality"
  claim) and linear/ring arithmetic. No result of the paper is used, so no
  predecessor is over-consumed.
- **Private helpers?** None exist (§5), so none can introduce new mathematics.
- **Circularity / conclusion as hypothesis?** None. The conclusion appears only as
  the left side of S2's printed equivalence; its `mpr` is used and the antecedent
  is supplied independently from S3 + S4. The kernel checks the assembly.

`FAIR_IMPLICIT_STEP` items (fill-ins the source does not spell out; none is an
issue):

| # | Implicit step | How it was filled in |
|---|---|---|
| F1 | `x > -1 ⟹ 1 + x > 0` (the source prints the conclusion of this one-step inference, not the inference) | `linarith` in `L02_S1` from `hx` alone |
| F2 | "multiplying both sides by $1+x$ preserves the inequality" as a formal equivalence | the mathlib lemma `le_div_iff₀` with side condition `0 < 1 + x`, i.e. literally multiply-by-a-positive |
| F3 | `(x-1)*(1+x)` vs the printed `(x-1)(x+1)` | commutativity of `ℝ`-multiplication, absorbed by `nlinarith` inside S2 — a form conversion only |
| F4 | `x^2 ≥ x^2 - 1` "obvious" | `linarith` (i.e. `-1 ≤ 0`) |

Encoding-convention check (so that our representation cannot manufacture a paper
error): Lean's `/` is total with `a/0 = 0`, but on the printed domain `1 + x ≠ 0`
— I proved `∀ x : ℝ, x > -1 → 1 + x ≠ 0` in my probe, so the junk value is never
reached. Everything is in `ℝ`, so the genuinely negative right-hand side `x - 1`
(for `x < 1`) is not clipped, which would otherwise have trivialised the lemma.

## 7. Non-vacuity

All of the following compile in
`pv_work/probes/auditor/L02/auditor_L02_fidelity.lean`
(`RESULT auditor_L02_fidelity mode=probe exit=0 errors=0 sorry_warnings=0`):

| Check | Content | Outcome |
|---|---|---|
| A | the printed statement, retyped by me from the `.tex`, closed by `L02_main`: `∀ x : ℝ, x > -1 → x^2/(1+x) ≥ x-1 := fun x hx => L02_main x hx` | compiles |
| B | type identity at `rfl` level: `(∀ x:ℝ, x > -1 → x^2/(1+x) ≥ x-1) = (type of L02_main)` by `rfl` | compiles |
| C | witnesses: `x = 0`, `x = -1/2`, `x = 3` instantiate the hypothesis (`by norm_num`) and give true instances; the nontrivial ones evaluate to `9/4 ≥ 2` and `1/2 ≥ -3/2` (both verified by `norm_num`), so no instance is degenerate | compiles |
| D | the **full** printed domain is available, not narrowed: `∀ x : ℝ, -1 < x → x < 0 → …` follows from `L02_main` — i.e. the Remark's `x ≥ 0` was not silently substituted | compiles |
| E | `∀ x : ℝ, x > -1 → 1 + x ≠ 0` (no junk division) | compiles |
| F | the hypothesis is essential and the statement is not trivially true as encoded: `¬ ((-2)^2/(1+(-2)) ≥ (-2)-1)` by `norm_num` | compiles |

So the hypothesis class is inhabited by nontrivial witnesses, the conclusion is a
substantive inequality, and the encoded domain is neither narrower nor wider than
the printed one.

## 8. Historical issue B01 (coordinator's question)

The closed history (old printed hypothesis `x \ne -1`, false at `x = -2`;
`verification/BLOCKERS.md` B01, `verification/audits/L02_issue_1.md`,
`L02_issue_1_audit.md`) is **not re-litigated** here. On the narrow question asked:

- The current printed statement (`main.tex:72`, `x > -1`) **excludes the entire
  region where the old statement failed**: the counterexample region was `x < -1`,
  and `x = -2` does not satisfy `x > -1`. My probe item F re-confirms, in Lean and
  independently of the old issue files, that the inequality is indeed false at
  `x = -2`, i.e. the revision removes exactly a region that had to be removed.
- The current statement is **true on the whole printed domain** and is machine-proved
  here (`L02_main`, clean axioms, no `sorry`), and the current printed proof's own
  clauses are each true and chain to the conclusion (§6) — the sign fact that was
  silently missing before is now printed and is exactly the licence used.

**Therefore: as now printed and as now proved, Lemma 2.3 contains no error, and
the defect recorded in B01 is removed by revision 1.** My judgement is that B01
can be marked RESOLVED (the final bookkeeping decision is the coordinator's); the
historical `ERROR` ruling against the *old* text stands as closed history and is
not withdrawn.

## 9. Status for the authors (≤ 3 lines)

Lemma 2.3 as printed in revision 1 — for every real `x > -1`, `x²/(1+x) ≥ x-1` —
is verified in Lean exactly as stated, along the paper's own one-sentence route
(sign fact `1+x>0`, clearing the denominator, `(x-1)(x+1)=x²-1`, `x² ≥ x²-1`),
with no external input, no cited result and no predecessor. It depends on nothing
beyond Lean/mathlib and the three standard axioms. Source assessment: no error,
no argument or assumption gap, no exposition gap; the only remarks are editorial —
"which is obvious" and "Since `1+x>0`" are terse but fair one-step assertions, and
the Remark at `main.tex:83-85` ("used … only for `x \ge 0`") concerns downstream
use and does not narrow this lemma's hypothesis.

## 10. FAIL items

None. (The mech report's `FAIL (probe)` is adjudicated in §1 as a script artifact
on a declaration-free `Stmt` module whose snapshot value is "0 declarations"; it
is a tooling nit, not a FAIL item of this audit. I state it openly rather than
silently overriding it.)

Checks I could not complete: none.

FINAL AUDIT: PASS
SUGGESTED VERDICT: UNCONDITIONAL
