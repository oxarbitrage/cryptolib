/-
  Examples from the spec http://cr.yp.to/snuffle/spec.pdf for each section:
  - Section 2 : Words
  - Section 3 : The quarterround function
  - Section 4 : The rowround function
  - Section 5 : The columnrow function
  - Section 6 : The doubleround function
  - Section 7 : The littleendian function
  - Section 8 : The Salsa20 hash function
  - Section 9 : The Salsa20 expansion function 

-/
import salsa20.words
import salsa20.quarterround
import salsa20.rowround
import salsa20.columnround
import salsa20.doubleround
import salsa20.littleendian
import salsa20.salsa20
import salsa20.salsa20_expansion

open words
open quarterround
open rowround
open columnround
open doubleround
open littleendian
open salsa20
open salsa20_expansion

namespace examples


namespace words

-- example from the spec for sum: 0xc0a8787e + 0x9fd1161d = 0x60798e9b
def u : bitvec word_len := 0xc0a8787e
def v : bitvec word_len := 0x9fd1161d

#eval (nat_as_bitvec (mod_as_nat (sum_as_mod u v))).to_nat
#eval 0x60798e9b

-- example from the spec for xor: 0xc0a8787e XOR 0x9fd1161d = 0x5f796e63
def x1 : bitvec 32 := 0xc0a8787e
def x2 : bitvec 32 := 0x9fd1161d

#eval (xor' x1 x2).to_nat
#eval 0x5f796e63

-- example from the spec for rot : 0xc0a8787e <<< 5 = 0x150f0fd8
def v' : bitvec 32 := 0xc0a8787e
def shift : ℕ := 5

#eval (push5 v' (reduce_bitvector (shift_left v' 5) 27)).to_nat
#eval 0x150f0fd8

def rotate5 (input: bitvec 32) := (push5 input (reduce_bitvector (shift_left input 5) 27))
#eval (rotate5 v').to_nat


end words


namespace quarterround

-- Examples from the spec

-- example 1
namespace example1

def y : (vector (bitvec word_len) 4) := 
  [0x00000000, 0x00000000, 0x00000000, 0x00000000].to_vec_of_bitvec word_len 4

example : (z₁ y).to_nat = 0x00000000 := by refl
example : (z₂ y).to_nat = 0x00000000 := by refl
example : (z₃ y).to_nat = 0x00000000 := by refl
example : (z₀ y).to_nat = 0x00000000 := by refl

end example1

-- example 2
namespace example2

def y : (vector (bitvec word_len) 4) := 
  [0x00000001, 0x00000000, 0x00000000, 0x00000000].to_vec_of_bitvec word_len 4

#eval (z₁ y).to_nat
#eval 0x00000080
#eval ((quarterround y).nth 1).to_nat

#eval (z₂ y).to_nat
#eval 0x00010200
#eval ((quarterround y).nth 2).to_nat

#eval (z₃ y).to_nat
#eval 0x20500000
#eval ((quarterround y).nth 3).to_nat

#eval (z₀ y).to_nat
#eval 0x08008145
#eval ((quarterround y).nth 0).to_nat

end example2

-- example 3
namespace example3

def y : (vector (bitvec word_len) 4) := 
  [0x00000000, 0x00000001, 0x00000000, 0x00000000].to_vec_of_bitvec word_len 4

#eval (z₁ y).to_nat
#eval 0x00000001
#eval ((quarterround y).nth 1).to_nat

#eval (z₂ y).to_nat
#eval 0x00000200
#eval ((quarterround y).nth 2).to_nat

#eval (z₃ y).to_nat
#eval 0x00402000
#eval ((quarterround y).nth 3).to_nat

#eval (z₀ y).to_nat
#eval 0x88000100
#eval ((quarterround y).head).to_nat

end example3

-- example 4
namespace example4

def y0 : bitvec word_len := 0x00000000
def y1 : bitvec word_len := 0x00000000
def y2 : bitvec word_len := 0x00000001
def y3 : bitvec word_len := 0x00000000

def y : (vector (bitvec word_len) 4) := 
  [0x00000000, 0x00000000, 0x00000001, 0x00000000].to_vec_of_bitvec word_len 4

#eval (z₁ y).to_nat
#eval 0x00000000
#eval ((quarterround y).nth 1).to_nat

#eval (z₂ y).to_nat
#eval 0x00000001
#eval ((quarterround y).nth 2).to_nat

#eval (z₃ y).to_nat
#eval 0x00002000
#eval ((quarterround y).nth 3).to_nat

#eval (z₀ y).to_nat
#eval 0x80040000
#eval ((quarterround y).head).to_nat

end example4

-- example 5
namespace example5

def y : (vector (bitvec word_len) 4) := 
  [0x00000000, 0x00000000, 0x00000000, 0x00000001].to_vec_of_bitvec word_len 4

#eval (z₁ y).to_nat
#eval 0x00000080
#eval ((quarterround y).nth 1).to_nat

#eval (z₂ y).to_nat
#eval 0x00010000
#eval ((quarterround y).nth 2).to_nat

#eval (z₃ y).to_nat
#eval 0x20100001
#eval ((quarterround y).nth 3).to_nat

#eval (z₀ y).to_nat
#eval 0x00048044
#eval ((quarterround y).head).to_nat

end example5

-- example 6
namespace example6

def y : (vector (bitvec word_len) 4) := 
  [0xe7e8c006, 0xc4f9417d, 0x6479b4b2, 0x68c67137].to_vec_of_bitvec word_len 4

#eval (z₁ y).to_nat
#eval 0x9361dfd5
#eval ((quarterround y).nth 1).to_nat

#eval (z₂ y).to_nat
#eval 0xf1460244
#eval ((quarterround y).nth 2).to_nat

#eval (z₃ y).to_nat
#eval 0x948541a3
#eval ((quarterround y).nth 3).to_nat

#eval (z₀ y).to_nat
#eval 0xe876d72b
#eval ((quarterround y).head).to_nat

end example6

-- example 7
namespace example7

def y : (vector (bitvec word_len) 4) := 
  [0xd3917c5b, 0x55f1c407, 0x52a58a7a, 0x8f887a3b].to_vec_of_bitvec word_len 4

#eval (z₁ y).to_nat
#eval 0xd90a8f36
#eval ((quarterround y).nth 1).to_nat

#eval (z₂ y).to_nat
#eval 0x6ab2a923
#eval ((quarterround y).nth 2).to_nat

#eval (z₃ y).to_nat
#eval 0x2883524c
#eval ((quarterround y).nth 3).to_nat

#eval (z₀ y).to_nat
#eval 0x3e2f308c
#eval ((quarterround y).head).to_nat

end example7


end quarterround


namespace rowround

-- example 1
namespace example1

def y₀ : bitvec word_len := 0x00000001
def y₁ : bitvec word_len := 0x00000000
def y₂ : bitvec word_len := 0x00000000
def y₃ : bitvec word_len := 0x00000000
def y₄ : bitvec word_len := 0x00000001
def y₅ : bitvec word_len := 0x00000000
def y₆ : bitvec word_len := 0x00000000
def y₇  : bitvec word_len := 0x00000000
def y₈ : bitvec word_len := 0x00000001
def y₉ : bitvec word_len := 0x00000000
def y₁₀ : bitvec word_len := 0x00000000
def y₁₁ : bitvec word_len := 0x00000000
def y₁₂ : bitvec word_len := 0x00000001
def y₁₃ : bitvec word_len := 0x00000000
def y₁₄ : bitvec word_len := 0x00000000
def y₁₅ : bitvec word_len := 0x00000000

def y : vector (bitvec word_len) 16 := 
  [y₀, y₁, y₂, y₃, y₄, y₅, y₆, y₇, y₈, y₉, y₁₀, y₁₁, y₁₂, y₁₃, y₁₄, y₁₅].to_vec_of_bitvec word_len 16

-- z₀
#eval ((rowround y).nth 0).to_nat
#eval 0x08008145

-- z₁
#eval ((rowround y).nth 1).to_nat
#eval 0x00000080

-- z₂
#eval ((rowround y).nth 2).to_nat
#eval 0x00010200

-- z₃
#eval ((rowround y).nth 3).to_nat
#eval 0x20500000

-- z₄
#eval ((rowround y).nth 4).to_nat
#eval 0x20100001

-- z₅
#eval ((rowround y).nth 5).to_nat
#eval 0x00048044

-- z₆
#eval ((rowround y).nth 6).to_nat
#eval 0x00000080

-- z₇
#eval ((rowround y).nth 7).to_nat
#eval 0x00010000

-- z₈
#eval ((rowround y).nth 8).to_nat
#eval 0x00000001

-- z₉
#eval ((rowround y).nth 9).to_nat
#eval 0x00002000

-- z₁₀
#eval ((rowround y).nth 10).to_nat
#eval 0x80040000

-- z₁₁
#eval ((rowround y).nth 11).to_nat
#eval 0x00000000

-- z₁₂
#eval ((rowround y).nth 12).to_nat
#eval 0x00000001

-- z₁₃
#eval ((rowround y).nth 13).to_nat
#eval 0x00000200

-- z₁₄
#eval ((rowround y).nth 14).to_nat
#eval 0x00402000

-- z₁₅
#eval ((rowround y).nth 15).to_nat
#eval 0x88000100

end example1

-- example 2
namespace example2

def y₀ : bitvec word_len := 0x08521bd6
def y₁ : bitvec word_len := 0x1fe88837
def y₂ : bitvec word_len := 0xbb2aa576
def y₃ : bitvec word_len := 0x3aa26365
def y₄ : bitvec word_len := 0xc54c6a5b
def y₅ : bitvec word_len := 0x2fc74c2f
def y₆ : bitvec word_len := 0x6dd39cc3
def y₇ : bitvec word_len := 0xda0a64f6
def y₈ : bitvec word_len := 0x90a2f23d
def y₉ : bitvec word_len := 0x067f95a6
def y₁₀ : bitvec word_len := 0x06b35f61
def y₁₁ : bitvec word_len := 0x41e4732e
def y₁₂ : bitvec word_len := 0xe859c100
def y₁₃ : bitvec word_len := 0xea4d84b7
def y₁₄ : bitvec word_len := 0x0f619bff
def y₁₅ : bitvec word_len := 0xbc6e965a

def y : vector (bitvec word_len) 16 := 
  [y₀, y₁, y₂, y₃, y₄, y₅, y₆, y₇, y₈, y₉, y₁₀, y₁₁, y₁₂, y₁₃, y₁₄, y₁₅].to_vec_of_bitvec word_len 16

-- z₀
#eval ((rowround y).nth 0).to_nat
#eval 0xa890d39d

-- z₁
#eval ((rowround y).nth 1).to_nat
#eval 0x65d71596

-- z₂
#eval ((rowround y).nth 2).to_nat
#eval 0xe9487daa

-- z₃
#eval ((rowround y).nth 3).to_nat
#eval 0xc8ca6a86

-- z₄
#eval ((rowround y).nth 4).to_nat
#eval 0x949d2192

-- z₅
#eval ((rowround y).nth 5).to_nat
#eval 0x764b7754

-- z₆
#eval ((rowround y).nth 6).to_nat
#eval 0xe408d9b9

-- z₇
#eval ((rowround y).nth 7).to_nat
#eval 0x7a41b4d1

-- z₈
#eval ((rowround y).nth 8).to_nat
#eval 0x3402e183

-- z₉
#eval ((rowround y).nth 9).to_nat
#eval 0x3c3af432

-- z₁₀
#eval ((rowround y).nth 10).to_nat
#eval 0x50669f96

-- z₁₁
#eval ((rowround y).nth 11).to_nat
#eval 0xd89ef0a8

-- z₁₂
#eval ((rowround y).nth 12).to_nat
#eval 0x0040ede5

-- z₁₃
#eval ((rowround y).nth 13).to_nat
#eval 0xb545fbce

-- z₁₄
#eval ((rowround y).nth 14).to_nat
#eval 0xd257ed4f

-- z₁₅
#eval ((rowround y).nth 15).to_nat
#eval 0x1818882d

end example2


end rowround 


namespace rowround

-- example 1
namespace example1

def x₀ : bitvec word_len := 0x00000001
def x₁ : bitvec word_len := 0x00000000
def x₂ : bitvec word_len := 0x00000000
def x₃ : bitvec word_len := 0x00000000
def x₄ : bitvec word_len := 0x00000001
def x₅ : bitvec word_len := 0x00000000
def x₆ : bitvec word_len := 0x00000000
def x₇ : bitvec word_len := 0x00000000
def x₈ : bitvec word_len := 0x00000001
def x₉ : bitvec word_len := 0x00000000
def x₁₀ : bitvec word_len := 0x00000000
def x₁₁ : bitvec word_len := 0x00000000
def x₁₂ : bitvec word_len := 0x00000001
def x₁₃ : bitvec word_len := 0x00000000
def x₁₄ : bitvec word_len := 0x00000000
def x₁₅ : bitvec word_len := 0x00000000

def x : vector (bitvec word_len) 16 := 
  [x₀, x₁, x₂, x₃, x₄, x₅, x₆, x₇, x₈, x₉, x₁₀, x₁₁, x₁₂, x₁₃, x₁₄, x₁₅].to_vec_of_bitvec word_len 16

-- y₀
#eval ((columnround x).nth 0).to_nat
#eval 0x10090288

-- y₁
#eval ((columnround x).nth 1).to_nat
#eval 0x00000000

-- y₂
#eval ((columnround x).nth 2).to_nat
#eval 0x00000000

-- y₃
#eval ((columnround x).nth 3).to_nat
#eval 0x00000000

-- y₄
#eval ((columnround x).nth 4).to_nat
#eval 0x00000101

-- y₅
#eval ((columnround x).nth 5).to_nat
#eval 0x00000000

-- y₆
#eval ((columnround x).nth 6).to_nat
#eval 0x00000000

-- y₇
#eval ((columnround x).nth 7).to_nat
#eval 0x00000000

-- y₈
#eval ((columnround x).nth 8).to_nat
#eval 0x00020401

-- y₉
#eval ((columnround x).nth 9).to_nat
#eval 0x00000000

-- y₁₀
#eval ((columnround x).nth 10).to_nat
#eval 0x00000000

-- y₁₁
#eval ((columnround x).nth 11).to_nat
#eval 0x00000000

-- y₁₂
#eval ((columnround x).nth 12).to_nat
#eval 0x40a04001

-- y₁₃
#eval ((columnround x).nth 13).to_nat
#eval 0x00000000

-- y₁₄
#eval ((columnround x).nth 14).to_nat
#eval 0x00000000

-- y₁₅
#eval ((columnround x).nth 15).to_nat
#eval 0x00000000

end example1

-- example 2
namespace example2

def x₀ : bitvec word_len := 0x08521bd6
def x₁ : bitvec word_len := 0x1fe88837
def x₂ : bitvec word_len := 0xbb2aa576
def x₃ : bitvec word_len := 0x3aa26365
def x₄ : bitvec word_len := 0xc54c6a5b
def x₅ : bitvec word_len := 0x2fc74c2f
def x₆ : bitvec word_len := 0x6dd39cc3
def x₇ : bitvec word_len := 0xda0a64f6
def x₈ : bitvec word_len := 0x90a2f23d
def x₉ : bitvec word_len := 0x067f95a6
def x₁₀ : bitvec word_len := 0x06b35f61
def x₁₁ : bitvec word_len := 0x41e4732e
def x₁₂ : bitvec word_len := 0xe859c100
def x₁₃ : bitvec word_len := 0xea4d84b7
def x₁₄ : bitvec word_len := 0x0f619bff
def x₁₅ : bitvec word_len := 0xbc6e965a

def x : vector (bitvec word_len) 16 := 
  [x₀, x₁, x₂, x₃, x₄, x₅, x₆, x₇, x₈, x₉, x₁₀, x₁₁, x₁₂, x₁₃, x₁₄, x₁₅].to_vec_of_bitvec word_len 16

-- y₀
#eval ((columnround x).nth 0).to_nat
#eval 0x8c9d190a

-- y₁
#eval ((columnround x).nth 1).to_nat
#eval 0xce8e4c90

-- y₂
#eval ((columnround x).nth 2).to_nat
#eval 0x1ef8e9d3

-- y₃
#eval ((columnround x).nth 3).to_nat
#eval 0x1326a71a

-- y₄
#eval ((columnround x).nth 4).to_nat
#eval 0x90a20123

-- y₅
#eval ((columnround x).nth 5).to_nat
#eval 0xead3c4f3

-- y₆
#eval ((columnround x).nth 6).to_nat
#eval 0x63a091a0

-- y₇
#eval ((columnround x).nth 7).to_nat
#eval 0xf0708d69

-- y₈
#eval ((columnround x).nth 8).to_nat
#eval 0x789b010c

-- y₉
#eval ((columnround x).nth 9).to_nat
#eval 0xd195a681

-- y₁₀
#eval ((columnround x).nth 10).to_nat
#eval 0xeb7d5504

-- y₁₁
#eval ((columnround x).nth 11).to_nat
#eval 0xa774135c

-- y₁₂
#eval ((columnround x).nth 12).to_nat
#eval 0x481c2027

-- y₁₃
#eval ((columnround x).nth 13).to_nat
#eval 0x53a8e4b5

-- y₁₄
#eval ((columnround x).nth 14).to_nat
#eval 0x4c1f89c5

-- y₁₅
#eval ((columnround x).nth 15).to_nat
#eval 0x3f78c9c8

end example2


end rowround


namespace doubleround

-- example 1
namespace example1

def x₀ : bitvec word_len := 0x00000001
def x₁ : bitvec word_len := 0x00000000
def x₂ : bitvec word_len := 0x00000000
def x₃ : bitvec word_len := 0x00000000
def x₄ : bitvec word_len := 0x00000000
def x₅ : bitvec word_len := 0x00000000
def x₆ : bitvec word_len := 0x00000000
def x₇ : bitvec word_len := 0x00000000
def x₈ : bitvec word_len := 0x00000000
def x₉ : bitvec word_len := 0x00000000
def x₁₀ : bitvec word_len := 0x00000000
def x₁₁ : bitvec word_len := 0x00000000
def x₁₂ : bitvec word_len := 0x00000000
def x₁₃ : bitvec word_len := 0x00000000
def x₁₄ : bitvec word_len := 0x00000000
def x₁₅ : bitvec word_len := 0x00000000

def x : vector (bitvec word_len) 16 := 
  [x₀, x₁, x₂, x₃, x₄, x₅, x₆, x₇, x₈, x₉, x₁₀, x₁₁, x₁₂, x₁₃, x₁₄, x₁₅].to_vec_of_bitvec word_len 16

-- double₀
#eval ((doubleround x).nth 0).to_nat
#eval 0x8186a22d

-- double₁
#eval ((doubleround x).nth 1).to_nat
#eval 0x0040a284

--  double₂
#eval ((doubleround x).nth 2).to_nat
#eval 0x82479210

-- double₃
#eval ((doubleround x).nth 3).to_nat
#eval 0x06929051

-- double₄
#eval ((doubleround x).nth 4).to_nat
#eval 0x08000090

-- double₅
#eval ((doubleround x).nth 5).to_nat
#eval 0x02402200

-- double₆
#eval ((doubleround x).nth 6).to_nat
#eval 0x00004000

-- double₇
#eval ((doubleround x).nth 7).to_nat
#eval 0x00800000

-- double₈
#eval ((doubleround x).nth 8).to_nat
#eval 0x00010200

-- double₉
#eval ((doubleround x).nth 9).to_nat
#eval 0x20400000

-- double₁₀
#eval ((doubleround x).nth 10).to_nat
#eval 0x08008104

-- double₁₁
#eval ((doubleround x).nth 11).to_nat
#eval 0x00000000

-- double₁₂
#eval ((doubleround x).nth 12).to_nat
#eval 0x20500000

-- double₁₃
#eval ((doubleround x).nth 13).to_nat
#eval 0xa0000040

-- double₁₄
#eval ((doubleround x).nth 14).to_nat
#eval 0x0008180a

-- double₁₅
#eval ((doubleround x).nth 15).to_nat
#eval 0x612a8020

end example1

-- example 2
namespace example2

def x₀ : bitvec word_len := 0xde501066
def x₁ : bitvec word_len := 0x6f9eb8f7
def x₂ : bitvec word_len := 0xe4fbbd9b
def x₃ : bitvec word_len := 0x454e3f57
def x₄ : bitvec word_len := 0xb75540d3
def x₅ : bitvec word_len := 0x43e93a4c
def x₆ : bitvec word_len := 0x3a6f2aa0
def x₇ : bitvec word_len := 0x726d6b36
def x₈ : bitvec word_len := 0x9243f484
def x₉ : bitvec word_len := 0x9145d1e8
def x₁₀ : bitvec word_len := 0x4fa9d247
def x₁₁ : bitvec word_len := 0xdc8dee11
def x₁₂ : bitvec word_len := 0x054bf545
def x₁₃ : bitvec word_len := 0x254dd653
def x₁₄ : bitvec word_len := 0xd9421b6d
def x₁₅ : bitvec word_len := 0x67b276c1

def x : vector (bitvec word_len) 16 := 
  [x₀, x₁, x₂, x₃, x₄, x₅, x₆, x₇, x₈, x₉, x₁₀, x₁₁, x₁₂, x₁₃, x₁₄, x₁₅].to_vec_of_bitvec word_len 16

-- double₀
#eval ((doubleround x).nth 0).to_nat
#eval 0xccaaf672

-- double₁
#eval ((doubleround x).nth 1).to_nat
#eval 0x23d960f7

-- double₂
#eval ((doubleround x).nth 2).to_nat
#eval 0x9153e63a

-- double₃
#eval ((doubleround x).nth 3).to_nat
#eval 0xcd9a60d0

-- double₄
#eval ((doubleround x).nth 4).to_nat
#eval 0x50440492

-- double₅
#eval ((doubleround x).nth 5).to_nat
#eval 0xf07cad19

-- double₆
#eval ((doubleround x).nth 6).to_nat
#eval 0xae344aa0

-- double₇
#eval ((doubleround x).nth 7).to_nat
#eval 0xdf4cfdfc

-- double₈
#eval ((doubleround x).nth 8).to_nat
#eval 0xca531c29

--  double₉
#eval ((doubleround x).nth 9).to_nat
#eval 0x8e7943db

-- double₁₀
#eval ((doubleround x).nth 10).to_nat
#eval 0xac1680cd

-- double₁₁
#eval ((doubleround x).nth 11).to_nat
#eval 0xd503ca00

-- double₁₂
#eval ((doubleround x).nth 12).to_nat
#eval 0xa74b2ad6

-- double₁₃
#eval ((doubleround x).nth 13).to_nat
#eval 0xbc331c5c

-- double₁₄
#eval ((doubleround x).nth 14).to_nat
#eval 0x1dda24c7

-- double₁₅
#eval ((doubleround x).nth 15).to_nat
#eval 0xee928277

end example2


end doubleround


namespace littleendian


-- littleendian

#eval (littleendian ([0, 0, 0, 0].to_vec_of_bitvec byte_len 4)).to_nat
#eval 0x00000000

#eval bitvec.to_nat (littleendian ([86, 75, 30, 9].to_vec_of_bitvec byte_len 4))
#eval 0x091e4b56

#eval bitvec.to_nat (littleendian ([255, 255, 255, 250].to_vec_of_bitvec byte_len 4))
#eval 0xfaffffff

#eval bitvec.to_nat (littleendian ([255, 255, 255, 255].to_vec_of_bitvec byte_len 4))
#eval 0xffffffff

-- littleendian_inv

#eval (littleendian_inv 0x00000000).to_list

#eval 0x091e4b56
#eval (littleendian_inv 0x091e4b56).to_list
#eval ((littleendian_inv 0x091e4b56).nth 0).to_nat
#eval ((littleendian_inv 0x091e4b56).nth 1).to_nat
#eval ((littleendian_inv 0x091e4b56).nth 2).to_nat
#eval ((littleendian_inv 0x091e4b56).nth 3).to_nat

#eval (littleendian_inv 0xfaffffff).to_list


end littleendian


namespace salsa20


#eval if salsa20
  (list.to_vec_of_bitvec byte_len 64 [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  ]) = list.to_vec_of_bitvec byte_len 64 [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  ] then tt else ff

#eval
  if salsa20 (list.to_vec_of_bitvec byte_len 64 [
    211, 159, 13, 115, 76, 55, 82, 183, 3, 117, 222, 37, 191, 187, 234, 136,
    49, 237, 179, 48, 1, 106, 178, 219, 175, 199, 166, 48, 86, 16, 179, 207,
    31, 240, 32, 63, 15, 83, 93, 161, 116, 147, 48, 113, 238, 55, 204, 36,
    79, 201, 235, 79, 3, 81, 156, 47, 203, 26, 244, 243, 88, 118, 104, 54
  ]) = list.to_vec_of_bitvec byte_len 64 [
    109, 42, 178, 168, 156, 240, 248, 238,  168, 196, 190, 203, 26, 110, 170, 154,
    29, 29, 150, 26, 150, 30, 235, 249,  190, 163, 251, 48, 69, 144, 51, 57,
    118, 40, 152, 157, 180, 57, 27, 94, 107, 42, 236, 35, 27, 111, 114, 114,
    219, 236, 232, 135, 111, 155, 110, 18, 24, 232, 95, 158, 179, 19, 48, 202
  ] then tt else ff

#eval
  if salsa20 (list.to_vec_of_bitvec byte_len 64 [
    88, 118, 104, 54, 79, 201, 235, 79, 3, 81, 156, 47, 203, 26, 244, 243,
    191, 187, 234, 136, 211, 159, 13, 115, 76, 55, 82, 183, 3, 117, 222, 37,
    86, 16, 179, 207, 49, 237, 179, 48, 1, 106, 178, 219, 175, 199, 166, 48,
    238, 55,204, 36, 31, 240, 32, 63, 15, 83, 93, 161, 116, 147, 48,113
  ]) = list.to_vec_of_bitvec byte_len 64 [
    179, 19, 48, 202, 219, 236, 232, 135, 111, 155, 110, 18, 24, 232, 95, 158,
    26, 110, 170, 154, 109, 42, 178, 168, 156, 240, 248, 238, 168, 196, 190, 203,
    69, 144, 51, 57, 29, 29, 150, 26, 150, 30, 235, 249, 190, 163, 251, 48,
    27, 111, 114, 114, 118, 40, 152, 157, 180, 57, 27, 94, 107, 42, 236, 35
  ] then tt else ff


end  salsa20


namespace salsa20_expansion


-- k₀ = (1, 2, 3, 4, 5, ... , 16)
def test_k₀ : vector (bitvec byte_len) 16 :=
  ([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16].to_vec_of_bitvec byte_len 16)

-- k₁ = (201, 202, 203, 204, 205, ... , 216)
def test_k₁ : vector (bitvec byte_len) 16 :=
  ([201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216].to_vec_of_bitvec byte_len 16)

-- n = (101, 102, 103, 104, 105, ... , 116)
def test_n : vector (bitvec byte_len) 16 :=
  ([101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116].to_vec_of_bitvec byte_len 16)

def res1 : list (bitvec byte_len) := [
  69, 37, 68, 39, 41, 15, 107, 193, 255, 139, 122, 6, 170, 233, 217, 98,
  89, 144, 182, 106, 21, 51, 200, 65, 239, 49, 222, 34, 215, 114, 40, 126,
  104, 197, 7, 225, 197, 153, 31, 2, 102, 78, 76, 176, 84, 245, 246, 184,
  177, 160, 133, 130, 6, 72, 149, 119, 192, 195, 132, 236, 234, 103, 246, 74
]

def res2 : list(bitvec byte_len) := [
  39, 173, 46, 248, 30, 200, 82, 17, 48, 67, 254, 239, 37, 18, 13, 247,
  241, 200, 61, 144, 10, 55, 50, 185, 6, 47, 246, 253, 143, 86, 187, 225,
  134, 85, 110, 246, 161, 163, 43, 235, 231, 94, 171, 51, 145, 214, 112, 29,
  14, 232, 5, 16, 151, 140, 183, 141, 171, 9, 122, 181, 104, 182, 177, 193
]

#eval if res1 = (salsa20_expansion_v1 test_k₀ test_k₁ test_n).to_list then tt else ff

#eval if res2 = (salsa20_expansion_v2 test_k₀ test_n).to_list then tt else ff


end salsa20_expansion


end examples
