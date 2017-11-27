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

# Created: 2017.11.26
# Copyright: Steven E. Pav, 2017
# Author: Steven E. Pav <shabbychef@gmail.com>
# Comments: Steven E. Pav

#' @title sierpinski_maze .
#'
#' @description 
#'
#' Recursively draw a Sierpinski triangle maze. The sides of the
#' triangle consist of \eqn{2^{depth}} pieces of length
#' \code{unit_len}.
#' The \sQuote{inner} and \sQuote{outer} pieces of
#' the flake are mazes drawn in different colors.
#'
#' @details
#'
#' Draws a maze in an Sierpinski Triangle. 
#'
#' @keywords plotting
#' @template etc
#' @template param-unitlen
#' @template param-clockwise
#' @template param-start-from
#' @template param-end-side
#' @template param-boundary-stuff
#' @template param-boundary-hole-controls
#' @template param-colors
#' @template return-none
#' @param depth the depth of recursion. This controls the side length.
#' Should be an integer.
#' @examples
#' library(TurtleGraphics)
#' turtle_init(1000,1000,mode='clip')
#' turtle_up()
#' turtle_hide()
#' turtle_do({
#' 	turtle_setpos(10,500)
#' 	turtle_setangle(0)
#' 	sierpinski_maze(depth=5,unit_len=19,boundary_lines=TRUE,
#' 	  boundary_hole_sides=c(1,3),color1='black',color2='gray60')
#' })
#'
#' @export
sierpinski_maze <- function(depth,unit_len,clockwise=TRUE,
														start_from=c('midpoint','corner'),
														method='random',
														color1='black',color2='gray40',
														draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,
														boundary_holes=NULL,boundary_hole_color=NULL,boundary_hole_locations=NULL,
														end_side=1) {

	start_from <- match.arg(start_from)
	num_segs <- 2^depth

	multiplier <- ifelse(clockwise,1,-1)

	if (start_from=='midpoint') { turtle_backward(distance=unit_len * num_segs/2) }

	if (depth > 1) {
		for (iter in 1:3) {
			sierpinski_maze(unit_len=unit_len,depth=depth-1,clockwise=clockwise,method=method,
											start_from='corner',draw_boundary=FALSE,
											color1=color1,color2=color2)
			turtle_forward(unit_len * num_segs)
			.turn_right(multiplier * 120)
		}

		turtle_forward(unit_len * num_segs/2)
		.turn_right(multiplier * 60)
		turtle_col(color2)
		eq_triangle_maze(unit_len,depth=depth-1,clockwise=clockwise,start_from='corner',method=method)
		turtle_col(color1)
		holey_path(unit_len,lengths=num_segs/2,angles=rep(multiplier*120,3),
							 draw_line=TRUE,has_hole=rep(TRUE,3))
		.turn_left(multiplier * 60)
		turtle_backward(unit_len * num_segs/2)
	} else {
		turtle_col(color1)
		eq_triangle_maze(unit_len,depth=depth,clockwise=clockwise,start_from='corner',method=method,draw_boundary=FALSE)
	}

	if (draw_boundary) {
		.do_boundary(unit_len,lengths=rep(num_segs,3),angles=multiplier*120,
								 num_boundary_holes=num_boundary_holes,boundary_lines=boundary_lines,
								 boundary_holes=boundary_holes,boundary_hole_color=boundary_hole_color,
								 boundary_hole_locations=boundary_hole_locations)
	}
	# move to ending side
	if ((end_side != 1) && (!is.null(end_side))) {
		for (iii in 1:(end_side-1)) {
			turtle_forward(distance=unit_len * num_segs)
			.turn_right(multiplier * 120)
		}
	}

	if (start_from=='midpoint') { turtle_forward(distance=unit_len * num_segs/2) }
}

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
