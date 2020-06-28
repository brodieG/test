# Remove DLLs when package is unloaded

.onUnload <- function(libpath) {
  library.dynam.unload("test", libpath)
}

#' Test Truncation Functions
#'
#' `trunc_utf8` assumes UTF8 encoding.  `trunc_sjis` requires "native" encoding
#' and is only useful if that is a multibyte encoding.  Internally it assumes
#' this is the case.
#'
#' Will attempt to truncate character from 0 bytes to n+1 bytes, where n is the
#' number of bytes in the input.
#'
#' @param x scalar character
#' @return a "trunc_test" object
#' @useDynLib test, .registration=TRUE, .fixes="TEST_"
#' @export

trunc_utf8 <- function(x) {
  stopifnot(
    length(x) == 1L,
    grepl("UTF-8$", Sys.getlocale(category="LC_CTYPE")) ||
    all(Encoding(x) == 'UTF-8')
  )
  i <- seq(0L, nchar(x, type='bytes') + 1L, 1L)
  x <- rep_len(x, length.out=length(i))
  structure(.Call(TEST_trunc_to_valid, x, i, 1L), class='trunc_test')
}

#' @export
#' @rdname trunc_utf8

trunc_multi <- function(x) {
  stopifnot(length(x) == 1L)
  i <- seq(0L, nchar(x, type='bytes') + 1L, 1L)
  x <- rep_len(x, length.out=length(i))
  structure(.Call(TEST_trunc_to_valid, x, i, 0L), class='trunc_test')
}
#' Test Truncation Speed
#'
#' This is intended to be called with a scalar character repeated many times,
#' but we keep the repetition out of the function so that it does not need to be
#' part of the timing run.
#'
#' @param x character, where the first element is the longest of all elements
#'   byte-wise (bad things may happen otherwise)
#' @param n integer truncation point, should be less than the length of the
#'   shortest element in `x` (bad things may happen otherwise)
#' @param utf8 TRUE or FALSE whether to use the UTF-8 truncation or the other
#'   normal multi-byte one.
#' @return integer a somewhat arbitrary number the only purpose of which is to
#'   ensure the compiler doesn't get too creative.
#' @export

trunc_speed <- function(x, n, utf8=TRUE) {
  stopifnot(length(n) == 1L)
  .Call(TEST_trunc_speed, x, n, utf8+0L)
}

#' @export

print.trunc_test <- function(x, ...) {
  bin <- vapply(x, function(y) capture.output(charToRaw(y)), "")
  bin <- gsub("\\s*\\[1\\]\\s*", "", bin, perl=TRUE)
  writeLines(paste0(format(paste0("<", bin, ">")), " | ", paste0('"', x, '"')))
}

