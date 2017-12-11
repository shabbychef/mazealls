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

#' @title iso_trapezoid_maze .
#'
#' @description 
#' 
#' Recursively draw a isosceles trapezoid maze, with three sides consisting
#' of \eqn{2^{depth}} pieces of length \code{unit_len}, and one long
#' side of length \eqn{2^{depth+1}} pieces, starting from the
#' long side.
#'
#' @details
#'
#' Draws a maze in an isoscelese trapezoid with three sides of equal length
#' and one long side of twice that length, starting from the midpoint
#' of the long side (or the corner before the first side via the
#' \code{start_from} option). A number of different recursive methods
#' are supported.
#' Optionally draws boundaries around the trapezoid, 
#' with control over which sides have lines and
#' holes. Three sides of the trapezoid consist of \eqn{2^{depth}} segments
#' of length \code{unit_len}, while the longer has \eqn{2^{depth}}. 
#' A number of different methods are supported.
#' For \code{method='four_trapezoids'}:
#'
#' \if{html}{
#' \figure{trap-four-1.png}{options: width="100\%" alt="Figure: four trapezoids"}
#' }
#' \if{latex}{
#' \figure{trap-four-1.png}{options: width=7cm}
#' }
#'
#' For \code{method='one_ear'}:
#'
#' \if{html}{
#' \figure{trap-ear-1.png}{options: width="100\%" alt="Figure: one ear"}
#' }
#' \if{latex}{
#' \figure{trap-ear-1.png}{options: width=7cm}
#' }
#'
#'
#'
#' @keywords plotting
#' @template etc
#' @template param-unitlen
#' @template param-clockwise
#' @template param-start-from
#' @template param-end-side
#' @template param-boustro
#' @template param-boundary-stuff
#' @template param-boundary-hole-controls
#' @template return-none
#' @param depth the depth of recursion. This controls the
#' side length: three sides have \code{round(2^depth)} segments
#' of length \code{unit_len}, while the long side is twice as long.
#' \code{depth} need not be integral.
#' @param method there are many ways to recursive draw an isosceles
#' trapezoid.  The following values are acceptable:
#' \describe{
#' \item{four_trapezoids}{Four isosceles trapezoids are packed around each
#' other with a \sQuote{bone} between them.}
#' \item{one_ear}{A parallelogram is placed next to an equilateral triangle
#' (an \sQuote{ear}). Note this method is acceptable when depth is
#' not an integer.}
#' \item{random}{A method is chosen uniformly at random.}
#' }
#'
#' @examples 
#'
#' library(TurtleGraphics)
#' turtle_init(1000,1000)
#' turtle_hide() 
#' iso_trapezoid_maze(depth=4,20,clockwise=FALSE,draw_boundary=TRUE)
#'
#' turtle_init(1000,1000)
#' turtle_hide() 
#' turtle_do({
#' iso_trapezoid_maze(depth=3,20,clockwise=TRUE,draw_boundary=TRUE,boundary_holes=3)
#' })
#'
#' turtle_init(2000,2000)
#' turtle_hide() 
#' turtle_up()
#' turtle_do({
#' 	len <- 22
#' 	iso_trapezoid_maze(depth=log2(len),15,clockwise=TRUE,draw_boundary=TRUE,
#' 	  boundary_holes=c(1,3),method='one_ear',
#' 	  boundary_hole_color=c('clear','clear','green','clear'))
#' 	iso_trapezoid_maze(depth=log2(len),15,clockwise=FALSE,draw_boundary=TRUE,
#' 	  boundary_lines=c(2,3,4),boundary_holes=c(2),method='one_ear',
#' 	  boundary_hole_color=c('red'))
#' })
#' @export
iso_trapezoid_maze <- function(depth,unit_len=4L,clockwise=TRUE,start_from=c('midpoint','corner'),
															 method=c('four_trapezoids','one_ear','random'),
															 boustro=c(1,1),
															 draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,
															 boundary_holes=NULL,boundary_hole_color=NULL,boundary_hole_locations=NULL,
															 boundary_hole_arrows=FALSE,
															 end_side=1) {
	method <- match.arg(method)
	start_from <- match.arg(start_from)

	# check for off powers of two
	non_two <- ! .near_integer(depth)
	num_segs <- round(2^depth)

	if (non_two) { 
		method <- 'one_ear' 
	} else if (method=='random') {
		method <- sample(c('four_trapezoids','one_ear'),1)
	}

	multiplier <- ifelse(clockwise,1,-1)

	if (start_from=='corner') { turtle_forward(distance=unit_len * num_segs) }

	if (depth > 0) {
		my_method <- method
		switch(my_method,
			four_trapezoids={

				# recurse.
				iso_trapezoid_maze(unit_len=unit_len,depth=depth-1,clockwise=clockwise,start_from='midpoint',
													 draw_boundary=FALSE,num_boundary_holes=NULL,
													 boustro=rev(boustro),end_side=1)

				# determine inner holes
				starts <- c(2,2,3,4,4)
				ends   <- c(3,1,1,1,3)
				which_holes <- .span_tree(starts,ends)

				inner_lines <- c(FALSE,TRUE,TRUE,FALSE,
												 FALSE,FALSE,TRUE,FALSE,
												 FALSE,FALSE,TRUE,TRUE)
				inner_holes <- rep(FALSE,length(inner_lines))
				inner_holes[which(inner_lines)[which_holes]] <- TRUE
				inner_hole_locs <- .rboustro(12,boustro=boustro,nsegs=num_segs)

				# have at it
				turn_ang <- c(120,60,60)
				for (iii in 1:3) {
					turtle_forward(num_segs * unit_len)
					.turn_right(multiplier * turn_ang[iii])
					myidx <- 1:4 + (iii-1)*4
					blines <- inner_lines[myidx]
					bholes <- inner_holes[myidx]
					iso_trapezoid_maze(unit_len=unit_len,depth=depth-1,clockwise=clockwise,start_from='corner',
														 boustro=rev(boustro),
														 draw_boundary=TRUE,
														 num_boundary_holes=NULL,
														 boundary_lines=blines,
														 boundary_holes=bholes,
														 boundary_hole_locations=inner_hole_locs[myidx],
														 end_side=1)
				}
				turtle_forward(num_segs * unit_len)
				.turn_right(multiplier * 120)
				turtle_forward(num_segs * unit_len)
			},
			one_ear={
				coinflip <- sample.int(n=2,size=1)
				if (coinflip==1) {
					parallelogram_maze(unit_len=unit_len,height=num_segs,width=num_segs,angle=120,clockwise=clockwise,
														 method='random',start_from='corner',
														 height_boustro=boustro,width_boustro=boustro,
														 draw_boundary=TRUE,num_boundary_holes=NULL,boundary_lines=c(4),boundary_holes=4,
														 end_side=4)
					eq_triangle_maze(depth=log2(num_segs),unit_len=unit_len,clockwise=!clockwise,
													 method='random',start_from='corner',
													 boustro=rev(boustro),
													 draw_boundary=FALSE,end_side=2)
					turtle_right(180)
				} else {
					eq_triangle_maze(depth=log2(num_segs),unit_len=unit_len,clockwise=clockwise,
													 method='random',start_from='corner',
													 boustro=rev(boustro),
													 draw_boundary=FALSE,end_side=3)
					parallelogram_maze(unit_len=unit_len,height=num_segs,width=num_segs,angle=60,clockwise=!clockwise,
														 method='random',start_from='corner',
														 height_boustro=boustro,width_boustro=boustro,
														 draw_boundary=TRUE,num_boundary_holes=NULL,boundary_lines=c(1),boundary_holes=1,
														 end_side=2)
					turtle_right(180)
				}
			})

	}
	if (draw_boundary) {
		turtle_backward(distance=unit_len * num_segs)
		if (is.null(boundary_hole_locations)) {
			boundary_hole_locations <- .rboustro(4,boustro=boustro,nsegs=num_segs)
			boundary_hole_locations[1] <- .rboustro(1,boustro=boustro,nsegs=2*num_segs)
		}

		.do_boundary(unit_len,lengths=num_segs * c(2,1,1,1),angles=multiplier * 60 * c(2,1,1,2),
								 num_boundary_holes=num_boundary_holes,boundary_lines=boundary_lines,
								 boundary_holes=boundary_holes,boundary_hole_color=boundary_hole_color,
								 boundary_hole_locations=boundary_hole_locations,boundary_hole_arrows=boundary_hole_arrows)

		turtle_forward(distance=unit_len * num_segs)
	}

	# move to ending side
	if ((end_side != 1) && (!is.null(end_side))) {
		turtle_backward(distance=unit_len * num_segs)
		molens <-  num_segs * c(2,1,1,1)
		angls <-   multiplier * 60 * c(2,1,1,2)

		holey_path(unit_len=unit_len,
							 lengths=molens[1:(end_side-1)],
							 angles=angls[1:(end_side-1)],
							 draw_line=FALSE,
							 has_hole=FALSE,
							 hole_color=NULL)

		turtle_forward(distance=unit_len * num_segs/2)
	}
	if (start_from=='corner') { 
		turtle_backward(distance=unit_len * num_segs / ifelse(end_side==1,1,2)) 
	}
}


#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
