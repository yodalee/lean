/-
Copyright (c) 2014 Robert Lewis. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Robert Lewis
-/
import algebra.ordered_ring algebra.field
open eq

structure linear_ordered_field [class] (A : Type) extends linear_ordered_ring A, field A

section linear_ordered_field

  variable {A : Type}
  variables [s : linear_ordered_field A] {a b c d : A}
  include s

  -- helpers for following
  theorem mul_zero_lt_mul_inv_of_pos (H : 0 < a) : a * 0 < a * (1 / a) :=
  sorry
  /-
   calc
      a * 0 = 0           : by rewrite mul_zero
        ... < 1           : !zero_lt_one
        ... = a * a⁻¹     : eq.symm (mul_inv_cancel (ne.symm (ne_of_lt H)))
        ... = a * (1 / a) : by rewrite inv_eq_one_div
  -/
  theorem mul_zero_lt_mul_inv_of_neg (H : a < 0) : a * 0 < a * (1 / a) :=
  sorry
  /-
    calc
      a * 0 = 0           : by rewrite mul_zero
        ... < 1           : !zero_lt_one
        ... = a * a⁻¹     : eq.symm (mul_inv_cancel (ne_of_lt H))
        ... = a * (1 / a) : by rewrite inv_eq_one_div
  -/

  theorem one_div_pos_of_pos (H : 0 < a) : 0 < 1 / a :=
    lt_of_mul_lt_mul_left (mul_zero_lt_mul_inv_of_pos H) (le_of_lt H)

  theorem one_div_neg_of_neg (H : a < 0) : 1 / a < 0 :=
    gt_of_mul_lt_mul_neg_left (mul_zero_lt_mul_inv_of_neg H) (le_of_lt H)


  theorem le_mul_of_ge_one_right (Hb : b ≥ 0) (H : a ≥ 1) : b ≤ b * a :=
      mul_one _ ▸ (mul_le_mul_of_nonneg_left H Hb)

  theorem lt_mul_of_gt_one_right (Hb : b > 0) (H : a > 1) : b < b * a :=
      mul_one _ ▸ (mul_lt_mul_of_pos_left H Hb)

  theorem one_le_div_iff_le (a : A) {b : A} (Hb : b > 0) : 1 ≤ a / b ↔ b ≤ a :=
    have Hb' : b ≠ 0, from ne.symm (ne_of_lt Hb),
    iff.intro
    (assume H : 1 ≤ a / b,
      calc
        b   = b           : rfl
        ... ≤ b * (a / b) : le_mul_of_ge_one_right (le_of_lt Hb) H
        ... = a           : mul_div_cancel' Hb')
    (assume H : b ≤ a,
      have Hbinv : 1 / b > 0, from  one_div_pos_of_pos Hb, calc
        1  = b * (1 / b) : eq.symm (mul_one_div_cancel Hb')
       ... ≤ a * (1 / b) : mul_le_mul_of_nonneg_right H (le_of_lt Hbinv)
       ... = a / b       : eq.symm $ div_eq_mul_one_div a b)

  theorem le_of_one_le_div (Hb : b > 0) (H : 1 ≤ a / b) : b ≤ a :=
  iff.mp (one_le_div_iff_le a Hb) H

  theorem one_le_div_of_le (Hb : b > 0) (H : b ≤ a) : 1 ≤ a / b :=
  iff.mpr (one_le_div_iff_le a Hb) H

  theorem one_lt_div_iff_lt (a : A) {b : A} (Hb : b > 0) : 1 < a / b ↔ b < a :=
  have Hb' : b ≠ 0, from ne.symm (ne_of_lt Hb),
  iff.intro
    (assume H : 1 < a / b,
      calc
        b   < b * (a / b) : lt_mul_of_gt_one_right Hb H
        ... = a           : mul_div_cancel' Hb')
    (assume H : b < a,
      have Hbinv : 1 / b > 0, from  one_div_pos_of_pos Hb, calc
        1 = b * (1 / b) : eq.symm (mul_one_div_cancel Hb')
      ... < a * (1 / b) : mul_lt_mul_of_pos_right H Hbinv
      ... = a / b       : eq.symm $ div_eq_mul_one_div a b)

  theorem lt_of_one_lt_div (Hb : b > 0) (H : 1 < a / b) : b < a :=
  iff.mp (one_lt_div_iff_lt a Hb) H

  theorem one_lt_div_of_lt (Hb : b > 0) (H : b < a) : 1 < a / b :=
  iff.mpr (one_lt_div_iff_lt a Hb) H

  theorem exists_lt (a : A) : ∃ x, x < a :=
  have H : a - 1 < a, from add_lt_of_le_of_neg (le.refl _) zero_gt_neg_one,
  exists.intro _ H

  theorem exists_gt (a : A) : ∃ x, x > a :=
  have H : a + 1 > a, from lt_add_of_le_of_pos (le.refl _) zero_lt_one,
  exists.intro _ H

  -- the following theorems amount to four iffs, for <, ≤, ≥, >.

  theorem mul_le_of_le_div (Hc : 0 < c) (H : a ≤ b / c) : a * c ≤ b :=
  div_mul_cancel b (ne.symm (ne_of_lt Hc)) ▸ mul_le_mul_of_nonneg_right H (le_of_lt Hc)

  theorem le_div_of_mul_le (Hc : 0 < c) (H : a * c ≤ b) : a ≤ b / c :=
  calc
      a   = a * c * (1 / c) : mul_mul_div a (ne.symm (ne_of_lt Hc))
      ... ≤ b * (1 / c)     : mul_le_mul_of_nonneg_right H (le_of_lt (one_div_pos_of_pos Hc))
      ... = b / c           : eq.symm $ div_eq_mul_one_div b c

  theorem mul_lt_of_lt_div (Hc : 0 < c) (H : a < b / c) : a * c < b :=
  div_mul_cancel b (ne.symm (ne_of_lt Hc)) ▸ mul_lt_mul_of_pos_right H Hc

  theorem lt_div_of_mul_lt (Hc : 0 < c) (H : a * c < b) : a < b / c :=
  calc
      a   = a * c * (1 / c) : mul_mul_div a (ne.symm (ne_of_lt Hc))
      ... < b * (1 / c)     : mul_lt_mul_of_pos_right H (one_div_pos_of_pos Hc)
      ... = b / c           : eq.symm $ div_eq_mul_one_div b c

  theorem mul_le_of_div_le_of_neg (Hc : c < 0) (H : b / c ≤ a) : a * c ≤ b :=
  div_mul_cancel b (ne_of_lt Hc) ▸ mul_le_mul_of_nonpos_right H (le_of_lt Hc)

  theorem div_le_of_mul_le_of_neg (Hc : c < 0) (H : a * c ≤ b) : b / c ≤ a :=
  calc
      a   = a * c * (1 / c) : mul_mul_div a (ne_of_lt Hc)
      ... ≥ b * (1 / c)     : mul_le_mul_of_nonpos_right H (le_of_lt (one_div_neg_of_neg Hc))
      ... = b / c           : eq.symm $ div_eq_mul_one_div b c

  theorem mul_lt_of_gt_div_of_neg (Hc : c < 0) (H : a > b / c) : a * c < b :=
  div_mul_cancel b (ne_of_lt Hc) ▸ mul_lt_mul_of_neg_right H Hc

  theorem div_lt_of_mul_lt_of_pos (Hc : c > 0) (H : b < a * c) : b / c < a :=
  calc
      a   = a * c * (1 / c) : mul_mul_div a (ne_of_gt Hc)
      ... > b * (1 / c)     : mul_lt_mul_of_pos_right H (one_div_pos_of_pos Hc)
      ... = b / c           : eq.symm $ div_eq_mul_one_div b c

  theorem div_lt_of_mul_gt_of_neg (Hc : c < 0) (H : a * c < b) : b / c < a :=
    calc
      a   = a * c * (1 / c) : mul_mul_div a (ne_of_lt Hc)
      ... > b * (1 / c)     : mul_lt_mul_of_neg_right H (one_div_neg_of_neg Hc)
      ... = b / c           : eq.symm $ div_eq_mul_one_div b c

  theorem div_le_of_le_mul (Hb : b > 0) (H : a ≤ b * c) : a / b ≤ c :=
    calc
      a / b = a * (1 / b)       : div_eq_mul_one_div a b
        ... ≤ (b * c) * (1 / b) : mul_le_mul_of_nonneg_right H (le_of_lt (one_div_pos_of_pos Hb))
        ... = (b * c) / b       : eq.symm $ div_eq_mul_one_div (b * c) b
        ... = c                 : mul_div_cancel_left (ne.symm (ne_of_lt Hb))

  theorem le_mul_of_div_le (Hc : c > 0) (H : a / c ≤ b) : a ≤ b * c :=
  sorry
  /-
    calc
      a = a / c * c : by rewrite (!div_mul_cancel (ne.symm (ne_of_lt Hc)))
    ... ≤ b * c     : mul_le_mul_of_nonneg_right H (le_of_lt Hc)
  -/

  -- following these in the isabelle file, there are 8 biconditionals for the above with - signs
  -- skipping for now

  theorem mul_sub_mul_div_mul_neg (Hc : c ≠ 0) (Hd : d ≠ 0) (H : a / c < b / d) :
      (a * d - b * c) / (c * d) < 0 :=
  sorry
  /-
    have H1 : a / c - b / d < 0, from calc
      a / c - b / d < b / d - b / d : sub_lt_sub_right H _
      ... = 0                       : !sub_self,
    calc
      0 > a / c - b / d : H1
      ... = (a * d - c * b) / (c * d) : !div_sub_div Hc Hd
      ... = (a * d - b * c) / (c * d) : by rewrite (mul.comm b c)
  -/
  theorem mul_sub_mul_div_mul_nonpos (Hc : c ≠ 0) (Hd : d ≠ 0) (H : a / c ≤ b / d) :
      (a * d - b * c) / (c * d) ≤ 0 :=
  sorry
  /-
    have H1 : a / c - b / d ≤ 0, from calc
      a / c - b / d ≤ b / d - b / d : sub_le_sub_right H _
                ... = 0             : !sub_self,
    calc
      0 ≥ a / c - b / d : H1
      ... = (a * d - c * b) / (c * d) : !div_sub_div Hc Hd
      ... = (a * d - b * c) / (c * d) : by rewrite (mul.comm b c)
  -/

  theorem div_lt_div_of_mul_sub_mul_div_neg (Hc : c ≠ 0) (Hd : d ≠ 0)
      (H : (a * d - b * c) / (c * d) < 0) : a / c < b / d :=
  sorry
  /-
    have H1 : (a * d - c * b) / (c * d) < 0,     by rewrite [mul.comm c b]; exact H,
    have H2 : a / c - b / d < 0,                 by rewrite [!div_sub_div Hc Hd]; exact H1,
    have H3 : a / c - b / d + b / d < 0 + b / d, from add_lt_add_right H2 _,
    begin rewrite [zero_add at H3, sub_eq_add_neg at H3, neg_add_cancel_right at H3], exact H3 end
  -/

  theorem div_le_div_of_mul_sub_mul_div_nonpos (Hc : c ≠ 0) (Hd : d ≠ 0)
      (H : (a * d - b * c) / (c * d) ≤ 0) : a / c ≤ b / d :=
  sorry
  /-
    have H1 : (a * d - c * b) / (c * d) ≤ 0,     by rewrite [mul.comm c b]; exact H,
    have H2 : a / c - b / d ≤ 0,                 by rewrite [!div_sub_div Hc Hd]; exact H1,
    have H3 : a / c - b / d + b / d ≤ 0 + b / d, from add_le_add_right H2 _,
    begin rewrite [zero_add at H3, sub_eq_add_neg at H3, neg_add_cancel_right at H3], exact H3 end
  -/

  theorem div_pos_of_pos_of_pos (Ha : 0 < a) (Hb : 0 < b) : 0 < a / b :=
  sorry
  /-
    begin
      rewrite div_eq_mul_one_div,
      apply mul_pos,
      exact Ha,
      apply one_div_pos_of_pos,
      exact Hb
    end
  -/

  theorem div_nonneg_of_nonneg_of_pos (Ha : 0 ≤ a) (Hb : 0 < b) : 0 ≤ a / b :=
  sorry
  /-
    begin
      rewrite div_eq_mul_one_div,
      apply mul_nonneg,
      exact Ha,
      apply le_of_lt,
      apply one_div_pos_of_pos,
      exact Hb
    end
  -/

  theorem div_neg_of_neg_of_pos (Ha : a < 0) (Hb : 0 < b) : a / b < 0:=
  sorry
  /-
    begin
      rewrite div_eq_mul_one_div,
      apply mul_neg_of_neg_of_pos,
      exact Ha,
      apply one_div_pos_of_pos,
      exact Hb
    end
  -/

  theorem div_nonpos_of_nonpos_of_pos (Ha : a ≤ 0) (Hb : 0 < b) : a / b ≤ 0 :=
  sorry
  /-
    begin
      rewrite div_eq_mul_one_div,
      apply mul_nonpos_of_nonpos_of_nonneg,
      exact Ha,
      apply le_of_lt,
      apply one_div_pos_of_pos,
      exact Hb
    end
  -/

  theorem div_neg_of_pos_of_neg (Ha : 0 < a) (Hb : b < 0) : a / b < 0 :=
  sorry
  /-
    begin
      rewrite div_eq_mul_one_div,
      apply mul_neg_of_pos_of_neg,
      exact Ha,
      apply one_div_neg_of_neg,
      exact Hb
    end
  -/

  theorem div_nonpos_of_nonneg_of_neg (Ha : 0 ≤ a) (Hb : b < 0) :  a / b ≤ 0 :=
  sorry
  /-
    begin
      rewrite div_eq_mul_one_div,
      apply mul_nonpos_of_nonneg_of_nonpos,
      exact Ha,
      apply le_of_lt,
      apply one_div_neg_of_neg,
      exact Hb
    end
  -/

  theorem div_pos_of_neg_of_neg (Ha : a < 0) (Hb : b < 0) : 0 < a / b :=
  sorry
  /-
    begin
      rewrite div_eq_mul_one_div,
      apply mul_pos_of_neg_of_neg,
      exact Ha,
      apply one_div_neg_of_neg,
      exact Hb
    end
  -/

  theorem div_nonneg_of_nonpos_of_neg (Ha : a ≤ 0) (Hb : b < 0) : 0 ≤ a / b :=
  sorry
  /-
    begin
      rewrite div_eq_mul_one_div,
      apply mul_nonneg_of_nonpos_of_nonpos,
      exact Ha,
      apply le_of_lt,
      apply one_div_neg_of_neg,
      exact Hb
    end
  -/

  theorem div_lt_div_of_lt_of_pos (H : a < b) (Hc : 0 < c) : a / c < b / c :=
  sorry
  /-
  begin
    rewrite [{a/c}div_eq_mul_one_div, {b/c}div_eq_mul_one_div],
    exact mul_lt_mul_of_pos_right H (one_div_pos_of_pos Hc)
  end
  -/

  theorem div_le_div_of_le_of_pos (H : a ≤ b) (Hc : 0 < c) : a / c ≤ b / c :=
  sorry
  /-
    begin
      rewrite [{a/c}div_eq_mul_one_div, {b/c}div_eq_mul_one_div],
      exact mul_le_mul_of_nonneg_right H (le_of_lt (one_div_pos_of_pos Hc))
    end
  -/

  theorem div_lt_div_of_lt_of_neg (H : b < a) (Hc : c < 0) : a / c < b / c :=
  sorry
  /-
  begin
    rewrite [{a/c}div_eq_mul_one_div, {b/c}div_eq_mul_one_div],
    exact mul_lt_mul_of_neg_right H (one_div_neg_of_neg Hc)
  end
  -/

  theorem div_le_div_of_le_of_neg (H : b ≤ a) (Hc : c < 0) : a / c ≤ b / c :=
  sorry
  /-
  begin
    rewrite [{a/c}div_eq_mul_one_div, {b/c}div_eq_mul_one_div],
    exact mul_le_mul_of_nonpos_right H (le_of_lt (one_div_neg_of_neg Hc))
  end
  -/

  theorem two_pos : (1 : A) + 1 > 0 :=
    add_pos zero_lt_one zero_lt_one

  theorem one_add_one_ne_zero : 1 + 1 ≠ (0:A) :=
  ne.symm (ne_of_lt two_pos)

  theorem two_ne_zero : 2 ≠ (0:A) :=
  sorry -- by unfold bit0; apply one_add_one_ne_zero

  theorem add_halves (a : A) : a / 2 + a / 2 = a :=
  sorry
  /-
    calc
      a / 2 + a / 2 = (a + a) / 2 : by rewrite div_add_div_same
      ... = (a * 1 + a * 1) / 2   : by rewrite mul_one
      ... = (a * (1 + 1)) / 2     : by rewrite left_distrib
      ... = (a * 2) / 2           : by rewrite one_add_one_eq_two
      ... = a                     : by rewrite [@mul_div_cancel A _ _ _ two_ne_zero]
  -/

  theorem sub_self_div_two (a : A) : a - a / 2 = a / 2 :=
  sorry -- by rewrite [-{a}add_halves at {1}, add_sub_cancel]

  theorem add_midpoint {a b : A} (H : a < b) : a + (b - a) / 2 < b :=
  sorry
  /-
  begin
    rewrite [-div_sub_div_same, sub_eq_add_neg, {b / 2 + _}add.comm, -add.assoc, -sub_eq_add_neg],
    apply add_lt_of_lt_sub_right,
    rewrite *sub_self_div_two,
    apply div_lt_div_of_lt_of_pos H two_pos
  end
  -/

  theorem div_two_sub_self (a : A) : a / 2 - a = - (a / 2) :=
  sorry -- by rewrite [-{a}add_halves at {2}, sub_add_eq_sub_sub, sub_self, zero_sub]

  theorem add_self_div_two (a : A) : (a + a) / 2 = a :=
  sorry
  /-
  symm (iff.mpr (!eq_div_iff_mul_eq (ne_of_gt (add_pos zero_lt_one zero_lt_one)))
       (by krewrite [left_distrib, *mul_one]))
  -/

  theorem two_gt_one : (2:A) > 1 :=
  calc (2:A) = 1+1 : one_add_one_eq_two
       ...   > 1+0 : add_lt_add_left zero_lt_one _
       ...   = 1   : add_zero 1

  theorem two_ge_one : (2:A) ≥ 1 :=
  le_of_lt two_gt_one

  theorem four_pos : (4 : A) > 0 := add_pos two_pos two_pos

  theorem mul_le_mul_of_mul_div_le (H : a * (b / c) ≤ d) (Hc : c > 0) : b * a ≤ d * c :=
  sorry
  /-
  begin
    rewrite [-mul_div_assoc at H, mul.comm b],
    apply le_mul_of_div_le Hc H
  end
  -/

  theorem div_two_lt_of_pos (H : a > 0) : a / (1 + 1) < a :=
  have Ha : a / (1 + 1) > 0, from div_pos_of_pos_of_pos H (add_pos zero_lt_one zero_lt_one),
  calc
      a / (1 + 1) < a / (1 + 1) + a / (1 + 1) : lt_add_of_pos_left Ha
              ... = a                         : add_halves a

  theorem div_mul_le_div_mul_of_div_le_div_pos {e : A} (Hb : b ≠ 0) (Hd : d ≠ 0) (H : a / b ≤ c / d)
          (He : e > 0) : a / (b * e) ≤ c / (d * e) :=
  sorry
  /-
    begin
      rewrite [!field.div_mul_eq_div_mul_one_div Hb (ne_of_gt He),
               !field.div_mul_eq_div_mul_one_div Hd (ne_of_gt He)],
      apply mul_le_mul_of_nonneg_right H,
      apply le_of_lt,
      apply one_div_pos_of_pos He
    end
  -/

  theorem exists_add_lt_and_pos_of_lt (H : b < a) : ∃ c : A, b + c < a ∧ c > 0 :=
  sorry
  /-
  exists.intro ((a - b) / (1 + 1))
      (and.intro (have H2 : a + a > (b + b) + (a - b), from calc
        a + a > b + a       : add_lt_add_right H _
        ... = b + a + b - b : by rewrite add_sub_cancel
        ... = b + b + a - b : by rewrite add.right_comm
        ... = (b + b) + (a - b) : by rewrite add_sub,
      have H3 : (a + a) / 2 > ((b + b) + (a - b)) / 2,
        from div_lt_div_of_lt_of_pos H2 two_pos,
      by rewrite [one_add_one_eq_two, sub_eq_add_neg, add_self_div_two at H3, -div_add_div_same at H3, add_self_div_two at H3];
           exact H3)
      (div_pos_of_pos_of_pos (iff.mpr !sub_pos_iff_lt H) two_pos))
  -/

  theorem ge_of_forall_ge_sub {a b : A} (H : ∀ ε : A, ε > 0 → a ≥ b - ε) : a ≥ b :=
  sorry
  /-
  begin
    apply le_of_not_gt,
    intro Hb,
    cases exists_add_lt_and_pos_of_lt Hb with [c, Hc],
    let Hc' := H c (and.right Hc),
    apply (not_le_of_gt (and.left Hc)) (iff.mpr !le_add_iff_sub_right_le Hc')
  end
  -/

end linear_ordered_field

structure discrete_linear_ordered_field [class] (A : Type) extends linear_ordered_field A,
  decidable_linear_ordered_comm_ring A :=
  (inv_zero : inv zero = zero)

section discrete_linear_ordered_field

  variable {A : Type}
  variables [s : discrete_linear_ordered_field A] {a b c : A}
  include s

  definition dec_eq_of_dec_lt : ∀ x y : A, decidable (x = y) :=
    take x y,
    decidable.by_cases
    (assume H : x < y, decidable.ff (ne_of_lt H))
    (assume H : ¬ x < y,
      decidable.by_cases
      (assume H' : y < x, decidable.ff (ne.symm (ne_of_lt H')))
      (assume H' : ¬ y < x,
        decidable.tt (le.antisymm (le_of_not_gt H') (le_of_not_gt H))))

  attribute [instance]
  definition discrete_linear_ordered_field.to_discrete_field :  discrete_field A :=
     ⦃ discrete_field, s, has_decidable_eq := dec_eq_of_dec_lt⦄

    theorem pos_of_one_div_pos (H : 0 < 1 / a) : 0 < a :=
    have H1 : 0 < 1 / (1 / a), from one_div_pos_of_pos H,
    have H2 : 1 / a ≠ 0, from
      (assume H3 : 1 / a = 0,
      have H4 : 1 / (1 / a) = 0, from symm H3 ▸ div_zero 1,
      absurd H4 (ne.symm (ne_of_lt H1))),
    (division_ring.one_div_one_div (ne_zero_of_one_div_ne_zero H2)) ▸ H1

  theorem neg_of_one_div_neg (H : 1 / a < 0) : a < 0 :=
    have H1 : 0 < - (1 / a), from neg_pos_of_neg H,
    have Ha : a ≠ 0, from ne_zero_of_one_div_ne_zero (ne_of_lt H),
    have H2 : 0 < 1 / (-a), from symm (division_ring.one_div_neg_eq_neg_one_div Ha) ▸ H1,
    have H3 : 0 < -a, from pos_of_one_div_pos H2,
    neg_of_neg_pos H3

  theorem le_of_one_div_le_one_div (H : 0 < a) (Hl : 1 / a ≤ 1 / b) : b ≤ a :=
    have Hb : 0 < b, from pos_of_one_div_pos (calc
      0   < 1 / a : one_div_pos_of_pos H
      ... ≤ 1 / b : Hl),
    have H' : 1 ≤ a / b, from (calc
      1   = a / a       : eq.symm (div_self (ne.symm (ne_of_lt H)))
      ... = a * (1 / a) : div_eq_mul_one_div a a
      ... ≤ a * (1 / b) : mul_le_mul_of_nonneg_left Hl (le_of_lt H)
      ... = a / b       : eq.symm $ div_eq_mul_one_div a b
      ), le_of_one_le_div Hb H'

  theorem le_of_one_div_le_one_div_of_neg (H : b < 0) (Hl : 1 / a ≤ 1 / b) : b ≤ a :=
  sorry
  /-
    have Ha : a ≠ 0, from ne_of_lt (neg_of_one_div_neg (calc
      1 / a ≤ 1 / b : Hl
        ... < 0     : one_div_neg_of_neg H)),
    have H'   : -b > 0,                from neg_pos_of_neg H,
    have Hl'  : - (1 / b) ≤ - (1 / a), from neg_le_neg Hl,
    have Hl'' : 1 / - b ≤ 1 / - a,     from calc
      1 / -b = - (1 / b) : by rewrite [division_ring.one_div_neg_eq_neg_one_div (ne_of_lt H)]
         ... ≤ - (1 / a) : Hl'
         ... = 1 / -a    : by rewrite [division_ring.one_div_neg_eq_neg_one_div Ha],
    le_of_neg_le_neg (le_of_one_div_le_one_div H' Hl'')
  -/

  theorem lt_of_one_div_lt_one_div (H : 0 < a) (Hl : 1 / a < 1 / b) : b < a :=
    have Hb : 0 < b, from pos_of_one_div_pos (calc
      0   < 1 / a : one_div_pos_of_pos H
      ... < 1 / b : Hl),
    have H : 1 < a / b, from (calc
      1   = a / a       : eq.symm (div_self (ne.symm (ne_of_lt H)))
      ... = a * (1 / a) : div_eq_mul_one_div a a
      ... < a * (1 / b) : mul_lt_mul_of_pos_left Hl H
      ... = a / b       : eq.symm $ div_eq_mul_one_div a b),
      lt_of_one_lt_div Hb H

  theorem lt_of_one_div_lt_one_div_of_neg (H : b < 0) (Hl : 1 / a < 1 / b) : b < a :=
    have H1 : b ≤ a, from le_of_one_div_le_one_div_of_neg H (le_of_lt Hl),
    have Hn : b ≠ a, from
      (assume Hn' : b = a,
      have Hl' : 1 / a = 1 / b, from Hn' ▸ refl _,
      absurd Hl' (ne_of_lt Hl)),
    lt_of_le_of_ne H1 Hn

  theorem one_div_lt_one_div_of_lt (Ha : 0 < a) (H : a < b) : 1 / b < 1 / a :=
    lt_of_not_ge
      (assume H',
      absurd H (not_lt_of_ge (le_of_one_div_le_one_div Ha H')))

  theorem one_div_le_one_div_of_le (Ha : 0 < a) (H : a ≤ b) : 1 / b ≤ 1 / a :=
    le_of_not_gt
      (assume H',
      absurd H (not_le_of_gt (lt_of_one_div_lt_one_div Ha H')))

  theorem one_div_lt_one_div_of_lt_of_neg (Hb : b < 0) (H : a < b) : 1 / b < 1 / a :=
    lt_of_not_ge
      (assume H',
      absurd H (not_lt_of_ge (le_of_one_div_le_one_div_of_neg Hb H')))

  theorem one_div_le_one_div_of_le_of_neg (Hb : b < 0) (H : a ≤ b) : 1 / b ≤ 1 / a :=
    le_of_not_gt
      (assume H',
      absurd H (not_le_of_gt (lt_of_one_div_lt_one_div_of_neg Hb H')))

  theorem one_div_le_of_one_div_le_of_pos (Ha : a > 0) (H : 1 / a ≤ b) : 1 / b ≤ a :=
  sorry
  /-
    begin
      rewrite -(one_div_one_div a),
      apply one_div_le_one_div_of_le,
      apply one_div_pos_of_pos,
      repeat assumption
    end
  -/

  theorem one_div_le_of_one_div_le_of_neg (Ha : b < 0) (H : 1 / a ≤ b) : 1 / b ≤ a :=
  sorry
  /-
    begin
      rewrite -(one_div_one_div a),
      apply one_div_le_one_div_of_le_of_neg,
      repeat assumption
    end
  -/

  theorem one_lt_one_div (H1 : 0 < a) (H2 : a < 1) : 1 < 1 / a :=
    one_div_one ▸ one_div_lt_one_div_of_lt H1 H2

  theorem one_le_one_div (H1 : 0 < a) (H2 : a ≤ 1) : 1 ≤ 1 / a :=
    one_div_one ▸ one_div_le_one_div_of_le H1 H2

  theorem one_div_lt_neg_one (H1 : a < 0) (H2 : -1 < a) : 1 / a < -1 :=
    one_div_neg_one_eq_neg_one ▸ one_div_lt_one_div_of_lt_of_neg H1 H2

  theorem one_div_le_neg_one (H1 : a < 0) (H2 : -1 ≤ a) : 1 / a ≤ -1 :=
    one_div_neg_one_eq_neg_one ▸ one_div_le_one_div_of_le_of_neg H1 H2

  theorem div_lt_div_of_pos_of_lt_of_pos (Hb : 0 < b) (H : b < a) (Hc : 0 < c) : c / a < c / b :=
  sorry
  /-
    begin
      apply iff.mp !sub_neg_iff_lt,
      rewrite [div_eq_mul_one_div, {c / b}div_eq_mul_one_div, -mul_sub_left_distrib],
      apply mul_neg_of_pos_of_neg,
      exact Hc,
      apply iff.mpr !sub_neg_iff_lt,
      apply one_div_lt_one_div_of_lt,
      repeat assumption
    end
  -/

  theorem div_mul_le_div_mul_of_div_le_div_pos' {d e : A} (H : a / b ≤ c / d)
          (He : e > 0) : a / (b * e) ≤ c / (d * e) :=
  sorry
  /-
    begin
      rewrite [2 div_mul_eq_div_mul_one_div],
      apply mul_le_mul_of_nonneg_right H,
      apply le_of_lt,
      apply one_div_pos_of_pos He
    end
  -/

  theorem abs_div (a b : A) : abs (a / b) = abs a / abs b :=
  sorry
  /-
  decidable.by_cases
    (suppose b = 0, by rewrite [this, abs_zero, *div_zero, abs_zero])
    (suppose b ≠ 0,
      have abs b ≠ 0, from assume H, this (eq_zero_of_abs_eq_zero H),
      eq_div_of_mul_eq _ _ this
        (show abs (a / b) * abs b = abs a, by rewrite [-abs_mul, div_mul_cancel _ `b ≠ 0`]))
  -/

  theorem abs_one_div (a : A) : abs (1 / a) = 1 / abs a :=
  sorry -- by rewrite [abs_div, abs_of_nonneg (zero_le_one : 1 ≥ (0 : A))]

  theorem sign_eq_div_abs (a : A) : sign a = a / (abs a) :=
  sorry
  /-
  decidable.by_cases
    (suppose a = 0, by subst a; rewrite [zero_div, sign_zero])
    (suppose a ≠ 0,
      have abs a ≠ 0, from assume H, this (eq_zero_of_abs_eq_zero H),
      !eq_div_of_mul_eq this !eq_sign_mul_abs⁻¹)
  -/

  theorem add_quarters (a : A) : a / 4 + a / 4 = a / 2 :=
  sorry
  /-
    have H4 : (4 : A) = 2 * 2, by norm_num,
    calc
      a / 4 + a / 4 = (a + a) / (2 * 2)         : by rewrite [-H4, div_add_div_same]
                ... = (a * 1 + a * 1) / (2 * 2) : by rewrite mul_one
                ... = (a * (1 + 1)) / (2 * 2)   : by rewrite left_distrib
                ... = (a * 2) / (2 * 2)         : rfl
                ... = ((a * 2) / 2) / 2         : by rewrite -div_div_eq_div_mul
                ... = a / 2                     : by rewrite (mul_div_cancel a two_ne_zero)
  -/

  lemma div_two_add_div_four_lt {a : A} (H : a > 0) : a / 2 + a / 4 < a :=
  sorry
  /-
  begin
    replace (4 : A) with (2 : A) + 2,
    have Hne : (2 + 2 : A) ≠ 0, from ne_of_gt four_pos,
    krewrite (div_add_div _ _ two_ne_zero Hne),
    have Hnum : (2 + 2 + 2) / (2 * (2 + 2)) = (3 : A) / 4, by norm_num,
    rewrite [{2 * a}mul.comm, -left_distrib, mul_div_assoc, -mul_one a at {2}], krewrite Hnum,
    apply mul_lt_mul_of_pos_left,
    apply div_lt_of_mul_lt_of_pos,
    apply four_pos,
    rewrite one_mul,
    replace (3 : A) with (2 : A) + 1,
    replace (4 : A) with (2 : A) + 2,
    apply add_lt_add_left,
    apply two_gt_one,
    exact H
  end
  -/
end discrete_linear_ordered_field
