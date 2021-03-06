/-
Copyright (c) 2016 Microsoft Corporation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author: Leonardo de Moura
-/
prelude
import init.logic init.category.applicative
universe variables u v

class alternative (f : Type u → Type v) extends applicative f : Type (max u+1 v) :=
(failure : Π {a : Type u}, f a)
(orelse  : Π {a : Type u}, f a → f a → f a)

@[inline] def failure {f : Type u → Type v} [alternative f] {a : Type u} : f a :=
alternative.failure f

@[inline] def orelse {f : Type u → Type v} [alternative f] {a : Type u} : f a → f a → f a :=
alternative.orelse

infixr ` <|> `:2 := orelse

@[inline] def guard {f : Type → Type v} [alternative f] (p : Prop) [decidable p] : f unit :=
if p then pure () else failure
