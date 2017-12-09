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
#' Draws a maze in an Sierpinski equilateral Triangle. The inner quarter is
#' drawn in the secondary color, while the outer three quarters are drawn
#' recursively. This is the traditional Sierpinski Triangle, generated when
#' \code{style=='four_triangles'}:
#'
#' \if{html}{
#' \figure{sierpinski-1.png}{options: width="100\%" alt="Figure: Sierpinski triangle"}
#' }
#' \if{latex}{
#' \figure{sierpinski-1.png}{options: width=7cm}
#' }
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
#' @param method controls the method to draw the underlying
#' equilateral triangles. See \code{\link{eq_triangle_maze}}.
#' @param style controls the style of Sierpinski triangle. The
#' following are recognized:
#' \describe{
#' \item{four_triangles}{The traditional Sierpinski Triangle of four triangles
#' with the center in the minor color, \code{color2}.}
#' \item{hexaflake}{Looks more like a hexaflake in a triangle.}
#' \item{dragon_left}{Looks like a dragon fractal.}
#' \item{dragon_right}{Looks like a dragon fractal.}
#' }
#'
#' @seealso \code{\link{eq_triangle_maze}},
#' \code{\link{hexaflake_maze}},
#' \code{\link{sierpinski_carpet_maze}},
#' \code{\link{sierpinski_trapezoid_maze}},
#' @examples
#' library(TurtleGraphics)
#' turtle_init(1000,1000,mode='clip')
#' turtle_up()
#' turtle_hide()
#' turtle_do({
#' 	turtle_setpos(10,500)
#' 	turtle_setangle(0)
#' 	sierpinski_maze(depth=5,unit_len=19,boundary_lines=TRUE,
#' 	  boundary_holes=c(1,3),color1='black',color2='gray60')
#' })
#'
#' @export
sierpinski_maze <- function(depth,unit_len,clockwise=TRUE,
														start_from=c('midpoint','corner'),
														method='random',
														style=c('four_triangles','hexaflake','dragon_left','dragon_right'),
														color1='black',color2='gray40',
														draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,
														boundary_holes=NULL,boundary_hole_color=NULL,boundary_hole_locations=NULL,
														boundary_hole_arrows=FALSE,
														end_side=1) {


	#cat(str(list(dep=depth,
							 #db=draw_boundary,
							 #bl=boundary_lines,
							 #bh=boundary_holes,
							 #bo=boundary_hole_locations,
							 #bc=boundary_hole_color)))

	start_from <- match.arg(start_from)
	num_segs <- 2^depth
	style <- match.arg(style)

	multiplier <- ifelse(clockwise,1,-1)

	if (start_from=='midpoint') { turtle_backward(distance=unit_len * num_segs/2) }

	if (style=='four_triangles') {
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
									 boundary_hole_locations=boundary_hole_locations,boundary_hole_arrows=boundary_hole_arrows)
		}
	} else {
		if (depth > 1) {
			# you have to pass these to the sub mazes ... 
			nsides <- 3
			holes <- .interpret_boundary_holes(boundary_holes,num_boundary_holes,nsides=nsides)
			boundary_lines <- .interpret_boundary_lines(boundary_lines,nsides=nsides)
			if (is.logical(boundary_lines)) { boundary_lines <- .recycle_no_warn(boundary_lines,nsides) }
			if (is.null(boundary_hole_color)) { boundary_hole_color <- rep('clear',nsides) }
			boundary_hole_color <- .recycle_no_warn(boundary_hole_color,nsides)
			if (is.null(boundary_hole_locations)) { 
				boundary_hole_locations <- sample.int(num_segs,size=3,replace=TRUE) 
			}
			boundary_hole_arrows <- .interpret_boundary_hole_arrows(boundary_hole_arrows,nsides=nsides)

			bline <- draw_boundary & c(boundary_lines[1:2],FALSE,boundary_lines[3])
			bhole <- c(holes[1],
								 holes[2] & (boundary_hole_locations[2] <= num_segs/2),
								 FALSE,
								 holes[3] & (boundary_hole_locations[3] > num_segs/2))
			bholoc <- c(boundary_hole_locations[1:2],0,boundary_hole_locations[3] - num_segs/2)
			bcolor <- c(boundary_hole_color[1:2],'clear',boundary_hole_color[3])
			bha    <- c(boundary_hole_arrows[1:2],FALSE,boundary_hole_arrows[3])

			flipc <- switch(style,
											hexaflake=1,
											dragon_left=2,
											sierpinski=3,
											dragon_right=4)

			sierpinski_trapezoid_maze(depth-1,unit_len=unit_len,
															clockwise=clockwise,start_from='corner',
															color1=color1,color2=color2,
															flip_color_parts=flipc,
															draw_boundary=TRUE,
															num_boundary_holes=NULL,
															boundary_lines=bline,
															boundary_holes=bhole,
															boundary_hole_locations=bholoc,
															boundary_hole_color=bcolor,
															boundary_hole_arrows=bha,
															end_side=3)
			# recurse
			turtle_forward(unit_len * num_segs/2)
			turtle_right(180)

			#browser()
			sierpinski_maze(depth-1,unit_len=unit_len,clockwise=clockwise,
											start_from='corner',
											method=method,style=style,
											color1=color1,color2=color2,
											draw_boundary=TRUE,
											num_boundary_holes=NULL,
											boundary_lines=c(TRUE,boundary_lines[2],boundary_lines[3]),
											boundary_holes=c(TRUE,holes[2] & (boundary_hole_locations[2] > num_segs/2),holes[3] & (boundary_hole_locations[3] <= num_segs/2)),
											boundary_hole_locations=c(0,boundary_hole_locations[2] - num_segs/2,min(boundary_hole_locations[3],num_segs/2)),
											boundary_hole_color=c('clear',boundary_hole_color[2],boundary_hole_color[3]),
											boundary_hole_arrows=c(FALSE,boundary_hole_arrows[2],boundary_hole_arrows[3]),
											end_side=1)
			turtle_right(180)
			.turn_right(multiplier * 60)
			turtle_forward(unit_len * num_segs/2)
			.turn_right(multiplier * 120)
		} else {
			if (draw_boundary) {
				turtle_col(color1)
				.do_boundary(unit_len,lengths=rep(num_segs,3),angles=multiplier*120,
										 num_boundary_holes=num_boundary_holes,boundary_lines=boundary_lines,
										 boundary_holes=boundary_holes,boundary_hole_color=boundary_hole_color,
										 boundary_hole_locations=boundary_hole_locations,boundary_hole_arrows=boundary_hole_arrows)
			}
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
