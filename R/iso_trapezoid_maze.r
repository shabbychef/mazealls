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

#' @title iso_trapezoid_maze .
#'
#' @description 
#' 
#' Recursively draw a isosceles trapezoid, with three sides consisting
#' of \eqn{2^depth} pieces of length \code{unit_len}, and one long
#' side of length \eqn{2^(depth+1)} pieces, starting from the
#' long side.
#'
#' @details
#'
#' @keywords plotting
#' @template etc
#' @template param-unitlen
#' @template param-clockwise
#' @template param-start-from
#' @template param-end-side
#' @template param-boundary-stuff
#' @template return-none
#' @param depth the depth of recursion. Should be integer. This controls the
#' side length.
#'
#' @note currently there is only one method for drawing an equilateral
#' trapezoid, though there may be more than one method in the future.
#'
#' @examples 
#' \dontrun{
#' turtle_init(1000,1000)
#' turtle_hide() 
#' iso_trapezoid_maze(depth=4,20,clockwise=FALSE,draw_boundary=TRUE)
#'
#' turtle_init(1000,1000)
#' turtle_hide() 
#' turtle_do({
#' iso_trapezoid_maze(depth=3,20,clockwise=TRUE,draw_boundary=TRUE,boundar_holes=3,boundary_hole_color=c('red','clear','green')
#' })
#' }
#' @export
iso_trapezoid_maze <- function(depth,unit_len=4L,clockwise=TRUE,start_from=c('midpoint','corner'),
															draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,boundary_holes=NULL,boundary_hole_color=NULL,
															end_side=1) {
	start_from <- match.arg(start_from)

	num_segs <- 2^depth
	multiplier <- ifelse(clockwise,1,-1)

	if (start_from=='corner') { turtle_backward(dist=unit_len * num_segs) }

	if (depth > 0) {
		# recurse.
		magic_ratio <- sqrt(3) / 4

		turtle_up()
		.turn_right(multiplier * 90)
		turtle_forward(num_segs * unit_len * magic_ratio)
		.turn_left(multiplier * 90)
		holey_bone(unit_len,num_segs/2)
		.turn_left(multiplier * 90)
		turtle_forward(num_segs * unit_len * magic_ratio)
		.turn_right(multiplier * 90)

		if (depth > 1) {
			iso_trapezoid_maze(depth-1,unit_len,clockwise=clockwise,draw_boundary=FALSE)
			turtle_forward(num_segs * unit_len)
			.turn_right(multiplier * 120)
			for (iii in c(1:3)) {
				turtle_forward(num_segs * unit_len/2)
				iso_trapezoid_maze(depth-1,unit_len,clockwise=clockwise,draw_boundary=FALSE)
				turtle_forward(num_segs * unit_len/2)
				.turn_right(multiplier * 60)
			}
			.turn_right(multiplier * 60)
			turtle_forward(num_segs * unit_len)
		}
	}
	if (draw_boundary) {
		holes <- .interpret_boundary_holes(boundary_holes,num_boundary_holes,nsides=4)
		boundary_lines <- .interpret_boundary_lines(boundary_lines,nsides=4)

		turtle_backward(dist=unit_len * num_segs)

		holey_path(unit_len=unit_len,
							lengths=num_segs * c(2,1,1,1),
							angles=multiplier * c(120,60,60,60),
							draw_line=boundary_lines,
							has_hole=holes,
							hole_color=boundary_hole_color)

		turtle_forward(dist=unit_len * num_segs)
	}

	# move to ending side
	if ((end_side != 1) && (!is.null(end_side))) {
		turtle_backward(dist=unit_len * num_segs)
		molens <-  num_segs * c(2,1,1,1)
		angls <-  multiplier * 60 * c(2,1,1,1)

		holey_path(unit_len=unit_len,
							 lengths=molens[1:(end_side-1)],
							 angles=angls[1:(end_side-1)],
							 draw_line=FALSE,
							 has_hole=FALSE,
							 hole_color=NULL)

		turtle_forward(dist=unit_len * num_segs)
	}
	if (start_from=='corner') { turtle_forward(dist=unit_len * num_segs) }
}

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
