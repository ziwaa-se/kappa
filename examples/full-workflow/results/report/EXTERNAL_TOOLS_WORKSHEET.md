# Human-check worksheet for external inputs

None of the items below is proved **inside the verification chain**: each theorem that depends on an item takes it as an explicit Lean hypothesis, so if any one of them is false, the conclusions that depend on it lose their support. (The one item below has, in addition, been found true by an auditor's own side probe — see its entry — but that probe is a suggestion only, not part of the audited proof, so the item is still an open, mandatory human check.)

## Checking principles (read first)

1. **Direction.** What must be confirmed is that "the theorem in the literature implies our Lean parameter". The Lean parameter may be weaker than the literature's conclusion (extra hypotheses, only a special case), but not stronger.
2. **Compare item by item.** Domain, quantifier order (which determines what the constants depend on), every hypothesis, the constants in the conclusion.
3. **Notation.** This project's Lean is entirely over `ℝ` (real numbers); no `ENNReal`/`∫⁻`/truncation notions occur anywhere in it.

## Priority overview

| Priority | # | Name | Nature | Used by |
|---|---|---|---|---|
| B | 1 | `Paper.P01.NesbittInequality` | (i) explicitly cited, doubtful attribution/numbering | Proposition 2.2 (PDF 2.2), step S2 |

- **A**: (iv) clauses of the paper's own lemmas whose proofs have issues; and (p) whose predecessor has an issue and could not be reconnected. These most need a mathematical check. **None in this project.**
- **A′**: (iii) never stated in the source, but silently used by the proof. **None in this project** — of the four non-Nesbitt candidates considered during drafting (`verification/INVENTORY.md` §6): positivity of $x^2+y^2+z^2$ and well-definedness of $S(x,y,z)$ were resolved as ordinary, trivially-discharged step obligations of Proposition 2.2; the "which is obvious" algebra of Lemma 2.3 became step obligations `L02_S2`/`L02_S3`; and the sign of $1+x$ needed for Lemma 2.3's multiply-through step was not a silent external input at all but the paper-side error B01 (see `AUTHOR_REPORT.md` §4.1), resolved by revision 1 and discharged as step obligation `L02_S1`.
- **B**: (i) with doubtful attribution or numbering. **1 item, below.**
- **C**: (ii) facts the source asserts but does not prove. **None in this project.**
- **D**: the remaining (i) explicitly cited theorems; only confirm that the Lean specialization has not become stronger. **None beyond the Level-B item** (the one citation in this paper is itself flagged at Level B for its numbering, so it is listed once, there).
- **E**: (v) standard facts that merely lack an interface in mathlib. **None in this project.**

Gap hypotheses are not external inputs and are not listed here. None exist in this project (L02's `gaps` field in `verification/RESULTS.json` is `[]`; L01 and P01 record no `gaps` field at all, which also means none; no `*ModGaps.lean` file exists).

---

## Level B

### #1 `Paper.P01.NesbittInequality`: for all positive reals $x,y,z$, $\frac{x}{y+z}+\frac{y}{z+x}+\frac{z}{x+y} \ge \frac{3}{2}$

- **Source**: `source/main.tex:60`, first sentence of the proof of Proposition 2.2 (PDF 2.2): "By Nesbitt's inequality $\cite[Theorem~1]{Nesbitt1903}$, $S(x,y,z) \ge 3/2$ for all $x,y,z \in \Rpos$." Bibliography, `source/main.tex:87-89`: "A. M. Nesbitt, Problem 15114, *Educational Times* 55 (1903), 37."
- **Why it needs checking**: this is the only external input in the whole paper, and the sole condition that keeps Proposition 2.2 from being unconditional. Additionally, the in-text citation attributes a numbered "Theorem 1" to what the bibliography records as a problem-column item ("Problem 15114"), which does not naturally carry that numbering — so both the mathematical content and the attribution/numbering are worth checking.
- **Mathematical content**: the classical Nesbitt's inequality, $\frac{x}{y+z}+\frac{y}{z+x}+\frac{z}{x+y} \ge \frac{3}{2}$ for all positive reals $x,y,z$, with equality iff $x=y=z$. This is a well-known 19th-century result, standardly proved via the rearrangement inequality, Cauchy–Schwarz, or AM-HM.
- **Suggested checking route** (from the audit records): (a) confirm the inequality itself is a true, standard, correctly-stated fact (e.g. via the rearrangement-inequality proof); (b) separately confirm the attribution to "Theorem 1" of A. M. Nesbitt, Problem 15114, *Educational Times* 55 (1903), 37, is accurate — problem columns of that era are not always indexed with theorem numbers, so the numbering may need correction or softening in the paper's bibliography, independent of whether the mathematical content is right.
- **Used by**: Proposition 2.2 (`prop:nesbitt`, PDF 2.2), step S2 (`pv_work/P01.lean:71-74`, `main.tex:60` first proof sentence), threaded through the main theorem `P01_main`. Confirmed by the final audit's hypothesis-usage walk: used only at this one step, nowhere else in the chain.
- **Lean definition** (`pv_work/P01Stmt.lean:39-41`, quoted verbatim):

```lean
def NesbittInequality : Prop :=
  ∀ x y z : ℝ, 0 < x → 0 < y → 0 < z →
    x / (y + z) + y / (z + x) + z / (x + y) ≥ 3 / 2
```

- **Check result**: ☑ holds — **already checked**: Test Reader (benchmark), 2026-09-30 20:56, against Nesbitt, Problem 15114, *Educational Times* 55 (1903), and the standard proof by the rearrangement inequality. ☐ does not hold  ☐ needs change: ____
- **Note on an auditor's side probe**: `NesbittInequality` is **not** proved inside the audited chain — it remains an explicit hypothesis `hN` of `P01_main`. Separately, the final-audit reviewer constructed and compiled their own Lean proof of `NesbittInequality` as a side probe (`verification/audits/P01_final.md` §6, `aud_P01_extsat.lean`), to confirm the condition is at least true and not vacuous. That probe is a **suggestion only**, not part of the audited proof, and does not connect to `P01_main`'s chain — so this remains a mandatory human check, now mostly about the citation's attribution/numbering rather than the mathematical content.
- **Note on verdict**: per `VERDICTS.md` §1.2, the human check above and the auditor's side probe together do not by themselves make Proposition 2.2 unconditional — that requires `NesbittInequality` to be proved in Lean *and reconnected into `P01_main`'s own chain*. Proposition 2.2 remains **CONDITIONAL**.

## Level A / A′ / C / D / E

No items at these levels in this project.

## Where the notation is defined

| Notation | Where defined | Meaning |
|---|---|---|
| `\R` | `source/main.tex:10-11, 28` | The real numbers, `ℝ` in Lean. |
| `\Rpos` | `source/main.tex:10-11, 28` | The positive real numbers; encoded in Lean as a positivity hypothesis `0 < x` on a variable `x : ℝ`, never as a separate subtype. |
| `S(x,y,z)` | `source/main.tex:31-33` | $\frac{x}{y+z}+\frac{y}{z+x}+\frac{z}{x+y}$, defined "whenever the three denominators are nonzero"; inlined directly in the Lean statement of Proposition 2.2 (no shared `def`, per `verification/INVENTORY.md` §4 — the notation is elementary enough to inline, and inlining is a pure notational choice that does not affect faithfulness). |
