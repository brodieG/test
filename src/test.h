/*
Copyright (C) 2017  Brodie Gaslam

This file is part of "fansi - ANSI Control Sequence Aware String Functions"

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Go to <https://www.r-project.org/Licenses/GPL-2> for a copy of the license.
*/

#include <stdint.h>
#include <R.h>
#include <Rinternals.h>

#define mbs_init(x) memset(x, 0, sizeof(mbstate_t))

SEXP TEST_trunc_to_valid(SEXP x, SEXP xi, SEXP mode);
SEXP TEST_trunc_speed(SEXP x, SEXP xi, SEXP mode);
