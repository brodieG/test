#include "test.h"
#include <wchar.h>

static int mbcslocale=1;
static int utf8locale;

static char* mbcsTruncateToValid(char *s)
{
    if (!mbcslocale || *s == '\0')
	return s;

    mbstate_t mb_st;
    size_t slen = strlen(s); /* at least 1 */
    size_t goodlen = 0;

    mbs_init(&mb_st);

    if (utf8locale) {
        /* UTF-8 is self-synchronizing so we can look back from end for first
           non-continuaton byte*/
        goodlen = slen - 1;             /* at least 0 */
        /* for char == signed char we assume 2's complement representation */
        while (goodlen && ((s[goodlen] & '\xC0') == '\x80')) {
            --goodlen;
        }
    }
    while(goodlen < slen) {
	size_t res;
	res = mbrtowc(NULL, s + goodlen, slen - goodlen, &mb_st);
	if (res == (size_t) -1 || res == (size_t) -2) {
	    /* strip off all remaining characters */
	    for(;goodlen < slen; goodlen++)
		s[goodlen] = '\0';
	    return s;
	}
	goodlen += res;
    }
    return s;
}
SEXP TEST_trunc_to_valid(SEXP x, SEXP xi, SEXP mode) {
  if(TYPEOF(x) != STRSXP) error("Internal Error: type mismatch");
  if(TYPEOF(xi) != INTSXP) error("Internal Error: type mismatch 2");
  if(XLENGTH(x) != XLENGTH(xi)) error("Internal Error: length mismatch");
  if(TYPEOF(mode) != INTSXP || XLENGTH(mode) != 1)
    error("mode must be a scalar integer");

  int m = asInteger(mode);

  if(m < 0 || m > 1) error("mode must be 0 or 1");

  utf8locale = m;

  R_xlen_t len = XLENGTH(x);
  R_len_t max_chr_len = 0;

  // Allocate a temporary buffer to copy and truncate strings with

  for(R_xlen_t i = 0; i < len; ++i) {
    SEXP el = STRING_ELT(x, i);
    if(LENGTH(el) > max_chr_len) max_chr_len = LENGTH(el);
  }
  char * tmp = R_alloc(max_chr_len + 1, sizeof(char));

  SEXP res = PROTECT(allocVector(STRSXP, len));
  for(R_xlen_t i = 0; i < len; ++i) {
    SEXP xchr = STRING_ELT(x, i);
    memcpy(tmp, CHAR(xchr), LENGTH(xchr));
    tmp[LENGTH(xchr)] = '\0';

    // truncate at specified index

    int xii = INTEGER(xi)[i];
    if(xii < 0) error("Zero or negative char index value at %d", (int) i);
    if(xii > LENGTH(xchr)) xii = LENGTH(xchr);
    for(int j = xii; j < LENGTH(xchr); ++j) tmp[j] = '\0'; /* truncate */

    // Rprintf("calling %d\n", i);
    tmp = mbcsTruncateToValid(tmp);

    // write out, should we check for ASCII?

    SEXP chrnew = PROTECT(mkCharCE(tmp, utf8locale ? CE_UTF8 : CE_NATIVE));
    SET_STRING_ELT(res, i, chrnew);
    UNPROTECT(1);
  }
  UNPROTECT(1);
  return res;
}
/*
 * This one requires a constant length of truncation so we can time
 * with minimal overhead.
 */

SEXP TEST_trunc_speed(SEXP x, SEXP xi, SEXP mode) {
  if(TYPEOF(x) != STRSXP) error("Internal Error: type mismatch");
  if(TYPEOF(xi) != INTSXP) error("Internal Error: type mismatch 2");
  if(XLENGTH(xi) != 1) error("Internal Error: bad length");
  if(TYPEOF(mode) != INTSXP || XLENGTH(mode) != 1)
    error("mode must be a scalar integer");

  int m = asInteger(mode);
  int xii = asInteger(xi);

  if(m < 0 || m > 1) error("mode must be 0 or 1");

  utf8locale = m;

  R_xlen_t len = XLENGTH(x);

  // Allocate a temporary buffer to copy and truncate strings with
  // assumes first string is longest.

  char * tmp = R_alloc(LENGTH(STRING_ELT(x, 1)) + 1, sizeof(char));
  int res = 0;

  for(R_xlen_t i = 0; i < len; ++i) {
    SEXP xchr = STRING_ELT(x, i);
    memcpy(tmp, CHAR(xchr), LENGTH(xchr));
    tmp[LENGTH(xchr)] = '\0';
    tmp[xii] = '\0';
    tmp = mbcsTruncateToValid(tmp);
    res += tmp[0];  // hopefully force compiler to keep everything
  }
  return ScalarInteger(res);
}

SEXP TEST_blah(SEXP x) {
  Rprintf("type %d\n", TYPEOF(x));
}
