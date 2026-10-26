import P05Stmt

/-!
# P05 draft, revision 1 (Proposition 3.5, `prop:stopping`)

Source `source/VSIFP_02.tex`: statement l.229-234; proof l.446-469 (the part l.456-468, inside the proof of
Proposition 3.4, for `h > 1`; l.447 "Let `h > 1`").  The old separate proof (l.471-476) is commented out and
not used.  Draft only: the `sorry`s are for the prover.
-/

open MeasureTheory Paper.P04

namespace Paper.P05

variable {Ω : Type*} {m0 : MeasurableSpace Ω}

/-- Main theorem (l.229-234).  `τ ∈ ℕ` an `𝔉`-stopping time; under the assumptions of Proposition 3.4
(`SeqSetting`, `S` strictly consistent, lag `h ≥ 1`), `E_Q(e_{τ+h-1}) ≤ 1` for `Q ∈ ℋ_S`.
The predecessor clause `P05_P04Consumed` (l.452, proof of P04) is the first hypothesis. -/
theorem P05_main (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν)
    (h : ℕ) (hh : 1 ≤ h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hP04 : P05_P04Consumed S ν h ℱ Y c p q lam)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (τ : Ω → ℕ) (hτ : IsStopTime ℱ τ) :
    P05Conclusion S h ℱ Y p q lam τ := by
  sorry

/-- S0.  The case `h = 1` (l.229-234 states the proposition for all `h ≥ 1`, the assumptions of
Proposition 3.4 allow `h = 1`; l.227 remarks only "for `h = 1` this is a consequence of the fact that
`(e_t)_{t≥2}` is a non-negative supermartingale, see Ramdas 2020").  The proof l.446-469 starts "Let
`h > 1`", so the source gives NO proof for `h = 1` within the proof (the supermartingale statement for
`h = 1` at l.214 is without stopping times).  Recorded gap (EXPOSITION_GAP candidate); the consumed
clause is vacuous for `h = 1`. -/
theorem P05_S0 (S : ℝ → ℝ → ℝ) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (τ : Ω → ℕ) (hτ : IsStopTime ℱ τ) :
    P05Conclusion S 1 ℱ Y p q lam τ := by
  sorry

/-- S1.  (l.452 "Then `e_t = ∑_{k=1}^h M^{[k]}_t / h`".)  Unfolding of `eT`, `Mk`. -/
theorem P05_S1 (S : ℝ → ℝ → ℝ) (h : ℕ) (Y p q lam : ℕ → Ω → ℝ) (t : ℕ) (ω : Ω) :
    eT S h Y p q lam t ω = (1 / (h : ℝ)) * ∑ k ∈ Finset.Icc 1 h, Mk S h Y p q lam k t ω := by
  sorry

/-- S2.  (A08; l.232 `Q ∈ ℋ_S` versus the general `c_t` of the assumptions, l.230; l.119 "If `c_t = 1`
for all `t`, we write `ℋ_{S;c} = ℋ_S`".  The source states nothing; l.452 says "for any `Q ∈ ℋ_S`".)
With `c_t ∈ {0,1}`, `ℋ_S ⊆ ℋ_{S;c}`.  No longer used by S7 after amendment A1 (the clause is stated for
`ℋ_S`); kept as a harmless side fact. -/
theorem P05_S2 (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hset : SeqSetting ℱ Y c p q lam) :
    HScInt S h ℱ Y (fun _ _ => (1 : ℝ)) p q ⊆ HScInt S h ℱ Y c p q := by
  sorry

/-- S3.  (l.456-459 "`f_k(τ) ∈ {τ, …, τ+h-1}`".)  Arithmetic: `τ ≤ f_k(τ) ≤ τ + h - 1` for `1 ≤ k ≤ h`. -/
theorem P05_S3 (h k τ : ℕ) (hk : k ∈ Finset.Icc 1 h) :
    τ ≤ fk h k τ ∧ fk h k τ ≤ τ + h - 1 := by
  sorry

/-- S4.  (l.459-463 "`f_k(τ)` is an `𝔉^{[k]}`-stopping time"; argument `t = k+hs+j`,
`f_k(τ) ≤ t ⇔ τ ≤ k+hs`.  Source typo "`k ∈ {1,…,k}`" for `k ∈ {1,…,h}`.)  Needs `h > 1` as in the source
(l.447), and `1 ≤ τ` (`ℕ = {1,2,…}`, `ℱ_j` trivial for `j ≤ 0`). -/
theorem P05_S4 (h : ℕ) (hh : 1 < h) (ℱ : Filtration ℕ m0) (k : ℕ) (hk : k ∈ Finset.Icc 1 h)
    (τ : Ω → ℕ) (hτ : IsStopTime ℱ τ) (t : ℕ) :
    MeasurableSet[filtK ℱ h k t] {ω | fk h k (τ ω) ≤ t} := by
  sorry

/-- S5.  (l.468 "using the fact that `M_{t+h-1} = ∑_k M^{[k]}_{f_k(t)}/h` for `t ∈ ℕ`"; `M` without
superscript is `e` of l.452 (notation slip).  No justification given.)  Deterministic identity, for
`t ≥ 1`: `I_k(t+h-1) = I_k(f_k(t))`.  For `t = 1` the index is `h`, `e_h = 1` in the Lean `eT` (empty
products), which agrees with the proof's formula although the statement of P04 defines `e_T` only for
`T ≥ h+1` (A07). -/
theorem P05_S5 (S : ℝ → ℝ → ℝ) (h : ℕ) (hh : 1 < h) (Y p q lam : ℕ → Ω → ℝ) (t : ℕ)
    (ht : 1 ≤ t) (ω : Ω) :
    eT S h Y p q lam (t + h - 1) ω =
      (1 / (h : ℝ)) * ∑ k ∈ Finset.Icc 1 h, Mk S h Y p q lam k (fk h k t) ω := by
  sorry

/-- S6.  (Silently used for linearity of the integral at l.453-455, 465-466; not mentioned in the
source, (iii).)  The stopped process `ω ↦ M^{[k]}_{f_k(τ ω)}(ω)` is `m0`-measurable (the stopping
time is `ℱ`-measurable, values in `ℕ`, each `M^{[k]}_t` is measurable), needed to split `∫⁻` of the
sum. -/
theorem P05_S6 (S : ℝ → ℝ → ℝ) (h : ℕ) (hh : 1 < h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (k : ℕ) (hk : k ∈ Finset.Icc 1 h) (τ : Ω → ℕ) (hτ : IsStopTime ℱ τ) :
    Measurable (fun ω => Mk S h Y p q lam k (fk h k (τ ω)) ω) := by
  sorry

/-- S7.  (l.452-456 applied with `τ[k] = f_k(τ)` of S4: `E_Q(M^{[k]}_{f_k(τ)}) ≤ 1`.)  Uses the
consumed clause `P05_P04Consumed` (stated for `ℋ_S`, so S2 is not needed) and S4. -/
theorem P05_S7 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν)
    (h : ℕ) (hh : 1 < h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hP04 : P05_P04Consumed S ν h ℱ Y c p q lam)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (τ : Ω → ℕ) (hτ : IsStopTime ℱ τ)
    (Q : Measure Ω) (hQ : Q ∈ HScInt S h ℱ Y (fun _ _ => (1 : ℝ)) p q)
    (k : ℕ) (hk : k ∈ Finset.Icc 1 h) :
    ∫⁻ ω, ENNReal.ofReal (Mk S h Y p q lam k (fk h k (τ ω)) ω) ∂Q ≤ 1 := by
  sorry

/-- S8.  (l.464-466 "`E_Q(M_{τ+h-1}) = E_Q((1/h)∑_k M^{[k]}_{f_k(τ)}) ≤ 1`", and l.453-455.)  Case `h > 1`:
S5 (pointwise at `t = τ ω ≥ 1`), linearity of `∫⁻` with S6, and the bound S7 for each `k`
(`h` terms, each `≤ 1`, times `1/h`).  Uses S5, S6, S7. -/
theorem P05_S8 (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (hrep : T01.MixtureRep S ν)
    (h : ℕ) (hh : 1 < h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) (hP04 : P05_P04Consumed S ν h ℱ Y c p q lam)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (τ : Ω → ℕ) (hτ : IsStopTime ℱ τ) :
    P05Conclusion S h ℱ Y p q lam τ := by
  sorry

end Paper.P05
