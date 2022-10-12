/-
  Section 7 : The littleendian function
  http://cr.yp.to/snuffle/spec.pdf
-/
import salsa20.words

-- If b = (b0, b1, b2, b3) then 
-- littleendian(b) = b0 + (2^8)*b1 + (2^16)*b2 + (2^24)*b3
def littleendian (b0 b1 b2 b3 : bitvec byte_len) : bitvec word_len := 
  bitvec.of_nat word_len (b0.to_nat + ((2^8) * b1.to_nat) + ((2^16) * b2.to_nat) + ((2^24) * b3.to_nat))

#check littleendian

#eval littleendian 0 0 0 0
#eval 0x00000000

lemma littleendian_zero : littleendian 0 0 0 0 = 0 := rfl

#eval bitvec.to_nat (littleendian 86 75 30 9)
#eval 0x091e4b56

#eval bitvec.to_nat (littleendian 255 255 255 250)
#eval 0xfaffffff

#eval bitvec.to_nat (littleendian 255 255 255 255)
#eval 0xffffffff

-- https://crypto.stackexchange.com/a/22314
def littleendian_inv (w : bitvec word_len) : list (bitvec byte_len) :=
  [
    bitvec.of_nat byte_len (bitvec.to_nat((bitvec.and w 0xff))),
    bitvec.of_nat byte_len (bitvec.to_nat(((bitvec.ushr w 8).and 0xff))),
    bitvec.of_nat byte_len (bitvec.to_nat(((bitvec.ushr w 16).and 0xff))), 
    bitvec.of_nat byte_len (bitvec.to_nat(((bitvec.ushr w 24).and 0xff)))
  ]

#eval littleendian_inv 0x00000000

#eval 0x091e4b56
#eval littleendian_inv 0x091e4b56
#eval (((littleendian_inv 0x091e4b56).nth 0).iget).to_nat
#eval (((littleendian_inv 0x091e4b56).nth 1).iget).to_nat
#eval (((littleendian_inv 0x091e4b56).nth 2).iget).to_nat
#eval (((littleendian_inv 0x091e4b56).nth 3).iget).to_nat

#eval littleendian_inv 0xfaffffff

lemma inv_undoes_littleendian (b0 b1 b2 b3 : bitvec byte_len) : 
  littleendian_inv (littleendian b0 b1 b2 b3) = 
    [b0, b1, b2, b3] :=
begin
  sorry,
end
