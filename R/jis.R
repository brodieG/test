#' Given JIS X 0208 Byte Pairs Return Shift JIS Encoding
#'
#' @export
#' @param j12 two row matrix with JIS byte-pair codes
#' @return two column data frame with S-JIS encodings in [as.hexmode()]

to_sjis <- function(j12) {
  j1 <- j12[1,]
  j2 <- j12[2,]
  stopifnot(!any(j1 < 33 | j1 > 126))
  s1 <- as.integer((j1 + 1) / 2) + ifelse(j1 >= 33 & j1 <= 94,112L, 176L)
  s2 <- j2 + ifelse(j1 %% 2L, 31 + as.integer(j2/96), 126)
  res <- data.frame(s1, s2)
  res[] <- lapply(res, as.hexmode)
  res
}
