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
.is_even <- function(x,toler=1e-7) {
	.near_integer(x/2,toler)
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

draw_line <- function(distance) {
	if (distance > 0) {
		turtle_down()
		turtle_forward(distance=distance)
		turtle_up()
	}
}
draw_colored_line <- function(distance,color) {
	old_color <- turtle_status()$DisplayOptions$col
	turtle_col(color)
	draw_line(distance=distance)
	turtle_col(old_color)
}

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
