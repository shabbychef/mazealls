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

# recycle as needed
.recycle_no_warn <- function(x,needlen) {
	stopifnot(length(x) > 0)
	if (length(x) < needlen) {
		x <- rep(x,ceiling(needlen / length(x)))
		x <- x[1:needlen]
	}
	x
}

.interpret_boundary_hole_arrows <- function(boundary_hole_arrows,nsides=3) {
	if (!is.logical(boundary_hole_arrows) && is.numeric(boundary_hole_arrows)) {
		boundary_hole_arrows <- 1:nsides %in% boundary_hole_arrows
	} else if (is.logical(boundary_hole_arrows)) {
		boundary_hole_arrows <- .recycle_no_warn(boundary_hole_arrows,nsides)
	}
	boundary_hole_arrows
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

.draw_arrowhead <- function(len,angle=80) {
	turtle_right(180-(angle/2))
	turtle_down()
	turtle_forward(distance=len)
	turtle_up()
	turtle_backward(distance=len)
	turtle_right(angle)
	turtle_down()
	turtle_forward(distance=len)
	turtle_up()
	turtle_backward(distance=len)
	turtle_right(180-(angle/2))
}

.draw_arrow <- function(unit_len,angle=80,multi=0.55,doubled=FALSE,double_bit=0.2) {
	turtle_down()
	turtle_forward(distance=unit_len)
	turtle_up()
	.draw_arrowhead(unit_len*multi,angle=angle)
	if (doubled) {
		turtle_backward(distance=double_bit * unit_len)
		.draw_arrowhead(unit_len*multi,angle=angle)
		turtle_forward(distance=double_bit * unit_len)
	} 
	turtle_backward(distance=unit_len)
}

.draw_double_arrow <- function(...) {
	for (iii in 1:2) {
		.draw_arrow(...)
		turtle_right(180)
	}
}

# return a subset of indices of edges implied by
# starts and ends that is random and defines a
# tree on the nodes
.span_tree <- function(starts,ends,all_nodes=NULL) {
	if (is.null(all_nodes)) {
		all_nodes <- unique(c(starts,ends))
	}
	stopifnot(length(starts)==length(ends))
	isin <- rep(FALSE,length(starts))
	# pick one node at random
	in_nodes <- sample(all_nodes,1)
	start_in <- starts %in% in_nodes
	end_in <- ends %in% in_nodes
	mismatch <- xor(start_in,end_in)
	while (any(mismatch)) {
		witchmatch <- which(mismatch)
		nexty <- witchmatch[sample(length(witchmatch),1)]
		isin[nexty] <- TRUE
		in_nodes <- unique(c(in_nodes,starts[nexty],ends[nexty]))
		start_in <- starts %in% in_nodes
		end_in <- ends %in% in_nodes
		mismatch <- xor(start_in,end_in)
	}
	which(isin)
}

.do_boundary <- function(unit_len,lengths,angles,nsides=length(lengths),
												 num_boundary_holes=2,boundary_lines=TRUE,boundary_holes=NULL,
												 boundary_hole_color=NULL,boundary_hole_locations=NULL,
												 boundary_hole_arrows=FALSE) {
	holes <- .interpret_boundary_holes(boundary_holes,num_boundary_holes,nsides=nsides)
	boundary_lines <- .interpret_boundary_lines(boundary_lines,nsides=nsides)

	holey_path(unit_len=unit_len,
						 lengths=lengths,
						 angles=angles,
						 draw_line=boundary_lines,
						 has_hole=holes,
						 hole_color=boundary_hole_color,
						 hole_locations=boundary_hole_locations,
						 hole_arrows=boundary_hole_arrows)
}

# sample from a 'discrete' beta distribution
.rboustro <- function(n,boustro=c(1,1),nsegs=100L) {
	sample(nsegs,size=n,prob=stats::dbeta(stats::ppoints(nsegs),shape1=boustro[1],shape2=boustro[2]),replace=TRUE)
}

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
