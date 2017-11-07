

# mazealls

[![Build Status](https://travis-ci.org/shabbychef/mazealls.png)](https://travis-ci.org/shabbychef/mazealls)
[![codecov.io](http://codecov.io/github/shabbychef/mazealls/coverage.svg?branch=master)](http://codecov.io/github/shabbychef/mazealls?branch=master)
[![CRAN](http://www.r-pkg.org/badges/version/mazealls)](https://cran.r-project.org/package=mazealls)

> *Sometimes magic is just someone spending more time on something than anyone else might reasonably expect.* -- Teller
	

Generate mazes recursively via Turtle graphics. 

-- Steven E. Pav, shabbychef@gmail.com

## Installation

This package can be installed 
via [drat](https://github.com/eddelbuettel/drat "drat"), or
from github:


```r
# via drat:
if (require(drat)) {
    drat:::add("shabbychef")
    install.packages("mazealls")
}
# get snapshot from github (may be buggy)
if (require(devtools)) {
    install_github("shabbychef/mazealls")
}
```

# parallelogram maze

The simplest maze to generate recursively is a parallelogram. One can generate
a parallelogram maze by splitting the domain into two parts by an arbitrary
cut line with a hole in it, and then recursively creating mazes on both parts. 
Unlike some shapes, this method applies for arbitrary (integral) side lengths,
where by 'length' we mean in units of 'hallway widths', what we call the
`unit_len` in the API. Here is a simple parallelogram maze:


```r
library(TurtleGraphics)
library(mazealls)
turtle_init(1000, 1000)
turtle_up()
turtle_hide()
turtle_do({
    turtle_left(90)
    turtle_forward(distance = 400)
    turtle_right(90)
    parallelogram_maze(angle = 90, unit_len = 10, width = 75, 
        height = 55, method = "uniform", draw_boundary = TRUE)
})
```

<img src="man/figures/para_maze-1.png" title="plot of chunk para_maze" alt="plot of chunk para_maze" width="800px" height="600px" />

# triangle maze

An equilateral triangle maze can be computed in a number of different ways:

1. Create four equilateral mazes with lines with holes between them. This
only works if the side length of the original is a power of two.
1. Cut out a parallelogram and attach two equilateral triangles.
Again only if the side length is a power of two.
1. Create an isosceles trapezoid maze, then stack an equilateral triangle
on top of it. This only works if the side length is even.
1. Create a regular hexagonal maze and three equilateral mazes in the corners.
This only works if the side length of the original triangle is divisible by
three.
1. Shave off a single hallway and create an equilateral triangular maze
of side length one less than the original.


I illustrate them here:


```r
library(TurtleGraphics)
library(mazealls)
# uniform method
turtle_init(1000, 1000)
turtle_up()
turtle_hide()
turtle_do({
    turtle_left(90)
    turtle_forward(distance = 300)
    turtle_right(90)
    eq_triangle_maze(depth = 6, unit_len = 12, method = "uniform", 
        draw_boundary = TRUE)
})
```

<img src="man/figures/eq_tri_uniform-1.png" title="plot of chunk eq_tri_uniform" alt="plot of chunk eq_tri_uniform" width="800px" height="600px" />


```r
library(TurtleGraphics)
library(mazealls)
# stacked trapezoids
turtle_init(1000, 1000)
turtle_up()
turtle_hide()
turtle_do({
    turtle_left(90)
    turtle_forward(distance = 300)
    turtle_right(90)
    eq_triangle_maze(depth = 6, unit_len = 12, method = "stack_trapezoids", 
        draw_boundary = TRUE)
})
```

<img src="man/figures/eq_tri_stack-1.png" title="plot of chunk eq_tri_stack" alt="plot of chunk eq_tri_stack" width="800px" height="600px" />


```r
library(TurtleGraphics)
library(mazealls)
# four triangles
turtle_init(1000, 1000)
turtle_up()
turtle_hide()
turtle_do({
    turtle_left(90)
    turtle_forward(distance = 300)
    turtle_right(90)
    eq_triangle_maze(depth = 6, unit_len = 12, method = "triangles", 
        draw_boundary = TRUE)
})
```

<img src="man/figures/eq_tri_four_tri-1.png" title="plot of chunk eq_tri_four_tri" alt="plot of chunk eq_tri_four_tri" width="800px" height="600px" />

```r
library(TurtleGraphics)
library(mazealls)
# two ears
turtle_init(1000, 1000)
turtle_up()
turtle_hide()
turtle_do({
    turtle_left(90)
    turtle_forward(distance = 300)
    turtle_right(90)
    eq_triangle_maze(depth = 6, unit_len = 12, method = "two_ears", 
        draw_boundary = TRUE)
})
```

<img src="man/figures/eq_tri_two_ears-1.png" title="plot of chunk eq_tri_two_ears" alt="plot of chunk eq_tri_two_ears" width="800px" height="600px" />


```r
library(TurtleGraphics)
library(mazealls)
# hex and three
turtle_init(1000, 1000)
turtle_up()
turtle_hide()
turtle_do({
    turtle_left(90)
    turtle_forward(distance = 300)
    turtle_right(90)
    eq_triangle_maze(depth = log2(66), unit_len = 12, 
        method = "hex_and_three", draw_boundary = TRUE)
})
```

<img src="man/figures/eq_tri_hex_and_three-1.png" title="plot of chunk eq_tri_hex_and_three" alt="plot of chunk eq_tri_hex_and_three" width="800px" height="600px" />


```r
library(TurtleGraphics)
library(mazealls)
# shave
turtle_init(1000, 1000)
turtle_up()
turtle_hide()
turtle_do({
    turtle_left(90)
    turtle_forward(distance = 300)
    turtle_right(90)
    eq_triangle_maze(depth = log2(66), unit_len = 12, 
        method = "shave", draw_boundary = TRUE)
})
```

<img src="man/figures/eq_tri_shave-1.png" title="plot of chunk eq_tri_shave" alt="plot of chunk eq_tri_shave" width="800px" height="600px" />



```r
library(TurtleGraphics)
library(mazealls)
# shave all
turtle_init(1000, 1000)
turtle_up()
turtle_hide()
turtle_do({
    turtle_left(90)
    turtle_forward(distance = 300)
    turtle_right(90)
    eq_triangle_maze(depth = log2(66), unit_len = 12, 
        method = "shave_all", draw_boundary = TRUE)
})
```

<img src="man/figures/eq_tri_shave_all-1.png" title="plot of chunk eq_tri_shave_all" alt="plot of chunk eq_tri_shave_all" width="800px" height="600px" />

