/*
Copyright (c) 2016 Microsoft Corporation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

Author: Leonardo de Moura
*/
#pragma once
#include "library/compiler/procedure.h"
namespace lean {
/* Common subexpression elimination.
   It must be only applied after simp_inductive step. */
void cse(environment const & env, buffer<procedure> & procs);
}
