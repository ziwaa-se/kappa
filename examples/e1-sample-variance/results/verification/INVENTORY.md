# Inventory

## Files read
- source/main.tex (single file; no \input/\include/\subfile; no macro files; only standard packages)
- source/main.aux (numbering); source/main.pdf exists, not text-checked.

## Numbering sources
All PDF numbers from `.aux` `\newlabel` entries (priority 1). Theorem counter shared by all environments, reset per section.

## Numbered results
| ID | PDF no. | Kind | Label | Statement | Proof | depends_on | External citations |
|---|---|---|---|---|---|---|---|
| L01 | 2.1 | Lemma | lem:centred | main.tex:42-44 | 46-48 | - | - |
| L02 | 2.2 | Lemma | lem:shortcut | 50-52 | 54-56 | - | - |
| P01 | 2.3 | Proposition | prop:popoviciu | 58-63 | 65-69 | - | Popoviciu \cite{popoviciu} (line 66), no theorem number |
| P02 | 2.4 | Proposition | prop:samuelson | 71-73 | 75-83 | L01 | - (Cauchy-Schwarz used, line 77-78) |
| L03 | 2.5 | Lemma | lem:raw | 85-87 | 89-92 | L02 | - |
| C01 | 2.6 | Corollary | cor:unit | 94-96 | 98-100 | L03 | - |

Totals: 6 numbered results (3 lemmas, 2 propositions, 1 corollary). Dependency levels: 3 (L01,L02,P01 / P02,L03 / C01).

## Verbatim statements
- L01 (2.1): `$\sum_{i=1}^n (x_i - \bar x) = 0$.`
- L02 (2.2): `$\sum_{i=1}^n (x_i - \bar x)^2 = \sum_{i=1}^n x_i^2 - n \bar x^2$.`
- P01 (2.3): `Suppose that $n \ge 2$ and that $a \le x_i \le b$ for $i = 1, \dots, n$. Then \[ s^2 \le \frac{n}{n-1} \cdot \frac{(b-a)^2}{4} . \]`
- P02 (2.4, Samuelson's inequality): `Suppose that $n \ge 2$. Then $|x_i - \bar x| \le \frac{n-1}{\sqrt{n}} \, s$ for every $i = 1, \dots, n$.`
- L03 (2.5): `Suppose that $n \ge 2$. Then $s^2 \le \frac{1}{n} \sum_{i=1}^n x_i^2$.`
- C01 (2.6): `Suppose that $n \ge 2$ and that $|x_i| \le 1$ for $i = 1, \dots, n$. Then $s^2 \le 2$.`

## Shared definitions
| ID | Name | Lines |
|---|---|---|
| D01 | sample mean (def:mean) | main.tex:28-30 |
| D02 | sample variance s^2 and standard deviation s (def:var; n>=2) | main.tex:32-38 |
| D03 | global setting n>=1, x in R^n | main.tex:26 |

## Global conventions
- n >= 1 integer, x in R^n (line 26). Variance only defined for n >= 2. No constants C. a, b real endpoints in P01 (a<=b implicit).

## Candidate external inputs
| Name | Source | Type | Users |
|---|---|---|---|
| Popoviciu's variance inequality: (1/n) sum (x_i - mean)^2 <= (b-a)^2/4 | main.tex:66-67, bib 103-106 | (i) (cited, no theorem number; the bib entry title is about algebraic equations) | P01 |
| Case s = 0 (division by s in z_j = (x_j - mean)/s) | main.tex:76 | (iii) silently used, never treated | P02 |
| Cauchy-Schwarz, sum_{j!=i} z_j^2 expansion | main.tex:77-80 | (v) standard fact | P02 |
| Expansion of the square / sum x_i = n*mean | main.tex:55 | (v) elementary | L02 |
| Positivity: n*mean^2 >= 0 and sum x_i^2 <= n when |x_i|<=1 | main.tex:90, 99 | (iii) unstated minor steps | L03, C01 |

## Unnumbered claims
None with a proof (abstract only summarizes). No experimental part.

## Notational ambiguities (recorded only)
- Samuelson (P02) with s = 0: statement reads fine (0 <= 0 holds) but proof divides by s.
- Notation of L03 "1/n" versus the (n-1) normalization of s^2 in D02: the proof divides (n-1)s^2 by n (line 91); the coordinator may want to check this step (not ruled on here).
- Proposition P01: a <= b not stated explicitly.
- Corollary C01 proof claims s^2 <= 1 <= 2; the bound 2 in the statement differs from the 1 in the proof (not ruled on).
