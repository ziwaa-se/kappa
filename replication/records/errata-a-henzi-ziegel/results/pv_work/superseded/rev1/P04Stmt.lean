import T01Stmt

/-!
# P04 statement definitions (source/VSIFP_02.tex:222-227, Proposition 3.4 `prop:combination`)

Time convention (A11): `(p_t, q_t, λ_t, c_t)` are `ℱ_t`-measurable forecasts/conditions for the
observation `Y_{t+h}` (l.111); `Y_t` is `ℱ_t`-measurable.  Everything is real valued; the
binary/range constraints are recorded in `SeqSetting`.
-/

open MeasureTheory

namespace Paper.P04

variable {Ω : Type*} {m0 : MeasurableSpace Ω}

/-- The hypotheses on the data (l.223): `(Y_t,c_t,p_t,q_t,λ_t) ∈ {0,1}² × (0,1)² × [0,1]`,
adapted to `ℱ_t`, and `λ_t = 0` if `c_t = 0`.  (D06, D10, l.122: `c_t` is `ℱ_t`-measurable.) -/
structure SeqSetting (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ) : Prop where
  Y_adapted : ∀ t, Measurable[ℱ t] (Y t)
  c_adapted : ∀ t, Measurable[ℱ t] (c t)
  p_adapted : ∀ t, Measurable[ℱ t] (p t)
  q_adapted : ∀ t, Measurable[ℱ t] (q t)
  lam_adapted : ∀ t, Measurable[ℱ t] (lam t)
  Y_mem : ∀ t ω, Y t ω = 0 ∨ Y t ω = 1
  c_mem : ∀ t ω, c t ω = 0 ∨ c t ω = 1
  p_mem : ∀ t ω, p t ω ∈ Set.Ioo (0:ℝ) 1
  q_mem : ∀ t ω, q t ω ∈ Set.Ioo (0:ℝ) 1
  lam_mem : ∀ t ω, lam t ω ∈ Set.Icc (0:ℝ) 1
  lam_zero : ∀ t ω, c t ω = 0 → lam t ω = 0

/-- D19 (l.223): `I_k = {k + h s : s = 0, …, ⌊(T-k)/h⌋ - 1}` (natural-number division is the floor;
`T - k` is the natural subtraction, harmless for `k ≤ h < T`). -/
def Ik (h T k : ℕ) : Finset ℕ := (Finset.range ((T - k) / h)).image (fun s => k + h * s)

/-- D19 (l.224-225): `e_T = (1/h) ∑_{k=1}^h ∏_{l ∈ I_k} E_{p_l,q_l;λ_l}(Y_{l+h})`.
`Erep` is the shared D14 (division by `0` is `0` in Lean; relevant only if `p_l = q_l`, see notes). -/
noncomputable def eT (S : ℝ → ℝ → ℝ) (h : ℕ) (Y p q lam : ℕ → Ω → ℝ) (T : ℕ) (ω : Ω) : ℝ :=
  (1 / (h : ℝ)) * ∑ k ∈ Finset.Icc 1 h,
    ∏ l ∈ Ik h T k, Paper.Erep S (p l ω) (q l ω) (lam l ω) (Y (l + h) ω)

/-- D08 (l.116-118, eq:h0s).  `ℋ_{S;c}`: probability measures `Q` on `(Ω, ℱ)` with
`c_t E_Q{S(p_t,Y_{t+h}) - S(q_t,Y_{t+h}) | ℱ_t} ≤ 0` a.s. for all `t`.  (The source writes
`𝔓` for the measure, A06; `Q` is used as in l.206, 238.) -/
def HSc (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q : ℕ → Ω → ℝ) :
    Set (Measure Ω) :=
  {Q | IsProbabilityMeasure Q ∧ ∀ t : ℕ, ∀ᵐ ω ∂Q,
    c t ω * (condExp (ℱ t) Q (fun ω' => S (p t ω') (Y (t + h) ω') - S (q t ω') (Y (t + h) ω'))) ω
      ≤ 0}

/-- CANDIDATE TFA (see notes): the conditional expectations in `ℋ_{S;c}` are only meaningful
(and `condExp` is `0` junk otherwise) when the score difference is integrable.  The conclusion of
the proposition is claimed for `Q ∈ ℋ_{S;c}` with these integrability conditions. -/
def HScInt (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q : ℕ → Ω → ℝ) :
    Set (Measure Ω) :=
  {Q | Q ∈ HSc S h ℱ Y c p q ∧ ∀ t : ℕ,
    Integrable (fun ω' => S (p t ω') (Y (t + h) ω') - S (q t ω') (Y (t + h) ω')) Q}

/-- "`e` is an e-value under `𝒬`" (l.78, D13, no alternative): `e ≥ 0` and `E_Q e ≤ 1` for
`Q ∈ 𝒬`.  The expectation is written as the lower integral of `ofReal e`, which is
`E_Q e` for `e ≥ 0` (and `+∞` if not integrable), so no junk value `0` arises. -/
def IsEValueUnder (e : Ω → ℝ) (𝒬 : Set (Measure Ω)) : Prop :=
  (∀ ω, 0 ≤ e ω) ∧ ∀ Q ∈ 𝒬, ∫⁻ ω, ENNReal.ofReal (e ω) ∂Q ≤ 1

/-- The two clauses of the conclusion (l.226) for a fixed `T`: `e_T` is `ℱ_T`-measurable and
an e-value under `ℋ_{S;c}` (with the integrability premise of `HScInt`). -/
structure P04Conclusion (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0) (Y c p q lam : ℕ → Ω → ℝ)
    (T : ℕ) : Prop where
  measurable : Measurable[ℱ T] (eT S h Y p q lam T)
  evalue : IsEValueUnder (eT S h Y p q lam T) (HScInt S h ℱ Y c p q)

/-- (p) Consumed clause of T01 (Theorem 3.1, l.144-149, the "if" direction, proved in the source at
l.403 "If E(y) is of the stated form, then E(y) ≥ E{1(p>q)} = 1-λ ≥ 0, and one can easily verify
that E has the given null hypothesis"): for `S` consistent with mixing measure `ν` charging
`[min p q, max p q)`, `p ≠ q`, `λ ∈ (0,1]`, the function `E_{p,q;λ}` is nonnegative and has
`E_π E ≤ 1` for `π ∈ H_S`.  (The alternative part of T01 is not used and omitted.)
T01 is not yet proved (ISSUE recorded), hence a parameter. -/
def P04_T01Consumed (S : ℝ → ℝ → ℝ) : Prop :=
  IsConsistent S → ∀ ν : Measure ℝ, T01.MixtureRep S ν →
    ∀ p ∈ Set.Ioo (0:ℝ) 1, ∀ q ∈ Set.Ioo (0:ℝ) 1, p ≠ q →
      0 < ν (Set.Ico (min p q) (max p q)) →
        ∀ lam ∈ Set.Ioc (0:ℝ) 1,
          IsEValue (Erep S p q lam) (HS S p q) ∅

/-- External input, provenance (ii) (l.106, asserted without proof; used silently, (iii), in P04):
"`S` is strictly consistent iff `ν` assigns positive measure to all non-degenerate intervals in
`(0,1)`" (only the "only if" direction is used).  The mixture representation `MixtureRep S ν` is
the convention of l.93-97, given as a hypothesis (`ν`, `hrep`), not a parameter.  P04 uses it to
obtain `ν{[min(p_t,q_t),max(p_t,q_t))} > 0` when applying T01 (X02, X04). -/
def P04_MixingOfStrict (S : ℝ → ℝ → ℝ) : Prop :=
  ∀ ν : Measure ℝ, T01.MixtureRep S ν → IsStrictlyConsistent S →
    ∀ a b : ℝ, 0 < a → a < b → b < 1 → 0 < ν (Set.Ico a b)

end Paper.P04
