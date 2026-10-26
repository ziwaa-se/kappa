# Inventory: Three facts about the empirical distribution function

## Files read
- source/main.tex (76 lines; single file, no \input/\include/\subfile; no macro files)
- source/main.aux (numbering); source/main.pdf exists (not text-checked)

## Numbering sources
All PDF numbers from `main.aux` \newlabel (priority 1): def:edf 1.1, lem:steps 2.1, prop:gc 2.2, thm:ks 2.3. Lemma/Proposition/Definition share the theorem counter (per section).

## Numbered results
| ID | PDF no. | Kind | Label | Statement | Proof | depends_on | External citations |
|---|---|---|---|---|---|---|---|
| L01 | 2.1 | Lemma | lem:steps | main.tex:35-38 | main.tex:40-43 | none | none |
| P01 | 2.2 | Proposition | prop:gc | main.tex:45-47 | main.tex:49-51 | none | none cited; proof is the one-line "This is the Glivenko--Cantelli theorem" (no \cite) |
| T01 | 2.3 | Theorem | thm:ks | main.tex:53-58 | main.tex:60-63 | none | Donsker \cite{donsker} (bib l.66-69, no theorem number); Kolmogorov \cite{kolmogorov} (bib l.70-73, no theorem number) |

Totals: 3 numbered results (1 lemma, 1 proposition, 1 theorem). Dependency levels: 1 (all independent).

## Verbatim statements
**L01 (Lemma 2.1).** For every $x \in \mathbb{R}^n$, $F_n$ is nondecreasing, and $n F_n(t) \in \{0, 1, \dots, n\}$ for every $t \in \mathbb{R}$.

**P01 (Proposition 2.2).** If $X_1, X_2, \dots$ are independent and identically distributed, then $D_n \to 0$ almost surely.

**T01 (Theorem 2.3).** If $X_1, X_2, \dots$ are independent and identically distributed with a continuous distribution function $F$, then $\sqrt{n}\, D_n$ converges in distribution to $\sup_{0 \le u \le 1} \lvert B(u) \rvert$, where $B$ is a Brownian bridge on $[0, 1]$. The limit has the distribution function $K(z) = 1 - 2 \sum_{k \ge 1} (-1)^{k-1} e^{-2 k^2 z^2}$ for $z > 0$.

## Shared definitions (not counted as results)
| ID | Object | Lines | Used by |
|---|---|---|---|
| D01 | Definition 1.1, empirical distribution function F_n(t) = (1/n)#{i : x_i <= t} | main.tex:24-27 | L01, P01, T01 |
| D02 | Convention: F_n is the EDF of (X_1,...,X_n) for random variables | main.tex:29-30 | P01, T01 |
| D03 | D_n = sup_t abs(F_n(t) - F(t)), F the distribution function of X_1 | main.tex:30-31 | P01, T01 |

Brownian bridge and the function K are used in T01 but not defined separately (see ambiguities).

## Global conventions
No constants. Samples are real-valued. Distribution function F(t) = P(X_1 <= t) presumed (not stated).

## Candidate external inputs
| Name | Source | Type | Users |
|---|---|---|---|
| Glivenko--Cantelli theorem | main.tex:50 (named, no \cite, no reference) | (i)/(ii): cited by name only, no bibliography entry | P01 (entire proof) |
| Donsker invariance principle for the empirical process | main.tex:61, \cite{donsker} (no theorem number) | (i) | T01 |
| Continuous mapping: sup is a continuous functional (on C[0,1] or D[0,1]) | main.tex:61-62 | (ii) asserted without proof; | T01 |
| Reduction from general continuous F to uniform samples (F(X_i) uniform, D_n distribution-free) | never stated; needed to apply Donsker to D_n | (iii) silently used | T01 |
| Kolmogorov's distribution formula K(z) for sup of Brownian bridge | main.tex:62, \cite{kolmogorov} (no theorem number) | (i) | T01 |
| Identification of sup_t abs(F_n(F^{-1}(u)) - u) with sup over u in [0,1] of the uniform empirical process, supremum measurability | never stated | (iii) | T01 |
| Brownian bridge existence/definition, Skorokhod/D-space topology for weak convergence | not stated | (iii)/(v) | T01 |

## Unnumbered claims
None with proof or computation. (Statement "K(z)=..." inside T01 is part of T01. Abstract only summarizes.)

## Notational ambiguities (recorded only)
| Item | Ambiguity |
|---|---|
| F | "distribution function of X_1" not defined as P(X_1<=t) explicitly |
| B | Brownian bridge not defined |
| K(z) | Defined only for z>0; for z<=0 unspecified; also is K the cdf of the sup |
| F_n | Used both for deterministic x in R^n (Def 1.1) and for the random version (main.tex:29), with n varying; random F_n is a random function, measurability of D_n not discussed |
| L01 | Statement "for every x in R^n" implicitly n>=1 |
| Lemma/Prop/Theorem | Share a single counter (2.1, 2.2, 2.3) |
