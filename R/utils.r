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

# Created: 2017.10.03
# Copyright: Steven E. Pav, 2017
# Author: Steven E. Pav <steven@gilgamath.com>
# Comments: Steven E. Pav

# internal utilities

library(TurtleGraphics)

draw_line <- function(dist) {
	if (dist > 0) {
		turtle_down()
		turtle_forward(dist=dist)
		turtle_up()
	}
}
draw_colored_line <- function(dist,color) {
	old_color <- turtle_status()$DisplayOptions$col
	turtle_col(color)
	draw_line(dist=seg_len)
	turtle_col(old_color)
}

.interpret_boundary_holes <- function(boundary_holes,num_boundary_holes,nsides=3) {
	if (is.null(boundary_holes)) {
		holes <- sample.int(n=nsides,size=nsides) <= num_boundary_holes
	} else {
		if (is.numeric(boundary_holes)) {
			holes <- 1:nsides %in% boundary_holes
		} else if (is.logical(boundary_holes)) {
			holes <- boundary_holes
		}
	}
	holes
}
.interpret_boundary_lines <- function(boundary_lines,nsides=3) {
	if (!is.logical(boundary_lines) && is.numeric(boundary_lines)) {
		boundary_lines <- 1:nsides %in% boundary_lines
	}
	boundary_lines
}


#'
#' @param num_segs the total number of segments. All but one of these,
#' of length \code{seg_len} will be drawn. The other, randomly
#' chosen, will be a hole.
#' @param seg_len the length of one segment.
#' @param go_back whether to go back when done.
#' @param hole_color the color to plot the \sQuote{hole}. A 
#' \code{NULL} value corresponds to no drawn hole. See the
#' \link{\code{grDevices::colors}} function for
#' more options
holey_line <- function(seg_len,num_segs,go_back=FALSE,hole_color=NULL) {
	if (num_segs > 1) {
		whichn <- sample.int(n=num_segs,size=1)
		draw_line(dist=(whichn-1) * seg_len)
		if (!is.null(hole_color)) {
			draw_colored_line(seg_len,hole_color)
		} else {
			turtle_forward(seg_len)
		}
		draw_line(dist=(num_segs-whichn) * seg_len)
		if (go_back) {
			turtle_backward(dist=seg_len * num_segs)
		}
	} else if (num_segs == 1) {
		if (!is.null(hole_color)) {
			draw_colored_line(seg_len,hole_color)
			if (go_back) {
				turtle_backward(dist=seg_len * num_segs)
			}
		} else if (!go_back) {
			turtle_forward(seg_len)
		}
	}
}
#'
#' @param unit_len the length of one unit, drawn or moved.
#' @param lengths an array of the number of units
#' each part of the path. An array of length \code{n}.
#' @param angles after each part of the path is
#' drawn, the turtle turns right by the given angle.
#' @param draw_line a boolean array telling whether
#' each part of the path is drawn or simply moved.
#' @param has_hole a boolean array telling whether,
#' conditional on the path being drawn, it has a one unit
#' hole.
#' @param hole_color the color to plot the \sQuote{hole}. A 
#' \code{NULL} value corresponds to no drawn hole. See the
#' \link{\code{grDevices::colors}} function for
#' more options
holey_path <- function(unit_len,lengths,angles,draw_line=TRUE,has_hole=FALSE,hole_color=NULL) {
	mapply(function(len,ang,drawl,hol) {
					 if (len > 0) {
						 if (drawl) {
							 if (hol) {
								 holey_line(unit_len,len,go_back=FALSE,hole_color=hole_color)
							 } else {
								 draw_line(dist=unit_len*len)
							 }
						 } else {
							 turtle_forward(dist=unit_len * len)
						 }
					 }
					 turtle_right(ang)
	},lengths,angles,draw_line,has_hole)
}


maybe_holey_line <- function(seg_len,num_segs,has_hole=TRUE,go_back=FALSE,hole_color=NULL) {
	if (has_hole) {
		holey_line(seg_len=seg_len,num_segs=num_segs,go_back=go_back,hole_color=hole_color) 
	} else {
		draw_line(dist=(seg_len*num_segs))
		if (go_back) {
			turtle_backward(dist=seg_len * num_segs)
		}
	}
}
holey_y <- function(seg_len,num_segs) {
	coinflip <- sample.int(n=2,size=1)
	turtle_left(60)
	maybe_holey_line(seg_len,num_segs,has_hole=coinflip==1,go_back=TRUE)
	turtle_right(120)
	maybe_holey_line(seg_len,num_segs,has_hole=coinflip==2,go_back=TRUE)
	turtle_left(60)
}
#' draw a \sQuote{bone} shape with holes in it, centered
#' on the turtle in the given direction.
holey_bone <- function(seg_len,num_segs) {
	if (num_segs > 0) {
		coinflip <- sample.int(n=2,size=1)
		if (coinflip==1) {
			no_hole_seg <- sample.int(n=4,size=1)
			# no hole in the center
			for (jjj in c(0,1)) {
				draw_line(dist=seg_len * num_segs/2)
				turtle_left(60)
				maybe_holey_line(seg_len,num_segs,has_hole=no_hole_seg != 2*jjj+1,go_back=TRUE)
				turtle_right(120)
				maybe_holey_line(seg_len,num_segs,has_hole=no_hole_seg != 2*jjj+2,go_back=TRUE)
				turtle_left(60)
				turtle_left(180)
				turtle_forward(dist=seg_len * num_segs/2)
			}
		} else {
			# hole in the center
			turtle_forward(dist=seg_len * num_segs/2)
			for (jjj in c(0,1)) {
				holey_y(seg_len,num_segs)
				turtle_right(180)
				turtle_forward(dist=seg_len * num_segs)
			}
			turtle_right(180)
			holey_line(seg_len,num_segs,go_back=TRUE)
			turtle_forward(dist=seg_len * num_segs/2)
			turtle_right(180)
		}
	}
}

# 2FIX: this should have options for which boundaries to have
# holes or no lines at all.
#
#
#' recursively draw a isosceles trapezoid, with three sides of length
#' 2^depth * seg_len and one of length 2^(depth+1) * seg_len, starting
#' from the middle of the longer side. will draw either 
#' @param depth the depth of recursion
#' @param seg_len the length of one segment
#' @param clockwise whether to draw clockwise.
#' @param draw_boundary whether to draw a boundary
trapezoid_maze <- function(depth,seg_len,clockwise=TRUE,
													 draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,boundary_holes=NULL,boundary_hole_color=NULL,
													 end_side=1) {
	num_segs <- 2^depth
	multiplier <- ifelse(clockwise,1,-1)
	if (depth > 0) {
		# recurse.
		magic_ratio <- sqrt(3) / 4

		turtle_up()
		turtle_right(multiplier * 90)
		turtle_forward(num_segs * seg_len * magic_ratio)
		turtle_left(multiplier * 90)
		holey_bone(seg_len,num_segs/2)
		turtle_left(multiplier * 90)
		turtle_forward(num_segs * seg_len * magic_ratio)
		turtle_right(multiplier * 90)

		if (depth > 1) {
			trapezoid_maze(depth-1,seg_len,clockwise=clockwise,draw_boundary=FALSE)
			turtle_forward(num_segs * seg_len)
			turtle_right(multiplier * 120)
			for (iii in c(1:3)) {
				turtle_forward(num_segs * seg_len/2)
				trapezoid_maze(depth-1,seg_len,clockwise=clockwise,draw_boundary=FALSE)
				turtle_forward(num_segs * seg_len/2)
				turtle_right(multiplier * 60)
			}
			turtle_right(multiplier * 60)
			turtle_forward(num_segs * seg_len)
		}
	}
	if (draw_boundary) {
		holes <- .interpret_boundary_holes(boundary_holes,num_boundary_holes,nsides=4)
		boundary_lines <- .interpret_boundary_lines(boundary_lines,nsides=4)

		turtle_backward(dist=seg_len * num_segs)

		holey_path(unit_len=seg_len,
							lengths=num_segs * c(2,1,1,1),
							angles=multiplier * c(120,60,60,60),
							draw_line=boundary_lines,
							has_hole=holes,
							hole_color=boundary_hole_color)

		turtle_forward(dist=seg_len * num_segs)
	}

	# move to ending side
	if ((end_side != 1) && (!is.null(end_side))) {
		turtle_backward(dist=seg_len * num_segs)
		molens <-  num_segs * c(2,1,1,1)
		angls <-  multiplier * 60 * c(2,1,1,1)

		holey_path(unit_len=seg_len,
							 lengths=molens[1:(end_side-1)],
							 angles=angls[1:(end_side-1)],
							 draw_line=FALSE,
							 has_hole=FALSE,
							 hole_color=NULL)

		turtle_forward(dist=seg_len * num_segs)
	}
}

#' recursively draw an equilateral triangle, with sides all of length
#' 2^depth * seg_len, starting from the middle of one side.
#' @param depth the depth of recursion
#' @param seg_len the length of one segment
#' @param clockwise whether to draw clockwise.
#' @param draw_boundary whether to draw a boundary
#' @param type there are many ways to recursive draw a triangle, either by
#'        recursively drawing 4 triangles, or by stacking trapezoids, and so
#'        on.
triangle_maze <- function(depth,seg_len,clockwise=TRUE,method=c('stack_trapezoids','triangles','grid','two_ears','random'),
													start_from=c('midpoint','corner'),
													draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,boundary_holes=NULL,boundary_hole_color=NULL,
													end_side=1) {
	
	method <- match.arg(method)
	start_from <- match.arg(start_from)
	num_segs <- 2^depth
	multiplier <- ifelse(clockwise,1,-1)

	if (start_from=='corner') { turtle_forward(dist=seg_len * num_segs/2) }

	if (depth > 0) {
		my_method <- switch(method,
												grid={ 'triangles' },
												random={
													sample(c('stack_trapezoids','triangles','two_ears'),1)
												},
												method)
		switch(my_method,
					 stack_trapezoids={
						 trapezoid_maze(depth-1,seg_len,clockwise=clockwise,draw_boundary=FALSE)
						 # now move over
						 magic_ratio <- sqrt(3) / 4

						 turtle_up()
						 turtle_right(multiplier * 90)
						 turtle_forward(num_segs * seg_len * magic_ratio)
						 turtle_left(multiplier * 90)
						 triangle_maze(depth-1,seg_len,clockwise=clockwise,method=method,draw_boundary=FALSE)
						 turtle_left(multiplier * 90)
						 turtle_forward(num_segs * seg_len * magic_ratio)
						 turtle_right(multiplier * 90)
					 },
					 two_ears={
						 # parallelogram and two triangles
						 turtle_backward(seg_len*num_segs/2)
						 parallelogram_maze(seg_len,height=num_segs/2,width=num_segs/2,angle=60,clockwise=clockwise,
																method='random',start_from='corner',
																draw_boundary=TRUE,boundary_lines=c(2,3),boundary_holes=c(2,3))
						 # now the other two triangles.
						 for (iii in c(1,2)) {
							 turtle_forward(seg_len*num_segs)
							 turtle_right(multiplier * 120)
							 triangle_maze(depth-1,seg_len,clockwise=clockwise,method=method,start_from='corner',draw_boundary=FALSE)
						 }
						 turtle_forward(seg_len*num_segs)
						 turtle_right(multiplier * 120)
						 turtle_forward(seg_len*num_segs/2)
					 },
					 triangles={
						 sub_method <- method
						 if (! (sub_method %in% c('random','grid'))) { sub_method <- sample(c('stack_trapezoids','two_ears'),1) }

						 turtle_up()
						 turtle_backward(dist=seg_len * num_segs/2)
						 for (iii in c(1:3)) {
							 triangle_maze(depth-1,seg_len,clockwise=clockwise,start_from='corner',
														 method=sub_method,draw_boundary=FALSE)
							 turtle_forward(dist=seg_len * num_segs)
							 turtle_right(multiplier * 120)
						 }
						 turtle_forward(dist=seg_len * num_segs/2)
						 turtle_right(multiplier * 60)
						 triangle_maze(depth-1,seg_len,clockwise=clockwise,start_from='corner',
													 method=sub_method,draw_boundary=TRUE,num_boundary_holes=3)
						 turtle_left(multiplier * 60)
					 })
	}
	if (draw_boundary) {
		holes <- .interpret_boundary_holes(boundary_holes,num_boundary_holes,nsides=3)
		boundary_lines <- .interpret_boundary_lines(boundary_lines,nsides=3)
		turtle_backward(dist=seg_len * num_segs/2)

		holey_path(unit_len=seg_len,
							lengths=num_segs,
							angles=multiplier * 120,
							draw_line=boundary_lines,
							has_hole=holes,
							hole_color=boundary_hole_color)
		turtle_forward(dist=seg_len * num_segs/2)
	}
	# move to ending side
	if ((end_side != 1) && (!is.null(end_side))) {
		for (iii in 1:(end_side-1)) {
			turtle_forward(dist=seg_len * num_segs/2)
			turtle_right(multiplier * 120)
			turtle_forward(dist=seg_len * num_segs/2)
		}
	}
	if (start_from=='corner') { turtle_backward(dist=seg_len * num_segs/2) }
}

turtle_init(1500,1500)
turtle_hide()
turtle_up()
turtle_do({
	#triangle_maze(depth=6,12,clockwise=FALSE,method='two_ears',draw_boundary=TRUE)
	#triangle_maze(depth=6,12,clockwise=FALSE,method='random',draw_boundary=TRUE)
	triangle_maze(depth=6,12,clockwise=TRUE,method='two_ears',draw_boundary=TRUE,boundary_holes=c(1,3))
	triangle_maze(depth=6,12,clockwise=FALSE,method='grid',draw_boundary=TRUE,boundary_lines=c(2,3),boundary_holes=c(2))
})


#' recursively draw a regular hexagon, with sides all of length
#' 2^depth * seg_len, starting from the middle of one side.
#' @param depth the depth of recursion
#' @param seg_len the length of one segment
#' @param clockwise whether to draw clockwise.
#' @param draw_boundary whether to draw a boundary
#' @param type there are many ways to recursive draw a triangle, either by
#'        drawing 6 triangles, or stacking two trapezoids, and so on.
hexagon_maze <- function(depth,seg_len,clockwise=TRUE,method=c('two_trapezoids','six_triangles','three_parallelograms'),
												 start_from=c('midpoint','corner'),
												 draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,boundary_holes=NULL,boundary_hole_color=NULL,
												 end_side=1) {
	
	method <- match.arg(method)
	start_from <- match.arg(start_from)

	if (start_from=='corner') { turtle_forward(dist=seg_len * num_segs/2) }
	num_segs <- 2^depth
	multiplier <- ifelse(clockwise,1,-1)

	if (depth > 1) {
		switch(method,
					 two_trapezoids={
						 magic_ratio <- sqrt(3) / 4

						 turtle_up()
						 turtle_right(multiplier * 90)
						 turtle_forward(2*num_segs * seg_len * magic_ratio)
						 turtle_left(multiplier * 90)
						 trapezoid_maze(depth,seg_len,clockwise=clockwise,draw_boundary=FALSE)
						 trapezoid_maze(depth,seg_len,clockwise=!clockwise,draw_boundary=FALSE)

						 turtle_backward(dist=seg_len * num_segs)
						 holey_line(seg_len,num_segs*2)
						 turtle_backward(dist=seg_len * num_segs)
						 
						 turtle_left(multiplier * 90)
						 turtle_forward(2*num_segs * seg_len * magic_ratio)
						 turtle_right(multiplier * 90)
					 },
					 six_triangles={
						 # 2FIX: write this
						 turtle_up()
						 #...
					 },
					 three_parallelograms={
						 bholes <- sample.int(n=3,size=2)
						 for (iii in 1:3) {
							 parallelogram_maze(seg_len,num_segs,num_segs,angle=60,clockwise=clockwise,
																	draw_boundary=TRUE,boundary_lines=3,num_boundary_holes=0,boundary_holes=iii %in% bholes)
							 turtle_forward(num_segs * seg_len / 2)
							 turtle_right(multiplier * 60)
							 turtle_forward(num_segs * seg_len)
							 turtle_right(multiplier * 60)
							 turtle_forward(num_segs * seg_len / 2)
						 }
					 })
	}
	if (draw_boundary) {
		holes <- .interpret_boundary_holes(boundary_holes,num_boundary_holes,nsides=6)
		boundary_lines <- .interpret_boundary_lines(boundary_lines,nsides=6)

		turtle_backward(dist=seg_len * num_segs/2)

		holey_path(unit_len=seg_len,
							 lengths=num_segs,
							 angles=multiplier*60,
							 draw_line=boundary_lines,
							 has_hole=holes,
							 hole_color=boundary_hole_color)
		turtle_forward(dist=seg_len * num_segs/2)
	}
	if ((end_side != 1) && (!is.null(end_side))) {
		for (iii in 1:(end_side-1)) {
			turtle_forward(dist=seg_len * num_segs/2)
			turtle_right(multiplier * 60)
			turtle_forward(dist=seg_len * num_segs/2)
		}
	}
	if (start_from=='corner') { turtle_backward(dist=seg_len * num_segs/2) }
}

turtle_init(1000,1000)
turtle_hide()
turtle_do({
	turtle_up()
	#trapezoid_maze(depth=4,20,clockwise=FALSE,draw_boundary=TRUE)
	#triangle_maze(depth=5,15,clockwise=FALSE,draw_boundary=TRUE)
	#triangle_maze(depth=5,15,clockwise=FALSE,method='triangles',draw_boundary=TRUE)
	turtle_backward(250)
	turtle_right(90)
	turtle_forward(150)
	turtle_left(90)

	turtle_right(60)
	hexagon_maze(depth=5,12,clockwise=FALSE,method='three_parallelograms',draw_boundary=TRUE,boundary_holes=c(1,4),boundary_hole_color='green')
})
dev.copy(png,'mazecubes.png')
dev.off()

#' recursively draw a parallelogram maze, with sides of length
#' width*seg_len and height*seg_len,
#' starting from the middle of one side.
#' @param seg_len the length of one segment
#' @param height the number of segments of the height of the 
#' maze, where we assume the turtle starts drawing upward.
#' We assume the turtle starts midway up the segment.
#' @param width the number of segments of the width of
#' the maze, which is the second dimension drawn.
#' @param angle the angle right turned by the turtle after
#' drawing the first segment. Left for counterclockwise mazes.
#' @param clockwise whether to draw clockwise.
#' @param draw_boundary whether to draw a boundary
#' @param type there are many ways to recursive draw a triangle, either by
#'        splitting into 2 parallelograms, or 4 parallelograms.
parallelogram_maze <- function(seg_len,height,width,angle=90,clockwise=TRUE,method=c('two_parallelograms','four_parallelograms','grid','random'),
															 start_from=c('midpoint','corner'),
															 draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,boundary_holes=NULL,boundary_hole_color=NULL,
															 end_side=1) {
	
	method <- match.arg(method)
	start_from <- match.arg(start_from)

	if (start_from=='midpoint') { turtle_backward(dist=seg_len * height/2) }

	multiplier <- ifelse(clockwise,1,-1)
	if ((height > 1) && (width > 1)) {
		my_method <- switch(method,
												 random={
													 sample(c('two_parallelograms','four_parallelograms'),1)
												 },
												 grid={ 'four_parallelograms' },
												 method)
		
		switch(my_method,
					 two_parallelograms={
						 spliton <- sample(c('height','width'),1)
						 switch(spliton,
										height={
											midp <- sample.int(size=1,n=(height-1))
											parallelogram_maze(seg_len,height=midp,width=width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																				 draw_boundary=TRUE,num_boundary_holes=0,boundary_lines=2,boundary_holes=2)
											turtle_forward(midp*seg_len)
											parallelogram_maze(seg_len,height=height-midp,width=width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																				 draw_boundary=FALSE)
											turtle_backward(midp*seg_len)
										},
										width={
											midp <- sample.int(size=1,n=(width-1))
											parallelogram_maze(seg_len,height=height,width=midp,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																				 draw_boundary=TRUE,num_boundary_holes=0,boundary_lines=3,boundary_holes=3)

											turtle_right(angle*multiplier)
											turtle_forward(midp*seg_len)
											turtle_left(angle*multiplier)
											parallelogram_maze(seg_len,height=height,width=width-midp,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																				 draw_boundary=FALSE)
											turtle_right(angle*multiplier)
											turtle_backward(midp*seg_len)
											turtle_left(angle*multiplier)
										})
					 },
					 four_parallelograms={
						 bholes <- sample.int(n=4,size=3)

						 if (method == 'grid') {
							 mid_height <- round((height/2))
							 mid_width <- round((width/2))
						 } else {
							 mid_height <- sample.int(size=1,n=(height-1))
							 mid_width  <- sample.int(size=1,n=(width-1))
						 }

						 parallelogram_maze(seg_len,height=mid_height,width=mid_width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																draw_boundary=TRUE,boundary_lines=2,boundary_holes=1 %in% bholes)
						 turtle_forward(mid_height*seg_len)
						 parallelogram_maze(seg_len,height=height-mid_height,width=mid_width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																draw_boundary=TRUE,boundary_lines=3,boundary_holes=2 %in% bholes)

						 turtle_right(angle*multiplier)
						 turtle_forward(mid_width*seg_len)
						 turtle_left(angle*multiplier)

						 parallelogram_maze(seg_len,height=height-mid_height,width=width-mid_width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																draw_boundary=TRUE,boundary_lines=4,boundary_holes=4 %in% bholes)
						 turtle_backward(mid_height*seg_len)
						 parallelogram_maze(seg_len,height=mid_height,width=width-mid_width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																draw_boundary=TRUE,boundary_lines=1,boundary_holes=3 %in% bholes)

						 turtle_right(angle*multiplier)
						 turtle_backward(mid_width*seg_len)
						 turtle_left(angle*multiplier)
					 })
	}

	if (draw_boundary) {
		holes <- .interpret_boundary_holes(boundary_holes,num_boundary_holes,nsides=4)
		boundary_lines <- .interpret_boundary_lines(boundary_lines,nsides=4)

		holey_path(unit_len=seg_len,
							 lengths=c(height,width,height,width),
							 angles=multiplier*c(angle,180-angle),
							 draw_line=boundary_lines,
							 has_hole=holes,
							 hole_color=boundary_hole_color)
	}
	# move to ending side
	if ((end_side != 1) && (!is.null(end_side))) {
		molens <-  c(height,width,height,width)
		angls <-  multiplier * c(angle,180-angle,180-angle)

		holey_path(unit_len=seg_len,
							 lengths=molens[1:(end_side-1)],
							 angles=angls[1:(end_side-1)],
							 draw_line=FALSE,
							 has_hole=FALSE,
							 hole_color=NULL)
	}

	if (start_from=='midpoint') { turtle_forward(dist=seg_len * height/2) }
}

turtle_init(2000,2000)
turtle_hide()
turtle_do({
	turtle_up()
	#parallelogram_maze(seg_len=10,width=15,height=15,draw_boundary=TRUE)
	#parallelogram_maze(angle=90,seg_len=10,width=25,height=25,draw_boundary=FALSE)
	#parallelogram_maze(angle=90,seg_len=10,width=25,height=25,method='four_parallelograms',draw_boundary=TRUE)

	#parallelogram_maze(angle=90,seg_len=10,width=35,height=55,method='random',draw_boundary=TRUE)
	parallelogram_maze(angle=90,seg_len=12,width=75,height=55,method='grid',draw_boundary=TRUE)
})

#library(TurtleGraphics)
turtle_init(1000,1000)
turtle_hide()
turtle_do({
	#trapezoid_maze(depth=3,20,clockwise=TRUE,)
	trapezoid_maze(depth=3,20,clockwise=FALSE,draw_boundary=TRUE,boundary_hole_color='green')
})

turtle_init(1000,1000)
turtle_hide()
turtle_do({
	#trapezoid_maze(depth=4,20,clockwise=FALSE,draw_boundary=TRUE)
	triangle_maze(depth=5,15,clockwise=FALSE,draw_boundary=TRUE)
})

turtle_init(1000,1000)
turtle_hide()
turtle_do({
	#trapezoid_maze(depth=4,20,clockwise=FALSE,draw_boundary=TRUE)
	#triangle_maze(depth=5,15,clockwise=FALSE,draw_boundary=TRUE)
	#triangle_maze(depth=5,15,clockwise=FALSE,method='triangles',draw_boundary=TRUE)
	hexagon_maze(depth=4,15,clockwise=FALSE,method='two_trapezoids',draw_boundary=TRUE,boundary_holes=c(1,4))
	hexagon_maze(depth=4,15,clockwise=TRUE,method='two_trapezoids',draw_boundary=TRUE,boundary_lines=c(2,3,4,5,6),boundary_holes=c(1,4))
})
	#turtle_down()
	#turtle_forward(20)
	#turtle_up()
	#turtle_right(20*runif(1))

# test# FOLDUP
turtle_init(1000,1000)
turtle_hide()
turtle_do({
	#trapezoid_maze(depth=4,20,clockwise=FALSE,draw_boundary=TRUE)
	#triangle_maze(depth=5,15,clockwise=FALSE,draw_boundary=TRUE)
	#triangle_maze(depth=5,15,clockwise=FALSE,method='triangles',draw_boundary=TRUE)
	depth <- 4
	num_segs <- 2^depth
	seg_len <- 8
	multiplier <- -1
	hexagon_maze(depth=depth,seg_len,clockwise=FALSE,method='two_trapezoids',draw_boundary=FALSE)
	for (iii in c(1:6)) {
		if (iii %in% c(1,4)) {
			holes <- c(1,4) 
		} else {
			holes <- c(1)
		}
		hexagon_maze(depth=depth,seg_len,clockwise=TRUE,method='two_trapezoids',draw_boundary=TRUE,boundary_holes=holes)
		turtle_forward(dist=seg_len * num_segs/2)
		turtle_right(multiplier * 60)
		turtle_forward(dist=seg_len * num_segs/2)
	}
})

dev.copy(png,'mazeballs.png')
dev.off()
# UNFOLD








#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
