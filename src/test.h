/*
 * Copyright (C) 2022 Brodie Gaslam
 *
 * This file is part of "test - a test package"
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 or 3 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * Go to <https://www.r-project.org/Licenses> for a copies of the licenses.
 */

#ifndef TEST_H
#define TEST_H
#define R_NO_REMAP

// System headers go above
#include <R.h>
#include <Rinternals.h>
#include <Rversion.h>

SEXP TEST_invalid_count1(SEXP x);
SEXP TEST_invalid_count2(SEXP x);

#endif  /* TEST_H */

