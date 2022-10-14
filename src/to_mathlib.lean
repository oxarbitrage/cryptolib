import data.bitvec.basic
import data.zmod.basic 
import group_theory.specific_groups.cyclic
import group_theory.subgroup.basic
import group_theory.subgroup.pointwise
import group_theory.order_of_element
import probability.probability_mass_function.basic
import probability.probability_mass_function.constructions
import probability.probability_mass_function.monad
import probability.probability_mass_function.uniform

/-
 ---------------------------------------------------------
  To multiset.range
 ---------------------------------------------------------
-/

lemma range_pos_ne_zero (n : ℕ) (n_pos : 0 < n): multiset.range n ≠ 0 := 
begin
  apply (multiset.card_pos).mp,
  rw multiset.card_range,
  exact n_pos,
end



/-
 ---------------------------------------------------------
  To group_theory.is_cyclic
 ---------------------------------------------------------
-/

def is_cyclic.generator {G : Type} [group G] [is_cyclic G] (g : G): Prop :=
   ∀ (x : G), x ∈ subgroup.zpowers g


/-
 ---------------------------------------------------------
  To bitvec.basic
 ---------------------------------------------------------
-/

namespace bitvec

instance fintype : Π (n : ℕ), fintype (bitvec n) := by {intro n, exact vector.fintype}

lemma card (n : ℕ) : fintype.card (bitvec n) = 2^n := card_vector n

lemma multiset_ne_zero (n : ℕ) : (bitvec.fintype n).elems.val ≠ 0 := 
begin
  apply (multiset.card_pos).mp,
  have h : multiset.card (fintype.elems (bitvec n)).val = 2^n := bitvec.card n,
  rw h,
  simp only [pow_pos, nat.succ_pos'],
end

-- missing bitvec lemmas used in streams ciphers. 
-- TODO: they need proof
variable n : ℕ
variables a b c : bitvec n

lemma add_self : a + a = bitvec.zero n := by sorry
lemma add_assoc : a + b + c = a + (b + c) := by sorry
lemma zero_add : a = bitvec.zero n + a := by sorry
lemma add_self_assoc : b = a + (a + b) :=
  by rw [←add_assoc, add_self, ←zero_add]

lemma add_comm : a + b = b + a := 
begin
  -- idea: convert a and b to ℕ and prove comm there
  have ha := bitvec.to_nat a,
  have hb := bitvec.to_nat b,
  sorry,
end

lemma add_assoc_self : b = a + b + a :=
  by rw [add_comm, ←add_assoc, add_self, ←zero_add]

lemma add_assoc_self_reduce : c = a + (b + (a + (b + c))) :=
begin
  rw [←add_assoc, ←add_assoc, ←add_assoc],
  rw [←add_assoc_self, add_self, ←zero_add],
end

def to_list (length: ℕ) (B : bitvec length) : list bool := 
  vector.to_list B


end bitvec 


/-
 ---------------------------------------------------------
  To data.basic.zmod, TO-DO Ask why this isn't already there
 ---------------------------------------------------------
-/

namespace zmod 

instance group : Π (n : ℕ) [fact (0 < n)], group (zmod n) := 
  by {intros n h, exact multiplicative.group}

end zmod 



/-
 ---------------------------------------------------------
  To nat
 ---------------------------------------------------------
-/

lemma exists_mod_add_div (a b: ℕ) : ∃ (m : ℕ), a = a % b + b * m := 
begin
  use (a/b),
  exact (nat.mod_add_div a b).symm,
end



/-
 ---------------------------------------------------------
  To group
 ---------------------------------------------------------
-/

variables (G : Type) [fintype G] [group G]

namespace group

lemma multiset_ne_zero : (fintype.elems G).val ≠ 0 := 
begin
  have e : G := (_inst_2.one),
  have h1 : e ∈ (fintype.elems G).val :=  finset.mem_univ e,
  have h2 : 0 < multiset.card (fintype.elems G).val := 
  begin
    apply (multiset.card_pos_iff_exists_mem).mpr,
    exact Exists.intro e h1,
  end,
  exact multiset.card_pos.mp h2,
end

end group 

/-
 ---------------------------------------------------------
  To list
 ---------------------------------------------------------
-/

namespace list

-- Given a list `l`, where each element is of type 
-- `bitvec` of a given length `len`, convert this to a
-- `vector`, truncating the list at `len_vec` elements. 
def to_vec_of_bitvec 
  (len_bitvec : ℕ) (len_vec: ℕ) (l : list (bitvec len_bitvec)) : 
  vector (bitvec len_bitvec ) len_vec :=
    ⟨list.take' len_vec l, list.take'_length len_vec l⟩ 

end list
