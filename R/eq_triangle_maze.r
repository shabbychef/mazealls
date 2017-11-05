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

#' @title eq_triangle_maze .
#'
#' @description 
#'
#' Recursively draw an equilateral triangle, with sides consisting
#' of \eqn{2^depth} pieces of length \code{unit_len}.
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
#' @param depth the depth of recursion. This controls the side length.
#'
#' @param method there are many ways to recursive draw a triangle. The
#' following values are acceptable:
#' \describe{
#' \item{stack_trapezoids}{Isosceles trapezoids are stacked on top of each
#' other, with the long sides aligned to the first side.}
#' \item{triangles}{The triangle maze is recursively drawn as four
#' equilateral triangle mazes of half size, each connected to their neighbors.}
#' \item{uniform}{The triangle maze is recursively drawn as four
#' equilateral triangle uniform mazes of half size, each connected to their
#' neighbors.}
#' \item{two_ears}{The triangle maze is recursively drawn as a large
#' parallelogram maze connected to two two half size equilateral triangle
#' mazes, which are \sQuote{ears}.}
#' \item{random}{A method is randomly selected from the available methods.}
#' \item{hex_and_three}{When \eqn{2^depth} is a power of three, the triangle
#' is drawn as a hexagonal maze of one third size connected to three
#' equilateral triangular mazes, each one third size, at the corners.}
#' \item{shave}{Here \eqn{2^depth} can be arbitrary. A single line is
#' \sQuote{shaved} off the triangle, connected to another equilateral triangle of
#' length one less is drawn next to it. This sub triangle will either be
#' drawn using a \sQuote{hex_and_three}, \sQuote{random}, or \sQuote{shave}
#' methods, in decreasing order of preference, depending on the side length.}
#' \item{shave_all}{Here \eqn{2^depth} can be arbitrary. A single line is
#' \sQuote{shaved} off the triangle, connected to another equilateral triangle of
#' length one less is drawn next to it. This sub triangle will also be drawn
#' using the \sQuote{shave_all} method. These mazes tend to look boring, and
#' are not recommended.}
#' }
#'
#' @examples 
#' \dontrun{
#' turtle_init(1500,1500)
#' turtle_hide() 
#' turtle_up()
#' turtle_do({
#'   turtle_left(90)
#'   turtle_forward(40)
#'   turtle_right(90)
#'   eq_triangle_maze(depth=4,12,clockwise=FALSE,method='two_ears',draw_boundary=TRUE)
#' })
#'
#' turtle_init(1500,1500)
#' turtle_hide() 
#' turtle_up()
#' turtle_do({
#'   turtle_left(90)
#'   turtle_forward(40)
#'   turtle_right(90)
#'   eq_triangle_maze(depth=4,12,clockwise=FALSE,method='random',draw_boundary=TRUE)
#' })
#'
#' # join two together, with green holes on opposite sides
#' turtle_init(1500,1500)
#' turtle_hide() 
#' turtle_up()
#' turtle_do({
#'   turtle_left(90)
#'   turtle_forward(40)
#'   turtle_right(90)
#'   eq_triangle_maze(depth=5,12,clockwise=TRUE,method='two_ears',draw_boundary=TRUE,boundary_holes=c(1,3),boundary_hole_color=c('clear','clear','green'))
#'   eq_triangle_maze(depth=5,12,clockwise=FALSE,method='uniform',draw_boundary=TRUE,boundary_lines=c(2,3),boundary_holes=c(2),boundary_hole_color='green')
#' })
#'
#' # non integral depths also possible:
#' turtle_init(1500,1500)
#' turtle_hide() 
#' turtle_up()
#' turtle_do({
#'   turtle_left(90)
#'   turtle_forward(40)
#'   turtle_right(90)
#'   eq_triangle_maze(depth=log2(81),12,clockwise=TRUE,method='hex_and_three',draw_boundary=TRUE,boundary_holes=c(1,3),boundary_hole_color=c('clear','clear','green'))
#'   eq_triangle_maze(depth=log2(81),12,clockwise=FALSE,method='shave',draw_boundary=TRUE,boundary_lines=c(2,3),boundary_holes=c(2),boundary_hole_color='green')
#' })
#' }
#' @export
eq_triangle_maze <- function(depth,unit_len,clockwise=TRUE,
														 method=c('stack_trapezoids','triangles','uniform','two_ears','random','hex_and_three','shave_all','shave'),
														 start_from=c('midpoint','corner'),
														 draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,boundary_holes=NULL,boundary_hole_color=NULL,
														 end_side=1) {
	
	method <- match.arg(method)
	start_from <- match.arg(start_from)

# check for hex and three ... 
	# check for off powers of two
	non_two <- ! .near_integer(depth)
	num_segs <- round(2^depth)
	by_three <- num_segs / 3

	if (method != 'random') {
		if (non_two) {
			if ( (.near_integer(by_three) && !(method %in% c('hex_and_three','shave','shave_all'))) ||
					 (.is_even(num_segs) && !(method %in% c('shave','shave_all','stack_trapezoids'))) ||
					 !(method %in% c('shave','shave_all','stack_trapezoids')) ) {
				method <- 'random'
			}
		} else {
			if (method %in% c('hex_and_three')) {
				method <- 'random'
			}
		}
	} 

	multiplier <- ifelse(clockwise,1,-1)

	if (start_from=='corner') { turtle_forward(dist=unit_len * num_segs/2) }

	if (depth > 0) {
		my_method <- switch(method,
												shave_all={ 'shave' },
												uniform={ 'triangles' },
												random={
													ifelse(non_two,
																 ifelse(.near_integer(by_three),
																				sample(c('hex_and_three','stack_trapezoids','shave','shave_all'),1),
																				sample(c('stack_trapezoids','shave','shave_all'),1)),
																 sample(c('stack_trapezoids','triangles','two_ears','uniform'),1))
												},
												method)
		switch(my_method,
					 stack_trapezoids={
						 iso_trapezoid_maze(depth-1,unit_len,clockwise=clockwise,draw_boundary=FALSE)
						 # now move over
						 magic_ratio <- sqrt(3) / 4

						 turtle_up()
						 .turn_right(multiplier * 90)
						 turtle_forward(num_segs * unit_len * magic_ratio)
						 .turn_left(multiplier * 90)
						 eq_triangle_maze(depth-1,unit_len,clockwise=clockwise,method=method,draw_boundary=TRUE,
															boundary_lines=c(1),boundary_holes=c(1))
						 .turn_left(multiplier * 90)
						 turtle_forward(num_segs * unit_len * magic_ratio)
						 .turn_right(multiplier * 90)
					 },
					 hex_and_three={
						 hexagon_maze(depth=log2(by_three),unit_len,clockwise=clockwise,method='random',
													start_from='midpoint',draw_boundary=TRUE,num_boundary_holes=0,
													boundary_lines=c(2,4,6),boundary_holes=c(2,4,6))
						 for (iii in c(1:3)) {
							 turtle_forward(dist=num_segs * unit_len/2)
							 .turn_right(multiplier*120)
							 eq_triangle_maze(depth=log2(by_three),unit_len,clockwise=clockwise,
																start_from='corner',method='random',draw_boundary=FALSE)
							 turtle_forward(dist=num_segs * unit_len/2)
						 }
					 },
					 two_ears={
						 # parallelogram and two triangles
						 turtle_backward(unit_len*num_segs/2)
						 parallelogram_maze(unit_len,height=num_segs/2,width=num_segs/2,angle=60,clockwise=clockwise,
																method='random',start_from='corner',
																draw_boundary=TRUE,boundary_lines=c(2,3),boundary_holes=c(2,3))
						 # now the other two triangles.
						 for (iii in c(1,2)) {
							 turtle_forward(unit_len*num_segs)
							 .turn_right(multiplier * 120)
							 eq_triangle_maze(depth-1,unit_len,clockwise=clockwise,method=method,start_from='corner',draw_boundary=FALSE)
						 }
						 turtle_forward(unit_len*num_segs)
						 .turn_right(multiplier * 120)
						 turtle_forward(unit_len*num_segs/2)
					 },
					 shave={
						 sub_num <- num_segs - 1
						 sub_method <- switch(method,
																	shave_all={ 'shave_all' },
																	shave={  ifelse(.is_divisible_by_three(sub_num),'hex_and_three',
																									ifelse(.is_power_of_two(sub_num),'random','shave')) })

						 shave_side <- sample.int(n=3,size=1)
						 turtle_backward(unit_len*num_segs/2)
						 for (iii in seq_len(shave_side-1)) {
							 turtle_forward(unit_len*num_segs)
							 .turn_right(multiplier*120)
						 }
						 eq_triangle_maze(log2(sub_num),unit_len,clockwise=clockwise,method=sub_method,start_from='corner',
															draw_boundary=TRUE,boundary_lines=c(2),boundary_holes=c(2))
						 for (iii in seq_len(shave_side-1)) {
							 .turn_left(multiplier*120)
							 turtle_backward(unit_len*num_segs)
						 }
						 turtle_forward(unit_len*num_segs/2)
					 },
					 triangles={
						 sub_method <- method
						 if (! (sub_method %in% c('random','uniform'))) { sub_method <- sample(c('stack_trapezoids','two_ears'),1) }

						 turtle_up()
						 turtle_backward(dist=unit_len * num_segs/2)
						 for (iii in c(1:3)) {
							 eq_triangle_maze(depth-1,unit_len,clockwise=clockwise,start_from='corner',
														 method=sub_method,draw_boundary=FALSE)
							 turtle_forward(dist=unit_len * num_segs)
							 .turn_right(multiplier * 120)
						 }
						 turtle_forward(dist=unit_len * num_segs/2)
						 .turn_right(multiplier * 60)
						 eq_triangle_maze(depth-1,unit_len,clockwise=clockwise,start_from='corner',
													 method=sub_method,draw_boundary=TRUE,num_boundary_holes=3)
						 .turn_left(multiplier * 60)
					 })
	}
	if (draw_boundary) {
		holes <- .interpret_boundary_holes(boundary_holes,num_boundary_holes,nsides=3)
		boundary_lines <- .interpret_boundary_lines(boundary_lines,nsides=3)
		turtle_backward(dist=unit_len * num_segs/2)

		holey_path(unit_len=unit_len,
							lengths=num_segs,
							angles=multiplier * 120,
							draw_line=boundary_lines,
							has_hole=holes,
							hole_color=boundary_hole_color)
		turtle_forward(dist=unit_len * num_segs/2)
	}
	# move to ending side
	if ((end_side != 1) && (!is.null(end_side))) {
		for (iii in 1:(end_side-1)) {
			turtle_forward(dist=unit_len * num_segs/2)
			.turn_right(multiplier * 120)
			turtle_forward(dist=unit_len * num_segs/2)
		}
	}
	if (start_from=='corner') { turtle_backward(dist=unit_len * num_segs/2) }
}

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
