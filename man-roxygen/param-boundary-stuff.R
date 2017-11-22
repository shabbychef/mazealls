#' @param draw_boundary a boolean indicating whether a final boundary shall be
#' drawn around the maze.
#' @param boundary_lines indicates which of the sides of the maze
#' shall have drawn boundary lines. Can be a logical array indicating
#' which sides shall have lines, or a numeric array, giving the
#' index of sides that shall have lines.
#' @param boundary_hole_locations the \sQuote{locations} of the boundary holes
#' within each boundary segment.
#' A value of \code{NULL} indicates the code may randomly choose, as is
#' the default.
#' May be a numeric array. A positive value up to the side length is
#' interpreted as the location to place the boundary hole.
#' A negative value is interpreted as counting down from the side
#' length plus 1. A value of zero corresponds to allowing the 
#' code to pick the location within a segment.
#' A value of \code{NA} may cause an error.
