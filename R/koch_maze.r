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

# Created: 2017.11.05
# Copyright: Steven E. Pav, 2017
# Author: Steven E. Pav <shabbychef@gmail.com>
# Comments: Steven E. Pav

.koch_side <- function(unit_len,depth,clockwise=TRUE,has_hole=FALSE,hole_color=NULL) {
	multiplier <- ifelse(clockwise,1,-1)
	num_segs <- round(3^depth)
	if (has_hole) { bholes <- sample.int(4,1) } else { bholes = 0 }
	if (depth > 1) {
		.koch_side(unit_len,depth-1,clockwise=clockwise,has_hole=bholes==1,hole_color=hole_color)

		eq_triangle_maze(unit_len,depth=log2(num_segs/3),clockwise=!clockwise,start_from='corner',
										 draw_boundary=TRUE,num_boundary_holes=NULL,boundary_lines=c(1),
										 boundary_holes=1)

		.turn_left(multiplier * 60)
		.koch_side(unit_len,depth-1,clockwise=clockwise,has_hole=bholes==2,hole_color=hole_color)
		.turn_right(multiplier * 120)
		.koch_side(unit_len,depth-1,clockwise=clockwise,has_hole=bholes==3,hole_color=hole_color)
		.turn_left(multiplier * 60)
		.koch_side(unit_len,depth-1,clockwise=clockwise,has_hole=bholes==4,hole_color=hole_color)
	} else if (depth==1) {
		holey_path(unit_len=unit_len,
							 lengths=rep(1,4),
							 angles=multiplier * c(-60,120,-60,0),
							 draw_line=TRUE,
							 has_hole=c(1:4) %in% bholes,
							 hole_color=hole_color)
	} else if (depth==0) {
		holey_path(unit_len=unit_len,
							 lengths=1,
							 angles=0,
							 draw_line=TRUE,
							 has_hole=has_hole,
							 hole_color=hole_color)
	} else {
		warning('should give non-negative depth')
	}
}


#' @title koch_maze .
#'
#' @description 
#'
#' Recursively draw an Koch snowflake maze. The inner part of the snowflake
#' maze consists of an equilateral triangle of side length \eqn{3^{depth}}
#' pieces of length \code{unit_len}.
#'
#' @details
#'
#' Draws a maze in an Koch snowflake, starting from the corner of the
#' first side. Relies on generation of triangular mazes for the internals.
#' The triangular part has sides consisting of \code{3^depth} segments
#' of length \code{unit_len}.
#'
#' \if{html}{
#' \figure{koch-flake-1.png}{options: width="100\%" alt="Figure: Koch snowflake"}
#' }
#' \if{latex}{
#' \figure{koch-flake-1.png}{options: width=7cm}
#' }
#'
#' @keywords plotting
#' @template etc
#' @template param-unitlen
#' @template param-clockwise
#' @template param-boundary-stuff
#' @template return-none
#' @param depth the depth of recursion. This controls the side length.
#' Should be an integer.
#'
#'
#' @examples 
#'
#' library(TurtleGraphics)
#' turtle_init(2000,2000)
#' turtle_hide() 
#' turtle_up()
#' set.seed(1234)
#' turtle_do({
#' 	turtle_backward(distance=400)
#' 	turtle_left(90)
#' 	turtle_forward(650)
#' 	turtle_right(90)
#' 	turtle_right(30)
#' 	koch_maze(depth=4,unit_len=15)
#' })
#' @export
koch_maze <- function(depth,unit_len,clockwise=TRUE,
											draw_boundary=TRUE,num_boundary_holes=2,boundary_lines=TRUE,boundary_holes=NULL,boundary_hole_color=NULL) {
	
	# stupid arguments and templates stupid.
	stopifnot(boundary_lines)

	depth <- round(depth)
	multiplier <- ifelse(clockwise,1,-1)
	holes <- .interpret_boundary_holes(boundary_holes,num_boundary_holes,nsides=3)
	if (is.null(boundary_hole_color)) {
		boundary_hole_color <- rep(c('clear'),3)
	} else if (length(boundary_hole_color) < 3) {
		boundary_hole_color <- rep(boundary_hole_color,3)
	}

	for (iii in c(1:3)) {
		.koch_side(unit_len=unit_len,depth=depth,clockwise=clockwise,has_hole=holes[iii],hole_color=boundary_hole_color[iii])
		.turn_right(120 * multiplier)
	}
	eq_triangle_maze(unit_len=unit_len,depth=log2(3^depth),start_from='corner',clockwise=clockwise,draw_boundary=FALSE)
}

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
