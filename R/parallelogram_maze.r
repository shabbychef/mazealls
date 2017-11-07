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

# Created: 2017.11.04
# Copyright: Steven E. Pav, 2017
# Author: Steven E. Pav <shabbychef@gmail.com>
# Comments: Steven E. Pav

#' @title parallelogram_maze .
#'
#' @description 
#' 
#' Recursively draw a parallelogram maze, with the first side consisting of
#' \code{height} segments of length \code{unit_len}, and the second side 
#' \code{width} segments of length \code{unit_len}. The angle between
#' the first and second side may be set.
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
#' @param height the length of the first side in numbers of \code{unit_len}
#' segments.
#' @param width the length of the second side in numbers of \code{unit_len}
#' segments.
#' @param angle the angle (in degrees) between the first and second sides.
#' @param method there are many ways to recursive draw an isosceles
#' trapezoid.  The following values are acceptable:
#' \describe{
#' \item{two_parallelograms}{The parallelogram maze is built as two
#' parallelogram mazes with a holey line between them.}
#' \item{four_parallelograms}{The parallelogram maze is built as four
#' parallelogram mazes with three holey lines and one solid line between them.}
#' \item{uniform}{The parallelogram maze is built as four
#' parallelogram mazes with three holey lines and one solid line between them.
#' Sub-mazes are chosen to be nearly equal in size.}
#' \item{random}{A method is chosen uniformly at random.}
#' }
#' @param balance for the \code{two_parallelograms} method, we choose whether
#' to split on height or width based on a balance condition. The log odds
#' of choosing height over width is \code{balance} times the difference
#' \code{height - width}. Set to 0 by default for equal odds.
#' @examples
#' \dontrun{
#'
#' turtle_init(2000,2000)
#' turtle_hide()
#' turtle_up()
#' turtle_do({
#' 	parallelogram_maze(angle=90,unit_len=12,width=75,height=55,method='uniform',
#' 	 draw_boundary=TRUE)
#' })
#'
#' # testing imbalance condition
#' turtle_init(2000,2000)
#' turtle_hide()
#' turtle_up()
#' turtle_do({
#' 	turtle_left(90)
#' 	turtle_forward(700)
#' 	turtle_right(90)
#' 	parallelogram_maze(angle=90,unit_len=12,width=110,height=120,method='two_parallelograms',draw_boundary=TRUE,balance=-0.01)
#' })
#' 
#'
#' }
#' @export
parallelogram_maze <- function(unit_len,height,width=height,angle=90,clockwise=TRUE,
															 method=c('two_parallelograms','four_parallelograms','uniform','random'),
															 start_from=c('midpoint','corner'),
															 balance=0,
															 draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,boundary_holes=NULL,boundary_hole_color=NULL,
															 end_side=1) {
	
	method <- match.arg(method)
	start_from <- match.arg(start_from)

	if (start_from=='midpoint') { turtle_backward(distance=unit_len * height/2) }

	multiplier <- ifelse(clockwise,1,-1)
	if ((height > 1) && (width > 1)) {
		my_method <- switch(method,
												 random={
													 sample(c('two_parallelograms','four_parallelograms'),1)
												 },
												 uniform={ 'four_parallelograms' },
												 method)
		
		switch(my_method,
					 two_parallelograms={
						 dheight <- height - width
						 logodds <- balance * dheight
						 elogo   <- exp(logodds)
						 spliton <- ifelse(runif(1) <= elogo / (1 + elogo),'height','width')
						 switch(spliton,
										height={
											midp <- sample.int(size=1,n=(height-1))
											parallelogram_maze(unit_len=unit_len,height=midp,width=width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																				 balance=balance,
																				 draw_boundary=TRUE,num_boundary_holes=0,boundary_lines=2,boundary_holes=2)
											turtle_forward(midp*unit_len)
											parallelogram_maze(unit_len=unit_len,height=height-midp,width=width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																				 balance=balance,
																				 draw_boundary=FALSE)
											turtle_backward(midp*unit_len)
										},
										width={
											midp <- sample.int(size=1,n=(width-1))
											parallelogram_maze(unit_len=unit_len,height=height,width=midp,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																				 balance=balance,
																				 draw_boundary=TRUE,num_boundary_holes=0,boundary_lines=3,boundary_holes=3)

											.turn_right(angle*multiplier)
											turtle_forward(midp*unit_len)
											.turn_left(angle*multiplier)
											parallelogram_maze(unit_len=unit_len,height=height,width=width-midp,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																				 balance=balance,
																				 draw_boundary=FALSE)
											.turn_right(angle*multiplier)
											turtle_backward(midp*unit_len)
											.turn_left(angle*multiplier)
										})
					 },
					 four_parallelograms={
						 bholes <- sample.int(n=4,size=3)

						 if (method == 'uniform') {
							 mid_height <- round((height/2))
							 mid_width <- round((width/2))
						 } else {
							 mid_height <- sample.int(size=1,n=(height-1))
							 mid_width  <- sample.int(size=1,n=(width-1))
						 }

						 parallelogram_maze(unit_len=unit_len,height=mid_height,width=mid_width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																balance=balance,
																draw_boundary=TRUE,boundary_lines=2,boundary_holes=1 %in% bholes)
						 turtle_forward(mid_height*unit_len)
						 parallelogram_maze(unit_len=unit_len,height=height-mid_height,width=mid_width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																balance=balance,
																draw_boundary=TRUE,boundary_lines=3,boundary_holes=2 %in% bholes)

						 .turn_right(angle*multiplier)
						 turtle_forward(mid_width*unit_len)
						 .turn_left(angle*multiplier)

						 parallelogram_maze(unit_len=unit_len,height=height-mid_height,width=width-mid_width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																balance=balance,
																draw_boundary=TRUE,boundary_lines=4,boundary_holes=4 %in% bholes)
						 turtle_backward(mid_height*unit_len)
						 parallelogram_maze(unit_len=unit_len,height=mid_height,width=width-mid_width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																balance=balance,
																draw_boundary=TRUE,boundary_lines=1,boundary_holes=3 %in% bholes)

						 .turn_right(angle*multiplier)
						 turtle_backward(mid_width*unit_len)
						 .turn_left(angle*multiplier)
					 })
	}

	if (draw_boundary) {
		holes <- .interpret_boundary_holes(boundary_holes,num_boundary_holes,nsides=4)
		boundary_lines <- .interpret_boundary_lines(boundary_lines,nsides=4)

		holey_path(unit_len=unit_len,
							 lengths=c(height,width,height,width),
							 angles=multiplier*c(angle,180-angle),
							 draw_line=boundary_lines,
							 has_hole=holes,
							 hole_color=boundary_hole_color)
	}
	# move to ending side
	if ((end_side != 1) && (!is.null(end_side))) {
		molens <-  c(height,width,height,width)
		angls <-  multiplier * c(angle,180-angle,angle,180-angle)

		holey_path(unit_len=unit_len,
							 lengths=molens[1:(end_side-1)],
							 angles=angls[1:(end_side-1)],
							 draw_line=FALSE,
							 has_hole=FALSE,
							 hole_color=NULL)
	}

# this needs to depend on the end_side !!!
	if (start_from=='midpoint') { 
		turtle_forward(distance=unit_len * ifelse(.is_even(end_side),width,height)/2) }
}

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
