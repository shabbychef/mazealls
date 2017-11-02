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
#' @param hole_color the color to plot the \sQuote{hole}. A 
#' \code{NULL} value corresponds to no drawn hole. See the
#' \link{\code{grDevices::colors}} function for
#' more options.
#' @return Returns the randomly chosen location of the hole, though typically
#' the function is called for side effects only.
#' @template etc
#' @examples 
#' \dontrun{
#' turtle_init(1000,1000)
#' y <- holey_line(unit_len=20, num_segs=15)
#' }
#' @export
holey_line <- function(unit_len,num_segs,go_back=FALSE,hole_color=NULL) {
	if (num_segs > 1) {
		whichn <- sample.int(n=num_segs,size=1)
		draw_line(dist=(whichn-1) * unit_len)
		if (!is.null(hole_color)) {
			draw_colored_line(unit_len,hole_color)
		} else {
			turtle_forward(unit_len)
		}
		draw_line(dist=(num_segs-whichn) * unit_len)
		if (go_back) {
			turtle_backward(dist=unit_len * num_segs)
		}
	} else if (num_segs == 1) {
		whichn <- 1
		if (!is.null(hole_color)) {
			draw_colored_line(unit_len,hole_color)
			if (go_back) {
				turtle_backward(dist=unit_len * num_segs)
			}
		} else if (!go_back) {
			turtle_forward(unit_len)
		}
	} else {
		whichn <- 0
	}
	whichn
}

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
