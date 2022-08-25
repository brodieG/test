## Copyright (C) 2022 Brodie Gaslam
##
## This file is part of "test - a test package"
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 2 or 3 of the License.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## Go to <https://www.r-project.org/Licenses> for copies of the licenses.

#' @export
invalid_count1 <- function(x) .Call(TEST_invalid_count1, x)

#' @export
invalid_count2 <- function(x) .Call(TEST_invalid_count2, x)
