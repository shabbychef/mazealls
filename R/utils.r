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
trapezoid <- function(depth,seg_len,clockwise=TRUE,draw_boundary=FALSE) {
	if (depth > 0) {
		# recurse.
		num_segs <- 2^depth
		magic_ratio <- sqrt(3) / 4
		multiplier <- ifelse(clockwise,1,-1)

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

	}
}

#library(TurtleGraphics)
turtle_init(1000,1000)
turtle_hide()
turtle_do({
	trapezoid(depth=3,20,clockwise=TRUE)
	trapezoid(depth=3,20,clockwise=FALSE)
})

	#turtle_down()
	#turtle_forward(20)
	#turtle_up()
	#turtle_right(20*runif(1))


#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
