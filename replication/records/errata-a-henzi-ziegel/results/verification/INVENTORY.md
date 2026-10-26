# INVENTORY: Henzi and Ziegel, "Valid sequential inference on probability forecast performance"

## 1. Files read

- `source/VSIFP_02.tex` (654 lines; the main file). It has no `\input`, `\include` or `\subfile`, and no separate macro file (macros are in the preamble, lines 14-41). The appendices (lines 397-651; new numbering after revision 1) are in the same file.
- `source/VSIFP_02.pdf`: pages 5-9 viewed to check the numbering.
- Not read: `VSIFP_02.bbl` and the figure PDFs (no mathematical content for the inventory). There is no `.aux`. The bibliography file `VSIFP_biblio_02` is not in `source/`.

## 2. Numbering sources

The `.aux` does not exist. `pdftotext` is not permitted in this environment. Basis used: (2') visual check of the PDF headings on pp. 5-8 (Theorem 3.1, 3.2, 3.3, Proposition 3.4, Proposition 3.5 confirmed), plus (3) the counters: `lem`, `proposition` and `theorem` share one counter numbered within sections (line 16-19). All five numbers are confirmed against the PDF.

Note: the PDF text refers to Proposition 3.4 as "Lemma 3.4" (OLD manuscript source lines 220, 236, 261, `\ref{prop:combination}` preceded by the word Lemma; in the revised manuscript these are now Proposition: l.214, 230 and 255 say "proposition/Proposition"). It is an environment `proposition`.

## 3. Numbered results

| ID | PDF no. | Kind | Label | Statement | Proof | depends_on | External citations in proof |
|---|---|---|---|---|---|---|---|
| T01 | Theorem 3.1 | Theorem | thm:uniqueness | VSIFP_02.tex:143-148 | 399-416 | none | Gneiting-Raftery 2007 Thm 2.3 mixture representation (line 90, used at 404) |
| T02 | Theorem 3.2 | Theorem | thm:grow | 152-167 | 418-440 | T01 ("All e-values ... are of the form (6)", l.419) | mixture representation (l.435); Gruenwald et al. 2019 Thm 1 only mentioned in a remark (l.169), not in the proof |
| T03 | Theorem 3.3 | Theorem | thm:allscores | 185-193 | 442-444 | none | Gruenwald et al. 2019 Theorem 1, with $W_1$ Dirac at $\pi_1$ (l.443) |
| P04 | Proposition 3.4 | Proposition | prop:combination | 216-221 | 446-469 (new proof for $h>1$ via supermartingales $M^{[k]}$; also the h=1 computation 199-214) | T01 (definition and e-value property of $E_{p,q;\lambda}$) | Vovk 2021 (U-statistics merging, only as motivation, l.214); Ramdas et al. 2020 (l.227, only in a remark) |
| P05 | Proposition 3.5 | Proposition | prop:stopping | 229-234 (revised statement, see note) | 446-469 (proved inside the proof of P04; the old separate proof is commented out at 471-476) | P04 (statement: "under the assumptions of Proposition 3.4"; proof inside P04's proof) | none |

Revision 1 note (line numbers updated by content mapping; the table above and the rest of this file use the NEW numbering of `source/VSIFP_02.tex` unless marked "old"). The statement of P05 is now "Let $\tau\in\mathbb N$ be a stopping time ... $\mathbb E_{\mathbb Q}(e_{\tau+h-1})\le1$"; the verbatim texts below for P05 (and the `where for ...` clause of T02, now moved to l.135-138 before Theorem 3.1) are the OLD manuscript; see `source/VSIFP_02.tex` for the current statement. This update changed line numbers only; it is not a re-inventory.

Totals: 5 numbered results (3 theorems, 2 propositions). Dependency levels: 3 (level 0: T01, T03; level 1: T02, P04; level 2: P05). The graph is acyclic.

Assertions of the kind "easily verified" in proofs: T01 l.400 ("one can easily verify that E has the given null hypothesis"), l.412 ("Similar arguments for the case p>q"); T02 l.424 ("The case p>q is analogous"); T03 l.443 ("A direct computation shows ..."); P04 (old l.470 "Follows as in the case h=1", old manuscript; the new proof l.446-469 is a different argument).

### Verbatim statements

**T01 (Theorem 3.1, l.143-148)**
```
Let $\myS$ be a consistent scoring function and $p, q \in (0,1)$, $p \neq q$. Assume that the mixing measure $\nu$ of $\myS$ satisfies $\nu\big\{[\min(p,q), \max(p,q))\big\} > 0$. Then a function $E = E(y)$ is an e-value with null hypothesis $H_{\myS}$ and alternative $[0,1] \setminus H_{\myS}$, if and only if for some $\lambda \in (0,1]$,
\begin{equation} \label{eq:representation}
	E(y) = E_{p,q; \lambda}(y) = 1 + \lambda \frac{\myS(p, y) - \myS(q, y)}{|\myS(p, \one\{p > q\}) - \myS(q, \one\{p > q\})|}.
\end{equation}
```

**T02 (Theorem 3.2, l.152-167; verbatim text below is the old manuscript, which still had the `where for ...` kappa clause at old l.167-171)**
```
Under the assumptions of Theorem \ref{thm:uniqueness}, for any $\pi_1 \not\in H_{\myS}$, $\mathbb{E}_{\pi_1}\{\log(E_{p,q;\lambda})\}$ is maximal in $\lambda$ if and only if
\[
	\lambda = \begin{dcases}
	(1-\pi_1) + \pi_1 \frac{\myS(p, 1) - \myS(q, 1)}{\myS(p, 0) - \myS(q, 0)}, & \ p > q, \\
	\pi_1 + (1-\pi_1) \frac{\myS(p, 0) - \myS(q, 0)}{\myS(p, 1) - \myS(q, 1)}, & \ p < q.
	\end{dcases}
\]
The corresponding e-value equals
\[
	E_{p,q}^{\pi_1}(y) = \begin{dcases}
		\frac{1 - \pi_1}{1 - \kappa_{\nu}\{[\min(p,q),\max(p,q))\}}, & \ y = 0, \\
		\frac{\pi_1}{\kappa_{\nu}\{[\min(p,q),\max(p,q))\big\}}, & \ y = 1,
	\end{dcases}
\]
where for $0 \leq a < b \leq 1$,
\[
	\kappa_{\nu}\{[a,b)\} = \frac{\int_{[a,b)} \theta \, d\nu(\theta)}{\nu\{[a,b)\}}.
\]
```

**T03 (Theorem 3.3, l.185-193)**
```
Let $p,q \in (0,1)$. Then the GROW e-value with null hypothesis $H$ and alternative hypothesis that $Y = 1$ with probability $\pi_1 \not\in H$ is given by
\[
	E^{\pi_1*}_{p,q}(y) = \begin{dcases}
		 (1-\pi_1)/(1-p), & \ y = 0,\\
		 \pi_1/p, & \ y = 1.\\
	\end{dcases}
\]
```

**P04 (Proposition 3.4, l.216-221)**
```
Let $(Y_t, c_t, p_t, q_t, \lambda_t) \in \{0, 1\}^2 \times (0,1)^2 \times [0,1]$ be defined on a measurable space $(\Omega, \mathcal{F})$ and adapted to the filtration $\mathcal{F}_t$, $t \in \mathbb{N}$, and assume $\lambda_t = 0$ if $c_t = 0$. Let further $\myS$ be a strictly consistent scoring function. Then for all $T \geq h + 1$, with $I_k = \{k + hs: \, s = 0, \dots, \lfloor (T-k)/h\rfloor - 1\}$, \[
	e_T = \frac{1}{h}\sum_{k = 1}^{h} \prod_{l \in I_k}E_{p_l, q_l; \lambda_l}(Y_{l + h})
\]
are $\mathcal{F}_T$-measurable and are e-values under $\mathcal{H}_{\myS; c}$.
```

**P05 (Proposition 3.5, now l.229-234; verbatim text below is the OLD statement, old l.235-240)**
```
Let $\tau \in \mathbb{N}$ be a almost surely finite stopping time. Then under the assumptions of Lemma \ref{prop:combination},
\[
	\mathbb{E}_{\mathbb{Q}}(e_{\tau}) \leq 1, \ \mathbb{Q} \in \mathcal{H}_{\myS}.
\]
```

## 4. Shared definitions and assumptions (not counted as results)

The paper has no numbered Definition or Assumption environments. Line ranges refer to `source/VSIFP_02.tex`.

| ID | Object | Lines | Label |
|---|---|---|---|
| D01 | scoring function $\myS$ and consistency (inequality (1)) | 69-73 | eq:scoring |
| D02 | strict consistency | 73 (characterization via $\nu$ at 103) | |
| D03 | mixture representation, mixing measure $\nu$ | 90-94 | eq:mixture |
| D04 | elementary score $\myS_\theta$ | 95-102 | eq:elementary |
| D05 | expectation notation $\mathbb{E}_{\mathbb Q}$, $\mathbb{E}_\pi$ | 88-88 | |
| D06 | sequential setting (filtration, adapted $(Y_t,p_t,q_t)$, lag $h$) | 108-108 | |
| D07 | conditional forecast dominance | 110-110 | |
| D08 | hypothesis $\mathcal H_{\myS;c}$ (and $\mathcal H_{\myS}$ when $c\equiv1$) | 113-115, 119 | eq:h0s |
| D09 | hypothesis $\mathcal H_c$ (and $\mathcal H$) | 116-118 | eq:h0 |
| D10 | condition sequence $(c_t)$, $\mathcal F_t$-measurable, values in $\{0,1\}$ | 119-119 | |
| D11 | one-period hypothesis $H_{\myS}$ | 132-132 | |
| D12 | one-period hypothesis $H$ | 133-133 | |
| D13 | e-value; null hypothesis and alternative of an e-value | 77-77, 141-141 | |
| D14 | $E_{p,q;\lambda}$ (and extension to $\lambda=0$) | 145-147, 205-205 | eq:representation |
| D15 | GROW (growth-rate optimal) e-value | 150-150 | |
| D16 | $\kappa_\nu$ (now defined in the text before Theorem 3.1, for $0<a<b<1$) | 135-138 | |
| D17 | $E^{\pi_1}_{p,q}$ | 161-166 | |
| D18 | $E^{\pi_1*}_{p,q}$ | 188-192 | |
| D19 | $I_k$ and $e_T$ (inside P04; also appendix 486-488 with $I_k(T)$) | 217-219 | |
| D20 | stopping time $\tau_\alpha$ | 239-241 | (label eq:taualpha no longer present) |
| D21 | stopping time $\tau_{\alpha,h}$ | 243-245 | |
| D22 | $d_{p,q}$ and $f(\pi)$ (proof-local) | 400-403 | eq:expscore |

Not a shared definition: the Brier, logarithmic and spherical scores of Table 1 (lines 171-181), used only in examples.

## 5. Global conventions

- $\mathbb{N}$ time index; forecasts $p_t,q_t$ at time $t$ are for $Y_{t+h}$ with integer lag $h\ge1$ (l.108).
- One-period setting: $p,q\in(0,1)$ fixed numbers (l.130). Sequential setting: $p_t,q_t\in(0,1)$ random, $\mathcal F_t$-measurable (P04).
- Scores: smaller is better. $\nu$ is "a locally finite Borel measure on $(0,1)$" (l.94); after revision 1 the integral is also written over $(0,1)$ (l.92), so this ambiguity is notation-resolved in the new manuscript (old l.95-97).
- The constant/parameter dependence conventions: none stated (no constant $C$).
- $\mathcal P$ = set of probability measures on $(\Omega,\mathcal F)$ (l.112). $\mathbb Q$ and $\mathbb P$ are both used for measures of the hypotheses.
- Section 3.2 is the text of the proof for the case $h=1$ (l.199-214), placed before P04.

## 6. Candidate external inputs

| ID | Name | Source location | Provisional type | Users |
|---|---|---|---|---|
| X01 | Integral (mixture) representation of consistent scoring functions (Gneiting and Raftery 2007, Thm 2.3; Schervish 1989), "under mild regularity conditions" | l.90-94 | (i) | T01 (l.404), T02 (l.435) |
| X02 | $\myS$ strictly consistent iff $\nu$ charges all non-degenerate intervals; needed to get $\nu\{[\min,\max)\}>0$ in P04 | l.103 (no citation given for this sentence) | (ii) | P04 |
| X03 | Gruenwald et al. 2019, Theorem 1 (GROW is the likelihood ratio with Dirac prior $W_1$) | l.183, 443 | (i) | T03 |
| X04 | Conditional use of T01: for random $(p_t,q_t,\lambda_t)$, $\mathbb E_{\mathbb Q}\{E_{p_t,q_t;\lambda_t}(Y_{t+h})\mid\mathcal F_t\}\le 1$ on $\mathcal H_{\myS;c}$; i.e. T01 for fixed numbers applied pointwise with $\pi_t=\mathbb Q(Y_{t+h}=1\mid\mathcal F_t)$, together with the case $c_t=0$. Stated only in the $h=1$ sketch (l.207-209) and never as a lemma | l.199-214 (old l.205-220, 470; the new P04 proof l.446-469 states "$M^{[k]}$ is a nonnegative supermartingale ... for any $\mathbb Q\in\mathcal H_{\myS}$" without justification) | (iii) | P04 |
| X05 | $\mathbb E(e_t\mid\mathcal F_t)\le 1$ a.s. for the $e_t$ of P04. P04 states only that $e_T$ is $\mathcal F_T$-measurable and an e-value (unconditional expectation $\le1$); the conditional bound is never stated | old manuscript l.474, 476 (the old P05 proof is now commented out at l.471-476; the new P05 is proved inside the P04 proof, l.446-469) | (iii) | P05 |
| X06 | Details in T02: uniqueness of the maximizer (strict concavity of $g$), $\lambda_0\in(0,1)$ and the equivalence "$1/\kappa>1/\pi_1$" iff $\pi_1\notin H_\myS$, both stated as consequences; the case $p>q$ | l.424-439 | (iii) | T02 |
| X07 | Standard measure-theory facts: tower property and pulling out measurable factors for nonnegative bounded variables; linearity (average of e-values is an e-value); iterating the one-step bound | l.202-214, 446-469 | (v) | P04, P05 |
| X08 | Claims asserted without proof: "one can easily verify that E has the given null hypothesis" (T01), "$H=[0,p]$ ... direct computation" (T03), "Similar arguments for $p>q$" | l.400, 412, 443 | (ii) | T01, T03 |
| X09 | U-statistic merging (Vovk and Wang 2020) as the model for the averaged $e_T$ for $h>1$ | l.214 | (i) | P04 (motivation only) |

Type (iii) count: 3 (X04, X05, X06).

## 7. Unnumbered claims

| ID | Claim | Location | Note |
|---|---|---|---|
| H01 | $h=1$ derivation: product of $E_{p_t,q_t;\lambda_t}(Y_{t+1})$ is an e-value for $\mathcal H_{\myS;c}$ (conditioning at $T$, then iterating) | l.199-214 | main text computation; used as the proof route of P04 |
| H02 | $H=[0,p]$ if $p<q$, $H=[p,1]$ if $p>q$ ("easily verify") | l.195 (also l.139) | also used in T03 proof (l.443) |
| H03 | Table 1: $\kappa_\nu$ values for Brier, logarithmic, spherical scores | l.171-181 | computation not shown |
| H04 | Remarks after T03: $H_\myS$ is rejected if $\pi$ is above (below) $\kappa_\nu$ | l.195 (old l.201; this remark text was rewritten in revision 1) | |
| H05 | Appendix B: with stopping rule $\tau_{\alpha,h}$, $e_{t+h-1}\ge1/\alpha$ no matter what $Y_{t+1},\dots,Y_{t+h-1}$ are (proof with displayed chain) | l.479-494; claimed l.243-246 | has a proof; not numbered |
| H06 | Optional stopping validity remark: stopping at $t_0$ corresponds to $\lambda_t\equiv0$ for $t\ge t_0$; stopped e-value for $h>1$ is random | l.236 | |
| H07 | Anytime-valid p-values $p_{t_0}=\min\{1,\inf_s1/e_s\}$ valid simultaneously (cited to Ramdas et al. 2020, Sec 3.1) | l.246 | external |
| H08 | Sec 4.1: Brier score, $p_t$ outperforms $q_t$ iff $\mu\le0.5$ ($\pi_t=\mu q_t+(1-\mu)p_t$); mixtures $\eta_t(\xi)$ and $e_t=\frac1k\sum e_{t;\xi_j}$ are e-values under $\mathcal H_\myS$ ("Lemma 3.4 implies"; now "Proposition 3.4 implies") | l.255-259 | |
| H09 | Appendix C: construction of $\pi_t$ for spherical and logarithmic scores so that $\mu=0.5$ gives zero score difference | l.510-513 | |
| H10 | Sec 4.2: $q_{t;h}=\pi_{t;h}$ outperforms $p_{t;h}=\pi_{t;h+1}$ (ideal forecasts); Diebold-Mariano valid there | l.278, 288 | |
| H11 | Sec 2.1: $\myS$ strictly consistent iff $\nu$ charges all nondegenerate intervals; Sec 2.2: classical example $p_t=\mathbb P(Y_{t+h}=1\mid\mathcal F_t)$ gives $\mathbb P\in\mathcal H$ | l.103, 121 | |
| H12 | Section 5 case-study numerical claims (evidence statements, percentages 9%, 27%, 85%, Table values) | l.353-362 (approx., old l.357-366) | empirical, no proof |

## 8. Notational ambiguities (recorded only)

| ID | Ambiguity | Location |
|---|---|---|
| A01 | $\nu$ is a measure on $(0,1)$ (l.97) but integrated over $[0,1]$ (l.95); $\sup_\theta$ over $[0,1]$ in D09, D12 where $\myS_0,\myS_1$ degenerate | old l.95-97, 120, 140 (new l.92-94, 117, 133; integral now over $(0,1)$) |
| A02 | "consistent" in T01 vs "strictly consistent" in P04; T01 requires $\nu\{[\min,\max)\}>0$ explicitly, P04 does not state it | l.144, 217 |
| A03 | P04 and P05 referred to as "Lemma 3.4" in the text | old l.220, 236, 261; resolved in revision 1 (now "Proposition", l.214, 230, 255) |
| A04 | $\lambda\in(0,1]$ in T01, $\lambda_t\in[0,1]$ with the extension $E_{p,q;0}\equiv1$ in sections 3.2 and P04; the extension is only informal | l.145, 205, 217 |
| A05 | $h$ denotes the lag and also $d(1)/d(0)$ in the proof of T02 | l.424 |
| A06 | $\mathbb P$ and $\mathbb Q$ both used for measures in hypotheses; $\mathcal H_{\myS;c}$ defined for $\mathbb P$, used with $\mathbb Q$ (revision 1 also writes "for all $\mathbb P\in H$") | l.112-117, 200, 232 |
| A07 | P04 asserts measurability and e-value property for $e_T$ at fixed $T$, while P05 uses $e_t$ with a conditional statement and $e_\tau$ for $\tau\in\mathbb N$ although $e_T$ is defined only for $T\ge h+1$ | old l.223, 236-239, 474 (new P05: stopped value $e_{\tau+h-1}$, l.229-234) |
| A08 | P05 states $\mathbb Q\in\mathcal H_{\myS}$ ($c\equiv1$) while its assumptions refer to P04 with general $c_t$ | l.230-232 |
| A09 | In T02, "maximal in $\lambda$": over $\lambda\in(0,1]$ (T01 family) or $[0,1)$ (proof, l.424) | l.153, 424 |
| A10 | $E_{p,q}^{\pi_1}$ notation (T02) vs $E_{p_t,q_t}^{\eta_t}$ in the text; the two use different superscript symbols for the alternative | l.162, 223 |
| A11 | Section 3.2 is typeset as $\mathbb E_{\mathbb Q}\{E(Y_{t+1})\mid\mathcal F_t\}$, where $Y_{t+1}$ is revealed after $\mathcal F_t$; time convention for $\mathcal F_t$ and $Y_{t+h}$ (observation indexed $t+h$) | l.108, 202 |
