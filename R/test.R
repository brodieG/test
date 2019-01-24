#' A document
#'
#' Blah Blah
#'
#' @useDynLib test, .registration=TRUE, .fixes="TEST_"
#' @export

test_fun <- function(x) .Call(TEST_test_fun, x)

