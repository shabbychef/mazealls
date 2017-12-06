#' @param num_boundary_holes the number of boundary sides which should be
#' randomly selected to have holes. Note that the \code{boundary_holes}
#' parameter takes precedence.
#' @param boundary_holes an array indicating which of the boundary lines
#' have holes. If \code{NULL}, then boundary holes are randomly selected
#' by the \code{num_boundary_holes} parameter. If numeric, indicates
#' which sides of the maze shall have holes. If a boolean array, indicates
#' which of the sides shall have holes. These forms are recycled
#' if needed. See \code{\link{holey_path}}. Note that if no line
#' is drawn, no hole can be drawn either.
#' @param boundary_hole_color the color of boundary holes. A value of
#' \code{NULL} indicates no colored holes. See \code{\link{holey_path}}
#' for more details. Can be an array of colors, or colors and the 
#' value \code{'clear'}, which stands in for \code{NULL} to
#' indicate no filled hole to be drawn.
#' @param boundary_hole_arrows a boolean or boolean array indicating whether to draw
#' perpendicular double arrows at the boundary holes, as a visual guide. These
#' can be useful for locating the entry and exit points of a maze.
