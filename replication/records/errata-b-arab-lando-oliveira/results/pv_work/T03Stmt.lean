import T01Stmt
import P04Stmt

/-!
# T03 statement definitions (Theorem 4.8, label cor:inclusion)
Source: source/SuperParetoPaper-v12.tex:332-335 (statement), 336-338 (proof).
No sorry, no theorems. Names of other results are always qualified (`Paper.P04.F` and
`Paper.L01.F` are different definitions of the same cdf).
-/

namespace Paper.T03

open MeasureTheory

/-- "Nonnegative" random variable (source :334): its law `μ` gives no mass to `(-∞,0)`.
Note: this does not exclude an atom at `0`, whereas `IsInvSub` (Def 2.2, :122-124) requires
`F_X(0)=0`; see notes (suspected PAPER_ASSUMPTION_GAP). -/
def Nonneg (μ : Measure ℝ) : Prop := μ (Set.Iio 0) = 0

/-- Law of `Y = Z - 1` where `F_Z = 𝒫` (source :337); `Z` has law `Paper.P04.paretoMeasure`. -/
noncomputable def lawY : Measure ℝ := Paper.P04.paretoMeasure.map (fun z => z - 1)

/-- Consumed clause, provenance (p) (and (iv): T01 is ISSUE; Thm 2.8 is false as printed, not
repaired). Location in T01: Theorem 2.8 (source :169-172, `thm:inclusion`), main theorem
`T01_main` of T01Draft. Specialised to the single application the source makes at :337:
the ITS variable is `Y` (law `lawY`) and `h` is continuous star-shaped. Applicability: `h`
star-shaped and continuous (the source asserts star-shapedness only; continuity is silently
needed, obligation S4), `Y` ITS is obligation S5. The T01 external input `T01_X02Tool` and
`T01_L01Consumed` are inside T01's proof, not needed here. -/
def T03_T01Consumed : Prop :=
  ∀ g : ℝ → ℝ, Continuous g → Paper.T01.StarShaped g →
    Paper.L01.IsInvSub lawY → Paper.L01.IsInvSub (lawY.map g)

end Paper.T03
