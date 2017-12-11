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
#' Draws a maze in an parallelogram, starting from the midpoint
#' of the first side (or the corner before the first side via the
#' \code{start_from} option). Can recursively subdivide into two or
#' four parallelograms.  The first (and third) side shall consist of \code{height}
#' segments of length \code{unit_len}. The second and fourth side consist of
#' \code{width} segments of length \code{unit_len}. The angle between them is
#' \code{angle}. Here is an example maze:
#'
#' \if{html}{
#' \figure{para-maze-1.png}{options: width="100\%" alt="Figure: parallelogram maze"}
#' }
#' \if{latex}{
#' \figure{para-maze-1.png}{options: width=7cm}
#' }
#'
#' This function admits a \code{balance} parameter which controls
#' how the maze should be recursively subdivided. A negative value creates
#' imbalanced mazes, while positive values create more uniform mazes. Here are
#' create seven mazes created side by side with an increasing balance
#' parameter:
#'
#' \if{html}{
#' \figure{para-imbalance-fade-1.png}{options: width="100\%" alt="Figure: parallelogram maze"}
#' }
#' \if{latex}{
#' \figure{para-imbalance-fade-1.png}{options: width=7cm}
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
#' @param height the length of the first side in numbers of \code{unit_len}
#' segments.
#' @param width the length of the second side in numbers of \code{unit_len}
#' segments.
#' @param angle the angle (in degrees) between the first and second sides.
#' Note that this is the angle that the Turtle turns when rounding
#' the first corner, so it is the internal angle at the starting
#' point (if starting from a corner), and the external angle at
#' the second corner.
#' @param height_boustro an array of two values, which help determine
#' the location of holes in internal lines of length
#' \code{height}. The default value, \code{c(1,1)} results in 
#' uniform selection. Otherwise the location of holes are chosen
#' with probability proportional to a beta density with 
#' \code{shape1} and \code{shape2} the two elements of \code{height_boustro}
#' in order. In sub mazes, this parameter is reversed, which
#' can lead to \sQuote{boustrophedonic} mazes. The sum of values
#' should probably not exceed 30, as otherwise the location of internal
#' holes is forced.
#' @param width_boustro an array of two values, which help determine
#' the location of any split along lines which are length \code{width}. 
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
#' of choosing height over width is the factor \code{balance} times the 
#' sign of the difference \code{height - width}. When balance takes the default
#' value of 0, you have equal odds of selecting to split on height or width.
#' Note that balance is positive and large, you tend to generate nearly
#' uniform splits. When balance is negative and large, you tend to have
#' imbalanced mazes, and the imbalance propagates.
#' @examples
#'
#' library(TurtleGraphics)
#'
#' turtle_init(500,300,mode='clip')
#' turtle_hide()
#' turtle_up()
#' turtle_do({
#'  turtle_setpos(15,15)
#'  turtle_setangle(0)
#'  parallelogram_maze(angle=90,unit_len=10,width=45,height=25,method='uniform',
#'  	start_from='corner',draw_boundary=TRUE)
#' })
#' 
#' # testing imbalance condition
#' turtle_init(400,500,mode='clip')
#' turtle_hide()
#' turtle_up()
#' turtle_do({
#'  turtle_setpos(15,250)
#'  turtle_setangle(0)
#'  parallelogram_maze(angle=90,unit_len=10,width=30,height=40,
#'    method='two_parallelograms',draw_boundary=TRUE,balance=-1.0)
#' })
#' 
#' # a bunch of imbalanced mazes, fading into each other
#' turtle_init(850,400,mode='clip')
#' turtle_hide()
#' turtle_up()
#' turtle_do({
#'   turtle_setpos(15,200)
#'   turtle_setangle(0)
#'   valseq <- seq(from=-1.5,to=1.5,length.out=4)
#'   blines <- c(1,2,3,4)
#'   bholes <- c(1,3)
#'   set.seed(12354)
#'   for (iii in seq_along(valseq)) {
#'      parallelogram_maze(angle=90,unit_len=10,width=20,height=25,
#'       method='two_parallelograms',draw_boundary=TRUE,balance=valseq[iii],
#'        end_side=3,boundary_lines=blines,boundary_holes=bholes)
#'      turtle_right(180)
#'      blines <- c(2,3,4)
#'      bholes <- c(3)
#'   }
#' })
#'
#' # a somewhat 'boustrophedonic' maze
#' turtle_init(500,300,mode='clip')
#' turtle_hide()
#' turtle_up()
#' turtle_do({
#'  turtle_setpos(15,15)
#'  turtle_setangle(0)
#'  parallelogram_maze(angle=90,unit_len=10,width=47,height=27,
#'     method='two_parallelograms', height_boustro=c(21,3),width_boustro=c(21,3),balance=-0.25,
#' 		 start_from='corner',draw_boundary=TRUE)
#' })
#' @export
#' @importFrom stats runif
parallelogram_maze <- function(unit_len,height,width=height,angle=90,clockwise=TRUE,
															 method=c('two_parallelograms','four_parallelograms','uniform','random'),
															 start_from=c('midpoint','corner'),
															 balance=0,height_boustro=c(1,1),width_boustro=c(1,1),
															 draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,
															 boundary_holes=NULL,boundary_hole_color=NULL,boundary_hole_locations=NULL,
															 boundary_hole_arrows=FALSE,
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
						 logodds <- balance * sign(dheight)
						 elogo   <- exp(logodds)
						 spliton <- ifelse(runif(1) <= elogo / (1 + elogo),'height','width')
						 switch(spliton,
															 height_boustro=c(1,1),width_boustro=c(1,1),
										height={
											midp <- sample.int(size=1,n=(height-1))
											parallelogram_maze(unit_len=unit_len,height=midp,width=width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																				 balance=balance,
																				 draw_boundary=TRUE,num_boundary_holes=0,boundary_lines=2,boundary_holes=2,
																				 height_boustro=height_boustro,width_boustro=rev(width_boustro),
																				 boundary_hole_locations=.rboustro(4,boustro=width_boustro,nsegs=width))
											turtle_forward(midp*unit_len)
											parallelogram_maze(unit_len=unit_len,height=height-midp,width=width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																				 balance=balance,
																				 draw_boundary=FALSE,
																				 height_boustro=height_boustro,width_boustro=rev(width_boustro))
											turtle_backward(midp*unit_len)
										},
										width={
											midp <- sample.int(size=1,n=(width-1))
											parallelogram_maze(unit_len=unit_len,height=height,width=midp,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																				 balance=balance,
																				 draw_boundary=TRUE,num_boundary_holes=0,boundary_lines=3,boundary_holes=3,
																				 height_boustro=rev(height_boustro),width_boustro=width_boustro,
																				 boundary_hole_locations=.rboustro(4,boustro=height_boustro,nsegs=height))

											.turn_right(angle*multiplier)
											turtle_forward(midp*unit_len)
											.turn_left(angle*multiplier)
											parallelogram_maze(unit_len=unit_len,height=height,width=width-midp,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																				 balance=balance,
																				 draw_boundary=FALSE,
																				 height_boustro=rev(height_boustro),width_boustro=width_boustro)
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
																balance=balance,height_boustro=rev(height_boustro),width_boustro=rev(width_boustro),
																draw_boundary=TRUE,boundary_lines=2,boundary_holes=1 %in% bholes,
																boundary_hole_locations=.rboustro(1,boustro=width_boustro,nsegs=mid_width))
						 turtle_forward(mid_height*unit_len)
						 parallelogram_maze(unit_len=unit_len,height=height-mid_height,width=mid_width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																balance=balance,height_boustro=rev(height_boustro),width_boustro=rev(width_boustro),
																draw_boundary=TRUE,boundary_lines=3,boundary_holes=2 %in% bholes,
																boundary_hole_locations=.rboustro(1,boustro=height_boustro,nsegs=height-mid_height))

						 .turn_right(angle*multiplier)
						 turtle_forward(mid_width*unit_len)
						 .turn_left(angle*multiplier)

						 parallelogram_maze(unit_len=unit_len,height=height-mid_height,width=width-mid_width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																balance=balance,height_boustro=rev(height_boustro),width_boustro=rev(width_boustro),
																draw_boundary=TRUE,boundary_lines=4,boundary_holes=4 %in% bholes,
																boundary_hole_locations=.rboustro(1,boustro=width_boustro,nsegs=width-mid_width))
						 turtle_backward(mid_height*unit_len)
						 parallelogram_maze(unit_len=unit_len,height=mid_height,width=width-mid_width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																balance=balance,height_boustro=rev(height_boustro),width_boustro=rev(width_boustro),
																draw_boundary=TRUE,boundary_lines=1,boundary_holes=3 %in% bholes,
																boundary_hole_locations=.rboustro(1,boustro=height_boustro,nsegs=mid_height))

						 .turn_right(angle*multiplier)
						 turtle_backward(mid_width*unit_len)
						 .turn_left(angle*multiplier)
					 })
	}

	if (draw_boundary) {
		.do_boundary(unit_len,lengths=rep(c(height,width),2),angles=multiplier * c(angle,180-angle),
								 num_boundary_holes=num_boundary_holes,boundary_lines=boundary_lines,
								 boundary_holes=boundary_holes,boundary_hole_color=boundary_hole_color,
								 boundary_hole_locations=boundary_hole_locations,boundary_hole_arrows=boundary_hole_arrows)
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
