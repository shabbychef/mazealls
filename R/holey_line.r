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

.cut_arrow <- function(unit_len) {
		turtle_forward(unit_len/2)
		turtle_right(90)
		.draw_double_arrow(unit_len=0.45*unit_len,angle=85,doubled=FALSE,double_bit=0.33)
		turtle_left(90)
		turtle_backward(unit_len/2)
}
#' @title holey_line .
#'
#' @description 
#' 
#' Draws a line with a randomly selected \sQuote{hole} in it.
#'
#' @details
#'
#' This function is the workhorse of drawing mazes, as it
#' creates a maze wall with a single hole in it.
#'
#' @keywords plotting
#' @param num_segs the total number of segments. All but one of these,
#' of length \code{unit_len} will be drawn. The other, randomly
#' chosen, will be a hole. If \code{num_segs} is one, only a hole is made,
#' and no line drawn.  If zero or less, no action taken.
#' @template param-unitlen
#' @param go_back whether to return the turtle to starting position
#' when the line has been drawn.
#' @param which_seg optional numeric indicating which segment should
#' have the hole. If \code{NULL}, the hole segment is chosen uniformly
#' at random.
#' @param hole_arrow a boolean or indicating whether
#' to draw a perpendicular arrow at a hole.
#' @param hole_color the color to plot the \sQuote{hole}. A 
#' \code{NULL} value corresponds to no drawn hole. 
#' See the \code{\link[grDevices]{colors}} function for
#' acceptable values.
#' @return Returns the \code{which_seg} variable, the location of the hole, though typically
#' the function is called for side effects only.
#' @template etc
#' @examples 
#'
#' library(TurtleGraphics)
#' turtle_init(1000,1000,mode='clip')
#' turtle_hide()
#' y <- holey_line(unit_len=20, num_segs=15)
#'
#' turtle_right(90)
#' y <- holey_line(unit_len=20, num_segs=10,hole_arrow=TRUE)
#'
#' @export
holey_line <- function(unit_len,num_segs,which_seg=NULL,go_back=FALSE,hole_color=NULL,hole_arrow=FALSE) {
	if (num_segs > 1) {
		if (is.null(which_seg)) {
			which_seg <- sample.int(n=num_segs,size=1)
		} else {
			which_seg <- min(num_segs,max(1,which_seg))
		}
		draw_line(distance=(which_seg-1) * unit_len)
		if (hole_arrow) { .cut_arrow(unit_len) }
		if (!is.null(hole_color)) {
			draw_colored_line(unit_len,hole_color)
		} else {
			turtle_forward(unit_len)
		}
		draw_line(distance=(num_segs-which_seg) * unit_len)
		if (go_back) {
			turtle_backward(distance=unit_len * num_segs)
		}
	} else if (num_segs == 1) {
		which_seg <- 1
		if (hole_arrow) { .cut_arrow(unit_len) }
		if (!is.null(hole_color)) {
			draw_colored_line(unit_len,hole_color)
			if (go_back) {
				turtle_backward(distance=unit_len * num_segs)
			}
		} else if (!go_back) {
			turtle_forward(unit_len)
		}
	} else {
		which_seg <- 0
	}
	which_seg
}

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
