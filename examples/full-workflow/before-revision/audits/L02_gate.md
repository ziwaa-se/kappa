# L02 — independent statement gate (pv-gate)

- **Reviewer:** `pv-gate` (independent subagent; not the drafter of these files)
- **Date:** Wed Sep 30 19:50:19 EDT 2026 (`date`)
- **Result reviewed:** L02 = Lemma `lem:quot` (numbered Lemma 2.3 in the compiled document), `source/main.tex:71-76` (statement), `source/main.tex:78-81` (proof)
- **Files reviewed (sha256, `python3 scripts/pv_snapshot.py hash`):**
  - `pv_work/L02Stmt.lean` — `08cb673719aff7819a2f8560598d17ae9d03744689eb352d55351b325146745e`
  - `pv_work/L02Draft.lean` — `8af2a82de281b08de7dde1d3ae4150f6ececbc9c73f5e75ef39d1efb547c29cd`
- **Also read:** `pv_work/notes/L02_draft_notes.md` (leads only, not evidence), `source/main.tex:1-92` in full (notation section, all three results, the Remark and the bibliography), `pv_work/L01Stmt.lean` / `pv_work/L01Draft.lean` (name-collision check only).
- **Shared definitions:** none. `pv_work/L02Stmt.lean` imports only `Mathlib.Data.Real.Basic`; `pv_work/L02Draft.lean` imports only `L02Stmt`. No `Defs*.lean`, no predecessor `Stmt` file, hence no imported hidden hypotheses, no `variable`s, no type classes beyond `ℝ`'s own instances, no `structure`s.

## Compilation (run by me, in this session)

```
$ scripts/pv_lean.sh check L02Draft
RESULT L02Draft mode=check exit=0 errors=0 sorry_warnings=3 nonstandard_axiom_lines=0 log=pv_work/logs/L02Draft_2.log olean=none
```
Real exit code: **0**; 3 `sorry` warnings (S1, S2, S3), 0 errors. Log: `pv_work/logs/L02Draft_2.log`.

Snapshot probes (on copies, see the last section):
```
$ scripts/pv_lean.sh probe pv_work/probes/gate/L02/gate_L02_stmtcopy.lean
RESULT gate_L02_stmtcopy mode=probe exit=0 errors=0 sorry_warnings=0 nonstandard_axiom_lines=0 log=pv_work/logs/gate_L02_stmtcopy_1.log olean=none
$ scripts/pv_lean.sh probe pv_work/probes/gate/L02/gate_L02_draftcopy.lean
RESULT gate_L02_draftcopy mode=probe exit=0 errors=0 sorry_warnings=3 nonstandard_axiom_lines=0 log=pv_work/logs/gate_L02_draftcopy_1.log olean=none
```
`scripts/pv_lean.sh packages` reports `linked` (mathlib 2452/6305 modules compiled), so no `lake build` was run by me.

## Source quotations (read directly, not via the notes)

`source/main.tex:71-76` (statement):
```
\begin{lemma}\label{lem:quot}
For every real number $x \neq -1$ we have
\[
  \frac{x^2}{1+x} \ge x - 1 .
\]
\end{lemma}
```

`source/main.tex:78-81` (proof, a single sentence):
```
\begin{proof}
Multiplying both sides by $1+x$, the claim is equivalent to
$x^2 \ge (x-1)(x+1) = x^2 - 1$, which is obvious.
\end{proof}
```

`source/main.tex:83-85` (Remark, **not** part of the lemma):
```
\begin{remark}
Lemma~\ref{lem:quot} is used in the companion paper only for $x \ge 0$.
\end{remark}
```

Relevant conventions: `source/main.tex:26-33` — "Throughout, $\R$ denotes the real numbers and $\Rpos$ the positive real numbers", and the notation `S(x,y,z)` "whenever the three denominators are nonzero". The `S(x,y,z)` notation is not used by this lemma. There is **no** global convention restricting the variable `x` in Lemma `lem:quot`: the only stated restriction is the one printed in the lemma itself, `x \neq -1`. The lemma is stated for real `x` (the statement says "For every real number"), not for `x \in \Rpos`.

## Item-by-item ruling

### 1. Hypotheses — **PASS**

| Source clause | Lean |
|---|---|
| "For every real number" | `(x : ℝ)` |
| "$x \neq -1$" | `(hx : x ≠ -1)` |
| (none) | (no further premise) |

`L02Draft.lean:87`: `theorem L02_main (x : ℝ) (hx : x ≠ -1) : x ^ 2 / (1 + x) ≥ x - 1`.

- Every printed hypothesis is encoded, in the printed form, and nothing else is added. In particular the domain is **not** narrowed to `x ≥ 0` or to `1 + x > 0`. That is correct: the `x ≥ 0` restriction appears only in the unlabeled/unregistered Remark at `main.tex:83-85`, which reports how a *companion paper* uses the lemma and is not part of the lemma's hypotheses. Narrowing the domain here would have been a repair of the source (forbidden by POLICY §1) and would have hidden the substantive question.
- No hidden hypotheses: `L02Stmt.lean` declares nothing at all (verified by the snapshot: 0 declarations), there is no `structure`, no `variable`, no type-class parameter, and no imported definition carrying side conditions.
- No hypothesis states the conclusion or an equivalent of it. `hx : x ≠ -1` is the printed side condition, not a form of the goal.
- `x ≠ -1` correctly captures "$x \neq -1$" and, as the drafter notes, is exactly what makes `1 + x ≠ 0`, so the Lean total division `x ^ 2 / (1 + x)` agrees with the source's quotient on the whole stated domain (no junk-value region is silently admitted, and none is silently excluded). I verified this myself: `x ≠ -1 ↔ 1 + x ≠ 0` over `ℝ`.

### 2. Conclusion — **PASS**

The printed conclusion is the single inequality $\frac{x^2}{1+x} \ge x-1$; the Lean conclusion is `x ^ 2 / (1 + x) ≥ x - 1`. Not weakened, not strengthened, no clause missing (unlike Lemma `lem:amgm` at `main.tex:37-43`, this lemma has **no** "with equality if and only if" clause, and the draft correctly adds none). `≥` is the same direction as `\ge`; `x ^ 2` is `x^2`; the denominator is `1 + x` in the same order as the source. Real-valued, no `ℝ≥0∞`/`ENNReal`/`toReal` truncation anywhere, so no truncation trap. This is an **exact transcription**, which was the focus question of the task: the Lean statement `x ^ 2 / (1 + x) ≥ x - 1` under `x ≠ -1` is neither stronger nor weaker than the printed claim.

### 3. Quantifiers and dependence of constants — **PASS**

The source universally quantifies over one real `x`; the Lean statement binds `(x : ℝ)` universally at the front. There are no constants, no implicit "there exists a constant C" convention in this manuscript's notation section, hence no ordering-of-choice question. Binder annotations are all explicit (`bi=ee`, `bi=e` in the snapshot), so nothing is silently made implicit or instance-implicit.

### 4. Domains and details — **PASS**

- Domain: all of `ℝ` minus `{-1}`, i.e. both `x > -1` and `x < -1` are in scope, matching the print. Non-periodic/measure-theoretic questions do not arise.
- Division: Lean's `/` on `ℝ` is total, but on the stated domain `1 + x ≠ 0`, so on the whole domain the Lean expression equals the source's quotient. No "equality vs. a.e. equality", no measurability, regularity, finiteness or existence/construction issues: the statement is a first-order inequality between two real expressions.
- No `ENNReal`, no `ofReal`, no `toReal`.
- Our own representation choices therefore do not manufacture a paper error: the falsity at `x = -2` discussed below comes from the printed domain and the printed inequality, not from the encoding (at `x = -2`, `1 + x = -1 ≠ 0`, so Lean's division is the honest quotient `4 / (-1) = -4`).

### 5. Step obligations — **PASS as a faithful transcription**, with one obligation **false as stated** (which mirrors the source)

| Step | Lean statement | Source sentence | Faithful? | True as stated? |
|---|---|---|---|---|
| `L02_S1` (`L02Draft.lean:49-51`) | `(x : ℝ) (hx : x ≠ -1) : x ^ 2 / (1 + x) ≥ x - 1 ↔ x ^ 2 ≥ (x - 1) * (x + 1)` | `main.tex:79-80`, "Multiplying both sides by $1+x$, the claim is equivalent to $x^2 \ge (x-1)(x+1)$" | Yes | **No — false as stated** |
| `L02_S2` (`:63`) | `(x - 1) * (x + 1) = x ^ 2 - 1` | `main.tex:80`, "$(x-1)(x+1) = x^2-1$" | Yes | Yes |
| `L02_S3` (`:73`) | `x ^ 2 ≥ x ^ 2 - 1` | `main.tex:80`, "$x^2 \ge x^2-1$, which is obvious" | Yes | Yes |

Detailed rulings:

- **S1 corresponds to its labelled sentence, as a single step.** The source's proof is one sentence with no case distinction; S1 is one obligation over the full domain `x ≠ -1` with **no** sign case-split added, and with none removed either (there is none to remove). The `↔` form is justified by the source's own words "is equivalent to". This is exactly what the task asked me to check, and it holds.
- **S1 is false as stated.** Take `x = -2` (allowed: `-2 ≠ -1`). Left side of the `↔`: `x ^ 2 / (1 + x) = 4 / (-1) = -4` and `x - 1 = -3`, so `-4 ≥ -3` is **false**. Right side: `x ^ 2 = 4` and `(x-1)*(x+1) = (-3)*(-1) = 3`, so `4 ≥ 3` is **true**. A biconditional with a false left side and a true right side is false. Hence S1 is false at `x = -2`, and the failing direction is precisely `mpr` (`←`), i.e. the direction the assembly actually consumes. I record this explicitly, as the gate must.
  - Note for blame attribution: the drafter's `↔` is not what makes S1 false. The weaker, single direction the source's argument actually needs (`x ^ 2 ≥ (x-1)*(x+1) → x ^ 2 / (1+x) ≥ x - 1`) is *also* false at `x = -2`. So the encoding choice does not manufacture the failure; the failure is in the printed step. (The other direction, `→`, is fine at `x = -2` only vacuously.)
- **No obligation smuggles in the target conclusion or a stronger intermediate one.** S1's left-hand side of the `↔` is the goal, but it appears as one side of a claimed equivalence that the source itself asserts, not as a hypothesis; S1 does not have the goal as a premise. S2, S3 are strictly weaker algebraic facts.
- **Assembly is complete and sound.** `L02_main` (`:87-93`) derives the goal from S1.mpr, S2, S3 with no extra input, and `scripts/pv_lean.sh check L02Draft` returns exit 0, so the decomposition really does yield the main theorem. All the substantive content (and the entire suspected defect) sits inside S1, which matches where the source's argument does its only non-trivial work.
- **Main theorem is itself false as stated** (same witness `x = -2`: `-4 ≥ -3` is false). This is a property of the printed lemma, not of the encoding; ruling on the paper's correctness is out of the gate's scope and goes to `pv-issue-checker` / the prover. The gate's job — is the transcription exact? — is answered: yes.

### 6. External parameters — **PASS (none declared)**

`pv_work/L02Stmt.lean` declares **no** `def _ : Prop`, no external parameter, no consumed clause `L02_<PredID>Consumed` (there is no predecessor: L02 does not use Lemma `lem:amgm` or Proposition `prop:nesbitt`, and its proof cites nothing; the bibliography entry `Nesbitt1903` is used only by `prop:nesbitt`). The snapshot of `L02Stmt.lean` shows 0 declarations, confirming this mechanically rather than by eye. Consequences:

- nothing can be "stronger than the source's use", "goal-shaped", or mis-provenanced;
- no name is redeclared from another `Stmt` file (`Paper.L01` declares `L01Conclusion`, `L01_S1..S4`, `L01_main`; `Paper.L02` declares only `L02_S1`, `L02_S2`, `L02_S3`, `L02_main` — disjoint, and in different namespaces);
- everything in both files is inside `namespace Paper.L02`;
- no "mathlib does not have X" claim needs support, because no parameter was created on that ground. The drafter's two INVENTORY candidates were handled correctly: EXT-4 (`x^2 \ge (x-1)(x+1) = x^2-1`, "which is obvious") is ordinary `ℝ` algebra and is rightly a step obligation (S2/S3) rather than an opaque parameter; EXT-5 (the sign of `1+x`) is a candidate *paper-side* defect and must not be dressed up as an external input or as a "technical" extra hypothesis — the draft does neither.

### 7. Doubts about the source — recorded, **routing recommended**

- `source/main.tex:71-76` + `78-81`: the printed lemma appears to be **false** on the part `x < -1` of its own stated domain (witness `x = -2`: `x^2/(1+x) = -4`, `x - 1 = -3`, and `-4 \ge -3` is false), and the printed one-sentence proof multiplies an inequality by `1+x` without addressing the case `1+x < 0`. Preliminary classification: **`ERROR`** (the printed conclusion is false as stated), with the missing sign discussion as a contributing `PAPER_ARGUMENT_GAP` / `PAPER_ASSUMPTION_GAP` (the hypothesis `1+x>0`, equivalently `x > -1`, that the argument needs is not printed). I do **not** rule on this in the gate. **Recommendation: dispatch `pv-issue-checker`** to construct/confirm the Lean counterexample at `x = -2` and to fix the fault class (in particular to decide between `ERROR` and `PAPER_ASSUMPTION_GAP`, given the Remark at `main.tex:83-85`).
- `source/main.tex:83-85`: the Remark ("used in the companion paper only for $x \ge 0$") is evidence about intent, not a hypothesis. It must not be used to narrow the lemma. Noted for the issue-checker as context only.

I confirm the task's framing: the drafter's flag is a judgment call about the **source**, not a drafting/encoding error. The statement `L02_main (x : ℝ) (hx : x ≠ -1) : x ^ 2 / (1 + x) ≥ x - 1` is an exact transcription of the printed claim; there is no `ENCODING_ERROR` here.

## TFAs ruled on

| TFA | Ruling | Reason |
|---|---|---|
| (none proposed, none present) | n/a | The draft adds no premise beyond the printed `x ≠ -1`, so there is nothing to approve or reject. Notably it does **not** add `0 < 1 + x` / `0 ≤ x` as a "technical" premise — which would have been rejected here, since it is not derivable from the context and excludes a non-degenerate part of the stated domain (exactly the part the suspected defect lives on). |

## External parameters

| Parameter | Provenance | Ruling |
|---|---|---|
| (none declared in `pv_work/L02Stmt.lean`) | n/a | Approved as-is: no parameter is needed or justified for this lemma; the file correctly declares nothing. |

## Required changes

None.

## Statement snapshot

`pv_work/probes/gate/L02/gate_L02_stmtcopy.lean` (copy of `pv_work/L02Stmt.lean` + `import PVTools` + `#pv_type_hashes_here`), log `pv_work/logs/gate_L02_stmtcopy_1.log`:

```
TYPE HASHES (current file, 0 declarations)
```

`pv_work/probes/gate/L02/gate_L02_draftcopy.lean` (copy of `pv_work/L02Draft.lean`, keeping `import L02Stmt`, + `import PVTools` + `#pv_type_hashes_here`), log `pv_work/logs/gate_L02_draftcopy_1.log`:

```
TYPE HASHES (current file, 4 declarations)
Paper.L02.L02_S1|thm|th=370882976|vh=-|bi=ee
Paper.L02.L02_S2|thm|th=2900165390|vh=-|bi=e
Paper.L02.L02_S3|thm|th=2894931473|vh=-|bi=e
Paper.L02.L02_main|thm|th=4196440307|vh=-|bi=ee
```

Any later change to these four types (or to the binder annotations) must show up as a different `th`/`bi` in the final audit's `#pv_type_hashes L02Draft` / `#pv_type_hashes L02` comparison; the gate decides "changed or not" only by these hashes, never by eye.

## Verdict

Statement and step obligations are a faithful, exact transcription of `source/main.tex:71-81` over the full printed domain `x ≠ -1`, with no added or removed hypotheses, no case split invented or suppressed, and no external parameters. `L02_S1` (and therefore `L02_main`) is **false as stated** at `x = -2`; that is a property of the printed source, to be ruled on by `pv-issue-checker`, and is not a reason to block the statement gate. Proof work (or, more likely, counterexample work) may begin.

STATEMENT GATE: PASS
