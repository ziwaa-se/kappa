# L01 statement gate

- Reviewer: pv-gate (independent subagent, claude-opus-5-5)
- Date: Mon Oct 12 21:58:40 EDT 2026
- Reviewed files (sha256, `python3 scripts/pv_snapshot.py hash`):
  - `695fc0fc822745a2a106a97ccc519b9d61764203d1114c739eb4f125a6aa39bc  pv_work/L01Stmt.lean`
  - `50d1e1e07057d31108d54126f3e7d439c84ea96b8dc9ddc3e4d0852161e0617d  pv_work/L01Draft.lean`
  - `1a84ee67ce46f2b4d639eaadf6229ee14ec07a2e08973fb06923d4cc2ef915c8  pv_work/Defs.lean` (imported; DEFS gate PASS, `verification/audits/DEFS_gate.md`)
  - `b184f03423aeaa337da0a24a712a8049c058bd1970b958d8ea4ff922e310b6fa  pv_work/notes/L01_draft_notes.md` (leads only)
- Compilation: `scripts/pv_lean.sh check L01Draft` -> `RESULT L01Draft mode=check exit=0 errors=0 sorry_warnings=2 nonstandard_axiom_lines=0 log=pv_work/logs/L01Draft_2.log olean=none`. The 2 sorry warnings are S1 and S2 (expected in a draft).

## Source quotations

- Definition `def:edf`, source/main.tex:24-27: "For $n \ge 1$ and $x = (x_1, \dots, x_n) \in \mathbb{R}^n$, the empirical distribution function is $F_n(t) = \frac1n \#\{ i : x_i \le t \}$ for $t \in \mathbb{R}$."
- Lemma `lem:steps`, source/main.tex:35-38: "For every $x \in \mathbb{R}^n$, $F_n$ is nondecreasing, and $n F_n(t) \in \{0, 1, \dots, n\}$ for every $t \in \mathbb{R}$."
- Proof, source/main.tex:40-43: "If $s \le t$, every $i$ with $x_i \le s$ also satisfies $x_i \le t$, so $F_n(s) \le F_n(t)$. The number $n F_n(t)$ counts a subset of $\{1, \dots, n\}$."

Lean definition used: `Paper.Defs.edf x t = (1/(n:ℝ)) * card {i : Fin n | x i ≤ t}` (Defs.lean:21-22), matching main.tex:26 with index shift `i ↦ i+1`; snapshot hash in DEFS_gate.md (`th=2665670918|vh=3752896497`).

## Item rulings

1. **Hypotheses: PASS.** Source hypotheses: $n \ge 1$ (from Definition, main.tex:25, where $F_n$ is defined only for $n\ge1$) and $x\in\mathbb{R}^n$. Lean: `{n : ℕ} (hn : 1 ≤ n) (x : Fin n → ℝ)`. `hn` is a source hypothesis, not an extra premise. No hidden hypotheses: `Conclusion` is a plain `structure` with no parameters beyond `x`; no type classes, `variable`s or hidden premises in `Defs`. No conclusion-shaped hypothesis.
2. **Conclusion: PASS.** Clause 1 `mono : Monotone (edf x)` = "$F_n$ is nondecreasing" (for fixed $x$, as a function of $t$). Clause 2 `values : ∀ t, ∃ k : ℕ, k ∈ Finset.range (n+1) ∧ (n:ℝ) * edf x t = k` = "$nF_n(t)\in\{0,\dots,n\}$ for every $t$" (range (n+1) = {0,…,n}). Neither weakened nor strengthened; no clause missing.
3. **Quantifiers / constants: PASS.** No constants. Order "∀ n ≥ 1, ∀ x, (mono ∧ ∀ t, …)" matches the source.
4. **Domains and details: PASS.** Domain ℝ for t, ℝ^n as `Fin n → ℝ`; equality is exact (no a.e.); finiteness of the count is automatic (Finset). No ℝ≥0∞/toReal conversions. `n = 0` junk value (`1/0 = 0`) is excluded by `hn`.
5. **Step obligations: PASS.**
   - S1 (main.tex:41) `Monotone (edf x)` under `1 ≤ n`: corresponds to the first sentence; true (filter set grows with t, coefficient 1/n > 0; in fact true even for n = 0). Not smuggling: it is exactly clause 1, which the source proves in exactly this sentence.
   - S2 (main.tex:41-42) `∃ k ∈ range (n+1), n * edf x t = k`: corresponds to the second sentence; true as stated *with* `hn` (n·(1/n)·card = card since n ≠ 0, and card ≤ card (Fin n) = n). Checked for a missing premise (LESSONS 10): the only needed premise, n ≠ 0, is present (and even without it the claim holds with k = 0). Using card ≤ n is a FAIR_IMPLICIT_STEP covered by "counts a subset of {1,…,n}".
   - Assembly: `L01_main` = `⟨L01_S1 hn x, L01_S2 hn x⟩` compiles, so S1 and S2 together yield the main theorem.
6. **External parameters: PASS (none).** No `def … : Prop` parameters, none needed (the source cites nothing for L01).
7. **Doubts about the source: PASS.** None found by the drafter or by me.

## TFAs ruled on

| Name | Ruling | Reason |
|---|---|---|
| (none) | — | `1 ≤ n` is a source hypothesis (main.tex:25), not a TFA |

## External parameters

| Name | Provenance | Ruling |
|---|---|---|
| (none) | — | — |

## Required changes

None.

## Statement snapshot

Statement copy `pv_work/probes/gate/L01/gate_L01_stmtcopy.lean` (`scripts/pv_lean.sh probe` exit=0, log `pv_work/logs/gate_L01_stmtcopy_1.log`):

```
TYPE HASHES (current file, 9 declarations)
Paper.L01.Conclusion.casesOn|def|th=3354618779|vh=2905508755|bi=iiiee
Paper.L01.Conclusion.mk|ctor|th=4271614115|vh=-|bi=iiee
Paper.L01.Conclusion.mono|thm|th=866079308|vh=-|bi=iie
Paper.L01.Conclusion.noConfusionType|def|th=3939334632|vh=4141986538|bi=iieee
Paper.L01.Conclusion.noConfusion|def|th=1136519714|vh=1406100813|bi=iiiiie
Paper.L01.Conclusion.recOn|def|th=3354618779|vh=607231609|bi=iiiee
Paper.L01.Conclusion.rec|rec|th=2235729813|vh=-|bi=iiiee
Paper.L01.Conclusion.values|thm|th=2170998279|vh=-|bi=iiee
Paper.L01.Conclusion|induct|th=4224485804|vh=-|bi=ie
```

Draft copy `pv_work/probes/gate/L01/gate_L01_draftcopy.lean` (`scripts/pv_lean.sh probe` exit=0, 2 sorry warnings, log `pv_work/logs/gate_L01_draftcopy_1.log`):

```
TYPE HASHES (current file, 3 declarations)
Paper.L01.L01_S1|thm|th=2748928822|vh=-|bi=iee
Paper.L01.L01_S2|thm|th=1290642605|vh=-|bi=ieee
Paper.L01.L01_main|thm|th=2266948329|vh=-|bi=iee
```

## Overall verdict

The statement and obligations are faithful to main.tex:35-43; no TFAs, no external parameters, no suspected paper issues.

STATEMENT GATE: PASS
