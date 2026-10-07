# L02 — issue 1, counterexample review (pv-auditor)

- **Role:** `pv-auditor`, counterexample-review mode (independent of the drafter, the gate and the issue-checker of L02)
- **Date:** Wed Sep 30 20:02:21 EDT 2026 (`date`)
- **Object reviewed:** ruling `verification/audits/L02_issue_1.md` (`ISSUE VERDICT: ERROR`, `THREATENS CONCLUSION: yes`) and its evidence file `pv_work/L02_Counterexample1.lean`
- **Source read directly:** `source/main.tex` in full (93 lines) — preamble/notation `1-33`, Lemma 2.1 `37-50`, Proposition 2.2 `52-69`, **Lemma 2.3 `lem:quot` statement `71-76` and proof `78-81`**, Remark `83-85`, bibliography `87-90`. Also read in full: `pv_work/L02Stmt.lean`, `pv_work/L02Draft.lean`, `pv_work/L02_Counterexample1.lean`, `pv_work/PVTools.lean`, the statement snapshot of `verification/audits/L02_gate.md:139-157`.
- **Environment:** `scripts/pv_lean.sh packages` → `PACKAGES linked … mathlib modules compiled: 2452 of 6305`; no `lake build`, no `lake update`, no network. I wrote only this report and `pv_work/probes/auditor/L02/`; I modified no audited file.

## 0. Checks I ran myself (not taken from the issue report)

| # | Check | Command / probe | Result |
|---|---|---|---|
| 1 | private rebuild + sha256 | `scripts/pv_lean.sh rebuild L02_Counterexample1 L02` | `exit=0`, delivered = rebuilt = `de30ab78…de5ae1`, **IDENTICAL** |
| 2 | axioms of every declaration | `#pv_axioms L02_Counterexample1` (probe `auditor_L02_ce1_axioms.lean`, log `pv_work/logs/auditor_L02_ce1_axioms_1.log`) | `ALL STANDARD (21 declarations checked)` |
| 3 | module closure | `#pv_walk L02_Counterexample1` | 21 roots, 5208 constants; `AXIOMS in closure: [propext, Classical.choice, Quot.sound]`; `sorryAx reached: false` |
| 4 | closure of the refutation itself | `#pv_walk_decl Paper.L02.Issue1.counterexample` | 4874 constants; same three axioms; `sorryAx reached: false`; in-project constants reached: only `PrintedClause` and `witness_satisfies_printed_hypothesis` (both in this module) → **no earlier project theorem is consumed**, so no further individual audit record is needed |
| 5 | fingerprints of the evidence file | `#pv_type_hashes L02_Counterexample1` | `PrintedClause … vh=4196440307`; `PrintedEquivalenceStep … vh=370882976` |
| 6 | the gated statements as they stand **now** | hand copy of `L02Draft.lean` + `#pv_type_hashes_here` (probe `auditor_L02_ce1_draftcopy.lean`) | `L02_S1 th=370882976 bi=ee`, `L02_S2 th=2900165390`, `L02_S3 th=2894931473`, `L02_main th=4196440307 bi=ee` — line-for-line equal to the gate snapshot (`L02_gate.md:151-154`) |
| 7 | **identity** of the refuted object with the gated statement | `example : GatedMainClosed = Paper.L02.Issue1.PrintedClause := rfl` and the same for `L02_S1` / `PrintedEquivalenceStep` (probe `auditor_L02_ce1_identity.lean`, `exit=0`) | both `rfl` checks **pass** |
| 8 | refutation re-derived from scratch | in the same probe, `example : ¬ GatedMainClosed` and `example : ¬ GatedS1Closed`, proved without using any declaration of the audited file | `exit=0, errors=0, sorry_warnings=0` |
| 9 | the suggested fix, independently | probe `auditor_L02_ce1_fix.lean` (own proofs, does not import the evidence file) | `exit=0`: `∀ x > -1` the inequality holds; the `main.tex:79` equivalence holds on `x > -1`; it fails at every `x < -1`; witnesses `x = 0`, `x = 3` show the restricted class is non-vacuous |

Hash cross-check for item 5/6/7: the gate's `th` for `Paper.L02.L02_main` is `4196440307` and equals the `vh` of `PrintedClause`; the gate's `th` for `Paper.L02.L02_S1` is `370882976` and equals the `vh` of `PrintedEquivalenceStep`. The `rfl` checks of item 7 are the stronger, hash-independent confirmation of the same thing. **This is therefore not an `ENCODING_ERROR` in disguise**: the object refuted is exactly the gated (and faithfully transcribed) statement, not a paraphrase.

## 1. Encoding fidelity (decisive item)

Printed clause, `source/main.tex:71-76`, verbatim: "For every real number $x \neq -1$ we have $\frac{x^2}{1+x} \ge x - 1$."

Encoded as `def PrintedClause : Prop := ∀ x : ℝ, x ≠ -1 → x ^ 2 / (1 + x) ≥ x - 1`.

| Printed element | Lean | Verdict |
|---|---|---|
| "every real number" (`\R` = reals, `main.tex:28`) | `∀ x : ℝ` | word for word |
| side condition `x ≠ -1` | hypothesis `x ≠ -1`, retained | present, not dropped |
| conclusion `x²/(1+x) ≥ x-1` | `x ^ 2 / (1 + x) ≥ x - 1` | unchanged, not strengthened |
| nothing else is printed as a hypothesis | no extra hypothesis added, none removed | not stronger than printed |

So the encoding has neither fewer premises nor a stronger conclusion than the source; it is literally the same statement (item 7 above proves it coincides with the gated transcription that `pv-gate` passed).

**Parameters vs. global objects.** The source statement quantifies over a single parameter `x ∈ ℝ`; the only global objects are `ℝ` and ordinary field/order operations. No global object is constructed from `x`, so there is no "the author fixed this object earlier" escape: the witness is a free choice of the universally quantified variable.

## 2. Does the instance satisfy every printed hypothesis?

Witness `x = -2`.

| Requirement | Status |
|---|---|
| `x` is a real number (`main.tex:28-29`, "every real number") | `(-2 : ℝ)` — yes |
| `x ≠ -1` (the only printed hypothesis) | `(-2 : ℝ) ≠ -1`, re-proved by me (`norm_num`) |
| denominator nonzero, so Lean `/` is the honest quotient (no junk value) | `1 + (-2) = -1 ≠ 0`, re-proved by me |
| conclusion fails there | `(-2)²/(1+(-2)) = -4`, `(-2)-1 = -3`, and `¬(-4 ≥ -3)`, all three re-proved by me |

**No definition or convention in the source excludes `x = -2`.** I searched the whole text myself: the Notation section (`main.tex:26-33`) defines `\R` (reals), `\Rpos` (positive reals) and `S(x,y,z)`; `\Rpos` is used only in Proposition 2.2 (`main.tex:52-57`) and `S` only there, neither in Lemma 2.3. Lemma 2.3 is stated over "every real number", not over `\Rpos`. The only text mentioning a smaller range is the Remark at `main.tex:83-85` ("Lemma~\ref{lem:quot} is used in the companion paper **only for** $x \ge 0$"): it carries no `\label`, stands *after* the proof, is not referenced by the lemma, and describes a *use* in another paper, not a hypothesis of this lemma. I agree with the issue report that it does not narrow the printed domain; adopting it as a hypothesis would be repairing the statement, not fairly adopting a convention.

## 3. Is the counterexample itself proved?

Yes, and I verified it without relying on the issue-checker's own theorems:

- compile + private rebuild byte-identical (item 1);
- axioms exactly `propext, Classical.choice, Quot.sound`, `sorryAx reached: false`, over the whole module and over `counterexample` alone (items 2-4) — checked with `#pv_axioms`/`#pv_walk`, not grep;
- the refutation consumes **no** earlier project theorem (item 4), so the "every earlier theorem used has an individual audit record" requirement is satisfied vacuously; nothing in the L02 proof chain imports this file, and it is not imported by `pv_work/L01.lean` (`import L01Stmt`, `Mathlib.Tactic.Linarith`, `Mathlib.Tactic.Ring`);
- I re-proved `¬ GatedMainClosed` and `¬ GatedS1Closed` from scratch in my own probe (item 8), so the paper-side finding does not rest on the audited file at all.

Auxiliary declarations in the evidence file (`quot_identity`, `RestrictedClause`, `restricted_clause_holds`, `fails_on_whole_lower_branch`, `RestrictedEquivalenceStep`, `restricted_equivalence_step_holds`, `ConsumedClause`, `consumed_of_printed`, `consumed_clause_holds`) are scope/fix-testing material, clearly labelled as the reviewer's own algebra and not as source steps; they are not used in any verification of L02 and are not a repair of the paper. I re-proved the three load-bearing ones independently (item 9). Correctly, they are a *suggestion to the authors*, never evidence for a verdict.

## 4. Scope: what is and is not refuted

| Object | Refuted? |
|---|---|
| `Paper.L02.L02_main` = printed Lemma 2.3 over the printed domain `x ≠ -1` (`main.tex:71-76`) | **Yes** — false at `x = -2`, and (independently re-proved) at **every** `x < -1` |
| `Paper.L02.L02_S1` = the equivalence asserted at `main.tex:79` over `x ≠ -1` | **Yes** — including the single direction the argument consumes (`PrintedStepUsedDirection`) |
| `L02_S2` (`(x-1)(x+1) = x²-1`), `L02_S3` (`x² ≥ x²-1`), and the "which is obvious" fact `x² ≥ (x-1)(x+1)` | **No** — these are true for all real `x`; the break is only in the sign-sensitive multiplication step |
| Lemma 2.3 restricted to `x > -1` (and a fortiori to `x ≥ 0`) | **No** — true; re-proved by me |
| L01 (Lemma 2.1, `lem:amgm`, `main.tex:37-50`) and P01 (Proposition 2.2, `prop:nesbitt`, `main.tex:52-69`) | **No** — reading `main.tex` myself, `\ref{lem:quot}` occurs exactly once outside the lemma, at `main.tex:84` inside the Remark; the proof of Proposition 2.2 (`main.tex:59-69`) cites only Nesbitt `[Nesbitt1903]` and `lem:amgm`, and `lem:amgm`'s proof cites nothing |
| The companion paper's use at `x ≥ 0` | **No**, as far as `main.tex:84` describes it — that range lies inside the true region. Like the issue-checker, I have no access to the companion paper, so the claim "the companion really only uses `x ≥ 0`" is **unverified** and must be checked by a human |

"False for what, credible for what": the printed *general* clause is false (on the open ray `x < -1`); the instance the authors say they consume (`x ≥ 0`) is true, as is the whole range `x > -1`. The scope stated in the ruling is therefore neither too broad nor too narrow.

## 5. Classification review

`ERROR` is the correct primary code: a counterexample satisfying every printed hypothesis refutes the printed conclusion on a non-degenerate part of the printed domain (VERDICTS §2). I checked the alternatives the ruling rejects and agree:

- not `PAPER_ARGUMENT_GAP` as primary (the conclusion is not merely unjustified, it is false), though the sign omission at `main.tex:79` is a real argument defect and is correctly recorded as a secondary code;
- not `PAPER_ASSUMPTION_GAP` as primary (the printed claim read as printed is refuted, not merely under-hypothesised), correctly kept as a secondary code;
- not `EXPOSITION_GAP` (the uncovered range is a range of falsity, not of weaker constants);
- not `FAIR_IMPLICIT_STEP` (`1+x>0` cannot be supplied: it is false on part of the stated domain);
- not `DOMAIN_CLARIFICATION` (the printed domain is unambiguous; the Remark speaks of another paper's use);
- not `ENCODING_ERROR` / `TRANSLATION_BLOCKED` (items 5-8 above; everything compiled, nothing missing).

`THREATENS CONCLUSION: yes` is right for L02 itself and, per the table in §4, for nothing else inside this manuscript.

## 6. Suggested fix: does it remove the problem?

The ruling proposes replacing `x \neq -1` by `x > -1` at `main.tex:72`. I verified this independently (probe `auditor_L02_ce1_fix.lean`, my own proofs):

- the restricted **statement** is true: `∀ x : ℝ, -1 < x → x²/(1+x) ≥ x-1`;
- the restricted **proof step** of `main.tex:79` is a genuine equivalence on `x > -1`, so the printed one-sentence proof becomes correct as written;
- `x > -1` is optimal: the inequality fails at every `x < -1`, so no larger subset of `ℝ \ {-1}` works;
- the restricted hypothesis class is non-vacuous (`x = 0`, `x = 3`; at `x = 3`, `9/4 ≥ 2`), and contains the `x ≥ 0` range of `main.tex:84`.

So the fix is sufficient and minimal. (This remains a suggestion to the authors; it is used in no verification.) The alternative restriction to `x ≥ 0` also works but discards true content — an editorial choice for the authors.

## 7. Items I could not complete / caveats

1. The companion paper is not in `source/`; whether its uses of Lemma 2.3 all satisfy `x \ge 0` is **not checked** by me either. If any use falls in `x < -1`, that use breaks too.
2. No other check was left incomplete. I did not run `pv_audit_mech.py` (that script is for final-audit mode on a result module; this is counterexample-review mode, and the mechanical items it would cover — compile, private rebuild and sha256, axioms, walk, statement fingerprints — I ran individually above).

## 8. Status for the authors (3 lines)

Lemma 2.3 (`lem:quot`, `main.tex:71-76`) is **false as printed**: at `x = -2`, which satisfies the only stated hypothesis `x \neq -1`, the claim reads `-4 \ge -3`; it fails at every `x < -1`. The cause is the proof's one step at `main.tex:79`, which multiplies the inequality by `1+x` without securing `1+x>0`; the closing algebraic fact `x^2 \ge x^2-1` is itself correct. Replacing the domain by `x > -1` makes both the statement and the printed proof correct, is optimal, and keeps the `x \ge 0` range the Remark says is used; Lemma 2.1 and Proposition 2.2 are unaffected.

---

Review items (VERIFICATION_METHODS §5): (1) `PrintedClause` is word-for-word the printed clause and `rfl`-identical to the gated `L02_main` closure; (2) the instance satisfies every printed hypothesis; (3) no source definition or convention excludes it; (4) the evidence compiles with the three standard axioms only and consumes no unaudited project theorem; (5) the proposed fix is verified sufficient.

COUNTEREXAMPLE VALID — `x = -2` is a real number with `-2 ≠ -1`, the only printed hypothesis of Lemma 2.3; there `x²/(1+x) = -4 < -3 = x-1`, so the printed conclusion fails. The refuted proposition is `rfl`-identical to the gate-snapshotted `Paper.L02.L02_main` (`th = 4196440307`), the refutation is machine-checked with only `propext`, `Classical.choice`, `Quot.sound` and no `sorryAx`, it uses no project theorem beyond its own witness lemma, and I re-derived it independently. Classification `ERROR` with `THREATENS CONCLUSION: yes` is confirmed; scope: L02 only (false exactly on `x < -1`; true on `x > -1`, hence L01, P01 and the `x \ge 0` use described at `main.tex:84` are untouched).
