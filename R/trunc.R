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

#' @export

print.trunc_test <- function(x, ...) {
  bin <- vapply(x, function(y) capture.output(charToRaw(y)), "")
  bin <- gsub("\\s*\\[1\\]\\s*", "", bin, perl=TRUE)
  writeLines(paste0(format(paste0("<", bin, ">")), " | ", paste0('"', x, '"')))
}

