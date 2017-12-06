# Copyright 2017-2017 Steven E. Pav. All Rights Reserved.
# Author: Steven E. Pav
#
# This file is part of mazealls.
#
# mazealls is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# mazealls is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with mazealls.  If not, see <http://www.gnu.org/licenses/>.

# Created: 2017.11.01
# Copyright: Steven E. Pav, 2017
# Author: Steven E. Pav <shabbychef@gmail.com>
# Comments: Steven E. Pav

#' @title holey_path .
#'
#' @description 
#' 
#' Make the turtle move multiple units, making turns, and possibly drawing
#' line segments possibly with holes in them.
#'
#' @details
#'
#' Causes the turtle to move through a path of connected line segments,
#' possibly drawing lines, possibly drawing holes in those lines.
#' All arguments are recycled to the length of the longest
#' argument via \code{mapply}, which simplifies
#' the path description.
#'
#' @seealso \code{\link{holey_line}}.
#'
#' @keywords plotting
#' @template etc
#' @template param-unitlen
#' @param lengths an array of the number of units
#' each part of the path. An array of length \code{n}.
#' @param angles after each part of the path is
#' drawn, the turtle turns right by the given angle.
#' @param draw_line a boolean array telling whether
#' each part of the path is drawn at all, or whether
#' the turtle simply moves through that path.
#' @param has_hole a boolean array telling whether,
#' conditional on the path being drawn, it has a one unit
#' hole.
#' @param hole_arrows a boolean or boolean array telling whether
#' to draw a perpendicular arrow at a hole.
#' @param hole_color the color to plot the \sQuote{hole}. 
#' A value \code{NULL} or \code{'clear'} corresponds to no 
#' drawn hole, the latter being useful for mixing drawn colored
#' holes with no hole drawn at all (for which \code{'white'}
#' would be an acceptable choice if the background were white).
#' Filled holes are often useful for indicating the entry and
#' exit points of a maze.
#' See the \code{\link[grDevices]{colors}} function for
#' acceptable values.
#' @param hole_locations an optional array of \sQuote{locations}
#' of the holes. These affect the \code{which_seg} of any holey
#' lines which are drawn. If an array of numeric values,
#' a value of zero corresponds to allowing the code to randomly
#' choose the location of a hole; 
#' negative values are \sQuote{inverted} by adding \code{length + 1}, 
#' so that if the same segment is drawn twice, in different 
#' directions, only the sign of the hole location needs to be 
#' flipped to have aligned holes.
#' \code{NA} values will throw an error for now, though
#' this may change in the future.
#' @template return-none
#' @examples 
#'
#' library(TurtleGraphics)
#' # draw a triangle with holes on the boundaries
#' turtle_init(1000,1000)
#' holey_path(unit_len=20, lengths=rep(10,3), angles=c(120), draw_line=TRUE, has_hole=TRUE)
#'
#' # draw a square with holes on the boundaries
#' turtle_init(1000,1000)
#' turtle_hide()
#' holey_path(unit_len=20, lengths=rep(10,4), angles=c(90), draw_line=TRUE, has_hole=TRUE, 
#'   hole_color=c('red','green'))
#'
#' # draw a square spiral
#' turtle_init(1000,1000)
#' turtle_hide()
#' holey_path(unit_len=20, lengths=sort(rep(1:10,2),decreasing=TRUE), angles=c(90), 
#'   draw_line=TRUE, has_hole=FALSE)
#' @export
holey_path <- function(unit_len,lengths,angles,draw_line=TRUE,has_hole=FALSE,
											 hole_color=NULL,hole_locations=NULL,hole_arrows=FALSE) {
# do something here about recycling hole color too?
	if (is.null(hole_color)) { hole_color <- c('clear') }
	if (is.null(hole_locations)) { hole_locations <- c(0) }
	retv <- mapply(function(len,ang,drawl,hol,holc,which_seg,hole_arrow) {
					 if (len > 0) {
						 if (drawl) {
							 if (hol) {
								 if (which_seg < 0) { 
									 which_seg <- len + which_seg + 1
								 } else if (which_seg == 0) {
									 which_seg <- NULL
								 }
								 if (holc == 'clear') {
									 holey_line(unit_len,len,which_seg=which_seg,go_back=FALSE,hole_color=NULL,hole_arrow=hole_arrow)
								 } else {
									 holey_line(unit_len,len,which_seg=which_seg,go_back=FALSE,hole_color=holc,hole_arrow=hole_arrow)
								 }
							 } else {
								 draw_line(distance=unit_len*len)
							 }
						 } else {
							 turtle_forward(distance=unit_len * len)
						 }
					 }
					 .turn_right(ang)
	},lengths,angles,draw_line,has_hole,hole_color,hole_locations,hole_arrows)
	invisible(retv)
}

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
