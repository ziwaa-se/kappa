# Counterexample review: L02 (Lemma 2.2, lem:min) issue 1

- Role: pv-auditor (claude-opus-5-5), counterexample-review mode; date Mon Oct 12 22:12:48 EDT 2026 (from `date`)
- Reviewed: ruling `verification/audits/L02_issue_1.md`; counterexample `pv_work/L02_Counterexample1.lean`
- Source read directly: `source/main.tex` (the whole file, 78 lines; relevant lines 25, 32-33, 48-56, 63-76)
- Audited files not modified.

## Hashes (from `python3 scripts/pv_snapshot.py hash`)

| File | sha256 | Matches |
|---|---|---|
| `pv_work/L02_Counterexample1.lean` | `5c2fbd7c…aa9d8ec` | ruling §6 |
| `pv_work/L02Stmt.lean` | `8c2d7440…62c6885a` | `L02_gate.md` (STATEMENT GATE: PASS) |
| `pv_work/Defs.lean` | `1de1a18f…de80b31` | `DEFS_gate.md` (STATEMENT GATE: PASS) |

## 1. Encoding fidelity (decisive item)

Source, main.tex:53-55: "The number $\rho$ is half the harmonic mean $2\theta^2\sigma^2/(\theta^2+\sigma^2)$ of $\theta^2$ and $\sigma^2$. The harmonic mean of two positive numbers is at most the smaller of them, so $\rho \le \frac12\min\{\theta^2,\sigma^2\} \le \min\{\theta^2,\sigma^2\}$."

| Clause | Lean | Premises vs source | Conclusion vs source | Ruling |
|---|---|---|---|---|
| (A) l.54 | `PrintedClauseA := ∀ a b : ℝ, 0<a → 0<b → 2*a*b/(a+b) ≤ min a b` | "two positive numbers": both positivity premises kept; nothing dropped | "at most the smaller", HM formula as printed at l.53 | faithful, not stronger |
| (B) l.55 first `≤` | `PrintedClauseB := ∀ θ σ, Setting θ σ → oracleRisk θ σ ≤ (1/2)*min (θ^2) (σ^2)` | standing assumption l.25 exactly (`Setting` = θ≠0 ∧ 0<σ, gated D04) | ρ (gated D03, l.33 verbatim) ≤ ½ min | faithful, not stronger |

- Checked by `rfl` in my probe: `PrintedClauseA` is definitionally the displayed proposition and equals the gated `Paper.L02.HarmonicLeMin` (S2 obligation of the gated draft).
- Global vs constructed objects: θ, σ are the paper's fixed-but-arbitrary reals of l.25 ("Throughout"), so the lemma and its proof must hold for every admissible pair; quantifying (B) over all `Setting θ σ` is the source's reading, and a single admissible pair refutes it. In (A), "two positive numbers" is a general claim over positive reals; it is also refuted at the instance actually used, since (1,4) = (θ², σ²) for θ=1, σ=2 (and (B) refutes the instance directly).
- Number system: the paper works over ℝ throughout (l.25, l.28); ℝ is the right domain for (A).

## 2. Instances satisfy every printed hypothesis

| Witness | Hypotheses | Values (independently re-checked by `norm_num` in my probe) |
|---|---|---|
| (A): a=1, b=4 | 0<1, 0<4 | HM = 8/5, min = 1, 8/5 ≤ 1 false |
| (B): θ=1, σ=2 | θ≠0, σ>0 (`Setting 1 2` constructed) | ρ = 4/5, ½·min{1,4} = 1/2, 4/5 ≤ 1/2 false |

No definition or convention in `source/main.tex` excludes these (the only conventions are l.25 and Definition def:risk l.27-34; I read the whole file).

## 3. The counterexample is proved

| Check | Result |
|---|---|
| `scripts/pv_lean.sh check L02_Counterexample1` (run by me) | `exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log `pv_work/logs/L02_Counterexample1_2.log` |
| My probe `pv_work/probes/auditor/L02/aud_L02_issue1.lean`, `scripts/pv_lean.sh probe` | `exit=0`, log `pv_work/logs/aud_L02_issue1_1.log` |
| `#pv_axioms L02_Counterexample1` | ALL STANDARD (11 declarations) |
| `#pv_walk L02_Counterexample1` | axioms `[propext, Classical.choice, Quot.sound]`; `sorryAx reached: false` |
| `#print axioms` counterexampleA/B, clauseB_pointwise_iff, conclusion_true, fix_chain | standard three only |
| Project constants reached | only gated definitions: `Paper.Setting` (+ projections/ctor), `Paper.oracleRisk` (DEFS gate PASS); `Paper.L02.Conclusion`, `harmonicMean`, `HarmonicLeMin` (L02 gate PASS). No earlier theorem is used, so no theorem audit record is needed. |

## 4. Scope

- Refuted: (A) l.54 (general form and the instance used), and (B) the first inequality of l.55. `clauseB_pointwise_iff` (proved) shows (B) holds iff θ² = σ², so it fails at every admissible pair with θ² ≠ σ²; `harmonicMean_ge_min` shows the direction of (A) is reversed.
- Not refuted: the identity ρ = ½·HM (l.53, used in `fix_chain`), the second inequality ½ min ≤ min (l.55), and the lemma's printed conclusion l.49, which is true (`conclusion_true`, a sanity check only, not the source route).
- Downstream: read main.tex:65-66 (T01 uses Lemma lem:min for ρ ≤ min{R(0),R(1)} with R(0)=θ², R(1)=σ²) and main.tex:75 (C01 uses ρ ≤ min{θ²,σ²}). Both consume only the printed conclusion, which is true; neither consumes (A) or (B). `consumed_of_printed` confirms (B) is strictly stronger than the consumed clause. Content of T01/C01 is not affected; how their dependence on L02 is recorded is for the coordinator (VERDICTS §1).
- Classification `PAPER_ARGUMENT_GAP`: confirmed. The printed conclusion is true, so not `ERROR`; the justification fails at every point with θ² ≠ σ², so not `EXPOSITION_GAP`; no extra hypothesis short of θ² = σ² rescues (B), so not `PAPER_ASSUMPTION_GAP`; a false step cannot be a `FAIR_IMPLICIT_STEP`; the encodings are verbatim, so no `ENCODING_ERROR`. The ruling's human note (the text prints a false inequality (B)) is appropriate.
- L02 verdict consequence: the source route stops at S2 = (A); L02 is ISSUE (proof), with its conclusion true.

## 5. Suggested fix

"The harmonic mean of two positive numbers is at most twice the smaller of them, so ρ ≤ min{θ², σ²}." Checked: `fix_harmonicMean_le_two_min` (HM ≤ 2 min for a,b>0) is true and proved; `fix_chain` derives `Conclusion` from ρ = ½ HM (l.53) plus that fact, with standard axioms. The fix removes the problem. (A weaker-sounding alternative, "at most the larger", would not suffice to give ρ ≤ min, so the specific wording matters.) It is a reviewer suggestion only, not evidence for any verdict.

## 6. Status for the authors

The proof of Lemma 2.2 (main.tex:54-55) asserts that the harmonic mean is at most the smaller number and that ρ ≤ ½ min{θ², σ²}; both are false (θ=1, σ=2). The lemma's conclusion is true, and changing the text to "at most twice the smaller" gives a correct proof.

## 7. Reason for the verdict

(A) at a=1,b=4 and (B) at θ=1,σ=2 satisfy every printed hypothesis, the clauses are faithful and not stronger, proofs are sorry-free with standard axioms; classification PAPER_ARGUMENT_GAP (conclusion true) confirmed.

COUNTEREXAMPLE VALID
