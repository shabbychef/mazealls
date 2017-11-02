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

.near_integer <- function(x,toler=1e-7) {
	abs(x - round(x)) < toler
}
.is_power_of_two <- function(x,toler=1e-7) {
	.near_integer(log2(x),toler)
}
.is_divisible_by_three <- function(x,toler=1e-7) {
	.near_integer(x/3,toler)
}

.turn_right <- function(angl) {
	if (angl > 0) {
		turtle_right(angl)
	} else {
		turtle_left(-angl)
	}
}
.turn_left <- function(angl) {
	if (angl > 0) {
		turtle_left(angl)
	} else {
		turtle_right(-angl)
	}
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
	draw_line(dist=dist)
	turtle_col(old_color)
}



.maybe_holey_line <- function(unit_len,num_segs,has_hole=TRUE,go_back=FALSE,hole_color=NULL) {
	if (has_hole) {
		holey_line(unit_len=unit_len,num_segs=num_segs,go_back=go_back,hole_color=hole_color) 
	} else {
		draw_line(dist=(unit_len*num_segs))
		if (go_back) {
			turtle_backward(dist=unit_len * num_segs)
		}
	}
}
.holey_y <- function(unit_len,num_segs) {
	coinflip <- sample.int(n=2,size=1)
	.turn_left(60)
	.maybe_holey_line(unit_len,num_segs,has_hole=coinflip==1,go_back=TRUE)
	.turn_right(120)
	.maybe_holey_line(unit_len,num_segs,has_hole=coinflip==2,go_back=TRUE)
	.turn_left(60)
}
#' draw a \sQuote{bone} shape with holes in it, centered
#' on the turtle in the given direction.
holey_bone <- function(unit_len,num_segs) {
	if (num_segs > 0) {
		coinflip <- sample.int(n=2,size=1)
		if (coinflip==1) {
			no_hole_seg <- sample.int(n=4,size=1)
			# no hole in the center
			for (jjj in c(0,1)) {
				draw_line(dist=unit_len * num_segs/2)
				.turn_left(60)
				.maybe_holey_line(unit_len,num_segs,has_hole=no_hole_seg != 2*jjj+1,go_back=TRUE)
				.turn_right(120)
				.maybe_holey_line(unit_len,num_segs,has_hole=no_hole_seg != 2*jjj+2,go_back=TRUE)
				.turn_left(60)
				.turn_left(180)
				turtle_forward(dist=unit_len * num_segs/2)
			}
		} else {
			# hole in the center
			turtle_forward(dist=unit_len * num_segs/2)
			for (jjj in c(0,1)) {
				.holey_y(unit_len,num_segs)
				.turn_right(180)
				turtle_forward(dist=unit_len * num_segs)
			}
			.turn_right(180)
			holey_line(unit_len,num_segs,go_back=TRUE)
			turtle_forward(dist=unit_len * num_segs/2)
			.turn_right(180)
		}
	}
}


#' recursively draw an equilateral triangle, with sides all of length
#' 2^depth * unit_len, starting from the middle of one side.
#' @param depth the depth of recursion
#' @param unit_len the length of one segment
#' @param clockwise whether to draw clockwise.
#' @param draw_boundary whether to draw a boundary
#' @param type there are many ways to recursive draw a triangle, either by
#'        recursively drawing 4 triangles, or by stacking trapezoids, and so
#'        on.
eq_triangle_maze <- function(depth,unit_len,clockwise=TRUE,method=c('stack_trapezoids','triangles','uniform','two_ears','random',
																																	 'hex_and_three','shave_all','shave'),
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
	if (non_two) {
		stopifnot((method != 'hex_and_three') || .near_integer(by_three))
		if (! method %in% c('shave','shave_all','hex_and_three')) {
			warning('for side length not a power of two, will switch to shave')
			method <- 'shave'
		}
	}

	multiplier <- ifelse(clockwise,1,-1)

	if (start_from=='corner') { turtle_forward(dist=unit_len * num_segs/2) }

	if (depth > 0) {
		my_method <- switch(method,
												shave_all={ 'shave' },
												uniform={ 'triangles' },
												random={
													sample(c('stack_trapezoids','triangles','two_ears'),1)
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

turtle_init(1500,1500)
turtle_hide()
turtle_up()
turtle_do({
	turtle_left(90)
	turtle_forward(40)
	turtle_right(90)
	#eq_triangle_maze(depth=6,12,clockwise=FALSE,method='two_ears',draw_boundary=TRUE)
	#eq_triangle_maze(depth=6,12,clockwise=FALSE,method='random',draw_boundary=TRUE)
	#eq_triangle_maze(depth=6,12,clockwise=TRUE,method='two_ears',draw_boundary=TRUE,boundary_holes=c(1,3),boundary_hole_color=c('clear','clear','green'))
	#eq_triangle_maze(depth=6,12,clockwise=FALSE,method='uniform',draw_boundary=TRUE,boundary_lines=c(2,3),boundary_holes=c(2),boundary_hole_color='green')
#	eq_triangle_maze(depth=6,12,clockwise=TRUE,method='triangles',draw_boundary=TRUE,boundary_holes=c(1,3),boundary_hole_color=c('clear','clear','green'))
	#eq_triangle_maze(depth=6,12,clockwise=FALSE,method='stack_trapezoids',draw_boundary=TRUE,boundary_lines=c(2,3),boundary_holes=c(2),boundary_hole_color='green')
	#eq_triangle_maze(depth=log2(9*9),12,clockwise=TRUE,method='hex_and_three',draw_boundary=TRUE,boundary_holes=c(1,3),boundary_hole_color=c('clear','clear','green'))
	#eq_triangle_maze(depth=log2(72),10,clockwise=FALSE,method='shave',draw_boundary=TRUE,boundary_lines=c(2,3),boundary_holes=c(2),boundary_hole_color='green')
	#eq_triangle_maze(depth=log2(72),10,clockwise=TRUE,method='shave_all',draw_boundary=TRUE,boundary_holes=c(1,3),boundary_hole_color=c('clear','clear','green'))

	eq_triangle_maze(depth=log2(3),15,start_from='corner',method='random',draw_boundary=TRUE,num_boundary_holes=0)
})

dev.copy(png,'mazefu.png')
dev.off()


#' recursively draw a regular hexagon, with sides all of length
#' 2^depth * unit_len, starting from the middle of one side.
#' @param depth the depth of recursion
#' @param unit_len the length of one segment
#' @param clockwise whether to draw clockwise.
#' @param draw_boundary whether to draw a boundary
#' @param type there are many ways to recursive draw a triangle, either by
#'        drawing 6 triangles, or stacking two trapezoids, and so on.
hexagon_maze <- function(depth,unit_len,clockwise=TRUE,method=c('two_trapezoids','six_triangles','three_parallelograms','random'),
												 start_from=c('midpoint','corner'),
												 draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,boundary_holes=NULL,boundary_hole_color=NULL,
												 end_side=1) {
	
	method <- match.arg(method)
	start_from <- match.arg(start_from)

	if (start_from=='corner') { turtle_forward(dist=unit_len * num_segs/2) }
	# check for off powers of two
	non_two <- ! .near_integer(depth)
	if (non_two && !(method %in% c('three_parallelograms'))) {
		warning('for side length not a power of two, will switch to three parallelograms')
		method <- 'three_parallelograms'
	}
	num_segs <- round(2^depth)
	multiplier <- ifelse(clockwise,1,-1)

	if (depth > 1) {
		turtle_up()
		my_method <- switch(method,
												 random={
													 sample(c('two_trapezoids','six_triangles','three_parallelograms'),1)
												 },
												 method)
		switch(my_method,
					 two_trapezoids={
						 magic_ratio <- sqrt(3) / 4

						 .turn_right(multiplier * 90)
						 turtle_forward(2*num_segs * unit_len * magic_ratio)
						 .turn_left(multiplier * 90)
						 iso_trapezoid_maze(depth,unit_len,clockwise=clockwise,draw_boundary=FALSE)
						 iso_trapezoid_maze(depth,unit_len,clockwise=!clockwise,draw_boundary=FALSE)

						 turtle_backward(dist=unit_len * num_segs)
						 holey_line(unit_len,num_segs*2)
						 turtle_backward(dist=unit_len * num_segs)
						 
						 .turn_left(multiplier * 90)
						 turtle_forward(2*num_segs * unit_len * magic_ratio)
						 .turn_right(multiplier * 90)
					 },
					 six_triangles={
						 turtle_backward(dist=unit_len * num_segs/2) 
						 bholes <- sample.int(n=6,size=5)
						 for (iii in c(1:6)) {
							 eq_triangle_maze(depth,unit_len,clockwise=clockwise,method='random',draw_boundary=TRUE,
																start_from='corner',
																boundary_lines=2,boundary_holes=iii %in% bholes)
							 turtle_forward(dist=unit_len * num_segs) 
							 .turn_right(multiplier*60)
						 }
						 turtle_forward(dist=unit_len * num_segs/2) 
					 },
					 three_parallelograms={
						 bholes <- sample.int(n=3,size=2)
						 for (iii in 1:3) {
							 parallelogram_maze(unit_len,num_segs,num_segs,angle=60,clockwise=clockwise,
																	draw_boundary=TRUE,boundary_lines=3,num_boundary_holes=0,boundary_holes=iii %in% bholes)
							 turtle_forward(num_segs * unit_len / 2)
							 .turn_right(multiplier * 60)
							 turtle_forward(num_segs * unit_len)
							 .turn_right(multiplier * 60)
							 turtle_forward(num_segs * unit_len / 2)
						 }
					 })
	}
	if (draw_boundary) {
		holes <- .interpret_boundary_holes(boundary_holes,num_boundary_holes,nsides=6)
		boundary_lines <- .interpret_boundary_lines(boundary_lines,nsides=6)

		turtle_backward(dist=unit_len * num_segs/2)

		holey_path(unit_len=unit_len,
							 lengths=num_segs,
							 angles=multiplier*60,
							 draw_line=boundary_lines,
							 has_hole=holes,
							 hole_color=boundary_hole_color)
		turtle_forward(dist=unit_len * num_segs/2)
	}
	if ((end_side != 1) && (!is.null(end_side))) {
		for (iii in 1:(end_side-1)) {
			turtle_forward(dist=unit_len * num_segs/2)
			.turn_right(multiplier * 60)
			turtle_forward(dist=unit_len * num_segs/2)
		}
	}
	if (start_from=='corner') { turtle_backward(dist=unit_len * num_segs/2) }
}

turtle_init(2000,2000)
turtle_hide()
turtle_do({
	turtle_up()
	turtle_backward(250)
	.turn_right(90)
	turtle_forward(150)
	.turn_left(90)

	.turn_right(60)
	hexagon_maze(depth=5,12,clockwise=FALSE,method='six_triangles',draw_boundary=TRUE,boundary_holes=c(1,4),boundary_hole_color='green')
})


turtle_init(2000,2000)
turtle_hide()
turtle_do({
	turtle_up()
	turtle_backward(250)
	.turn_right(90)
	turtle_forward(150)
	.turn_left(90)

	.turn_right(60)
	hexagon_maze(depth=log2(20),12,clockwise=FALSE,method='six_triangles',draw_boundary=TRUE,boundary_holes=c(1,4),boundary_hole_color='green')
})


turtle_init(1000,1000)
turtle_hide()
turtle_do({
	turtle_up()
	#iso_trapezoid_maze(depth=4,20,clockwise=FALSE,draw_boundary=TRUE)
	#eq_triangle_maze(depth=5,15,clockwise=FALSE,draw_boundary=TRUE)
	#eq_triangle_maze(depth=5,15,clockwise=FALSE,method='triangles',draw_boundary=TRUE)
	turtle_backward(250)
	.turn_right(90)
	turtle_forward(150)
	.turn_left(90)

	.turn_right(60)
	hexagon_maze(depth=5,12,clockwise=FALSE,method='three_parallelograms',draw_boundary=TRUE,boundary_holes=c(1,4),boundary_hole_color='green')
})
dev.copy(png,'mazecubes.png')
dev.off()

#' recursively draw a parallelogram maze, with sides of length
#' width*unit_len and height*unit_len,
#' starting from the middle of one side.
#' @param unit_len the length of one segment
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
parallelogram_maze <- function(unit_len,height,width,angle=90,clockwise=TRUE,method=c('two_parallelograms','four_parallelograms','uniform','random'),
															 start_from=c('midpoint','corner'),
															 draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,boundary_holes=NULL,boundary_hole_color=NULL,
															 end_side=1) {
	
	method <- match.arg(method)
	start_from <- match.arg(start_from)

	if (start_from=='midpoint') { turtle_backward(dist=unit_len * height/2) }

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
						 spliton <- sample(c('height','width'),1)
						 switch(spliton,
										height={
											midp <- sample.int(size=1,n=(height-1))
											parallelogram_maze(unit_len,height=midp,width=width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																				 draw_boundary=TRUE,num_boundary_holes=0,boundary_lines=2,boundary_holes=2)
											turtle_forward(midp*unit_len)
											parallelogram_maze(unit_len,height=height-midp,width=width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																				 draw_boundary=FALSE)
											turtle_backward(midp*unit_len)
										},
										width={
											midp <- sample.int(size=1,n=(width-1))
											parallelogram_maze(unit_len,height=height,width=midp,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																				 draw_boundary=TRUE,num_boundary_holes=0,boundary_lines=3,boundary_holes=3)

											.turn_right(angle*multiplier)
											turtle_forward(midp*unit_len)
											.turn_left(angle*multiplier)
											parallelogram_maze(unit_len,height=height,width=width-midp,angle=angle,clockwise=clockwise,method=method,start_from='corner',
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

						 parallelogram_maze(unit_len,height=mid_height,width=mid_width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																draw_boundary=TRUE,boundary_lines=2,boundary_holes=1 %in% bholes)
						 turtle_forward(mid_height*unit_len)
						 parallelogram_maze(unit_len,height=height-mid_height,width=mid_width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																draw_boundary=TRUE,boundary_lines=3,boundary_holes=2 %in% bholes)

						 .turn_right(angle*multiplier)
						 turtle_forward(mid_width*unit_len)
						 .turn_left(angle*multiplier)

						 parallelogram_maze(unit_len,height=height-mid_height,width=width-mid_width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
																draw_boundary=TRUE,boundary_lines=4,boundary_holes=4 %in% bholes)
						 turtle_backward(mid_height*unit_len)
						 parallelogram_maze(unit_len,height=mid_height,width=width-mid_width,angle=angle,clockwise=clockwise,method=method,start_from='corner',
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
		angls <-  multiplier * c(angle,180-angle,180-angle)

		holey_path(unit_len=unit_len,
							 lengths=molens[1:(end_side-1)],
							 angles=angls[1:(end_side-1)],
							 draw_line=FALSE,
							 has_hole=FALSE,
							 hole_color=NULL)
	}

	if (start_from=='midpoint') { turtle_forward(dist=unit_len * height/2) }
}

turtle_init(2000,2000)
turtle_hide()
turtle_do({
	turtle_up()
	#parallelogram_maze(unit_len=10,width=15,height=15,draw_boundary=TRUE)
	#parallelogram_maze(angle=90,unit_len=10,width=25,height=25,draw_boundary=FALSE)
	#parallelogram_maze(angle=90,unit_len=10,width=25,height=25,method='four_parallelograms',draw_boundary=TRUE)

	#parallelogram_maze(angle=90,unit_len=10,width=35,height=55,method='random',draw_boundary=TRUE)
	parallelogram_maze(angle=90,unit_len=12,width=75,height=55,method='uniform',draw_boundary=TRUE)
})

#library(TurtleGraphics)
turtle_init(1000,1000)
turtle_hide()
turtle_do({
	#iso_trapezoid_maze(depth=3,20,clockwise=TRUE,)
	iso_trapezoid_maze(depth=3,20,clockwise=FALSE,draw_boundary=TRUE,boundary_hole_color='green')
})

turtle_init(1000,1000)
turtle_hide()
turtle_do({
	#iso_trapezoid_maze(depth=4,20,clockwise=FALSE,draw_boundary=TRUE)
	eq_triangle_maze(depth=5,15,clockwise=FALSE,draw_boundary=TRUE)
})

turtle_init(1000,1000)
turtle_hide()
turtle_do({
	#iso_trapezoid_maze(depth=4,20,clockwise=FALSE,draw_boundary=TRUE)
	#eq_triangle_maze(depth=5,15,clockwise=FALSE,draw_boundary=TRUE)
	#eq_triangle_maze(depth=5,15,clockwise=FALSE,method='triangles',draw_boundary=TRUE)
	hexagon_maze(depth=4,15,clockwise=FALSE,method='two_trapezoids',draw_boundary=TRUE,boundary_holes=c(1,4))
	hexagon_maze(depth=4,15,clockwise=TRUE,method='two_trapezoids',draw_boundary=TRUE,boundary_lines=c(2,3,4,5,6),boundary_holes=c(1,4))
})
	#turtle_down()
	#turtle_forward(20)
	#turtle_up()
	#.turn_right(20*runif(1))

# test# FOLDUP
turtle_init(1000,1000)
turtle_hide()
turtle_do({
	#iso_trapezoid_maze(depth=4,20,clockwise=FALSE,draw_boundary=TRUE)
	#eq_triangle_maze(depth=5,15,clockwise=FALSE,draw_boundary=TRUE)
	#eq_triangle_maze(depth=5,15,clockwise=FALSE,method='triangles',draw_boundary=TRUE)
	depth <- 4
	num_segs <- 2^depth
	unit_len <- 8
	multiplier <- -1
	hexagon_maze(depth=depth,unit_len,clockwise=FALSE,method='two_trapezoids',draw_boundary=FALSE)
	for (iii in c(1:6)) {
		if (iii %in% c(1,4)) {
			holes <- c(1,4) 
		} else {
			holes <- c(1)
		}
		hexagon_maze(depth=depth,unit_len,clockwise=TRUE,method='two_trapezoids',draw_boundary=TRUE,boundary_holes=holes)
		turtle_forward(dist=unit_len * num_segs/2)
		.turn_right(multiplier * 60)
		turtle_forward(dist=unit_len * num_segs/2)
	}
})

dev.copy(png,'mazeballs.png')
dev.off()
# UNFOLD








#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
