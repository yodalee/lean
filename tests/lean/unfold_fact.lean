import data.nat
open nat

definition fact1 : nat → nat
| 0        := 1
| (succ a) := (succ a) * fact1 a

open tactic

example (a : nat) : fact1 a > 0 :=
by do
  -- fact1 should not be unfolded since argument is not 0 or succ
  unfold [`fact1],
  trace_state, trace "-------",
  get_local `a >>= λ H, induction_core semireducible H `nat.rec_on [`n, `iH],
  -- now it should unfold
  unfold [`fact1],
  swap,
  unfold [`fact1],
  trace_state,
  mk_const `mul_pos >>= apply,
  mk_const `nat.zero_lt_succ >>= apply,
  assumption,
  mk_const `zero_lt_one >>= apply