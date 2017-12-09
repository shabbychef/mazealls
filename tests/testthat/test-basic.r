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
	# travis only?
	#skip_on_cran()
	set.char.seed("569dd47d-f9e5-40e4-b2ac-e5dbb4771a53")

	library(TurtleGraphics)
	library(mazealls)
	turtle_init(2000,2000,mode='clip')
	turtle_up()
	turtle_hide()

	turtle_do({
		turtle_left(90)
		turtle_forward(distance=400)
		turtle_right(90)
		parallelogram_maze(angle=90,unit_len=10,width=25,height=25,method='uniform',
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
			parallelogram_maze(angle=90,unit_len=12,width=22,height=20,method='two_parallelograms',draw_boundary=TRUE,balance=valseq[iii],
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
		eq_triangle_maze(depth=4,unit_len=12,method='uniform',draw_boundary=TRUE)
	})

	# stacked trapezoids
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=300)
		turtle_right(90)
		eq_triangle_maze(depth=4,unit_len=12,method='stack_trapezoids',draw_boundary=TRUE)
	})

	# four triangles
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=300)
		turtle_right(90)
		eq_triangle_maze(depth=4,unit_len=12,method='triangles',draw_boundary=TRUE)
	})

	# two ears
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=300)
		turtle_right(90)
		eq_triangle_maze(depth=4,unit_len=12,method='two_ears',draw_boundary=TRUE)
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
		hexagon_maze(depth=4,unit_len=12,method='two_trapezoids',draw_boundary=TRUE)
	})
	# six triangles
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=300)
		turtle_right(90)
		hexagon_maze(depth=4,unit_len=12,method='six_triangles',draw_boundary=TRUE)
	})
	# six triangles
	turtle_init(1000,1000)
	turtle_up()
	turtle_hide()
	turtle_do({
		turtle_left(90)
		turtle_forward(distance=300)
		turtle_right(90)
		hexagon_maze(depth=4,unit_len=12,method='three_parallelograms',draw_boundary=TRUE)
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
		iso_trapezoid_maze(depth=4,unit_len=12,method='one_ear',draw_boundary=TRUE)
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

	# dodecagon
	turtle_init(2200,2200,mode='clip')
	turtle_hide()
	turtle_up()
	turtle_do({
		turtle_setpos(60,1100)
		turtle_setangle(0)
		 dodecagon_maze(depth=log2(14),unit_len=10,draw_boundary=TRUE,boundary_holes=c(1,7))
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

		parallelogram_maze(unit_len=10,height=15,draw_boundary=FALSE,end_side=3)

		turtle_left(90)
		turtle_forward(distance=30)
		turtle_left(90)

		parallelogram_maze(unit_len=10,height=15,draw_boundary=TRUE,boundary_lines=c(1,3),boundary_holes=FALSE,end_side=3)

		turtle_left(90)
		turtle_forward(distance=30)
		turtle_left(90)

		parallelogram_maze(unit_len=10,height=15,draw_boundary=TRUE,boundary_lines=c(2,4),boundary_holes=c(2,4),boundary_hole_color=c('ignore','green','ignore','blue'))
	})

	# sentinel
	expect_true(TRUE)
})#UNFOLD
test_that("2ngons",{#FOLDUP
	# travis only?
	skip_on_cran()
	set.char.seed("af46af42-adb8-4e0e-8aee-4aec6bda56d5")

	library(TurtleGraphics)
	library(mazealls)
	turtle_init(2500,2500,mode='clip')
	turtle_up()
	turtle_hide()

	turtle_do({
		turtle_setpos(1250,1250)
		turtle_setangle(0)
		for (clockwise in c(TRUE,FALSE)) {
			octagon_maze(unit_len=10,log2(48),clockwise=clockwise,draw_boundary=TRUE,boundary_holes=c(1,5))
			decagon_maze(5,21,clockwise=clockwise,draw_boundary=TRUE,boundary_holes=c(1,6))
			dodecagon_maze(depth=log2(14),unit_len=10,clockwise=clockwise,draw_boundary=TRUE,boundary_holes=c(1,7))
		}
	})

	# sentinel
	expect_true(TRUE)
})#UNFOLD
test_that("sierpinskis",{#FOLDUP
	# travis only?
	skip_on_cran()
	set.char.seed("56576014-8cc4-45ba-a839-f1ae6754662d")

	library(TurtleGraphics)
	library(mazealls)
	turtle_init(2500,2500,mode='clip')
	turtle_up()
	turtle_hide()

	turtle_do({
		turtle_setpos(1250,1250)
		turtle_setangle(0)
		for (clockwise in c(TRUE,FALSE)) {
			sierpinski_maze(unit_len=5,depth=3,clockwise=clockwise,draw_boundary=TRUE)
			sierpinski_maze(unit_len=5,depth=3,clockwise=clockwise,style='hexaflake',draw_boundary=TRUE)
			sierpinski_maze(unit_len=5,depth=3,clockwise=clockwise,style='dragon_left',draw_boundary=TRUE)
		}
	})

	# sentinel
	expect_true(TRUE)
})#UNFOLD
test_that("fractallys",{#FOLDUP
	# travis only?
	skip_on_cran()
	set.char.seed("987dac1c-ae54-489a-80fb-c80380d246d9")

	library(TurtleGraphics)
	library(mazealls)
	turtle_init(2500,2500,mode='clip')
	turtle_up()
	turtle_hide()

	turtle_do({
		turtle_setpos(1250,1250)
		turtle_setangle(0)
		clockwise <- TRUE
		sierpinski_trapezoid_maze(unit_len=5,depth=3,clockwise=clockwise,draw_boundary=TRUE,flip_color_parts=1)
		sierpinski_trapezoid_maze(unit_len=5,depth=3,clockwise=clockwise,draw_boundary=TRUE,flip_color_parts=2)
		sierpinski_trapezoid_maze(unit_len=5,depth=3,clockwise=clockwise,draw_boundary=TRUE,flip_color_parts=3)
		sierpinski_trapezoid_maze(unit_len=5,depth=3,clockwise=clockwise,draw_boundary=TRUE,flip_color_parts=4)
    hexaflake_maze(depth=3,unit_len=10,draw_boundary=TRUE,color2='green')
	})

	# sentinel
	expect_true(TRUE)
})#UNFOLD
test_that("hit etcs ",{#FOLDUP
	# travis only?
	skip_on_cran()
	set.char.seed("f8d2e53f-aae2-4595-bfcd-8f24da9aa7dd")

	library(TurtleGraphics)
	library(mazealls)
	turtle_init(2500,2500,mode='clip')
	turtle_up()
	turtle_hide()

	turtle_do({
		turtle_setpos(1250,1250)
		turtle_setangle(0)
		for (clockwise in c(TRUE,FALSE)) {
			for (angl in c(45,90,135)) {
				parallelogram_maze(angle=angl,unit_len=10,width=25,height=25,
													 clockwise=clockwise,draw_boundary=TRUE)
				sierpinski_carpet_maze(angle=angl,unit_len=10,width=27,height=27,
															 clockwise=clockwise,draw_boundary=TRUE)
			}
		}
	})

	# sentinel
	expect_true(TRUE)
})#UNFOLD
test_that("test arrows ",{#FOLDUP
	# travis only?
	skip_on_cran()
	set.char.seed("d79492e7-6b4d-416e-8b98-b3bb58fdcc1d")

	library(TurtleGraphics)
	library(mazealls)
	turtle_init(250,250,mode='clip')
	turtle_up()
	turtle_hide()

	turtle_do({
		turtle_setpos(125,125)
		turtle_setangle(0)
		parallelogram_maze(unit_len=10,width=25,height=25,
											 clockwise=TRUE,draw_boundary=TRUE,boundary_hole_arrows=TRUE)
	})

	# sentinel
	expect_true(TRUE)
})#UNFOLD
# 2FIX: check the effects of NA
#UNFOLD

#for vim modeline: (do not edit)
# vim:ts=2:sw=2:tw=79:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r:ai:si:cin:nu:fo=croql:cino=p0t0c5(0:
