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

# Created: 2017.12.16
# Copyright: Steven E. Pav, 2017
# Author: Steven E. Pav <shabbychef@gmail.com>
# Comments: Steven E. Pav

#' @title sierpinski_hexagon_maze .
#'
#' @description 
#'
#' Draws a Sierpinski hexagon maze. 
#'
#' @details
#'
#' Recursively draw a Sierpinski hexagon maze. The sides of the
#' hexagon consist of \eqn{2^{depth}} pieces of length
#' \code{unit_len}. The hexagon is drawn as a ring of six
#' Sierpinski trapezoids in a ring around a Sierpinski
#' hexagon of a smaller size. 
#' The \sQuote{inner} and \sQuote{outer} pieces of
#' mazes drawn in different colors. The 
#'
#' @keywords plotting
#' @template sierpinski
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
#' @param style controls the style of Sierpinski triangle. The
#' following are recognized:
#' \describe{
#' \item{sierpinski}{The traditional Sierpinski Triangle of four triangles
#' with the center in the minor color, \code{color2}.}
#' \item{hexaflake}{Looks more like a hexaflake in a triangle.}
#' \item{reverse_flake}{Like a hexaflake, but the colors reverse in recursive
#' calls.}
#' \item{outer_flake}{Like a hexaflake, but only for the outermost ring.}
#' \item{dragon_left}{Looks like a dragon fractal.}
#' \item{dragon_right}{Looks like a dragon fractal.}
#' \item{dragon_leftright}{Looks like a dragon fractal.}
#' \item{dragon_rightleft}{Looks like a dragon fractal.}
#' }
#'
#' @seealso \code{\link{eq_triangle_maze}},
#' \code{\link{hexaflake_maze}},
#' \code{\link{sierpinski_carpet_maze}},
#' \code{\link{sierpinski_trapezoid_maze}}.
#' @examples
#' library(TurtleGraphics)
#' turtle_init(800,800,mode='clip')
#' turtle_up()
#' turtle_hide()
#' turtle_do({
#' 	turtle_setpos(50,400)
#' 	turtle_setangle(30)
#' 	sierpinski_hexagon_maze(depth=4,unit_len=20,boundary_lines=TRUE,
#' 													draw_boundary=TRUE,boundary_holes=c(1,3),
#' 													start_from='corner',
#' 													color1='black',color2='green',
#' 													style='sierpinski')
#' })
#'
#' @export
sierpinski_hexagon_maze <- function(depth,unit_len,clockwise=TRUE,
																		start_from=c('midpoint','corner'),
																		style=c('sierpinski','four_triangles','hexaflake',
																						'reverse_flake','outer_flake',
																						'dragon_left','dragon_right','dragon_leftright','dragon_rightleft'),
																		color1='black',color2='gray40',
																		draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,
																		boundary_holes=NULL,boundary_hole_color=NULL,boundary_hole_locations=NULL,
																		boundary_hole_arrows=FALSE,
																		end_side=1) {

	start_from <- match.arg(start_from)
	num_segs <- 2^depth
	style <- match.arg(style)

	multiplier <- ifelse(clockwise,1,-1)

	if (start_from=='midpoint') { turtle_backward(distance=unit_len * num_segs/2) }

	if (depth > 0) {
		# you have to pass these to the sub mazes ... 
		nsides <- 6
		holes <- .interpret_boundary_holes(boundary_holes,num_boundary_holes,nsides=nsides)
		boundary_lines <- .interpret_boundary_lines(boundary_lines,nsides=nsides)
		if (is.logical(boundary_lines)) { boundary_lines <- .recycle_no_warn(boundary_lines,nsides) }
		if (is.null(boundary_hole_color)) { boundary_hole_color <- rep('clear',nsides) }
		boundary_hole_color <- .recycle_no_warn(boundary_hole_color,nsides)
		if (is.null(boundary_hole_locations)) { 
			boundary_hole_locations <- sample.int(num_segs,size=3,replace=TRUE) 
		}
		boundary_hole_arrows <- .interpret_boundary_hole_arrows(boundary_hole_arrows,nsides=nsides)

		flipc <- switch(style,
										hexaflake=1,
										reverse_flake=1,
										outer_flake=1,
										dragon_left=2,
										dragon_leftright=2,
										sierpinski=3,
										four_triangles=3,
										dragon_right=4,
										dragon_rightleft=4)


		starts <- kronecker(c(1:6),rep(1,2))
		ends   <- c(2,7,
								3,7,
								4,7,
								5,7,
								6,7,
								1,7)
		which_holes <- .span_tree(starts,ends)

		inner_lines <- rep(c(FALSE,TRUE,TRUE,FALSE),6)
		inner_holes <- rep(FALSE,length(inner_lines))
		inner_holes[which(inner_lines)[which_holes]] <- TRUE

		for (iii in 1:6) {
			myidx <- (1:4) + (iii-1) * 4
			blin <- inner_lines[myidx]
			bhol <- inner_holes[myidx]
			bcol <- rep('clear',4)
			bloc <- rep(0,4)
			bha  <- rep(FALSE,4)

			blin[1] <- draw_boundary & boundary_lines[iii]
			bhol[1] <- draw_boundary & holes[iii]
			bcol[1] <- boundary_hole_color[iii]
			bloc[1] <- boundary_hole_locations[iii]
			 bha[1] <- boundary_hole_arrows[iii]

			sierpinski_trapezoid_maze(unit_len=unit_len,depth=depth-1,clockwise=clockwise,
																color1=color1,color2=color2,
																start_from='corner',
																flip_color_parts=flipc,
																draw_boundary=TRUE,boundary_lines=blin,
																boundary_holes=bhol,boundary_hole_color=bcol,boundary_hole_locations=bloc,
																boundary_hole_arrows=bha,end_side=1) 

			turtle_forward(unit_len * num_segs)
			.turn_right(multiplier * 60)
		}

		# recurse
		sub_style <- switch(style,
												dragon_leftright='dragon_rightleft',
												dragon_rightleft='dragon_leftright',
												style)
		sub_color1 <- switch(style,
												 reverse_flake=color2,
												 outer_flake=color2,
												 color1)
		sub_color2 <- switch(style,
												 reverse_flake=color1,
												 color2)

		.turn_right(multiplier * 60)
		turtle_forward(unit_len * num_segs/2)
		.turn_left(multiplier * 60)
		sierpinski_hexagon_maze(depth=depth-1,unit_len=unit_len,clockwise=clockwise,
														start_from='corner',style=sub_style,
														color1=sub_color1,color2=sub_color2,
														draw_boundary=FALSE)
		.turn_right(multiplier * 60)
		turtle_backward(unit_len * num_segs/2)
		.turn_left(multiplier * 60)

	} else {
		if (draw_boundary) {
			turtle_col(color1)
			.do_boundary(unit_len,lengths=rep(num_segs,6),angles=multiplier*60,
									 num_boundary_holes=num_boundary_holes,boundary_lines=boundary_lines,
									 boundary_holes=boundary_holes,boundary_hole_color=boundary_hole_color,
									 boundary_hole_locations=boundary_hole_locations,boundary_hole_arrows=boundary_hole_arrows)
		}
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
