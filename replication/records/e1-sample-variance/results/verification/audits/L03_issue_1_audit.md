# L03 issue 1: counterexample review (Lemma lem:raw)

- Reviewer: pv-auditor (independent subagent, claude-opus-5-5)
- Date: Mon Oct 12 22:22:37 EDT 2026 (from `date`)
- Reviewed: `verification/audits/L03_issue_1.md` (ruling), `pv_work/L03_Counterexample1.lean`, the gate report `verification/audits/L03_gate.md`, and source/main.tex:24-38, 50-56, 85-100, which I read directly.

## Files (sha256, `python3 scripts/pv_snapshot.py hash`)

| File | sha256 | Matches gate (L03_gate.md:10-13) |
|---|---|---|
| pv_work/L03Stmt.lean | 0528bec8…4e2d4 | yes |
| pv_work/Defs.lean | e69206f7…c08e | yes |
| pv_work/L03Draft.lean | 05e890c7…af | yes |
| pv_work/L03_Counterexample1.lean | 0e4ddf50…2f2f | (audited object; not modified) |

## 1. Encoding fidelity (decisive item)

| Check | Result |
|---|---|
| Source clause :86: "Suppose that $n\ge2$. Then $s^2 \le \frac1n\sum x_i^2$", with $x\in\mathbb R^n$ (:26), $\bar x$ (:29), $s^2=\frac{1}{n-1}\sum(x_i-\bar x)^2$ (:35) | read directly |
| `PrintedClause := ∀ {n} (_hn : 2 ≤ n) (x : Sample n), Conclusion x` | same premises, same conclusion |
| `Conclusion` fingerprint | th=3418533756, vh=556412300: equal to the gate snapshot (L03_gate.md:69) |
| `PrintedClause` value hash | vh=3472474048: equal to the gate th of `Paper.L03.L03_main` (L03_gate.md:79) |
| My own `example` (probe check 1): `¬ (∀ {n} (hn : 2 ≤ n) (x : Sample n), Conclusion x)` closed by `counterexample` | compiles, so the refuted proposition is the type of the gated main theorem |
| My own `Iff.rfl` (probe check 2): `Conclusion x ↔ (1/((n:ℝ)-1)) * ∑ (x i - (1/n) * ∑ x j)^2 ≤ (1/n) * ∑ (x i)^2` | compiles, so the definitions unfold literally to :35, :29, :86 |
| Not stronger than the source | no premise removed, conclusion not strengthened. `ConsumedByC01` adds a premise, so it is weaker, which is allowed |
| Parameters and global objects | $s^2$ and $\bar x$ are built from $(n,x)$; there are no global objects or constants. Real cast `(n:ℝ)-1`, no ℕ truncation. At $n=2$ there is no division by zero |

## 2. The instance satisfies every printed hypothesis

- $n=2$: this satisfies $n\ge2$ (:86), the global $n\ge1$ (:26), and the $n\ge2$ in the domain of def:var (:33).
- $x=(1,-1)\in\mathbb R^2$. The source places no restriction on $x$.
- I searched the whole text (main.tex:1-109) for other definitions of $s^2$ or $\bar x$. There is only def:var (:32-38) and def:mean (:28-30).
- The population-variance reading ($1/n$) is excluded twice: by :35, and by the proof's own $(n-1)s^2$ at :90.
- The instance also satisfies $|x_i|\le1$ (`x0_bounded`).

## 3. The counterexample is proved

| Check | Result |
|---|---|
| `scripts/pv_lean.sh build L03_Counterexample1` (my run) | `exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0`, log `pv_work/logs/L03_Counterexample1_2.log`, olean produced |
| Auditor probe `pv_work/probes/auditor/L03/aud_L03_cex1.lean` (`pv_lean.sh probe`) | exit=0, 0 errors, 0 sorries; log `pv_work/logs/aud_L03_cex1_1.log` |
| `#pv_axioms L03_Counterexample1` | ALL STANDARD (17 declarations) |
| `#pv_walk L03_Counterexample1` | closure axioms [propext, Classical.choice, Quot.sound]; sorryAx reached: false |
| Project constants reached | `Paper.Sample`, `Paper.sampleMean`, `Paper.sampleVar` (Defs, hash = gate snapshot), `Paper.L03.Conclusion` (L03Stmt, gated). These are definitions only; no earlier theorem is used, so no individual theorem audit record is needed |
| Independent arithmetic (probe check 3) | Computed directly from the raw definitions without the helper lemmas: $\bar x=0$, $s^2=\frac11(1+1)=2$, RHS $=\frac12\cdot2=1$, $2\not\le1$. Confirmed in Lean |

## 4. Scope

- **Refuted:** the universal clause at main.tex:86, i.e. the gated `L03_main`, at $n=2$.
- **Also refuted:** the restricted form consumed by C01 (:99), which adds $|x_i|\le1$ (`counterexample_consumed`).
- **The step at :91 fails:** at the instance, the premise from :90 is true (`step91_premise_holds`) and the claimed conclusion is false.
- **The "every $n\ge2$" family is reasoning only.** I checked it by hand: if $\bar x=0$ and $x\ne0$, then $s^2=\frac{\sum x_i^2}{n-1}>\frac{\sum x_i^2}{n}$. It is correct, but it is not Lean evidence, and the ruling labels it that way.
- **Not refuted:**
  - the lines at :90 (S1, S2: true);
  - L01, L02, P01, P02, none of which cites lem:raw;
  - C01's printed conclusion $s^2\le2$, which holds at x0 with equality (`x0_C01_conclusion_holds`).
- **C01 consequence:** C01's proof (:99) relies on the false lemma, and its intermediate claim $s^2\le1$ fails at x0 (`x0_C01_intermediate_fails`). C01 needs its own ruling.
- **The ruling's scope is stated correctly**, neither too broad nor too narrow.

## 5. Suggested fix

- **Fix 1:** claim $s^2\le\frac{1}{n-1}\sum x_i^2$, and "dividing by $n-1$". This follows from :90 because $n-1\ge1>0$, so it is correct. The C01 route that goes with it is $\sum x_i^2\le n$, then $\frac{n}{n-1}\le2$ for $n\ge2$. That is also correct, but it was constructed by the reviewer, so it is a suggestion only.
- **Fix 2:** claim $\frac{n-1}{n}s^2\le\frac1n\sum x_i^2$. This is :90 divided by $n>0$, so it is correct.
- Both fixes remove the problem. Neither one is used as evidence.

## 6. Classification

- **`ERROR` confirmed.** The printed conclusion is false under the source's own definitions, on an instance that satisfies every printed hypothesis.
- **No `ENCODING_ERROR`:** the encoding is literal and was verified by `Iff.rfl`.
- **No `DOMAIN_CLARIFICATION`:** :35 and :90 fix the normalisation.
- **The :91 step defect is subsumed by the ERROR**, as the ruling says.

## Status for the authors

- Lemma lem:raw (main.tex:86) is false. The Lean counterexample at $n=2$, $x=(1,-1)$ gives $s^2=2>1$.
- The error is in the step "Dividing by $n$" (:91). Dividing by $n-1$, with the claim changed to match, fixes it.
- Corollary cor:unit's proof (:99) depends on the lemma and needs its own ruling.

Reason: it refutes exactly the gated L03_main / main.tex:86 (fingerprints equal to the gate snapshot), the instance n=2, x=(1,-1) satisfies every printed hypothesis, and the proof builds with standard axioms only and no sorryAx.

COUNTEREXAMPLE VALID
