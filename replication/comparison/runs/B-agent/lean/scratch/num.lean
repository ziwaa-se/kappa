-- Numerical check of Example 2.6: hazard condition r(x) ≤ 1/x  ⇔  g_b(x) ≤ 1, where
-- g_b(x) = (b-1) x^b log(1+x) + x^(b+1)/(1+x)
def g (b x : Float) : Float := (b-1) * x^b * Float.log (1+x) + x^(b+1)/(1+x)

def maxg (b : Float) : Float := Id.run do
  let mut m : Float := -1e9
  for k in [0:6000] do
    let x := Float.pow 10.0 ((k.toFloat - 2400.0)/400.0)
    let v := g b x
    if v > m then m := v
  return m

#eval [0.5, 0.6, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95].map fun b => (b, maxg b)
