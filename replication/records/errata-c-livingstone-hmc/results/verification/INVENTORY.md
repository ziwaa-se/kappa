# Inventory of the source manuscript

(pv-architect, /pv-setup. Date 2026-10-12.)

Paper: S. Livingstone, M. Betancourt, S. Byrne, M. Girolami, "On the Geometric Ergodicity of Hamiltonian Monte Carlo" (arXiv:1601.08057), version v3.1.

## 0. Scope decision (set by the user, binding)

Only six numbered results are registered in `RESULTS.json` (`run_scope` = these six):

| ID | PDF no. | Label |
|---|---|---|
| T01 | Theorem 2.2 | thm:negative |
| C01 | Corollary 2.3 (part (ii) only checked) | crly:expfam |
| T02 | Theorem 5.14 | thm:light |
| L01 | Lemma 5.15 | lem:xelower |
| L02 | Lemma 5.16 | lem:xlower |
| L03 | Lemma 5.17 | lem:arate_0 |

(IDs are chosen by order of dependency, not by the P/T/L convention of the kit: T = theorem, C = corollary, L = lemma.)

Every other numbered result is OUTSIDE THE SCOPE: it is not registered in `results` and not checked. Where a registered proof uses one, it is listed in section 7 as a candidate external input of provenance (ii) (stated by the paper, not proved here). Corollary 2.3(i) is recorded as "not encoded (outside the scope set by the user)" in the `unencoded` field of C01.

Decisions made unattended (noted for the coordinator):
1. Theorem 2.2 has no proof of its own in the text. Its two parts are evidently Theorem 5.14 (part (i), whose hypotheses (17)-(19) are exactly "lim ||grad U||/||x|| = infinity and (18), (19)") and Theorem 5.18 (part (ii)). The text never says this explicitly (see 7, item X3). `proof_loc` of T01 records those two proofs. T01 depends_on [T02]; Theorem 5.18 is an external input.
2. Corollary 2.3(ii) proof (line 806): "Part (ii) is a direct consequence of Theorem 2.2". So C01 depends_on [T01].
3. Lemma 5.16 depends_on [L01] and Lemma 5.17 depends_on [L02] (the first by the proof's use of the first-step bound, the second by the explicit statement "||x_{L eps}|| >= 2^L ||x_0||"). The first is implicit (type iii flag, X5).
4. Proposition 3.5 (prop:supr, cited from roberts1996geometric) is registered as external input of provenance (ii), as instructed, although it is also a cited literature result (type (i) location noted).

## 1. Files read

Entry file `source/geo_erg_HMC_v3.1.tex` (1323 lines). It contains no `\input`, `\include` or `\subfile`; it is the whole manuscript (macros are in `\startlocaldefs`, lines 39-63). No other `.tex` file exists. Also present (not part of the TeX tree): `source/geo_erg_HMC_v3.1.bbl` (bibliography, not read in detail), `source/geo_erg_HMC_v3.1.pdf` (read pages 4, 5, 6, 19-23 as images). Not read: the supplementary material `\citep{supplement}` (a separate document, not in `source/`).

Theorem environments (lines 48-61): `defn`, `thm`, `prop`, `lem`, `crly`, `ex`, `rem` share ONE counter `defn` that resets at each `\section`; `assn` has its own counter (A) but A1-A3 are written by hand as `\textbf{A1}` etc.

## 2. Numbering sources

No `.aux` file is present. Basis used: (b) PDF headings by direct reading of page images, supported by (c) counter inference. Result:

| Result | PDF number | Basis |
|---|---|---|
| Thm thm:negative | Theorem 2.2 | PDF p.6 heading read; equals counter inference (Sect. 2: Thm 2.1 unlabelled, 2.2, 2.3, 2.4) |
| Crly crly:expfam | Corollary 2.3 | PDF p.6 heading read |
| Thm thm:light | Theorem 5.14 | PDF p.20 heading read; counter inference (Sect. 5: Rem 5.1, 5.2, Thm 5.3, Thm 5.4, Prop 5.5, Crly 5.6, Lem 5.7-5.9, Prop 5.10, 5.11, Rem 5.12, Prop 5.13, Thm 5.14) agrees |
| Lem lem:xelower | Lemma 5.15 | PDF p.21 heading read |
| Lem lem:xlower | Lemma 5.16 | PDF p.21 heading read |
| Lem lem:arate_0 | Lemma 5.17 | PDF p.22 heading read |
| Thm thm:heavy (external) | Theorem 5.18 | PDF p.23 heading read |
| Prop prop:supr (external) | Proposition 3.5 | PDF p.21 cross-reference text "Proposition 3.5"; counter inference (Sect. 3: Thm 3.1, Defn 3.2, Prop 3.3, Crly 3.4, Prop 3.5, Prop 3.6) |

Equation numbers in the PDF (read from PDF p.20-22): (17) = eqn:explode, (18) = eqn:oscillations, (19) = eqn:oscillation2, (20) = the unlabelled display in Lemma 5.15's proof, (21) = eqn:inter21; (13) = eqn:inwards, (16) = eqn:ic2, (3) = eqn:geoerg. UNRESOLVED NUMBERS: none.

## 3. Numbered results in scope (table)

Paths below abbreviate `source/geo_erg_HMC_v3.1.tex` to `TEX`.

| ID | PDF no. | Kind | Label | Statement | Proof | depends_on | External citations / uses |
|---|---|---|---|---|---|---|---|
| L01 | 5.15 | Lemma | lem:xelower | TEX:884-886 | TEX:888-897 | none | implicit: single-step formula of (eqn:mprop) with L=1 (Prop 4.2, external) |
| L02 | 5.16 | Lemma | lem:xlower | TEX:899-901 | TEX:903-935 | L01 (implicit) | Prop 4.2 (external) for the x_{i eps} recursion; uses (18) though the statement lists only (17) |
| L03 | 5.17 | Lemma | lem:arate_0 | TEX:939-944 | TEX:946-971 | L02 | Prop 4.2 (acceptance formula and p_{L eps} (eqn:mprop2), external); (17),(18),(19) |
| T02 | 5.14 | Theorem | thm:light | TEX:863-877 | TEX:879-880 | L01, L02, L03 | Prop 3.5 (prop:supr, = roberts1996geometric, Roberts and Tweedie 1996, cited at TEX:298) |
| T01 | 2.2 | Theorem | thm:negative | TEX:208-219 | no own proof; (i) = T02 (TEX:879-880); (ii) = Thm 5.18 (TEX:986-996) | T02 | Thm 5.18 (thm:heavy, external); via it Prop 3.6 (jarner2003necessary, Jarner and Tweedie 2003, cited at TEX:305) |
| C01 | 2.3 | Corollary | crly:expfam | TEX:229-239 | TEX:804-806 (part (ii)); part (i) TEX:806-853 outside scope | T01 | roberts1996exponential for the class E(beta,alpha) (TEX:223) |

Dependency levels: L01 (0), L02 (1), L03 (2), T02 (3), T01 (4), C01 (5): 6 levels. The graph is acyclic.

Assertions of the "standard / obvious" kind in the proofs: T02 proof: "To conclude we simply note that P(||p_0|| <= ||x_0||^delta) -> 1" (Gaussian tail, standard (v)); "allowing Proposition 3.5 to be envoked". L01: "the last term can be made negligibly small". L02: "An entirely analogous argument can be used to show that ||x_{i eps}|| >= 2 ||x_{(i-1) eps}|| for any fixed i" (induction left to the reader). L03: "The term inside the bracket can be bounded below by some fixed constant gamma_L > 0"; "simply envoking (19) gives the result". C01(ii): "a direct consequence of Theorem 2.2".

## 4. Verbatim statements

### L01 = Lemma 5.15 (TEX:884-886)
```
\begin{lem} \label{lem:xelower}
If (\ref{eqn:explode}) holds then there exists an $\eta<\infty$ such that for all $\|x_0\|>\eta$ and any $\|p_0\|\leq \|x_0\|^\delta$ for some $\delta<1$, it holds that $\|x_\e\|>2\|x_0\|$.
\end{lem}
```

### L02 = Lemma 5.16 (TEX:899-901)
```
\begin{lem} \label{lem:xlower}
If (\ref{eqn:explode}) holds then there exists an $\eta<\infty$ such that for all $\|x_0\|>\eta$ and any $\|p_0\| \leq \|x_0\|^\delta$ for some $\delta < 1$, it holds that  $\|x_{L\e}\| \geq 2^L\|x_0\|$.
\end{lem}
```

### L03 = Lemma 5.17 (TEX:939-944)
```
\begin{lem} \label{lem:arate_0}
If (\ref{eqn:explode}), (\ref{eqn:oscillations}) and (\ref{eqn:oscillation2}) hold then for any $\delta<1$ it holds that
\[
\lim_{\|x_0\|\to\infty,\|p_0\|\leq\|x_0\|^\delta} \alpha(x_0,x_{L\e}) = 0.
\]
\end{lem}
```

### T02 = Theorem 5.14 (TEX:863-877)
```
\begin{thm} \label{thm:light}
If it holds that
\begin{equation} \label{eqn:explode}
\lim_{\|x\| \to \infty}\frac{\|\nabla U(x)\|}{\|x\|} = \infty,
\end{equation}
and that there is a fixed $C <\infty$ such that whenever $\|y\|\geq 2\|x\|\geq C$ then
\begin{equation} \label{eqn:oscillations}
\|\nabla U(y)\| \geq 3\|\nabla U(x)\|,
\end{equation} 
and it also holds that
\begin{equation} \label{eqn:oscillation2}
\lim_{\|x\|\to\infty, \|y\| \geq 2^L\|x\|} \left( U(x) - U(y) - \frac{1}{2}\|x\|^2 \right) = -\infty,
\end{equation}
then the Hamiltonian Monte Carlo method with fixed integration time $T = L\e$ does not produce a geometrically ergodic Markov chain for any choice $T>0$.
\end{thm}
```
Proof (TEX:879-880), verbatim: "Lemmas \ref{lem:xelower} and \ref{lem:xlower} below establish that in this case $\|x_{L\e}\|\geq 2^L\|x_0\|$, and Lemma \ref{lem:arate_0} shows that this will result in $\alpha(x_0,x_{L\e})$ tending to zero as $\|x_0\|\to\infty$ provided $\|p_0\|\leq \|x_0\|^\delta$ for some $\delta<1$, allowing Proposition \ref{prop:supr} to be envoked.  To conclude we simply note that $\mathbb{P}(\|p_0\|\leq \|x_0\|^\delta) \to 1$ as $\|x_0\| \to \infty$, establishing the result."

### T01 = Theorem 2.2 (TEX:208-219)
```
\begin{thm} \label{thm:negative}
If either of the following hold then HMC will \emph{not} produce a geometrically ergodic Markov chain:

\vspace{0.2cm}

(i) $\lim_{\|x\| \to \infty}\frac{\|\nabla U(x)\|}{\|x\|} = \infty$ and (\ref{eqn:oscillations}) and (\ref{eqn:oscillation2}) are satisfied

\vspace{0.2cm}

(ii) There is an $M<\infty$ such that $\|\nabla U(x)\| \leq M$ for all $x \in \X$, and $\mathbb{E}_\pi[e^{s\|x\|}]=\infty$ for every $s>0$.

\end{thm}
```

### C01 = Corollary 2.3 (TEX:229-239); only part (ii) checked
```
\begin{crly} \label{crly:expfam}
For the exponential family class of models $\mathcal{E}(\beta,\alpha)$, under assumption \textbf{A1} the following results hold:

\vspace{0.2cm}

(i) For $1 \leq \beta \leq 2$, the Hamiltonian Monte Carlo method will produce a geometrically ergodic chain (for small enough $\e$ in the $\beta = 2$ case)

\vspace{0.2cm}

(ii) If $\beta < 1$ or $\beta > 2$, then the Hamiltonian Monte Carlo method will \emph{not} produce a geometrically ergodic chain
\end{crly}
```
Proof of part (ii) (TEX:804-806), verbatim: "\begin{proof}[Proof of Corollary \ref{crly:expfam}] \label{proof:expfam} Part (ii) is a direct consequence of Theorem \ref{thm:negative} For part (i), we consider three cases separately."

## 5. Shared definitions (not numbered results)

| ID | Name | Location | Label |
|---|---|---|---|
| D01 | Target density, potential U(x) = -log pi(x), pi ∝ e^{-U}, U: X -> [0,inf) | TEX:320 | |
| D02 | Hamiltonian H(x,p) = U(x) + p^t M^{-1} p / 2 | TEX:321-323 | eqn:hamiltonian |
| D03 | Leapfrog (Stormer-Verlet) recursion, step size eps, x_{i eps}, p_{i eps}, flow phi_{L eps} | TEX:330-336 | |
| D04 | HMC single iteration (Algorithm 1), accept iff log u < H(x_0,p_0) - H(phi_T(x_0,p_0)) | TEX:338-352 | alg:hmc |
| D05 | Convention M = I (p_0 ~ N(0,I)) | TEX:354-356 | |
| D06 | HMC candidate kernel Q(x,A) = ∫ 1_A(g_xi(x)) mu(d xi), g_xi = Pr_x o phi_T, xi = {T,p} | TEX:163, 171-175 | eqn:hmap |
| D07 | Acceptance probability alpha(x,y) = 1 ∧ r(x,y), r = pi(y)q(y,x)/(pi(x)q(x,y)) | TEX:163-167 | eqn:accept |
| D08 | Metropolis-Hastings type kernel P(x,dy) = alpha Q + r(x) delta_x, with rejection probability r(x) = 1 - ∫ alpha(x,y) Q(x,dy) | TEX:274-279 | eqn:mhtype |
| D09 | Geometric ergodicity: exists rho<1, pi-a.e. finite M(x) with ||P^n(x,.) - pi||_TV <= M(x) rho^n | TEX:264-268 | eqn:geoerg |
| D10 | Distribution 𝔏 of the number of leapfrog steps L; integration time T = L eps | TEX:192, 343 | |
| D11 | Exponential family class E(beta,alpha): pi in C^1(R), pi ∝ exp(-alpha|x|^beta) for |x|>M | TEX:223-227 | |
| D12 | Assumption A1 (P[L=1]>0 and exponential moment of ||x_{L eps}||; an assumption, not a result) | TEX:393 | ass:A1 |
| D13 | Notation: Euclidean norm ||x||, X = R^d, Gaussian measure mu^G, total variation norm | TEX:192-194 | |

Note on the HMC marginal-chain formula (TEX:361-374, Proposition 4.2, eqn:mprop, eqn:mprop2): it is a numbered result outside the scope; it is treated as external input E2 (section 7), not as a definition.

## 6. Global conventions

- State space X = R^d, Euclidean norm (TEX:152, 192). U: X -> [0,inf) (TEX:320). M = I (TEX:354-356). Step size eps > 0 fixed; L the number of leapfrog steps; T = L eps.
- Section 5 results are stated "conditioned on a fixed choice of L" (TEX:411); Theorem 5.14 says "fixed integration time T = L eps ... for any choice T>0" and the lemmas use L as a fixed integer.
- Constants: "there exists eta < infinity" in the lemmas depends on eps, d, delta, L (not stated); the order of quantifiers is left implicit.
- delta (exponent) lies in (0,1) in Lemmas 5.15-5.17 ("some delta<1"), but the earlier notation (TEX:413) has 1/2 < delta < 1 for I_delta.
- Limits "lim_{||x_0||->infinity, ||p_0||<=||x_0||^delta}" are taken over the pair (x_0,p_0) in a deterministic sense (supremum over the allowed p_0 region); x_{i eps}, p_{L eps} are the deterministic leapfrog outputs for given (x_0,p_0).
- Corollary 2.3 is for the one-dimensional class E(beta,alpha) (TEX:223) under A1; Theorem 2.2 is on X = R^d.

## 7. Candidate external inputs (provenance (i)-(v))

Provenance labels follow the user instruction (all out-of-scope numbered results are type (ii)).

| ID | Name | Source location | Provenance | Users |
|---|---|---|---|---|
| E1 | Proposition 3.5 (prop:supr): for P of MH type, (eqn:geoerg) fails if esssup r(x) = 1 | TEX:300-303 (cited from roberts1996geometric, Roberts and Tweedie 1996, no theorem number given at TEX:298) | (ii) per user instruction (also type (i) location) | T02 |
| E2 | Proposition 4.2 (prop:mprop): x_{L eps} formula (eqn:mprop), alpha formula, p_{L eps} formula (eqn:mprop2). "can be straightforwardly derived using classical results (see e.g. bou2018geometric)", no proof | TEX:359-374 | (ii) | L01, L02, L03, T02 |
| E3 | Theorem 5.18 (thm:heavy): ||grad U|| < M everywhere => geometric ergodicity requires ∫ e^{s||x||} pi(dx) < infinity for some s>0 | TEX:978-996 | (ii) | T01 (part ii), C01 (ii) |
| E4 | Proposition 3.6 (prop:tight, jarner2003necessary): used inside the proof of Thm 5.18 only | TEX:307-313 | (ii) (transitive via E3) | E3 |
| E5 | Proposition 3.3 (prop:mh1) (irreducibility/aperiodicity of the MH chain): context hypothesis of Prop 3.5, and Cor 3.4 | TEX:283-289 | (ii) (transitive, may not be needed) | E1 (context) |
| E6 | Gaussian tail fact: P(||p_0|| <= ||x_0||^delta) -> 1 as ||x_0|| -> infinity for p_0 ~ N(0,I), delta>0 (stated "we simply note") | TEX:879 | (v) | T02 |
| X1 | Passage from "alpha(x_0,x_{L eps}) -> 0 uniformly on {||p_0||<=||x_0||^delta}" to "esssup r(x) = 1" (needs that r(x) = 1 - E[alpha], with the probability of the p_0-region tending to 1 and the set of x with large norm having positive Lebesgue measure) | TEX:879 | (iii) | T02 |
| X2 | Passage from the theorem's "fixed integration time T = L eps" to the chain with random L ~ 𝔏 under A1 (P[L=1]>0, L unbounded possible), used when Cor 2.3(ii) invokes Thm 2.2 under A1; Thm 5.14's proof covers a fixed L only | TEX:393, 806, 876 | (iii) | C01 (ii), T01 |
| X3 | Identification of the two parts of Thm 2.2 with Thm 5.14 (i) and Thm 5.18 (ii); Thm 2.2 is never explicitly referred to either proof | TEX:208-219, 863, 978 | (iii) | T01 |
| X4 | Verification that E(beta,alpha) with beta>2 satisfies (17)-(19) (growth ||grad U||/||x|| -> infinity, tripling (18), (19) with the L-th power 2^L) and that E(beta,alpha) with beta<1 satisfies "||grad U|| <= M on all of X" (needs control of grad U on compact sets from pi in C^1 and pi>0, not just for |x|>M) and E_pi[e^{s|x|}] = infinity for every s>0 (needs normalisation of pi ∝ exp(-alpha|x|^beta) outside [-M,M]); none of this is written in the paper | TEX:806 | (iii) | C01 (ii) |
| X5 | Lemma 5.16 uses (18) (via "Envoking (18)") and the bound of Lemma 5.15 for the first step, but its statement lists only (17); Lemma 5.17's use of (18) at points x_{i eps} needs ||x_{L eps}|| >= 2 ||x_{i eps}|| and ||x_{i eps}|| >= C for all i (only the final bound of Lemma 5.16 is stated; the intermediate bounds ||x_{i eps}|| >= 2||x_{(i-1) eps}|| are in the proof of Lemma 5.16 and are used without being part of its statement) | TEX:899-901, 930, 953-957 | (iii) | L02, L03 |
| X6 | Lemma 5.17: the limit in (19) is used with y = x_{L eps} but with x_0 in place of x; the inequality ||p_0||^2 - ||p_{L eps}||^2 <= -||x_0||^2 is claimed from "frac{eps gamma_L}{4}||grad U(x_{L eps})|| >= M ||x_{L eps}|| >= 2^L ||x_0||" for an arbitrary M, which uses (17) at the point x_{L eps} (that ||x_{L eps}||→infinity) | TEX:966-970 | (iii) | L03 |

## 8. Unnumbered claims (not counted)

| ID | Location | Claim |
|---|---|---|
| H01 | TEX:882 | "The conditions (18) and (19) ... are very lenient and should be satisfied for the vast majority of statistical models of interest for which (17) holds." (no proof; heuristic) |
| H02 | TEX:221 | Verbal interpretation of Thm 2.2 (i) "lighter tails than Gaussian ... explicit solvers become unstable" |
| H03 | TEX:245 | "taking more than a single leapfrog step ... will not result in a chain 'becoming' geometrically ergodic" (consequence claim following Cor 2.3) |
| H04 | TEX:937 | "the acceptance rate will approach 0" (informal statement of Lemma 5.17) |
| H05 | TEX:1016 | Description of the class with bounded gradient and exponential moment: "essentially comprising U(x) = C||x|| + b(x)" (no proof) |

No mathematical claims in an experimental part (the paper has none in the six-result scope).

Numbered results outside the scope (not registered, not checked): Thm 2.1, Thm 2.4 (unlabelled), Thm 3.1, Defn 3.2, Prop 3.3, Crly 3.4, Prop 3.5, Prop 3.6, Prop 4.2, Rem 4.1, Thm 5.3, Thm 5.4, Prop 5.5, Crly 5.6, Lem 5.7-5.9, Prop 5.10, 5.11, Prop 5.13, Thm 5.18, Prop 5.19 (prop:heavyexact), Thm 6.x (thm:virial, thm:dynamic), Example in Appendix A, appendix Lemma/Prop (TEX:1254, 1270). (PDF numbers of those after 5.18 and Section 6 were not verified.)

## 9. Notational ambiguities (recorded only, no ruling)

| ID | Where | Ambiguity |
|---|---|---|
| N1 | TEX:413 vs 432 | I_delta(x) / I(x) defined twice: {||y|| <= ||x||^delta} with delta in (1/2,1) and later I(x_0) = {||y|| <= ||x_0||}; "In the case delta = 1 we will simply write I(x)" |
| N2 | TEX:885, 900, 914, 942, 960 | The symbol delta denotes (a) the exponent in ||p_0|| <= ||x_0||^delta, (b) a small positive number in (21), (c) delta_L (undefined) in the expansion of ||p_{L eps}||^2; eta is the threshold in Lemma 5.15/5.16 and also eta(d) = Gamma((d+1)/2)/Gamma(d/2); M is the mass matrix, a gradient bound (Thm 2.2) and a free constant |
| N3 | TEX:874 | In (19) the variables x, y are free, L is the (fixed) number of leapfrog steps of the HMC but is not a quantified parameter of the hypothesis; the condition "||y|| >= 2^L||x||" is joined to limit ||x|| -> infinity (limit over the two-variable region) |
| N4 | TEX:896 | "the first term on the right-hand side is larger than 6/eps^2": the first term of (20) is (eps^2/2)||grad U||/||x_0||; the constant 6/eps^2 evidently refers to the ratio ||grad U||/||x_0|| or to a different normalisation |
| N5 | TEX:885, 900, 942 | Quantifier order in "for all ||x_0||>eta and any ||p_0||<=||x_0||^delta for some delta<1": whether eta depends on delta (and on eps, L, d) is not stated |
| N6 | TEX:914 | Inequality (21) is written with ">= 1 - delta" but the middle expression has e^2||grad U|| - 2||x_0|| - 2 eps||p_0|| in the numerator where the previous line has ||x_eps|| >= (eps^2/2)||grad U|| - ... ; the factor 2 normalisation is not carried consistently |
| N7 | TEX:219, 217 | In Thm 2.2 (ii) the symbol X in "for all x in X" and ||x|| (Euclidean) versus E(beta,alpha) of Cor 2.3 in dimension one with |x| |
| N8 | TEX:173 vs 393 | L is a random variable (A1, Algorithm 1) in Section 2 and Section 4 but a fixed integer in Section 5.3 |
| N9 | TEX:216, 874 | "HMC will not produce a geometrically ergodic chain" (Thm 2.2) vs "does not produce ... for any choice T>0" (Thm 5.14): T = L eps with both L and eps free |

> **Revision 1 (2026-10-13):** line numbers in this inventory refer to the previous manuscript (verification/source_baseline_v1/) for TEX lines >= 803; see "Revision mapping" in AUDIT.md (new = old + 32 after the Cor 2.3 proof, + 125 after Thm 5.14 region; exact table there). RESULTS.json carries the current locations.
