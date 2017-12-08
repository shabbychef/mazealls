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

# Created: 2017.11.25
# Copyright: Steven E. Pav, 2017
# Author: Steven E. Pav <shabbychef@gmail.com>
# Comments: Steven E. Pav

#' @title hexaflake_maze .
#'
#' @description 
#'
#' Recursively draw a hexaflake maze, a cross between a Koch snowflake
#' and a Sierpinski triangle. The outer part of the flake consists of 
#' a hexagon of side length \eqn{3^{depth}} pieces of length
#' \code{unit_len}. The \sQuote{inner} and \sQuote{outer} pieces of
#' the flake are mazes drawn in different colors.
#'
#' @details
#'
#' Draws a maze in an Hexflake. Relies on generation of hexagonal and
#' triangular mazes for the internals. An internal hexagon and
#' six surrounding hexagons are recursively drawn as hexaflakes,
#' connected by 12 equilateral triangles, drawn in the secondary color:
#'
#' \if{html}{
#' \figure{hexaflake-1.png}{options: width="100\%" alt="Figure: Hexaflake maze"}
#' }
#' \if{latex}{
#' \figure{hexaflake-1.png}{options: width=7cm}
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
#' @seealso \code{\link{sierpinski_trapezoid_maze}}.
#' @examples
#' library(TurtleGraphics)
#' turtle_init(1000,1000,mode='clip')
#' turtle_hide()
#' turtle_do({
#'   turtle_setpos(50,500)
#'   turtle_setangle(0)
#'   hexaflake_maze(depth=3,unit_len=10,draw_boundary=TRUE,color2='green')
#' })
#'
#' @export
hexaflake_maze <- function(depth,unit_len,clockwise=TRUE,
													 start_from=c('midpoint','corner'),
													 color1='black',color2='gray40',
													 draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,
													 boundary_holes=NULL,boundary_hole_color=NULL,boundary_hole_locations=NULL,
													 boundary_hole_arrows=FALSE,
													 end_side=1) {

	start_from <- match.arg(start_from)
	num_segs <- round(3^depth)
	if (!.is_divisible_by_three(num_segs)) {
		turtle_col(color1)
		hexagon_maze(depth=depth,unit_len=unit_len,
								 clockwise=clockwise,start_from=start_from,
								 draw_boundary=draw_boundary,
								 num_boundary_holes=num_boundary_holes,
								 boundary_lines=boundary_lines,
								 boundary_holes=boundary_holes,
								 boundary_hole_locations=boundary_hole_locations,
								 boundary_hole_color=boundary_hole_color,
								 boundary_hole_arrows=boundary_hole_arrows,
								 end_side=end_side)
	} else {
		multiplier <- ifelse(clockwise,1,-1)
		if (start_from=='corner') { turtle_forward(distance=unit_len * num_segs/2) }

		.in_middle <- function(x) {
			(3 * x > num_segs) && (3 * x <= 2*num_segs)
		}
		# you have to pass these to the sub mazes ... 
		nsides <- 6
		holes <- .interpret_boundary_holes(boundary_holes,num_boundary_holes,nsides=nsides)
		if (!draw_boundary) { 
			boundary_lines <- rep(FALSE,nsides)
			boundary_hole_arrows <- rep(FALSE,nsides)
		} else {
			boundary_lines <- .interpret_boundary_lines(boundary_lines,nsides=nsides)
			if (is.logical(boundary_lines)) { boundary_lines <- .recycle_no_warn(boundary_lines,nsides) }
			boundary_hole_arrows <- .interpret_boundary_hole_arrows(boundary_hole_arrows,nsides=nsides)
		}
		if (is.null(boundary_hole_color)) { 
			boundary_hole_color <- rep('clear',6) 
		} else {
			boundary_hole_color <- .recycle_no_warn(boundary_hole_color,nsides)
		}
		if (is.null(boundary_hole_locations)) { boundary_hole_locations <- sample.int(num_segs,size=6,replace=TRUE) }
		bhl_in_mid <- (boundary_hole_locations > num_segs/3) & (boundary_hole_locations <= 2*num_segs/3)
		bhl_in_high <- (boundary_hole_locations > 2*num_segs/3) 
		bhl_in_low <- ! (bhl_in_mid | bhl_in_high)
		#browser()

		turtle_backward(distance=unit_len * num_segs/6) 
		.turn_right(multiplier * 60)


		starts <- c(kronecker(c(1:7),rep(1,4)),rep(7,2))
		ends   <- c(10,12,13,11,
								12,14,15,13,
								14,16,17,15,
								16,18,19,17,
								18,20,21,19,
								20,10,11,21,
								13,15,17,19,21,11)
								
		which_holes <- .span_tree(starts,ends)

		inner_lines <- c(rep(c(TRUE,FALSE,FALSE,rep(TRUE,3)),6),rep(TRUE,6))
		inner_holes <- rep(FALSE,length(inner_lines))
		inner_holes[which(inner_lines)[which_holes]] <- TRUE

		for (iii in 1:6) {
			turtle_col(color2)
			eq_triangle_maze(unit_len,depth=log2(num_segs/3),
											 clockwise=!clockwise,
											 start_from='corner',
											 draw_boundary=TRUE,
											 boundary_lines=c(FALSE,FALSE,boundary_lines[iii]),
											 boundary_holes=c(FALSE,FALSE,holes[iii] && bhl_in_mid[iii]),
											 boundary_hole_locations=c(0,0,max(0,boundary_hole_locations[iii] - num_segs/3)),
											 boundary_hole_color=c('clear','clear',boundary_hole_color[iii]),
											 boundary_hole_arrows=boundary_hole_arrows[iii],
											 end_side=1)
			turtle_forward(distance=unit_len * num_segs/3) 
			eq_triangle_maze(unit_len,depth=log2(num_segs/3),
											 clockwise=clockwise,
											 start_from='corner',
											 draw_boundary=FALSE,
											 end_side=3)
			turtle_forward(distance=unit_len * num_segs/3) 
			next_iii <- 1 + (iii %% 6)

			myidx <- (1:6) + (iii-1) * 6
			blines <- inner_lines[myidx]
			bholes <- inner_holes[myidx]
			blines[2] <- boundary_lines[iii]
			blines[3] <- boundary_lines[next_iii]
			bholes[2] <- holes[iii] && bhl_in_high[iii]
			bholes[3] <- holes[next_iii] && bhl_in_low[next_iii]
			bholoc <- rep(0,6)
			bholoc[2] <- boundary_hole_locations[iii] - 2*num_segs / 3
			bholoc[3] <- boundary_hole_locations[next_iii]
			bhc <- rep('clear',6)
			bhc[2] <- boundary_hole_color[iii]
			bhc[3] <- boundary_hole_color[next_iii]
			bha <- rep(FALSE,6)
			bha[2] <- boundary_hole_arrows[iii]
			bha[3] <- boundary_hole_arrows[next_iii]

			turtle_col(color1)
			hexaflake_maze(depth=depth-1,unit_len=unit_len,
										 clockwise=clockwise,start_from='corner',
										 color1=color1,color2=color2,
										 draw_boundary=TRUE,
										 num_boundary_holes=NULL,
										 boundary_lines=blines,
										 boundary_holes=bholes,
										 boundary_hole_locations=bholoc,
										 boundary_hole_color=bhc,
										 boundary_hole_arrows=bha,
										 end_side=4)
		}

		# do the center
		
		turtle_forward(distance=unit_len * 2 * num_segs/3) 
		myidx <- (1:6) + (6) * 6
		turtle_col(color1)
		hexaflake_maze(depth=depth-1,unit_len=unit_len,
									 clockwise=clockwise,start_from='corner',
									 color1=color1,color2=color2,
									 draw_boundary=TRUE,
									 num_boundary_holes=NULL,
									 boundary_lines=inner_lines[myidx],
									 boundary_holes=inner_holes[myidx],
									 boundary_hole_arrows=FALSE,
									 end_side=1)
		turtle_backward(distance=unit_len * 2 * num_segs/3) 

		.turn_left(multiplier * 60)
		turtle_forward(distance=unit_len * num_segs/6) 


		#if (draw_boundary) {
			#turtle_backward(distance=unit_len * num_segs/2)
			#.do_boundary(unit_len,lengths=rep(num_segs,6),angles=multiplier * 60,
									 #num_boundary_holes=num_boundary_holes,boundary_lines=boundary_lines,
									 #boundary_holes=boundary_holes,boundary_hole_color=boundary_hole_color,
		               #boundary_hole_locations=boundary_hole_locations,boundary_hole_arrows=boundary_hole_arrows)
			#turtle_forward(distance=unit_len * num_segs/2)
		#}
		if ((end_side != 1) && (!is.null(end_side))) {
			for (iii in 1:(end_side-1)) {
				turtle_forward(distance=unit_len * num_segs/2)
				.turn_right(multiplier * 60)
				turtle_forward(distance=unit_len * num_segs/2)
			}
		}
		if (start_from=='corner') { turtle_backward(distance=unit_len * num_segs/2) }
	}
}

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
