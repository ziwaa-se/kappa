# Registry of external inputs (visible parameters)

For the rules see `verification/rules/VERDICTS.md` §4. Each parameter is a `def … : Prop`, used as an explicit hypothesis of a theorem, and **never written as an axiom**.

Provenance types:
- (i) explicitly cited in the source;
- (ii) asserted in the source but not proved;
- (iii) **never stated in the source**;
- (iv) a clause of one of the source's own lemmas whose proof has a recorded issue;
- (v) a standard fact with no interface in the pinned mathlib;
- (p) the consumed clause `<ID>_<PredID>Consumed` of a predecessor; it must be reconnected once the predecessor is proved.

Gap hypotheses `<ID>_S<k>_Gap` are **not** registered here; they are recorded in each result's `gaps` field. The machine-readable registry is `external_tools` in `RESULTS.json`; the table below can be generated with `python3 scripts/pv_status.py tools`.

| ID | Lean name (file:line) | Meaning in one sentence | Type | Source location | Used by (result/clause/step) | mathlib search evidence | Audit judgment | Human check points |
|---|---|---|---|---|---|---|---|---|
| P01_NesbittInequality | pv_work/P01Stmt.lean:39 `Paper.P01.NesbittInequality` | Nesbitt-type bound S(x,y,z) ≥ 3/2 for all positive reals x,y,z | (i) | source/main.tex:60, `\cite[Theorem~1]{Nesbitt1903}` | P01 (step S2, main theorem) | not searched (external literature citation, not a request to mathlib); specialized exactly as main.tex:60 states it, no stronger — confirmed by pv-gate (`verification/audits/P01_gate.md`) | pv-gate PASS: faithful, non-goal-shaped specialization | **Priority B**: confirm this is indeed Theorem 1 of A. M. Nesbitt, Problem 15114, *Educational Times* 55 (1903), 37, as cited — a 19th-century problem-column item, attribution/numbering worth a second look (gate's EDITORIAL note) |

Generate/refresh this table any time with `python3 scripts/pv_status.py tools`.

## Candidates from the inventory, now settled

| ID | Name | Preliminary provenance | Resolution |
|---|---|---|---|
| EXT-1 | Nesbitt's inequality, "Theorem 1" of Nesbitt1903 | (i) | **Registered** as `P01_NesbittInequality` above. |
| EXT-2 | $x^2+y^2+z^2>0$ for $x,y,z\in\R_{>0}$ | (iii)/(v) border | **Not registered as a parameter** — proved as step obligation `P01_S4` in `pv_work/P01Draft.lean`, confirmed immediate from positivity by pv-gate. |
| EXT-3 | Well-definedness of $S(x,y,z)$ on $x,y,z\in\R_{>0}$ | (iii) | **Not registered as a parameter** — proved as step obligation `P01_S1`, confirmed immediate from positivity by pv-gate. |
| EXT-4 | "$x^2\ge(x-1)(x+1)=x^2-1$, which is obvious" | (v) | **Not registered as a parameter** — kept as ordinary step obligations `L02_S2`/`L02_S3` in `pv_work/L02Draft.lean`, trivial `ℝ`-algebra, confirmed by pv-gate. |
| EXT-5 | Sign of $1+x$ needed for the multiply-through step | (iii) | **Not an external input — was a confirmed paper-side ERROR, now RESOLVED.** See `verification/BLOCKERS.md` B01 (RESOLVED 2026-09-30 20:53, revision 1): the pre-revision printed conclusion of L02 was false for $x<-1$ (counterexample $x=-2$), confirmed by independent counterexample review (`verification/audits/L02_issue_1_audit.md`). The paper was revised to restrict the domain to $x>-1$ and the sign fact is now explicit in the proof; L02 verdict (current): UNCONDITIONAL (see `verification/audits/L02_final.md`). |

## Provenance debt recorded in words (not Lean hypotheses)

| Debt | Content | Affected | Not affected |
|---|---|---|---|

## External assertions not encoded

| Assertion | Source location | Impact |
|---|---|---|
