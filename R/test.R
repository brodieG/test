#' A document
#'
#' Blah Blah

test_fun <- function(x) filter(x, rep(1, 4) / 4)

missing <- function(x) UseMethod('missing')

missing.numeric <- function(x) 'hello'
