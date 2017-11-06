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

# Created: 2017.11.05
# Copyright: Steven E. Pav, 2017
# Author: Steven E. Pav <shabbychef@gmail.com>
# Comments: Steven E. Pav

.koch_side <- function(unit_len,depth,clockwise=TRUE,has_hole=FALSE,hole_color=NULL) {
	multiplier <- ifelse(clockwise,1,-1)
	num_segs <- round(3^depth)
	if (has_hole) { bholes <- sample.int(4,1) } else { bholes = 0 }
	if (depth > 0) {
		.koch_side(unit_len,depth-1,clockwise=clockwise,has_hole=bholes==1,hole_color=hole_color)

		eq_triangle_maze(unit_len,depth=log2(num_segs),clockwise=!clockwise,start_from='corner',
										 draw_boundary=TRUE,num_boundary_holes=NULL,boundary_lines=c(1),
										 boundary_holes=1)

		.turn_left(multiplier * 60)
		.koch_side(unit_len,depth-1,clockwise=clockwise,has_hole=bholes==2,hole_color=hole_color)
		.turn_right(multiplier * 120)
		.koch_side(unit_len,depth-1,clockwise=clockwise,has_hole=bholes==3,hole_color=hole_color)
		.turn_left(multiplier * 60)
		.koch_side(unit_len,depth-1,clockwise=clockwise,has_hole=bholes==4,hole_color=hole_color)
	} else {
		holey_path(unit_len=unit_len,
							 lengths=rep(1,4),
							 angles=multiplier * c(-60,120,-60,0),
							 draw_line=TRUE,
							 has_hole=c(1:4) %in% bholes,
							 hole_color=hole_color)
	}
}

turtle_init(2000,2000)
turtle_hide() 
turtle_up()
set.seed(1234)
turtle_do({
	turtle_backward(distance=400)
	turtle_left(90)
	turtle_forward(650)
	turtle_right(90)
	turtle_right(30)
	for (iii in c(1:3)) {
		.koch_side(unit_len=15,3,has_hole=(iii != 3),hole_color='green')
		turtle_right(120)
	}
	eq_triangle_maze(unit_len=15,depth=log2(3^4),start_from='corner',clockwise=TRUE)
})
#dev.copy(png,'koch.png')
#dev.off()

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
