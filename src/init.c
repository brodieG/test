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

#include <R_ext/Rdynload.h>
#include <R_ext/Visibility.h>
#include "test.h"

static const
R_CallMethodDef callMethods[] = {
  {"invalid_count1", (DL_FUNC) &TEST_invalid_count1, 1},
  {"invalid_count2", (DL_FUNC) &TEST_invalid_count2, 1},

  {NULL, NULL, 0}
};

void attribute_visible R_init_test(DllInfo *info)
{
 /* Register the .C and .Call routines.
    No .Fortran() or .External() routines,
    so pass those arrays as NULL.
  */
  R_registerRoutines(info, NULL, callMethods, NULL, NULL);
  R_useDynamicSymbols(info, FALSE);
  R_forceSymbols(info, FALSE);
}


