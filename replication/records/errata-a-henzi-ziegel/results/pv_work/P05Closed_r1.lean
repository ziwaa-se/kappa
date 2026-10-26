import P05
import P04

open MeasureTheory Paper.P04

namespace Paper.P05

variable {Ω : Type*} {m0 : MeasurableSpace Ω}

/-- `P05_P04Consumed` follows from `P04_S10` (instantiated with `c := 1`; `SeqSetting` for `c ≡ 1`
is derived from `SeqSetting` for `c`, since `c ≡ 1` is measurable, `{0,1}`-valued, and `lam_zero` is
vacuous). -/
theorem P05_P04Consumed_holds (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (h : ℕ) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S) :
    P05_P04Consumed S ν h ℱ Y c p q lam := by
  intro hrep hset hS hh Q hQ k hk τ' hτ'
  have hset1 : SeqSetting ℱ Y (fun _ _ => (1 : ℝ)) p q lam :=
    { Y_adapted := hset.Y_adapted
      c_adapted := fun t => measurable_const
      p_adapted := hset.p_adapted
      q_adapted := hset.q_adapted
      lam_adapted := hset.lam_adapted
      Y_mem := hset.Y_mem
      c_mem := fun t ω => Or.inr rfl
      p_mem := hset.p_mem
      q_mem := hset.q_mem
      lam_mem := hset.lam_mem
      lam_zero := fun t ω h0 => absurd h0 one_ne_zero }
  exact P04_S10 S ν hrep h hh ℱ Y (fun _ _ => (1 : ℝ)) p q lam hT01 hMix hset1 hS Q hQ k hk τ' hτ'

theorem main_closed (S : ℝ → ℝ → ℝ)
    (hT01 : P04_T01Consumed S) (hMix : P04_MixingOfStrict S)
    (ν : Measure ℝ) (hrep : T01.MixtureRep S ν)
    (h : ℕ) (hh : 1 ≤ h) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ)
    (hset : SeqSetting ℱ Y c p q lam) (hS : IsStrictlyConsistent S)
    (τ : Ω → ℕ) (hτ : IsStopTime ℱ τ) :
    P05Conclusion S h ℱ Y p q lam τ :=
  P05_main S ν hrep h hh ℱ Y c p q lam (P05_P04Consumed_holds S ν h ℱ Y c p q lam hT01 hMix)
    hset hS τ hτ

end Paper.P05
