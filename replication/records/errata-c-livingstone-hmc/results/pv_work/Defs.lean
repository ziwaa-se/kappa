import Mathlib

/-!
# Shared definitions for the HMC paper (source/geo_erg_HMC_v3.1.tex)

Definitions only, no theorems.  Everything lives in `namespace Paper.Defs`.
Encoding choices are recorded in `pv_work/notes/DEFS_draft_notes.md`.
-/

open Filter Topology

namespace Paper.Defs

/-- State space `X = R^d` with the Euclidean norm (TEX:192-194: "restrict attention to
`X = R^d` (and write `‖x‖` for the Euclidean norm)"). -/
abbrev E (d : ℕ) := EuclideanSpace ℝ (Fin d)

/-- Unnormalised target density `π(x) ∝ e^{-U(x)}` (TEX:320).  Only the unnormalised
density is needed: all uses are ratios `π(y)/π(x)`. -/
noncomputable def piDens {d : ℕ} (U : E d → ℝ) (x : E d) : ℝ := Real.exp (-U x)

/-- Hamiltonian with mass matrix `M = I` (TEX:321-323 with the Remark at TEX:354-356):
`H(x,p) = U(x) + (1/2) p^t p = U(x) + ‖p‖²/2`. -/
noncomputable def H {d : ℕ} (U : E d → ℝ) (x p : E d) : ℝ := U x + (1 / 2) * ‖p‖ ^ 2

/-- `gU` is (a version of) the gradient `∇U` of the potential `U` (TEX:320 "provided `U` is
differentiable", TEX:332).  `U` itself is kept generic, `∇U` is passed as a function. -/
def IsGradField {d : ℕ} (U : E d → ℝ) (gU : E d → E d) : Prop :=
  ∀ x, HasGradientAt U (gU x) x

/-- One leapfrog step with step-size `eps` and `M = I` (TEX:331-335):
`p_{t+ε/2} = p_t - (ε/2)∇U(x_t)`, `x_{t+ε} = x_t + ε p_{t+ε/2}`,
`p_{t+ε} = p_{t+ε/2} - (ε/2)∇U(x_{t+ε})`. -/
noncomputable def leapfrogStep {d : ℕ} (gU : E d → E d) (eps : ℝ) (s : E d × E d) :
    E d × E d :=
  let ph : E d := s.2 - (eps / 2) • gU s.1
  let x' : E d := s.1 + eps • ph
  (x', ph - (eps / 2) • gU x')

/-- The leapfrog trajectory: `leapfrogState gU eps x0 p0 i = (x_{iε}, p_{iε})`, `i` steps of the
recursion started at `(x_0,p_0)` (TEX:330-336). -/
noncomputable def leapfrogState {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) :
    ℕ → E d × E d
  | 0 => (x0, p0)
  | n + 1 => leapfrogStep gU eps (leapfrogState gU eps x0 p0 n)

/-- `x_{iε}` (TEX:330-336). -/
noncomputable def xLF {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (i : ℕ) : E d :=
  (leapfrogState gU eps x0 p0 i).1

/-- `p_{iε}` (TEX:330-336). -/
noncomputable def pLF {d : ℕ} (gU : E d → E d) (eps : ℝ) (x0 p0 : E d) (i : ℕ) : E d :=
  (leapfrogState gU eps x0 p0 i).2

/-- Acceptance probability `α(x_0, x_{Lε})` of HMC (Prop. 4.2, TEX:366-369, used in the form of
TEX:949; the two coincide because `π(y)/π(x) = exp(U x - U y)` for `π ∝ e^{-U}`):
`1 ∧ (π(x_{Lε})/π(x_0)) exp(‖p_0‖²/2 - ‖p_{Lε}‖²/2)`.
Equivalently `1 ∧ exp(H(x_0,p_0) - H(x_{Lε},p_{Lε}))`, the criterion of Algorithm 1
(TEX:345-346).  The momentum `p_0` is an explicit argument (implicit in the source notation
`α(x_0,x_{Lε})`). -/
noncomputable def accProb {d : ℕ} (U : E d → ℝ) (gU : E d → E d) (eps : ℝ) (L : ℕ)
    (x0 p0 : E d) : ℝ :=
  min 1 (piDens U (xLF gU eps x0 p0 L) / piDens U x0 *
    Real.exp ((1 / 2) * ‖p0‖ ^ 2 - (1 / 2) * ‖pLF gU eps x0 p0 L‖ ^ 2))

/-- Filter for "`‖x_0‖ → ∞, ‖p_0‖ ≤ ‖x_0‖^δ`" (TEX:885, 900, 942), on pairs `(x_0,p_0)`:
`‖x_0‖ → ∞` intersected with the region `‖p_0‖ ≤ ‖x_0‖^δ`.  Helper for stating Lemma 5.17
(limit form); lemmas 5.15/5.16 use the same region as a hypothesis. -/
def tailMomFilter (d : ℕ) (δ : ℝ) : Filter (E d × E d) :=
  comap (fun q : E d × E d => ‖q.1‖) atTop ⊓
    𝓟 {q : E d × E d | ‖q.2‖ ≤ ‖q.1‖ ^ δ}

/-- Hypothesis (17), `eqn:explode` (TEX:865-867):
`lim_{‖x‖→∞} ‖∇U(x)‖/‖x‖ = ∞`. -/
def HypExplode {d : ℕ} (gU : E d → E d) : Prop :=
  Tendsto (fun x : E d => ‖gU x‖ / ‖x‖) (comap (fun x : E d => ‖x‖) atTop) atTop

/-- Hypothesis (18), `eqn:oscillations` (TEX:868-871): there is a fixed `C < ∞` such that
whenever `‖y‖ ≥ 2‖x‖ ≥ C`, `‖∇U(y)‖ ≥ 3‖∇U(x)‖`. -/
def HypOscillations {d : ℕ} (gU : E d → E d) : Prop :=
  ∃ C : ℝ, ∀ x y : E d, 2 * ‖x‖ ≤ ‖y‖ → C ≤ 2 * ‖x‖ → 3 * ‖gU x‖ ≤ ‖gU y‖

/-- Hypothesis (19), `eqn:oscillation2` (TEX:874):
`lim_{‖x‖→∞, ‖y‖ ≥ 2^L‖x‖} (U(x) - U(y) - ‖x‖²/2) = -∞`, a limit over pairs `(x,y)` with
`‖x‖ → ∞` inside the region `‖y‖ ≥ 2^L ‖x‖`.  `L` is a parameter (cf. note N3). -/
def HypOscillation2 {d : ℕ} (U : E d → ℝ) (L : ℕ) : Prop :=
  Tendsto (fun q : E d × E d => U q.1 - U q.2 - (1 / 2) * ‖q.1‖ ^ 2)
    (comap (fun q : E d × E d => ‖q.1‖) atTop ⊓
      𝓟 {q : E d × E d | (2 : ℝ) ^ L * ‖q.1‖ ≤ ‖q.2‖})
    atBot

end Paper.Defs
