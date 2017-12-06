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

# Created: 2017.11.16
# Copyright: Steven E. Pav, 2017
# Author: Steven E. Pav <shabbychef@gmail.com>
# Comments: Steven E. Pav


#' @title dodecagon_maze .
#'
#' @description 
#'
#' Draw a regular dodecagon maze, with each side consisting of
#' of \eqn{2^{depth}} pieces of length \code{unit_len}. 
#'
#' @details
#'
#' Draws a maze in a regular dodecagon. Currently dissects the maze
#' into a hexagon and a ring of squares and equilateral triangles.
#'
#' \if{html}{
#' \figure{simple-dodecagon-1.png}{options: width="100\%" alt="Figure: hex ring dodecagon"}
#' }
#' \if{latex}{
#' \figure{simple-dodecagon-1.png}{options: width=7cm}
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
#' @template return-none
#' @param depth the depth of recursion. This controls the side length.
#'
#' @param method there are a few ways to recursively draw an decagon. 
#' The following values are acceptable:
#' \describe{
#' \item{hex_ring}{A regular hexagon maze in the center is drawn, with a 
#' ring of alternating squares and equilateral triangle mazes around it.}
#' }
#'
#' @examples 
#' \dontrun{
#' turtle_init(2200,2200,mode='clip')
#' turtle_hide()
#' turtle_up()
#' turtle_do({
#'   turtle_setpos(25,1100)
#'   turtle_setangle(0)
#' 	 dodecagon_maze(5,21,draw_boundary=TRUE,boundary_holes=c(1,6))
#' })
#' }
#' @export
dodecagon_maze <- function(depth,unit_len=4L,clockwise=TRUE,start_from=c('midpoint','corner'),
												 method=c('hex_ring'),
												 draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,
												 boundary_holes=NULL,boundary_hole_color=NULL,boundary_hole_locations=NULL,
												 boundary_hole_arrows=FALSE,
												 end_side=1) {
	method <- match.arg(method)
	start_from <- match.arg(start_from)
	num_segs <- round(2^depth)

	multiplier <- ifelse(clockwise,1,-1)
	if (start_from=='midpoint') { turtle_backward(distance=unit_len * num_segs/2) }

	nsides <- 12
	outang <- (180 * (nsides-2)) / nsides
	inang <- 180 - outang

	switch(method,
				 hex_ring={
					 .turn_right(multiplier * 60)
					 starts <- c(1,1,2,
											 3,3,4,
											 5,5,6,
											 7,7,8,
											 9,9,10,
											 11,11,12)
					 ends <- c(12,2,0,
										 2,4,0,
										 4,6,0,
										 6,8,0,
										 8,10,0,
										 10,12,0)
					 which_holes <- .span_tree(starts,ends)

					 inner_lines <- rep(c(TRUE,TRUE,FALSE,
																FALSE,FALSE,FALSE,TRUE),6)
					 inner_holes <- rep(FALSE,length(inner_lines))
					 inner_holes[which(inner_lines)[which_holes]] <- TRUE

					 for (iii in c(1:6)) {
						 tri_myidx <- (1:3) + (iii-1) * 7 
						 sqr_myidx <- (4:7) + (iii-1) * 7 
						 eq_triangle_maze(unit_len=unit_len,depth=depth,clockwise=!clockwise,start_from='corner',
															draw_boundary=TRUE,num_boundary_holes=NULL,
															boundary_lines=inner_lines[tri_myidx],
															boundary_holes=inner_holes[tri_myidx],
															end_side=2)

						 parallelogram_maze(unit_len=unit_len,height=num_segs,width=num_segs,angle=90,
																clockwise=clockwise,start_from='corner',
																draw_boundary=TRUE,num_boundary_holes=NULL,
																boundary_lines=inner_lines[sqr_myidx],
																boundary_holes=inner_holes[sqr_myidx],
																end_side=3)
					 }
					 turtle_forward(num_segs*unit_len)
					 .turn_right(multiplier * 90)
					 hexagon_maze(unit_len=unit_len,depth=depth,clockwise=!clockwise,start_from='corner',
												draw_boundary=FALSE)
					 .turn_left(multiplier * 90)
					 turtle_backward(num_segs*unit_len)
					 .turn_left(multiplier * 60)

	})
	if (draw_boundary) {
		.do_boundary(unit_len,lengths=rep(num_segs,nsides),angles=multiplier * inang,
								 num_boundary_holes=num_boundary_holes,boundary_lines=boundary_lines,
								 boundary_holes=boundary_holes,boundary_hole_color=boundary_hole_color,
								 boundary_hole_locations=boundary_hole_locations,boundary_hole_arrows=boundary_hole_arrows)
	}
	# move to ending side
	if ((end_side != 1) && (!is.null(end_side))) {
		for (iii in 1:(end_side-1)) {
			turtle_forward(distance=unit_len * num_segs)
			.turn_right(multiplier * inang)
		}
	}
	if (start_from=='midpoint') { turtle_forward(distance=unit_len * num_segs/2) }
}

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
