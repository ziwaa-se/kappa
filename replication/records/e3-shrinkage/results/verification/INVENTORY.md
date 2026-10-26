# Inventory of the source manuscript

"The oracle risk of linear shrinkage" (single file, 79 lines).

## Files read
- `source/main.tex` (entry file; no `\input`, `\include` or `\subfile`; no separate macro file)
- `source/main.aux` (numbering)
- `source/main.pdf` exists (not needed; aux numbers are decisive)

## Numbering sources
Priority 1 (`main.aux` `\newlabel`): def:risk = 1.1, lem:square = 2.1, lem:min = 2.2, thm:oracle = 2.3, cor:half = 2.4. All numbers share one counter (`\newtheorem{lemma}[theorem]`, within section). Note: the aux numbers are section-relative to `\section{Setting}` (1) and `\section{Results}` (2). No unresolved numbers.

## Numbered results

| ID | PDF no. | Kind | Label | Statement | Proof | depends_on | External citations |
|---|---|---|---|---|---|---|---|
| L01 | 2.1 | Lemma | lem:square | main.tex:39-41 | main.tex:43-52 | none | none |
| L02 | 2.2 | Lemma | lem:min | main.tex:54-56 | main.tex:58-61 | none | none |
| T01 | 2.3 | Theorem | thm:oracle | main.tex:63-66 | main.tex:68-72 | L01, L02 | none |
| C01 | 2.4 | Corollary | cor:half | main.tex:74-76 | main.tex:78-81 | L01, L02 | none |

Total: 4 numbered results (1 theorem, 2 lemmas, 1 corollary). Dependency levels: 2 (L01, L02 -> T01, C01). Acyclic.

Remarks on proofs (recorded only, not ruled on):
- L02 proof asserts "the harmonic mean of two positive numbers is at most the smaller of them" (a "standard fact" assertion, line 54), then writes rho <= (1/2) min. It is stated without proof or citation. Type (ii)/(v) candidate.
- C01 proof's second sentence (line 75, rho <= min{theta^2, sigma^2}, via L02) does not appear to be used for the stated claim R(c*) <= R(1/2); it also uses R(c*) = rho, which follows from L01 at c = c* (not cited explicitly).
- T01 proof uses R(0) = theta^2 and R(1) = sigma^2 (direct from D01, unstated computation).
- L01 proof uses the identity expansion and "completing the square" (routine algebra); implicitly theta^2 + sigma^2 > 0 (D04).
- T01 proof uses theta^2+sigma^2 > 0 explicitly, from D04.

## Verbatim statements

**L01 (Lemma 2.1, lem:square)**
> For every $c \in \mathbb{R}$, $R(c) - \rho = (\theta^2 + \sigma^2)(c - c^\ast)^2$.

**L02 (Lemma 2.2, lem:min)**
> $\rho \le \min\{\theta^2, \sigma^2\}$.

**T01 (Theorem 2.3, thm:oracle)**
> For every $c \in \mathbb{R}$, $R(c) \ge \rho$, with equality if and only if $c = c^\ast$. Moreover,
> $\rho \le \min\{R(0), R(1)\}$.

**C01 (Corollary 2.4, cor:half)**
> $R(c^\ast) \le R(1/2)$.

## Shared definitions and assumptions (not counted as results)

| ID | Object | Lines | Label | Content |
|---|---|---|---|---|
| D01 | risk R(c) | main.tex:28-29 | def:risk | $R(c) = c^2\sigma^2 + (1-c)^2\theta^2$ for $c\in\mathbb R$ |
| D02 | oracle factor c* | main.tex:30-31 | def:risk | $c^\ast = \theta^2/(\theta^2+\sigma^2)$ |
| D03 | oracle risk rho | main.tex:32-33 | def:risk | $\rho = \theta^2\sigma^2/(\theta^2+\sigma^2)$ |
| D04 | standing assumption | main.tex:25 | none | "Throughout, $\theta \ne 0$ and $\sigma > 0$ are real numbers." |

D01-D03 sit in one Definition environment (lines 27-34), each given its own line range.

## Global conventions
- theta, sigma are fixed real parameters with theta != 0, sigma > 0 (D04); all results are for these fixed values. No constant C.
- c ranges over R. The statement of D01 mentions "when X has mean theta and variance sigma^2" only as interpretation; R is defined by the explicit formula.
- No probability space is formalized; estimators are only used through R.

## Candidate external inputs

| Name | Source | Provenance | Users |
|---|---|---|---|
| Harmonic mean of two positive numbers is at most the smaller of them | main.tex:54 | (ii) asserted without proof (as worded, it appears to need checking; not ruled on here) | L02 |
| R(0) = theta^2, R(1) = sigma^2 | main.tex:65 | (iii) silently used computation (trivial from D01) | T01 |
| R(c*) = rho (from L01 at c = c*) | main.tex:75 | (iii) used without citing | C01 |
| theta^2+sigma^2 > 0 | main.tex:64 | from D04, stated | L01, T01, C01 |

No literature citations (no `\cite`, no bibliography).

## Unnumbered claims
None with a proof or computation outside the numbered results. (The abstract, lines 17-21, is descriptive only.) Experimental part: none.

## Notational ambiguities (recorded only)
1. D01 says R(c) is "mean squared error when X has mean theta and variance sigma^2": R is defined by formula; the statistical interpretation is not used.
2. "Half the harmonic mean" (L02): the harmonic mean is 2ab/(a+b); the proof's inequality chain wording ("at most the smaller of them") should be read against this definition.
3. Numbering: lemmas, theorems, corollaries and definitions share one counter, numbered by section (Definition 1.1; Lemma 2.1, 2.2; Theorem 2.3; Corollary 2.4).
