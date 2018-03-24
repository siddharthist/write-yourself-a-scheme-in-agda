module _ where

open import Agda.Builtin.Equality               using  (_≡_; refl)
open import Data.Integer           as Integer   using (ℤ)
open import Data.List              as List      using (List ; [] ; _∷_)
open import Data.List.NonEmpty     as NonEmpty
open import Data.Sum               as Sum       using (_⊎_ ; inj₁ ; inj₂ ; [_,_]′)
open import Data.String            as String    hiding (_==_ ; show)
open import Function                            using (_$_ ; _∘_ ; id)
open import Level

open import Eval
open import Parsers                             hiding (atom ; list ; integer)
open import Util

open ℤ

-- TODO: https://github.com/agda/agda-stdlib/pull/221
_>>=_ : ∀ {a b c : Level} {A : Set a} {B : Set b} {C : Set c}
      → (A ⊎ B) → (B → A ⊎ C) → (A ⊎ C)
_>>=_  = λ x f → [ inj₁ , f ]′ x

show∘eval∘parse : String → Error ⊎ String
show∘eval∘parse str = show <$⊎> (parse str >>= eval)

_ : eval (atom "str") ≡ inj₂ (atom "str")
_ = refl

_ : eval (list $ (atom "fun") ∷ []) ≡ inj₁ (err-noargs "fun")
_ = refl

_ : eval (list $ (atom "+") ∷ (integer (pos 5)) ∷ ((integer (pos 5)) ∷ [])) ≡
         inj₂ (integer (pos 10))
_ = refl

_ : show∘eval∘parse "(+ 2 2)" ≡ inj₂ "4"
_ = refl