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
#'
#' @param the total number of segments. All but one of these,
#' of length \code{seg_len} will be drawn. The other, randomly
#' chosen, will be a hole.
#' @param seg_len the length of one segment.
#' @param go_back whether to go back when done.
holey_line <- function(seg_len,num_segs,go_back=FALSE) {
	if (num_segs > 1) {
		whichn <- sample.int(n=num_segs,size=1)
		draw_line(dist=(whichn-1) * seg_len)
		turtle_forward(seg_len)
		draw_line(dist=(num_segs-whichn) * seg_len)
		if (go_back) {
			turtle_backward(dist=seg_len * num_segs)
		}
	}
}
maybe_holey_line <- function(seg_len,num_segs,has_hole=TRUE,go_back=FALSE) {
	if (has_hole) {
		holey_line(seg_len=seg_len,num_segs=num_segs,go_back=go_back) 
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

#' recursively draw a isosceles trapezoid, with three sides of length
#' 2^depth * seg_len and one of length 2^(depth+1) * seg_len, starting
#' from the middle of the longer side. will draw either 
#' @param depth the depth of recursion
#' @param seg_len the length of one segment
#' @param clockwise whether to draw clockwise.
#' @param draw_boundary whether to draw a boundary
trapezoid <- function(depth,seg_len,clockwise=TRUE,draw_boundary=FALSE,boundary_holes=2) {
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
			trapezoid(depth-1,seg_len,clockwise=clockwise,draw_boundary=FALSE)
			turtle_forward(num_segs * seg_len)
			turtle_right(multiplier * 120)
			for (iii in c(1:3)) {
				turtle_forward(num_segs * seg_len/2)
				trapezoid(depth-1,seg_len,clockwise=clockwise,draw_boundary=FALSE)
				turtle_forward(num_segs * seg_len/2)
				turtle_right(multiplier * 60)
			}
			turtle_right(multiplier * 60)
			turtle_forward(num_segs * seg_len)
		}
	}
	if (draw_boundary) {
		# do this
		holes <- sample.int(n=4,size=4) <= boundary_holes
		turtle_backward(dist=seg_len * num_segs)
		maybe_holey_line(seg_len,num_segs*2,has_hole=holes[1])
		turtle_right(multiplier * 120)
		for (iii in c(1:3)) {
			maybe_holey_line(seg_len,num_segs,has_hole=holes[1+iii])
			turtle_right(multiplier * 60)
		}
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
triangle <- function(depth,seg_len,clockwise=TRUE,method=c('stack_trapezoids','triangles'),
										 draw_boundary=FALSE,boundary_holes=2) {
	
	method <- match.arg(method)
	num_segs <- 2^depth
	multiplier <- ifelse(clockwise,1,-1)

	if (depth > 1) {
		switch(method,
					 stack_trapezoids={
						 trapezoid(depth-1,seg_len,clockwise=clockwise,draw_boundary=FALSE)
						 # now move over
						 magic_ratio <- sqrt(3) / 4

						 turtle_up()
						 turtle_right(multiplier * 90)
						 turtle_forward(num_segs * seg_len * magic_ratio)
						 turtle_left(multiplier * 90)
						 triangle(depth-1,seg_len,clockwise=clockwise,method=method,draw_boundary=FALSE)
						 turtle_left(multiplier * 90)
						 turtle_forward(num_segs * seg_len * magic_ratio)
						 turtle_right(multiplier * 90)
					 },
					 triangles={
						 turtle_up()
						 turtle_backward(dist=seg_len * num_segs/2)
						 for (iii in c(1:3)) {
							 turtle_forward(dist=seg_len * num_segs/4)
							 triangle(depth-1,seg_len,clockwise=clockwise,method='stack_trapezoids',draw_boundary=FALSE)
							 turtle_forward(dist=seg_len * 3 * num_segs/4)
							 turtle_right(multiplier * 120)
						 }
						 turtle_forward(dist=seg_len * num_segs/2)
						 turtle_right(multiplier * 60)
						 turtle_forward(dist=seg_len * num_segs/4)
						 triangle(depth-1,seg_len,clockwise=clockwise,method='stack_trapezoids',draw_boundary=TRUE,boundary_holes=3)
						 turtle_backward(dist=seg_len * num_segs/4)
						 turtle_left(multiplier * 60)
					 })
	}
	if (draw_boundary) {
		# do this
		holes <- sample.int(n=3,size=3) <= boundary_holes
		turtle_backward(dist=seg_len * num_segs/2)
		for (iii in c(1:3)) {
			maybe_holey_line(seg_len,num_segs,has_hole=holes[iii])
			turtle_right(multiplier * 120)
		}
		turtle_forward(dist=seg_len * num_segs/2)
	}
}

#' recursively draw a regular hexagon, with sides all of length
#' 2^depth * seg_len, starting from the middle of one side.
#' @param depth the depth of recursion
#' @param seg_len the length of one segment
#' @param clockwise whether to draw clockwise.
#' @param draw_boundary whether to draw a boundary
#' @param type there are many ways to recursive draw a triangle, either by
#'        drawing 6 triangles, or stacking two trapezoids, and so on.
hexagon <- function(depth,seg_len,clockwise=TRUE,method=c('two_trapezoids','six_triangles'),
										draw_boundary=FALSE,num_boundary_holes=2,boundary_holes=NULL) {
	
	method <- match.arg(method)
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
						 trapezoid(depth,seg_len,clockwise=clockwise,draw_boundary=FALSE)
						 trapezoid(depth,seg_len,clockwise=!clockwise,draw_boundary=FALSE)

						 turtle_backward(dist=seg_len * num_segs)
						 holey_line(seg_len,num_segs*2)
						 turtle_backward(dist=seg_len * num_segs)
						 
						 turtle_left(multiplier * 90)
						 turtle_forward(2*num_segs * seg_len * magic_ratio)
						 turtle_right(multiplier * 90)
					 },
					 two_triangles={
						 turtle_up()
					 })
	}
	if (draw_boundary) {
		# do this
		if (is.null(boundary_holes)) {
			holes <- sample.int(n=6,size=6) <= num_boundary_holes
		} else {
			holes <- 1:6 %in% boundary_holes
		}
		turtle_backward(dist=seg_len * num_segs/2)
		for (iii in c(1:6)) {
			maybe_holey_line(seg_len,num_segs,has_hole=holes[iii])
			turtle_right(multiplier * 60)
		}
		turtle_forward(dist=seg_len * num_segs/2)
	}
}

#library(TurtleGraphics)
turtle_init(1000,1000)
turtle_hide()
#turtle_do({
	#trapezoid(depth=3,20,clockwise=TRUE)
	#trapezoid(depth=3,20,clockwise=FALSE)
#})

turtle_init(1000,1000)
turtle_hide()
turtle_do({
	#trapezoid(depth=4,20,clockwise=FALSE,draw_boundary=TRUE)
	#triangle(depth=5,15,clockwise=FALSE,draw_boundary=TRUE)
	#triangle(depth=5,15,clockwise=FALSE,method='triangles',draw_boundary=TRUE)
	hexagon(depth=4,15,clockwise=FALSE,method='two_trapezoids',draw_boundary=TRUE,boundary_holes=c(1,4))
	hexagon(depth=4,15,clockwise=TRUE,method='two_trapezoids',draw_boundary=FALSE,boundary_holes=c(1,4))
})
	#turtle_down()
	#turtle_forward(20)
	#turtle_up()
	#turtle_right(20*runif(1))

turtle_init(1000,1000)
turtle_hide()
turtle_do({
	#trapezoid(depth=4,20,clockwise=FALSE,draw_boundary=TRUE)
	#triangle(depth=5,15,clockwise=FALSE,draw_boundary=TRUE)
	#triangle(depth=5,15,clockwise=FALSE,method='triangles',draw_boundary=TRUE)
	depth <- 4
	num_segs <- 2^depth
	seg_len <- 8
	multiplier <- -1
	hexagon(depth=depth,seg_len,clockwise=FALSE,method='two_trapezoids',draw_boundary=FALSE)
	for (iii in c(1:6)) {
		if (iii %in% c(1,4)) {
			holes <- c(1,4) 
		} else {
			holes <- c(1)
		}
		hexagon(depth=depth,seg_len,clockwise=TRUE,method='two_trapezoids',draw_boundary=TRUE,boundary_holes=holes)
		turtle_forward(dist=seg_len * num_segs/2)
		turtle_right(multiplier * 60)
		turtle_forward(dist=seg_len * num_segs/2)
	}
})

dev.copy(png,'mazeballs.png')
dev.off()

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
