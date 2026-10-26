# Inventory of the source manuscript

(pv-architect, /pv-setup. All line numbers refer to `source/SuperParetoPaper-v12.tex` = "F" below.)

**Revision 1 note (2026-10-13):** "F:" numbers below are baseline (v1) numbers; for lines >= 258 subtract 23 to get current numbers (RESULTS.json is already updated). T02 proof is now F:190-234. Previous manuscript: verification/source_baseline_v1/.

## 1. Files read

- `source/SuperParetoPaper-v12.tex` (463 lines; self-contained: no `\input`, `\include`, `\subfile`; macros are in the preamble, lines 8-37).
- `source/SuperParetoPaper-v12.bbl` (bibliography keys only: ineq-order2024 = Arab, Lando, Oliveira 2024; superPareto2024 = Chen, Embrechts, Wang 2024; ChenShneer2024 = Chen and Shneer 2024; lando2023nonparametric; marshall2007; Muller2024 = Mueller 2024; pomatto; shaked2007).
- `source/SuperParetoPaper-v12.pdf` pages 3-7 (viewed). `biblio-peo.bib` exists, not needed.
- No `.aux` file exists.

## 2. Numbering sources

- Priority 1 (`.aux`): not available.
- Priority 2 (PDF): pages 3-7 viewed; confirmed Def 2.1, Def 2.2, Lemma 2.3, Ex 2.4, Prop 2.5, Ex 2.6, Ex 2.7, Thm 2.8, Thm 3.1, Prop 3.2, Prop 3.3, Def 4.1, Thm 4.2, Prop 4.3. (`pdftotext` is not permitted in this environment.)
- Priority 3 (inference): all theorem-like environments share ONE counter, `theorem`, reset per section (preamble lines 8-15: proposition, definition, corollary, application, lemma, remark, example all `[theorem]`). Numbers from Prop 4.6 on are inferred from this counter (consistent with every confirmed number). Order in sec 4: Def 4.1, Thm 4.2, Prop 4.3, Def 4.4 (classes), Def 4.5 (order2), Prop 4.6, Ex 4.7, Thm 4.8, Def 4.9 (superheavy), Lem 4.10, Thm 4.11 (ChenShneer), Thm 4.12, Ex 4.13, Def 4.14, Thm 4.15 (Mueller), Ex 4.16. Sec 5: Def 5.1, Prop 5.2, Prop 5.3.
- Note: the PDF prints the key `superPareto2024` as "Chen et al. (2024)" (Chen, Embrechts, Wang) and `ineq-order2024` as "Arab et al. (2024)".

## 3. Numbered results (registered: 12)

Registered: 4 Theorems (T01-T04), 6 Propositions (P01-P06), 2 Lemmas (L01, L02). Dependency levels: 3 (level 0: L01, P01, P02, P04, L02, T04, P05, P06; level 1: T01, T02; level 2: P03, T03).

Not registered as results (cited, quoted without proof, listed as external inputs X01-X03 instead): Thm 4.2 (adapted Thm 1 of superPareto2024), Prop 4.3 (= Prop 1 of superPareto2024), Thm 4.11 (adapted Thm 1 of ChenShneer2024), Thm 4.15 (Thm 2.10 of Muller2024). Definitions (2.1, 2.2, 4.1, 4.4, 4.5, 4.9, 4.14, 5.1) and Examples (2.4, 2.6, 2.7, 4.7, 4.13, 4.16) are not counted as results; Examples with computations are in section 7.

| ID | PDF no. | Kind | Label | Statement | Proof | depends_on (numbered, actually cited) | External citations / "standard" claims |
|---|---|---|---|---|---|---|---|
| L01 | 2.3 | Lemma | lem:ITS-carac | F:128-135 | F:136-138 | - (uses Def 2.2, Lemma-level only) | none |
| P01 | 2.5 | Prop | prop:ITS-dens | F:148-151 | F:152-154 | - | "concavity implies subadditivity for nonnegative functions" (F:147, well known); "easily seen to be negative" (F:153) |
| T01 | 2.8 | Thm | thm:inclusion | F:169-172 | F:173-181 | L01 (F:180), eq (2) | Lemma 4.1 of ineq-order2024 (F:174) |
| T02 | 3.1 | Thm | thm:main | F:186-189 | F:190-257 | eq (2) (F:201, F:256) = L01 direction; (1) | "easily seen" (F:191), "follows easily" (F:195), Figures 1, 2 |
| P02 | 3.2 | Prop | prop:inf-mean | F:261-264 | F:265-267 | (1) | Jensen's inequality (F:266); mentions Prop 2 of superPareto2024 (F:260) as an alternative |
| P03 | 3.3 | Prop | prop:mean-fsub | F:270-273 | F:269 ("immediate") | T02, P02 | none |
| P04 | 4.6 | Prop | prop:conv | F:315-318 | F:319-321 | Prop 4.3 (via "or, equivalently, super-Pareto"; external X01), Def 4.4, Def 4.5 | "the result follows immediately" |
| T03 | 4.8 | Thm | cor:inclusion | F:332-335 | F:336-338 | T01, Prop 4.3 (external X01) | "shift invariance of the convex transform order"; "straightforward to verify that Y is InvSub" |
| L02 | 4.10 | Lemma | lem:inv-NWU | F:359-366 | none ("straightforward", F:358) | - | none |
| T04 | 4.12 | Thm | thm:inv-nwu-fsub | F:376-379 | F:380-386 | Def 4.9; remark F:356 | "as the exponential is superadditive" |
| P05 | 5.2 | Prop | cor:invNWU | F:429-432 | F:433-436 | Def 5.1, Def 4.9 | none |
| P06 | 5.3 | Prop | cor:fsub | F:440-443 | F:444-446 | Def 5.1, Def 2.2 | none |

Remark: the text after P05/P06 (F:448) claims T04 has an alternative proof via transitivity of <=_{i-sb} and H <=_{i-sb} P; these are never proved (see H16).

## 4. Verbatim statements

**L01 (Lemma 2.3, F:128-135).**
A random variable $X$ is \ITS\ if and only if
\begin{equation}
\label{eq:sub-1x}
F_X(\tfrac{x}{\theta})+F_X(\tfrac{x}{1-\theta})\leq F_X(x)+1,\quad \forall x\geq0,\, \theta\in(0,1).
\end{equation}

**P01 (Proposition 2.5, F:148-151).**
Assume the nonnegative random variable $X$ has density $f_X$ such that its hazard rate $r_X(x)=\frac{f_X(x)}{\Fbar_X(x)}\leq\frac1x$, for $x>0$. Then $X$ is \ITS.

**T01 (Theorem 2.8, F:169-172).**
Let $X$ be \ITS\ and $h$ a continuous star-shaped function. Then $h(X)$ is \ITS.

**T02 (Theorem 3.1, F:186-189).**
If $X$ is \ITS, then the stochastic dominance (\ref{eq:main-st}) holds.
(where (1) = F:96-99: `X\leqst \theta_1 X_1+\cdots+\theta_n X_n.` for $n$ i.i.d. copies of $X$ and weights $\theta_i\geq0$, $\sum\theta_i=1$, F:95.)

**P02 (Proposition 3.2, F:261-264).**
Let $X_1,\ldots,X_n$ be independent random variables such that $\Prob(X_1=\cdots=X_n)<1$, and $\theta_1,\ldots,\theta_n>0$ such that $\theta_1+\cdots+\theta_n=1$. If (\ref{eq:main-st}) holds, then $X$ has infinite mean.

**P03 (Proposition 3.3, F:270-273).**
If $X$ is \ITS, then $\Mexp X$ is infinite.

**P04 (Proposition 4.6, F:315-318).**
$F_X$ is \DOR\ (or, equivalently, $X$ is super-Pareto) if and only if $\mathcal{P}\leqc F_X$. Analogously $F_X$ has increasing odds rate if and only if $F_X\leqc\mathcal{P}$.

**T03 (Theorem 4.8, F:332-335).**
If $X$ is nonnegative super-Pareto then $X$ is \ITS.

**L02 (Lemma 4.10, F:359-366).**
A random variable $X$ is super-heavy-tailed if and only if
\begin{equation}
\label{eq:inv-NWU}
F_X(\tfrac{x}{\theta})F_X(\tfrac{x}{1-\theta})\leq F_X(x),\quad\forall x\geq0,\,\theta\in(0,1).
\end{equation}

**T04 (Theorem 4.12, F:376-379).**
If $X$ is super-heavy-tailed, then $X$ is \ITS.

**P05 (Proposition 5.2, F:429-432).**
A random variable $X$ is super-heavy-tailed if and only if $F_X\leq_{i-sb}\mathcal{H}$.

**P06 (Proposition 5.3, F:440-443).**
A random variable $X$ such that $F_X(0)=0$ is \ITS\ if and only if\linebreak $F_X\leq_{i-sb}\mathcal{P}$.

## 5. Shared definitions (listed separately, not counted as results)

| ID | Object | Lines | Notes |
|---|---|---|---|
| D01 | increasing/decreasing = non-decreasing/non-increasing | F:111 | |
| D02 | generalised inverse $v^{-1}(u)=\sup\{x\in\mathbb R: v(x)\le u\}$ | F:111 | used for h^{-1}, H^{-1}, P^{-1}, F_2^{-1} |
| D03 | subadditive / superadditive | F:111 | for all x,y in the domain |
| D04 | star-shaped ($v(0)=0$, $v(x)/x$ increasing) / anti-star-shaped | F:111 | on $[0,\infty)$ |
| D05 | $F_X$, $\Fbar_X=1-F_X$ | F:113 | |
| D06 | $F_X^-(x)=\Prob(X<x)$ | F:113 | |
| D07 | odds function $\Lambda_X=F_X/\Fbar_X$ | F:113 | |
| D08 | Def 2.1 stochastic dominance | F:115-118 | |
| D09 | inverted distribution $F^-_{1/X}(x)=1-F_X(1/x)$ | F:121 | |
| D10 | Def 2.2 InvSub (requires $F_X(0)=0$) | F:122-125 | |
| D11 | dominance relation (1) | F:95-99 | |
| D12 | Pareto(1) cdf $\mathcal P(x)=1-1/x$, $x\ge1$ | F:279 | |
| D13 | Cauchy cdf $\mathcal C$ | F:279 | |
| D14 | Frechet(1) cdf $\mathcal H(x)=e^{-1/x}$, $x>0$ | F:142 | |
| D15 | Def 4.1 super-Pareto | F:284-287 | |
| D16 | Def 4.4 DOR (concave odds function) | F:304-307 | |
| D17 | Def 4.5 convex transform order | F:308-311 | |
| D18 | Def 4.9(1) super-heavy-tailed | F:344-349 | |
| D19 | Def 4.9(2) NWU | F:351 | |
| D20 | Def 4.14 super-Cauchy | F:399-402 | |
| D21 | Def 5.1 inverted-subadditive order | F:422-425 | |
| D22 | hazard rate $r_X=f_X/\Fbar_X$ | F:150 | |
| D23 | odds rate $\lambda_X=\Lambda_X'$ | F:301 | |
| D24 | setting of (1): i.i.d. copies, weights | F:95 | |

Super-Frechet is used (F:105, F:409) but never defined in the paper.

## 6. Global conventions

- "increasing/decreasing" mean non-strict (F:111).
- Random variables and cdfs are identified (F:119); orders depend only on cdfs.
- No density is assumed in general (F:113).
- No constants C appear. Example 2.7 uses distributions on $(0,+\infty]$ (mass at $+\infty$), which departs from real-valued random variables.
- Abstract-level claims in the introduction (F:92-107) are narrative and not proved there.

## 7. Candidate external inputs

| Name | Source location | Prelim. type | Users |
|---|---|---|---|
| X01 Prop 1 of superPareto2024: super-Pareto iff $1/\Fbar_X$ concave (= Prop 4.3) | F:296-299 | (i) | T03 (F:337), P04 (F:317, "equivalently") |
| X02 Lemma 4.1 of ineq-order2024: inverse of star-shaped is anti-star-shaped | F:174 | (i) | T01 |
| X03 Thm 1 superPareto2024 (Thm 4.2), Thm 1 ChenShneer2024 (Thm 4.11), Thm 2.10 and 2.14 Mueller2024 (Thm 4.15, F:412) | F:290, 370, 407, 412 | (i) | no numbered proof uses them (comparison only; Thm 2.14 in H13) |
| X04 concave/anti-star-shaped nonnegative function vanishing at 0 is subadditive | F:147, 153 | (v) | P01 |
| X05 conditioning + independence + Stieltjes integral formula for $\Prob(\theta X_1+(1-\theta)X_2>x)$ (Fubini) | F:191-194, 223-224 | (v) | T02 |
| X06 stochastic dominance + equal finite means imply equal distribution | F:266 | (v) | P02 |
| X07 strict Jensen for the strictly concave $\sqrt{\cdot}$ | F:266 | (v) | P02 |
| X08 $e^{a+b}\ge e^a+e^b-1$ for $a,b\le0$ ("exponential is superadditive", F:383) | F:383 | (v) | T04 |
| X09 reduction of general $n$ to $n=2$ ("It is enough to prove the case n=2"), never justified | F:266 | (iii) | P02 |
| X10 T02: the displayed identities mix $>$ and $\ge$ (F:222: $\Prob(X_n\ge x/\theta_n)+\Prob(\ldots\ge x, X_n\le x/\theta_n)$ for $\Prob(\ldots>x)$); in presence of atoms they do not obviously agree; also uses $F_X(0)=0$ (no mass at 0) for measure of $[0,x]$ equals $F_X(x)$; zero weights $\theta_i=0$ (allowed in (1), F:95) not treated; $n=1$ trivial | F:191-256 | (iii) | T02 |
| X11 T01: $F_{h(X)}(x)=F_X(h^{-1}(x))$ for continuous star-shaped $h$ with generalised inverse (flat parts); and that $F_{h(X)}(0)=0$ (needed by Def 2.2; star-shaped $h$ may vanish on $[0,a]$) | F:174 | (iii) | T01 |
| X12 T03: $h(0)=0$ asserted from nonnegativity of $X$ ("$h$ increasing convex and $h(0)=0$"); a nonnegative super-Pareto (e.g. Pareto itself, $h(y)=y+1$) may have $h(0)>0$; also "shift invariance" of $\le_c$ and "$Y$ is InvSub straightforward" unproved | F:337 | (iii) | T03 |
| X13 P04: proof computes $\mathcal P^{-1}\circ F_X=\Lambda_X+1$, which is the transform for $F_X\le_c\mathcal P$ by Def 4.5; the statement $\mathcal P\le_c F_X$ needs $F_X^{-1}\circ\mathcal P$ convex, i.e. passage from concavity of $\mathcal P^{-1}\circ F_X$ to convexity of its inverse (unstated; generalised inverse, supports) | F:310, 320 | (iii) | P04 |
| X14 P03: hypothesis $\Prob(X_1=\cdots=X_n)<1$ of P02 is not checked for InvSub $X$ (non-degeneracy), nonnegativity of $X$ (needed for $\sqrt{\cdot}$ in P02 and "infinite mean") and extended-valued $X$ (Ex 2.7) not addressed | F:269-273 | (iii) | P03, P02 |
| X15 P02 statement: $X_i$ only "independent" (not identically distributed), $X$ undefined in the statement; proof assumes iid copies, nonnegative | F:261-266 | (iii) | P02 |
| X16 L01 statement omits $F_X(0)=0$ required by Def 2.2; (2) at $x=0$ gives no information; reading of "$\forall x\ge0$" with $1/x$; equivalence of subadditivity in $t=1/x$ with (2) requires change of variables $s=\theta/x$, $t=(1-\theta)/x$ (not written) | F:122-137 | (iii) | L01, T01, T02, P06 |
| X17 P05/P06: Def 5.1 uses $F_1^-(1/x)=\Prob(X<1/x)$ but proofs use $F_X(1/x)$ (and $1-F_X(1/x)$); the generalised inverse formulas $\mathcal H^{-1}(p)=-1/\Log p$, $\mathcal P^{-1}(p)=1/(1-p)$ (including $p=0,1$ and range of $\mathcal P$ off $[1,\infty)$) are not derived | F:424, 434, 445 | (iii) | P05, P06 |
| X18 P01: a.e. derivative sign and monotonicity of $x\mapsto\frac1x(1-F_X(1/x))$ (absolute continuity of $F_X$ from the density); vanishing at 0 means $F_X(\infty)=1$ | F:153 | (iii) | P01 |
| X19 T04: definition-level equivalence "$\Log(1-F^-_{1/X}(x))=\Log F_X(1/x)$" and domain where $F_X(1/x)=0$ ($\Log 0$) | F:381 | (iii) | T04 |

No candidate of type (ii) or (iv) was identified.

## 8. Unnumbered claims (H)

| ID | Location | Claim |
|---|---|---|
| H01 | F:140-145 (Ex 2.4) | Frechet(1) is InvSub via $1+\mathcal H(x)-\mathcal H(x/\theta)-\mathcal H(x/(1-\theta))=(1-e^{-\theta/x})(1-e^{-(1-\theta)/x})$; $\mathbb E X=\infty$; odds function convex |
| H02 | F:157-160 (Ex 2.6) | $Y_b$ with $\Fbar_b=1/(1+x^b\Log(x+1))$ satisfies hazard-rate hypothesis of P01 for $b\le0.7$ ("easily seen"); odds function neither concave nor convex ("can be checked") |
| H03 | F:163-166 (Ex 2.7) | $F_X=(1-p)^{\lceil 1/x\rceil}$ is InvSub (geometric cdf subadditive, "can be seen"), $\mathbb E X=+\infty$ |
| H04 | F:101-102 | if $\mathbb EX<\infty$, (1) holds iff exactly one coefficient positive (convex-order argument, text only) |
| H05 | F:260 | finite mean implies convex order $\mathbb E\phi(\sum\theta_iX_i)\le\mathbb E\phi(X)$ ("follows by using repeatedly the definition of convexity") |
| H06 | F:279 | $\mathcal P$ is InvSub ("straightforward"); Cauchy $T$ is not InvSub but $|T|$ is InvSub ("can be verified") |
| H07 | F:301 | concavity of $\Lambda_X$ implies a.e. differentiability of $F_X$ and equals decreasing odds rate |
| H08 | F:323 | $\mathcal H\le_c\mathcal P$ (Lambda_H convex) so Frechet is not super-Pareto; $\mathcal H\le_c\mathcal P\le_c F_X$ for super-Pareto $X$ by transitivity |
| H09 | F:326-329 (Ex 4.7) | restates Ex 2.6: $Y_b$ not DOR but InvSub for small $b$ |
| H10 | F:354 | NWU iff $\Log\Fbar_X$ superadditive (shaked2007) |
| H11 | F:356 | continuous case: super-heavy-tailed iff $1/X$ is NWU |
| H12 | F:390-393 (Ex 4.13) | $R_a$ with cdf $a^{-1/x}(1+1/(e^{2x}-1))$, $a=0.5$, is InvSub by P01 but violates (eq:inv-NWU) hence not super-heavy-tailed ("can be verified"); note the cdf as written must satisfy cdf properties (not checked) |
| H13 | F:412 | Thm 2.14 of Mueller: $|T|$ is super-Cauchy, $T$ not super-heavy-tailed; $|T|$ InvSub ("easily seen") |
| H14 | F:414-417 (Ex 4.16) | $V(x)=e^{-1/\sqrt x}(1+e^{2x-1})$: $1-V(1/x)$ anti-star-shaped so InvSub; $\mathcal C^{-1}\circ V$ neither concave nor convex so not super-Cauchy (also $V$ as written exceeds 1 for large $x$: not checked here) |
| H15 | F:426 | $\le_{i-sb}$ is not shift-invariant; rules out distributions whose support strictly contains the origin |
| H16 | F:448 | alternative proof of T04 by transitivity of $\le_{i-sb}$ and $\mathcal H\le_{i-sb}\mathcal P$ (neither transitivity nor $\mathcal H\le_{i-sb}\mathcal P$ proved) |
| H17 | F:450 | Frechet benchmark yields larger class for $\le_c$ and smaller for $\le_{i-sb}$ |
| H18 | F:105-107 | inclusion/non-inclusion relations among the classes (summary of sec 4) |

## 9. Notational ambiguities (recorded only)

| # | Location | Ambiguity |
|---|---|---|
| A1 | F:113 vs F:121 vs F:424 | $F^-$ means $\Prob(X<x)$ (F:113), but $F^-_{1/X}(x)=1-F_X(1/x)$ (F:121, valid as $\Prob(1/X<x)$) while in Def 5.1 $F_1^-(1/x)$ is $\Prob(X<1/x)$; proofs of P05/P06 use $F_X(1/x)$ |
| A2 | F:122-125, F:128-135 | Def 2.2 requires $F_X(0)=0$; Lemma 2.3 and (2) omit it |
| A3 | F:133, F:364 | "$\forall x\ge0$" while $1/x$-type quantities are used; at $x=0$ $F_X(0/\theta)$ |
| A4 | F:263 | in P02 "$X$" is not defined (only $X_1,\dots,X_n$ independent, not iid); $\theta_i>0$ vs $\theta_i\ge0$ in (1) at F:95 |
| A5 | F:222 | $\Prob(\cdot>x)$ versus $\ge$ in the induction display |
| A6 | F:171 | "continuous star-shaped function $h$": domain $[0,\infty)$ only through D04; $h^{-1}$ generalised (D02), not a true inverse |
| A7 | F:284, F:296 | super-Pareto defined with $h$ increasing convex nonconstant, no condition on $h(0)$; T03 needs $h(0)=0$ |
| A8 | F:315-317 | "$F_X$ is DOR (or, equivalently, X is super-Pareto)": equivalence quoted from Prop 4.3; $\le_c$ direction convention $F_1\le_cF_2$ iff $F_2^{-1}\circ F_1$ convex |
| A9 | F:383 | "the exponential is superadditive" (actual inequality: $e^{a+b}\ge e^a+e^b-1$ for $a,b\le0$) |
| A10 | F:165, F:142 | Ex 2.7 uses a variable on the "completed half line" $(0,+\infty]$; $\mathcal H$ defined for $x>0$ only (values at 0) |
| A11 | F:111, F:279 | $\mathcal P$ defined on $x\ge1$ only; its generalised inverse used for all $p\in[0,1)$ |
| A12 | F:401 | super-Cauchy uses $\mathcal C\le_c F_X$ with $\mathcal C$ on $\mathbb R$; no definition of super-Frechet |
| A13 | F:296, F:23 | PDF prints superPareto2024 as "Chen et al. (2024)"; both the Chen-Embrechts-Wang paper (superPareto2024) and Chen-Shneer (ChenShneer2024) are cited |
