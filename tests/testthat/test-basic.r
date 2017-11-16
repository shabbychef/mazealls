# Copyright 2016 Steven E. Pav. All Rights Reserved.
# Author: Steven E. Pav

# This file is part of fromo.
#
# fromo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# fromo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with fromo.  If not, see <http://www.gnu.org/licenses/>.

# env var:
# nb: 
# see also:
# todo:
# changelog: 
#
# Created: 2016.03.25
# Copyright: Steven E. Pav, 2016-2016
# Author: Steven E. Pav
# Comments: Steven E. Pav

# helpers#FOLDUP
set.char.seed <- function(str) {
	set.seed(as.integer(charToRaw(str)))
}
#UNFOLD

context("code runs at all")#FOLDUP
test_that("README code",{#FOLDUP
	set.char.seed("569dd47d-f9e5-40e4-b2ac-e5dbb4771a53")

	library(TurtleGraphics)
	library(mazealls)
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=400)
		turtle_right(90)
		parallelogram_maze(angle=90,unit_len=10,width=75,height=55,method='uniform',
		 draw_boundary=TRUE)
	})

	turtle_init(2000,2000)
	turtle_hide()
	turtle_up()
	turtle_do({
	turtle_left(90)
	turtle_forward(930)
	turtle_right(90)
	valseq <- seq(from=-1.5,to=1.5,length.out=7)
	blines <- c(1,2,3,4)
	bholes <- c(1,3)
	set.seed(1234)
	for (iii in seq_along(valseq)) {
		parallelogram_maze(angle=90,unit_len=12,width=22,height=130,method='two_parallelograms',draw_boundary=TRUE,balance=valseq[iii],
											 end_side=3,boundary_lines=blines,boundary_holes=bholes)
		turtle_right(180)
		blines <- c(2,3,4)
		bholes <- c(3)
	}
	})

	# triangle
	# uniform method
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=300)
		turtle_right(90)
		eq_triangle_maze(depth=6,unit_len=12,method='uniform',draw_boundary=TRUE)
	})

	# stacked trapezoids
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=300)
		turtle_right(90)
		eq_triangle_maze(depth=6,unit_len=12,method='stack_trapezoids',draw_boundary=TRUE)
	})

	# four triangles
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=300)
		turtle_right(90)
		eq_triangle_maze(depth=6,unit_len=12,method='triangles',draw_boundary=TRUE)
	})

	# two ears
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=300)
		turtle_right(90)
		eq_triangle_maze(depth=6,unit_len=12,method='two_ears',draw_boundary=TRUE)
	})

	# hex and three
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=300)
		turtle_right(90)
		eq_triangle_maze(depth=log2(66),unit_len=12,method='hex_and_three',draw_boundary=TRUE)
	})

	# shave 
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=300)
		turtle_right(90)
		eq_triangle_maze(depth=log2(66),unit_len=12,method='shave',draw_boundary=TRUE)
	})

	# shave all
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=300)
		turtle_right(90)
		eq_triangle_maze(depth=log2(66),unit_len=12,method='shave_all',draw_boundary=TRUE)
	})

	# hexagon maze
	
	# two trapezoids
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=300)
		turtle_right(90)
		hexagon_maze(depth=5,unit_len=12,method='two_trapezoids',draw_boundary=TRUE)
	})
	# six triangles
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=300)
		turtle_right(90)
		hexagon_maze(depth=5,unit_len=12,method='six_triangles',draw_boundary=TRUE)
	})
	# six triangles
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=300)
		turtle_right(90)
		hexagon_maze(depth=5,unit_len=12,method='three_parallelograms',draw_boundary=TRUE)
	})

	# trapezoid maze

	# four trapezoids
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=300)
		turtle_right(90)
		iso_trapezoid_maze(depth=5,unit_len=12,method='four_trapezoids',draw_boundary=TRUE)
	})
	# one ear
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=300)
		turtle_right(90)
		iso_trapezoid_maze(depth=5,unit_len=12,method='one_ear',draw_boundary=TRUE)
	})

	# Rhombic Dissections

	# octagon
	turtle_init(2000,2000,mode='clip')
	turtle_hide()
	turtle_up()
	turtle_do({
		turtle_setpos(75,1000)
		turtle_setangle(0)
		octagon_maze(log2(48),16,draw_boundary=TRUE,boundary_holes=c(1,5))
	})
	# decagon
	turtle_init(2200,2200,mode='clip')
	turtle_hide()
	turtle_up()
	turtle_do({
		turtle_setpos(60,1100)
		turtle_setangle(0)
		decagon_maze(5,21,draw_boundary=TRUE,boundary_holes=c(1,6))
	})


	# Koch snowflake maze

	# koch
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=200)
		turtle_right(90)
		turtle_backward(distance=300)
		koch_maze(depth=4,unit_len=8)
	})
	# Controls

	## unit length

	# stack some trapezoids with different unit_len
	turtle_init(2500,2500)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=800)
		turtle_right(90)
		clockwise <- TRUE
		for (iii in c(1:6)) {
			iso_trapezoid_maze(depth=5,unit_len=2^(6-iii),method='four_trapezoids',draw_boundary=TRUE,clockwise=clockwise,end_side=3,start_from='midpoint',
				boundary_lines=c(1,2,4),boundary_holes=c(1))
			clockwise <- !clockwise
		}
	})
	# side by side
	turtle_init(1000,400)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=450)
		turtle_right(90)

		parallelogram_maze(unit_len=10,height=25,draw_boundary=FALSE,end_side=3)

		turtle_left(90)
		turtle_forward(distance=30)
		turtle_left(90)

		parallelogram_maze(unit_len=10,height=25,draw_boundary=TRUE,boundary_lines=c(1,3),boundary_holes=FALSE,end_side=3)

		turtle_left(90)
		turtle_forward(distance=30)
		turtle_left(90)

		parallelogram_maze(unit_len=10,height=25,draw_boundary=TRUE,boundary_lines=c(2,4),boundary_holes=c(2,4),boundary_hole_color=c('ignore','green','ignore','blue'))
	})

	## end side

	# triangle of hexes
	turtle_init(2500,2500)
	turtle_up()
	turtle_hide()
	ul <- 22
	dep <- 4
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=1150)
		turtle_right(90)
		turtle_backward(distance=650)
		hexagon_maze(unit_len=ul,depth=dep,end_side=4,draw_boundary=TRUE,boundary_holes=c(1,3,4))
		parallelogram_maze(unit_len=ul,height=2^dep,clockwise=FALSE,width=3*(2^dep),end_side=3,
			draw_boundary=TRUE,num_boundary_holes=0,boundary_lines=c(2,4))
		hexagon_maze(unit_len=ul,depth=dep,end_side=2,draw_boundary=TRUE,boundary_holes=c(1,2))
		parallelogram_maze(unit_len=ul,height=2^dep,clockwise=FALSE,width=3*(2^dep),end_side=3,
			draw_boundary=TRUE,num_boundary_holes=0,boundary_lines=c(2,4))
		hexagon_maze(unit_len=ul,depth=dep,end_side=2,draw_boundary=TRUE,boundary_holes=c(1,5))
		parallelogram_maze(unit_len=ul,height=2^dep,clockwise=FALSE,width=3*(2^dep),end_side=3,
			draw_boundary=TRUE,num_boundary_holes=0,boundary_lines=c(2,4))
	})
	# tiling!
	tile_bit <- function(unit_len,depth,clockwise=TRUE,draw_boundary=FALSE,boundary_holes=NULL) {
		turtle_col('black')
		parallelogram_maze(unit_len=unit_len,height=2^depth,clockwise=clockwise,draw_boundary=TRUE,num_boundary_holes=4)
		turtle_col('red')
		for (iii in c(1:4)) {
			turtle_forward(unit_len * 2^(depth-1))
			turtle_right(90)
			turtle_forward(unit_len * 2^(depth-1))
			eq_triangle_maze(unit_len=unit_len,depth=depth,clockwise=!clockwise,draw_boundary=draw_boundary,
				boundary_lines=ifelse(iii <= 2,2,3),num_boundary_holes=3,end_side=ifelse(iii==4,2,1))
			if (iii==2) { turtle_col('blue') }
		}
		turtle_col('black')
		if (draw_boundary) { blines <- c(1,2,4) } else { blines = 1 }
		parallelogram_maze(unit_len=unit_len,height=2^depth,clockwise=clockwise,draw_boundary=TRUE,
			boundary_lines=blines,boundary_holes=blines,end_side=3)
		turtle_forward(unit_len * 2^(depth-1))
		turtle_left(60)
		turtle_forward(unit_len * 2^(depth-1))
	}

	turtle_init(2500,2500,mode='clip')
	turtle_up()
	turtle_hide()

	x0 <- 220
	y0 <- 0
	ul <- 20
	dep <- 5
	turtle_do({
		for (jjj in c(1:5)) {
			turtle_setpos(x=x0,y=y0)
			turtle_setangle(angle=0)
			replicate(5,tile_bit(unit_len=ul,depth=dep,draw_boundary=TRUE))
			x0 <- x0 + ul * (2^dep) * (1 + sqrt(3)/2)
			y0 <- y0 + ul * (2^(dep-1))
		}
	})

	# Fun

	## A dumb looking tree

	treeit <- function(unit_len,depth,height,left_shrink=3/4,right_shrink=1/3) {
		height <- ceiling(height)
		parallelogram_maze(unit_len=unit_len,height=2^depth,width=height,clockwise=TRUE,
											 draw_boundary=TRUE,boundary_lines=c(1,2,4),
											 start_from='midpoint',
											 boundary_holes=c(1),end_side=3)
		if (depth > 0) {
			iso_trapezoid_maze(depth=depth-1,unit_len=unit_len,
												 clockwise=FALSE,
												 draw_boundary=TRUE,boundary_lines=c(1,3),
												 start_from='midpoint',
												 boundary_holes=c(1),end_side=4)
			treeit(unit_len=unit_len,depth=depth-1,height=left_shrink*height,left_shrink=left_shrink,right_shrink=right_shrink)
			turtle_right(180)
			turtle_forward(unit_len * 2^(depth-2))
			turtle_right(60)
			turtle_forward(unit_len * 2^(depth-1))
			turtle_right(60)
			turtle_forward(unit_len * 2^(depth-2))
			turtle_right(180)
			treeit(unit_len=unit_len,depth=depth-1,height=right_shrink*height,left_shrink=left_shrink,right_shrink=right_shrink)
			turtle_forward(unit_len * 2^(depth-2))
			turtle_left(60)
			turtle_forward(unit_len * 2^(depth-2))
			turtle_left(90)
			turtle_forward(unit_len * sqrt(3) * 2^(depth-2))
			turtle_left(90)
		}
		turtle_right(90)
		turtle_forward(unit_len*height)
		turtle_right(90)
	}

	turtle_init(2500,2500,mode='clip')
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_setpos(1600,20)
		turtle_setangle(270)
		treeit(unit_len=13,depth=5,height=70,left_shrink=2/3,right_shrink=1/3)
	})

	# sentinel
	expect_true(TRUE)
})#UNFOLD
# 2FIX: check the effects of NA
#UNFOLD

#for vim modeline: (do not edit)
# vim:ts=2:sw=2:tw=79:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r:ai:si:cin:nu:fo=croql:cino=p0t0c5(0:
