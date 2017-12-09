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

# Created: 2017.11.27
# Copyright: Steven E. Pav, 2017
# Author: Steven E. Pav <shabbychef@gmail.com>
# Comments: Steven E. Pav

#' @title sierpinski_carpet_maze .
#'
#' @description 
#'
#' Recursively draw a Sierpinski carpet maze in a parallelogram,
#' with the first side consisting of
#' \code{height} segments of length \code{unit_len}, and the second side 
#' \code{width} segments of length \code{unit_len}. The angle between
#' the first and second side may be set.
#'
#' @details
#'
#' Draws a Sierpinski carpet as two-color maze in a parallelogram.
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
#' @param height the length of the first side in numbers of \code{unit_len}
#' segments.
#' @param width the length of the second side in numbers of \code{unit_len}
#' segments.
#' @param angle the angle (in degrees) between the first and second sides.
#' @param method passed to \code{\link{parallelogram_maze}} to control the method
#' of drawing the sub mazes.
#' @param balance passed to \code{\link{parallelogram_maze}} to
#' control imbalance of sub mazes.
#' @seealso \code{\link{parallelogram_maze}},
#' \code{\link{sierpinski_maze}}.
#' @examples
#' library(TurtleGraphics)
#' turtle_init(800,900,mode='clip')
#' turtle_hide()
#' turtle_up()
#' turtle_do({
#'  turtle_setpos(35,400)
#'  turtle_setangle(0)
#'  sierpinski_carpet_maze(angle=80,unit_len=8,width=30,height=30,
#'    method='two_parallelograms',draw_boundary=TRUE,balance=-1.0,color2='green')
#' })
#'
#' \dontrun{
#' library(TurtleGraphics)
#' turtle_init(2000,2000,mode='clip')
#' turtle_hide()
#' turtle_up()
#' bholes <- list(c(1,2), c(1), c(2))
#' turtle_do({
#'  turtle_setpos(1000,1100)
#'  turtle_setangle(180)
#'  for (iii in c(1:3)) {
#' 	 mybhol <- bholes[[iii]]
#' 	 sierpinski_carpet_maze(angle=120,unit_len=12,width=81,height=81,
#' 		 draw_boundary=TRUE,boundary_lines=c(1,2,3),num_boundary_holes=0,
#' 		 boundary_holes=mybhol,balance=1.0,color2='green',
#' 		 start_from='corner')
#' 	 turtle_left(120)
#'  }
#' })
#' }
#' @export
sierpinski_carpet_maze <- function(unit_len,height,width=height,angle=90,clockwise=TRUE,
																	 method='random',
																	 color1='black',color2='gray40',
																	 start_from=c('midpoint','corner'),
																	 balance=0,
																	 draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,
																	 boundary_holes=NULL,boundary_hole_color=NULL,boundary_hole_locations=NULL,
																	 boundary_hole_arrows=FALSE,
																	 end_side=1) {

	start_from <- match.arg(start_from)
	if (start_from=='midpoint') { turtle_backward(distance=unit_len * height/2) }

	multiplier <- ifelse(clockwise,1,-1)

	if ((height >=3) && (width >= 3)) {
		hei_1 <- round(height/3)
		hei_2 <- round(2*height/3) - hei_1
		hei_3 <- height - (hei_1 + hei_2)
		wid_1 <- round(width/3)
		wid_2 <- round(2*width/3) - wid_1
		wid_3 <- width - (wid_1 + wid_2)

		end_sides <- rep(c(2,3,4),3)
		starts <- kronecker(c(2,4,6,8),c(1,1,1))
		ends   <- c(1,5,3,
								3,5,9,
								5,1,7,
								7,9,5)
		which_holes <- .span_tree(starts,ends)

		inner_lines <- c(TRUE,TRUE,TRUE,FALSE,
										 TRUE,TRUE,TRUE,FALSE,
										 TRUE,TRUE,FALSE,TRUE,
										 TRUE,FALSE,TRUE,TRUE)
		inner_holes <- rep(FALSE,length(inner_lines))
		inner_holes[which(inner_lines)[which_holes]] <- TRUE

		turtle_forward(unit_len*hei_1)
		.turn_right(multiplier*angle)
		turtle_forward(unit_len*wid_1)

		turtle_col(color2)
		parallelogram_maze(unit_len=unit_len,height=wid_2,width=hei_2,angle=angle,
													 balance=balance,method=method,start_from='corner',
													 clockwise=!clockwise,draw_boundary=FALSE,end_side=1)
		turtle_col(color1)
		turtle_backward(unit_len*wid_1)
		.turn_left(multiplier*angle)
		turtle_backward(unit_len*hei_1)

		sierpinski_carpet_maze(unit_len=unit_len,height=hei_1,width=wid_1,angle=angle,
													 color1=color1,color2=color2,balance=balance,method=method,start_from='corner',
													 clockwise=clockwise,draw_boundary=FALSE,end_side=end_sides[1])
		sierpinski_carpet_maze(unit_len=unit_len,height=wid_1,width=hei_2,angle=angle,
													 color1=color1,color2=color2,balance=balance,method=method,start_from='corner',
													 clockwise=!clockwise,draw_boundary=TRUE,boundary_lines=(inner_lines[1:4]),
													 boundary_holes=(inner_holes[1:4]),end_side=end_sides[2])
		sierpinski_carpet_maze(unit_len=unit_len,height=wid_1,width=hei_3,angle=180-angle,
													 color1=color1,color2=color2,balance=balance,method=method,start_from='corner',
													 clockwise=clockwise,draw_boundary=FALSE,end_side=end_sides[3])
		sierpinski_carpet_maze(unit_len=unit_len,height=hei_3,width=wid_2,angle=180-angle,
													 color1=color1,color2=color2,balance=balance,method=method,start_from='corner',
													 clockwise=!clockwise,draw_boundary=TRUE,boundary_lines=(inner_lines[5:8]),
													 boundary_holes=(inner_holes[5:8]),end_side=end_sides[4])
		## center is different:
		#turtle_col(color2)
		#parallelogram_maze(unit_len=unit_len,height=wid_2,width=hei_2,angle=180-angle,
													 #balance=balance,method=method,start_from='corner',
													 #clockwise=clockwise,draw_boundary=FALSE,end_side=end_sides[5])
		#turtle_col(color1)
		turtle_forward(unit_len*wid_2)
		.turn_right(multiplier*(180-angle))
		turtle_forward(unit_len*hei_2)
		.turn_right(multiplier*(angle))

		sierpinski_carpet_maze(unit_len=unit_len,height=wid_2,width=hei_1,angle=angle,
													 color1=color1,color2=color2,balance=balance,method=method,start_from='corner',
													 clockwise=!clockwise,draw_boundary=TRUE,boundary_lines=(inner_lines[9:12]),
													 boundary_holes=(inner_holes[9:12]),end_side=end_sides[6])
		sierpinski_carpet_maze(unit_len=unit_len,height=hei_1,width=wid_3,angle=angle,
													 color1=color1,color2=color2,balance=balance,method=method,start_from='corner',
													 clockwise=clockwise,draw_boundary=FALSE,end_side=end_sides[7])
		sierpinski_carpet_maze(unit_len=unit_len,height=wid_3,width=hei_2,angle=angle,
													 color1=color1,color2=color2,balance=balance,method=method,start_from='corner',
													 clockwise=!clockwise,draw_boundary=TRUE,boundary_lines=(inner_lines[13:16]),
													 boundary_holes=(inner_holes[13:16]),end_side=end_sides[8])
		sierpinski_carpet_maze(unit_len=unit_len,height=wid_3,width=hei_3,angle=180-angle,
													 color1=color1,color2=color2,balance=balance,method=method,start_from='corner',
													 clockwise=clockwise,draw_boundary=FALSE,end_side=end_sides[9])

		turtle_forward(unit_len * height)
		.turn_right(multiplier * angle)
		turtle_forward(unit_len * width)
		.turn_right(multiplier * (180-angle))
	} else {
		turtle_col(color1)
		parallelogram_maze(unit_len=unit_len,height=height,width=width,angle=angle,clockwise=clockwise,
											 method=method,balance=balance,start_from='corner',
											 draw_boundary=FALSE)
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
