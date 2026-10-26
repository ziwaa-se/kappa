# Inventory: Variance bounds for proportions and sums

## Files read
- source/main.tex (single file; no \input/\include/\subfile; no macro files)
- source/main.aux (numbering); source/main.pdf exists (not run through pdftotext)

## Numbering sources
All PDF numbers from `main.aux` `\newlabel` (priority 1). Shared counter within section (theorem, lemma, proposition, definition all share).

## Numbered results (6: 3 lemmas, 3 propositions; 0 theorems)

| ID | PDF no. | Kind | Label | Statement | Proof | depends_on | External citations |
|---|---|---|---|---|---|---|---|
| L01 | 2.1 | Lemma | lem:quarter | main.tex:38-40 | 42-45 | - | none |
| L02 | 2.2 | Lemma | lem:positive | 47-49 | 51-53 | - | none |
| P01 | 2.3 | Proposition | prop:concave | 55-58 | 60-63 | - | none ("well known" concavity of sqrt(p(1-p))) |
| L03 | 2.4 | Lemma | lem:linear | 65-67 | 69-71 | L01 | none |
| P02 | 2.5 | Proposition | prop:uniform | 73-75 | 77-79 | L01 | none |
| P03 | 2.6 | Proposition | prop:sum | 81-83 | 85-88 | - | none |

Dependency levels: 2 (level 0: L01, L02, P01, P03; level 1: L03, P02).

## Verbatim statements
- L01 (Lemma 2.1): For every $p \in \mathbb{R}$, $p(1-p) = \frac14 - (p - \frac12)^2$. In particular $V_n(p) \le \frac{1}{4n}$.
- L02 (Lemma 2.2): For every $p \in I$, $V_n(p) > 0$.
- P01 (Proposition 2.3): For all $p, q \in I$, $\sqrt{V_n\bigl(\tfrac{p+q}{2}\bigr)} \ge \frac12 \Bigl(\sqrt{V_n(p)} + \sqrt{V_n(q)}\Bigr)$.
- L03 (Lemma 2.4): For every $p \in I$, $V_n(p) \le \frac{p}{4n}$.
- P02 (Proposition 2.5): There is a constant $C$ such that $V_n(p) \le C/n$ for every $n \ge 1$ and every $p \in \mathbb{R}$.
- P03 (Proposition 2.6): For $m \ge 2$ and $x, y \in \mathbb{R}^m$, $s^2(x + y) \le 2 s^2(x) + 2 s^2(y)$.

## Shared definitions (not numbered results)

| ID | Object | Lines | Label |
|---|---|---|---|
| D01 | V_n(p) = p(1-p)/n, p real (Definition 1.1) | main.tex:26-29 | def:vp |
| D02 | sample mean and s^2(u), m>=2 (Definition 1.2) | main.tex:31-34 | def:svar |
| D03 | convention: I = unit interval | main.tex:24 | - |
| D04 | convention: n >= 1 integer | main.tex:24 | - |

## Global conventions
n >= 1 integer throughout; the constant C in P02 is existentially quantified (not depending on n, p). Definition 1.1 explicitly allows p in R.

## Candidate external inputs

| Name | Source | Type | Users |
|---|---|---|---|
| concavity of p -> sqrt(p(1-p)) on I ("well known") | main.tex:61 | (ii)/(v) (asserted without proof; check mathlib for interface) | P01 |
| Cross term of s^2(x+y) vanishes: s^2(x+y)=s^2(x)+s^2(y) (never stated as a fact, silently used; identity holds only up to 2*cov(x,y)) -- PROMINENT | main.tex:86 | (iii) | P03 |
| "V_n(p) <= p/(4n)" obtained from L01 though L01 only gives 1/(4n); the step p(1-p) <= p/4 is not justified by L01 (needs 1-p <= 1/4, not a consequence) | main.tex:70 | (iii) candidate | L03 |
| Standard algebra nonnegativity/positivity facts (p>0, 1-p>0 on I; depends on whether I is open) | main.tex:52 | (iii) candidate (see ambiguity A1) | L02 |

## Unnumbered claims
None with proof (abstract only, main.tex:17-20). H-list empty. No experimental part.

## Notational ambiguities (recorded only)
- A1: "I denotes the unit interval" (main.tex:24): open (0,1) or closed [0,1] is not stated. L02 and its proof ("both p and 1-p are positive") are sensitive to this; P01, L03 are not.
- A2: In L01 "In particular V_n(p) <= 1/(4n)" holds for all real p; L03 and P02 then use L01 with different quantifier ranges (I vs R).
- A3: Constant C in P02 is existential; no dependence stated beyond "n, p".
