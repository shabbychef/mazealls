#' @param boustro an array of two values, which help determine
#' the location of holes in internal lines of length
#' \code{height}. The default value, \code{c(1,1)} results in 
#' uniform selection. Otherwise the location of holes are chosen
#' with probability proportional to a beta density with the
#' ordered elements of \code{boustro} set as 
#' \code{shape1} and \code{shape2}.
#' In sub mazes, this parameter is reversed, which
#' can lead to \sQuote{boustrophedonic} mazes. It is suggested
#' that the sum of values not exceed 40, as otherwise the location 
#' of internal holes may be not widely dispersed from the mean
#' value.
