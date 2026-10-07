# Human-check worksheet for external inputs

None of the items below has been **proved in Lean**. Theorems that depend on an item take it as an explicit hypothesis, so if any one of them is false, the conclusions that depend on it lose their support.

## Checking principles (read first)

1. **Direction.** What must be confirmed is that "the theorem in the literature implies our Lean parameter". The Lean parameter may be weaker than the literature's conclusion (extra hypotheses, only a special case), but not stronger.
2. **Compare item by item.** Domain, quantifier order (which determines what the constants depend on), every hypothesis, the constants in the conclusion.
3. **Notation.** `S(x,y,z) = x/(y+z) + y/(z+x) + z/(x+y)`, exactly as `source/main.tex:26-33` defines it; the Lean parameter below inlines this same sum rather than naming it.

## Priority overview

| Priority | # | Name | Nature | Used by |
|---|---|---|---|---|
| B | 1 | `Paper.P01.NesbittInequality` | (i) explicitly cited, doubtful attribution/numbering | P01 |

- **A**: (iv) clauses of the paper's own lemmas whose proofs have issues; and (p) whose predecessor has an issue and could not be reconnected. These most need a mathematical check. *(None in this project.)*
- **A′**: (iii) never stated in the source, but silently used by the proof. Flag these prominently; suggest that the authors add them to the text. *(None in this project — see `verification/EXTERNAL_TOOLS.md` "Candidates from the inventory, now settled" for the candidates considered and resolved as ordinary proof steps instead.)*
- **B**: (i) with doubtful attribution or numbering. *(1 item, below.)*
- **C**: (ii) facts the source asserts but does not prove. *(None in this project.)*
- **D**: the remaining (i) explicitly cited theorems; only confirm that the Lean specialization has not become stronger. *(None beyond the item in B.)*
- **E**: (v) standard facts that merely lack an interface in mathlib. *(None in this project.)*

Gap hypotheses are not external inputs and are not listed here; this project has none (no obligation was left as a gap — Lemma 2.3's problem is a confirmed paper-side issue, not a gap, see `verification/BLOCKERS.md` B01).

---

## Level B

### #1 `Paper.P01.NesbittInequality`: Nesbitt-type bound `S(x,y,z) ≥ 3/2` for positive reals

- **Source**: `source/main.tex:60` — "By Nesbitt's inequality `\cite[Theorem~1]{Nesbitt1903}`, $S(x,y,z) \ge 3/2$ for all $x,y,z \in \Rpos$." Bibliography: `source/main.tex:87-90` — "A. M. Nesbitt, Problem 15114, *Educational Times* 55 (1903), 37."
- **Why it needs checking**: the bibliography entry is a 19th-century problem-column item ("Problem 15114"), which does not naturally carry a numbered "Theorem 1" as the in-text citation claims. This is a citation-attribution question, not a mathematical one — `NesbittInequality` is not proved anywhere inside the verification chain (it remains a visible hypothesis, which is why P01 stays CONDITIONAL), but one reviewer, the final auditor, separately constructed and compiled a proof of it as a side probe (`pv_work/probes/auditor/P01/aud_P01_extsat.lean`, `verification/audits/P01_final.md`), using only standard axioms. This is a suggestion/observation only, not part of the delivered proof, so it does not change the CONDITIONAL verdict — but it does mean the mathematical content, independently of the citation's attribution, is very likely correct.
- **Mathematical content**: for all reals `x,y,z > 0`, `x/(y+z) + y/(z+x) + z/(x+y) ≥ 3/2` (the classical Nesbitt inequality).
- **Suggested checking route**: locate the original "Problem 15114" in *Educational Times* 55 (1903), p. 37, and confirm (a) it is by A. M. Nesbitt, (b) it states the inequality above (or something at least as strong, specialized correctly down to this), and (c) whether "Theorem 1" is an appropriate way to refer to it (e.g. because of how it is indexed in a later collection, or because the citation means a different, mislabeled source). This is a bibliographic/attribution check, not a re-derivation of the mathematics.
- **Used by**: Proposition 2.2 (PDF 2.2), step S2 (the proof's first sentence, `main.tex:60`), threaded through the main theorem `P01_main`. Confirmed by the final audit's hypothesis-usage walk: `hN` is used at exactly this one step; no other step of Proposition 2.2's proof touches it.
- **Lean definition** (`pv_work/P01Stmt.lean:39-41`, quoted verbatim):

```lean
def NesbittInequality : Prop :=
  ∀ x y z : ℝ, 0 < x → 0 < y → 0 < z →
    x / (y + z) + y / (z + x) + z / (x + y) ≥ 3 / 2
```

- **Check result**: ☐ holds  ☐ does not hold  ☐ needs change: ____

## Where the notation is defined

| Notation | Where defined | Meaning |
|---|---|---|
| `ℝ` | `source/main.tex:10` (`\R`) | the real numbers |
| `ℝ_{>0}` / `\Rpos` | `source/main.tex:11,28` | the positive real numbers (standard reading: excludes 0) |
| `S(x,y,z)` | `source/main.tex:26-33` ("Notation" section) | `x/(y+z) + y/(z+x) + z/(x+y)`, defined "whenever the three denominators are nonzero" |
