#include "test.h"

SEXP TEST_test_fun(SEXP x) {
  if(TYPEOF(x) != STRSXP) error("Internal Error: type mismatch");

  SEXP x_prev = STRING_ELT(x, 0);
  SEXP x_cur = STRING_ELT(x, 1);
  const char * prev = CHAR(x_prev);

  return x;
}
/*
SEXP TEST_test_fun(SEXP x) {
  if(TYPEOF(x) != STRSXP) error("Internal Error: type mismatch");

  SEXP x_prev;

  for(R_xlen_t i = 0; i < XLENGTH(x); ++i) {
    SEXP x_cur = STRING_ELT(x, i);
    x_prev = x_cur;;
  }
  return x;
}
*/
