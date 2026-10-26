import P04Stmt

/-!
# P05 statement definitions (source/VSIFP_02.tex:229-234, Proposition 3.5 `prop:stopping`), revision 1

The proof is inside the proof of Proposition 3.4 (l.456-468; the old separate proof l.471-476 is
commented out and NOT used).  Only definitions here, no theorems.  Reuses from `P04Stmt`
(`Paper.P04.{SeqSetting, eT, Mk, filtK, fk, HScInt}`) without redeclaring anything.
-/

open MeasureTheory Paper.P04

namespace Paper.P05

variable {Ω : Type*} {m0 : MeasurableSpace Ω}

/-- `𝔉`-stopping time with values in `ℕ = {1,2,…}` (l.229 "`τ ∈ ℕ` a stopping time", l.447 `𝔉`-stopping
time, `𝔉 = (ℱ_t)_{t∈ℕ}`): `{τ ≤ n} ∈ ℱ_n` for all `n`, and `1 ≤ τ` (A07: `ℕ` starts at 1 in the
source, cf. `ℱ_j` trivial for `j ≤ 0`, l.452). -/
structure IsStopTime (ℱ : Filtration ℕ m0) (τ : Ω → ℕ) : Prop where
  le_meas : ∀ n : ℕ, MeasurableSet[ℱ n] {ω | τ ω ≤ n}
  pos : ∀ ω, 1 ≤ τ ω

/-- The conclusion (l.232): `E_Q(e_{τ+h-1}) ≤ 1` for all `Q ∈ ℋ_S` (`c_t ≡ 1`, A08), where
`ℋ_S` is `HScInt` with the constant condition `1` (integrability premise as in P04, candidate TFA
inherited from P04).  The expectation is the lower integral of `ofReal e` (as in `IsEValueUnder`),
valid since `e ≥ 0`.  `e_{τ+h-1}` is `eT … (τ ω + h - 1) ω` (value at the random index). -/
def P05Conclusion (S : ℝ → ℝ → ℝ) (h : ℕ) (ℱ : Filtration ℕ m0)
    (Y p q lam : ℕ → Ω → ℝ) (τ : Ω → ℕ) : Prop :=
  ∀ Q ∈ HScInt S h ℱ Y (fun _ _ => (1 : ℝ)) p q,
    ∫⁻ ω, ENNReal.ofReal (eT S h Y p q lam (τ ω + h - 1) ω) ∂Q ≤ 1

/-- (p) Consumed clause of the PROOF of P04 (not of its conclusion `P04Conclusion`), l.452:
"for `k = 1,…,h`, `(M^{[k]}_t)` is a nonnegative supermartingale w.r.t. `𝔉^{[k]}` for any
`Q ∈ ℋ_S`, and therefore `E_Q(M^{[k]}_{τ[k]}) ≤ 1` for any `𝔉^{[k]}`-stopping time `τ[k]`".  In the
P04 draft this is step `P04_S10` (supermartingale `P04_S9a-c` + optional stopping), `h > 1` only
(the source proof l.447 starts "Let `h > 1`").  Stated for `ℋ_S` as at l.452 (`HScInt` with `c ≡ 1`);
it is derivable from `P04_S10` by instantiating `c := 1`.  The applicability conditions of `P04_S10`
are inside the clause: mixture representation `T01.MixtureRep S ν` (TFA-2 of P04, supplied by `hrep`
of `P05_main`), SeqSetting, strict consistency, `h > 1`.  P04's own parameters (`P04_T01Consumed`,
`P04_MixingOfStrict`) are NOT repeated here: they are inherited through P04 at reconnection.
Stopping time: `{τ' ≤ t} ∈ 𝔉^{[k]}_t` for all `t` (`filtK`). -/
def P05_P04Consumed (S : ℝ → ℝ → ℝ) (ν : Measure ℝ) (h : ℕ) (ℱ : Filtration ℕ m0)
    (Y c p q lam : ℕ → Ω → ℝ) : Prop :=
  T01.MixtureRep S ν → SeqSetting ℱ Y c p q lam → IsStrictlyConsistent S → 1 < h →
    ∀ Q ∈ HScInt S h ℱ Y (fun _ _ => (1 : ℝ)) p q, ∀ k ∈ Finset.Icc 1 h, ∀ τ' : Ω → ℕ,
      (∀ t, MeasurableSet[filtK ℱ h k t] {ω | τ' ω ≤ t}) →
        ∫⁻ ω, ENNReal.ofReal (Mk S h Y p q lam k (τ' ω) ω) ∂Q ≤ 1

end Paper.P05
