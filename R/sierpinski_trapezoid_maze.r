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


#' @title sierpinski_trapezoid_maze .
#'
#' @description 
#' 
#' Recursively draw a Sierpinski isosceles trapezoid maze, 
#' with three sides consisting
#' of \eqn{2^{depth}} pieces of length \code{unit_len}, and one long
#' side of length \eqn{2^{depth+1}} pieces, starting from the
#' long side.
#'
#' @details
#'
#' Draws a maze in an isoscelese trapezoid with three sides of equal length
#' and one long side of twice that length, starting from the midpoint
#' of the long side (or the corner before the first side via the
#' \code{start_from} option). Differently colors the parts of the
#' maze for a Sierpinski effect.
#'
#' @seealso \code{\link{iso_trapezoid_maze}},
#' \code{\link{sierpinski_carpet_maze}},
#' \code{\link{sierpinski_maze}}.
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
#' @param depth the depth of recursion. This controls the
#' side length: three sides have \code{round(2^depth)} segments
#' of length \code{unit_len}, while the long side is twice as long.
#' \code{depth} need not be integral.
#'
#' @examples 
#'
#' require(TurtleGraphics)
#' turtle_init(1000,1000,mode='clip')
#' turtle_hide()
#' turtle_up()
#' turtle_do({
#'   turtle_setpos(500,500)
#'   turtle_setangle(0)
#' 	sierpinski_trapezoid_maze(unit_len=15,depth=5,color1='black',color2='green',
#' 														clockwise=TRUE,draw_boundary=TRUE,boundary_holes=c(1,3))
#' 	sierpinski_trapezoid_maze(unit_len=15,depth=5,color1='black',color2='green',
#' 														clockwise=FALSE,draw_boundary=TRUE,
#' 														boundary_lines=c(2,3,4),boundary_holes=3)
#' })
#' 
#'
#' @export
sierpinski_trapezoid_maze <- function(depth,unit_len=4L,clockwise=TRUE,start_from=c('midpoint','corner'),
																			color1='black',color2='gray40',
																			draw_boundary=FALSE,num_boundary_holes=2,boundary_lines=TRUE,
																			boundary_holes=NULL,boundary_hole_color=NULL,boundary_hole_locations=NULL,
																			end_side=1) {
	start_from <- match.arg(start_from)

	# check for off powers of two
	depth <- round(depth)
	num_segs <- round(2^depth)

	multiplier <- ifelse(clockwise,1,-1)

	if (start_from=='corner') { turtle_forward(distance=unit_len * num_segs) }

	#cat(str(list(dep=depth,
							 #num_segs=num_segs,
							 #holes=boundary_holes,
							 #holoc=boundary_hole_locations,
							 #bline=boundary_lines)))

	if (depth > 0) {

		# you have to pass these to the sub mazes ... 
		nsides <- 4
		holes <- .interpret_boundary_holes(boundary_holes,num_boundary_holes,nsides=nsides)
		boundary_lines <- .interpret_boundary_lines(boundary_lines,nsides=nsides)
		if (is.logical(boundary_lines) && length(boundary_lines) < 4) {
			boundary_lines <- rep(boundary_lines,4)
			boundary_lines <- boundary_lines[1:4]
		}
		if (is.null(boundary_hole_color)) { boundary_hole_color <- rep('clear',4) }
		if (is.null(boundary_hole_locations)) { 
			boundary_hole_locations <- sapply(num_segs * c(2,1,1,1),
																				function(x) { sample.int(x,size=1) })
		}
		#cat('picking: ',
				#str(list(holes=holes,
								 #holoc=boundary_hole_locations,
								 #bline=boundary_lines)))



		bhc <- rep('clear',4)
		bhc[1] <- boundary_hole_color[1]
		
		# recurse.
		bhole1 <- boundary_hole_locations[1] - (num_segs/2)
		# the inner hole is twice color2 btw:
		# if you want to be weird, sub in color2=color1. does not look as good tho
		sierpinski_trapezoid_maze(unit_len=unit_len,depth=depth-1,clockwise=clockwise,start_from='midpoint',
															color1=color2,color2=color2,
														 	draw_boundary=TRUE,
															num_boundary_holes=NULL,
															boundary_lines=c(boundary_lines[1],rep(FALSE,3)),
															boundary_holes=c(holes[1] & (bhole1 > 0) & (bhole1 <= num_segs),rep(FALSE,3)),
															boundary_hole_locations=c(max(0,bhole1),0,0,0),
															boundary_hole_color=bhc,
															end_side=1)

		# determine inner holes
		starts <- c(2,2,3,4,4)
		ends   <- c(3,1,1,1,3)
		which_holes <- .span_tree(starts,ends)

		inner_lines <- c(FALSE,TRUE,TRUE,FALSE,
										 FALSE,FALSE,TRUE,FALSE,
										 FALSE,FALSE,TRUE,TRUE)
		inner_holes <- rep(FALSE,length(inner_lines))
		inner_holes[which(inner_lines)[which_holes]] <- TRUE

		# have at it

		turtle_forward(num_segs * unit_len)
		.turn_right(multiplier * 120)

		blines <- inner_lines[1:4]
		blines[1] <- boundary_lines[2]
		blines[4] <- boundary_lines[1]
		bhole2 <- bhole1 - num_segs
		bholes <- inner_holes[1:4]
		bholes[1] <- holes[2] 
		bholes[4] <- holes[1] & (bhole2 > 0)
		bhc <- rep('clear',4)
		bhc[1] <- boundary_hole_color[2]
		bhc[4] <- boundary_hole_color[1]

		sierpinski_trapezoid_maze(unit_len=unit_len,depth=depth-1,clockwise=clockwise,start_from='corner',
															color1=color1,color2=color2,
														 	draw_boundary=TRUE,
															num_boundary_holes=NULL,
															boundary_lines=blines,
															boundary_holes=bholes,
															boundary_hole_locations=c(boundary_hole_locations[2],0,0,bhole2),
															boundary_hole_color=bhc,
															end_side=1)

		turtle_forward(num_segs * unit_len)
		.turn_right(multiplier * 60)

		blines <- inner_lines[5:8]
		blines[1] <- boundary_lines[3]
		bholes <- inner_holes[5:8]
		bholes[1] <- holes[3]
		bhc <- rep('clear',4)
		bhc[1] <- boundary_hole_color[3]
		sierpinski_trapezoid_maze(unit_len=unit_len,depth=depth-1,clockwise=clockwise,start_from='corner',
															color1=color1,color2=color2,
														 	draw_boundary=TRUE,
															num_boundary_holes=NULL,
															boundary_lines=blines,
															boundary_holes=bholes,
															boundary_hole_locations=c(boundary_hole_locations[3],0,0,0),
															boundary_hole_color=bhc,
															end_side=1)

		turtle_forward(num_segs * unit_len)
		.turn_right(multiplier * 60)

		blines <- inner_lines[9:12]
		blines[1] <- boundary_lines[4]
		blines[2] <- boundary_lines[1]
		bholes <- inner_holes[9:12]
		bholes[1] <- holes[4]
		bholes[2] <- holes[1] & (boundary_hole_locations[1] <= (num_segs/2))
		bhc <- rep('clear',4)
		bhc[1] <- boundary_hole_color[4]
		bhc[2] <- boundary_hole_color[1]
		sierpinski_trapezoid_maze(unit_len=unit_len,depth=depth-1,clockwise=clockwise,start_from='corner',
															color1=color1,color2=color2,
														 	draw_boundary=TRUE,
															num_boundary_holes=NULL,
															boundary_lines=blines,
															boundary_holes=bholes,
															boundary_hole_locations=c(boundary_hole_locations[4],boundary_hole_locations[1],0,0),
															boundary_hole_color=bhc,
															end_side=1)

		turtle_forward(num_segs * unit_len)
		.turn_right(multiplier * 120)
		turtle_forward(num_segs * unit_len)
	} else {
		if (draw_boundary) {
			turtle_backward(distance=unit_len * num_segs)
			turtle_col(color1)

			.do_boundary(unit_len,lengths=num_segs * c(2,1,1,1),angles=multiplier * 60 * c(2,1,1,2),
									 num_boundary_holes=num_boundary_holes,boundary_lines=boundary_lines,
									 boundary_holes=boundary_holes,boundary_hole_color=boundary_hole_color,
									 boundary_hole_locations=boundary_hole_locations)

			turtle_forward(distance=unit_len * num_segs)
		}
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

#require(TurtleGraphics)
#turtle_init(3000,3000,mode='clip')
#turtle_hide()
#turtle_up()
#ul <- 8
#dep <- 7
#turtle_do({
  #turtle_setpos(1500,1500)
  #turtle_setangle(0)
	#sierpinski_trapezoid_maze(unit_len=ul,depth=dep,color1='black',color2='green',
														#clockwise=TRUE,draw_boundary=TRUE,boundary_holes=c(1,3))
	#sierpinski_trapezoid_maze(unit_len=ul,depth=dep,color1='black',color2='green',
														#clockwise=FALSE,draw_boundary=TRUE,
														#boundary_lines=c(2,3,4),boundary_holes=3)
#})
##dev.copy(png,height=8,width=8,units='in',res=300,'siertrap.png')
##dev.off()


#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
