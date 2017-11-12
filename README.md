

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

<img src="man/figures/para-maze-1.png" title="plot of chunk para-maze" alt="plot of chunk para-maze" width="700px" height="700px" />

The `parallelogram_maze` function admits a `balance` parameter which controls
how the maze should be recursively subdivided. A negative value creates
imbalanced mazes, while positive values create more uniform mazes. In the
example below we create seven mazes side by side with an increasing balance
parameter:


```r
library(TurtleGraphics)
library(mazealls)
turtle_init(2000, 2000)
turtle_hide()
turtle_up()
turtle_do({
    turtle_left(90)
    turtle_forward(930)
    turtle_right(90)
    valseq <- seq(from = -1.5, to = 1.5, length.out = 7)
    blines <- c(1, 2, 3, 4)
    bholes <- c(1, 3)
    set.seed(1234)
    for (iii in seq_along(valseq)) {
        parallelogram_maze(angle = 90, unit_len = 12, 
            width = 22, height = 130, method = "two_parallelograms", 
            draw_boundary = TRUE, balance = valseq[iii], 
            end_side = 3, boundary_lines = blines, 
            boundary_holes = bholes)
        turtle_right(180)
        blines <- c(2, 3, 4)
        bholes <- c(3)
    }
})
```

<img src="man/figures/para-imbalance-fade-1.png" title="plot of chunk para-imbalance-fade" alt="plot of chunk para-imbalance-fade" width="700px" height="700px" />

# triangle maze

An equilateral triangle maze can be constructed in a number of different ways:

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

<img src="man/figures/eq-tri-uniform-1.png" title="plot of chunk eq-tri-uniform" alt="plot of chunk eq-tri-uniform" width="700px" height="700px" />


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

<img src="man/figures/eq-tri-stack-1.png" title="plot of chunk eq-tri-stack" alt="plot of chunk eq-tri-stack" width="700px" height="700px" />


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

<img src="man/figures/eq-tri-four-tri-1.png" title="plot of chunk eq-tri-four-tri" alt="plot of chunk eq-tri-four-tri" width="700px" height="700px" />

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

<img src="man/figures/eq-tri-two-ears-1.png" title="plot of chunk eq-tri-two-ears" alt="plot of chunk eq-tri-two-ears" width="700px" height="700px" />


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

<img src="man/figures/eq-tri-hex-and-three-1.png" title="plot of chunk eq-tri-hex-and-three" alt="plot of chunk eq-tri-hex-and-three" width="700px" height="700px" />


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

<img src="man/figures/eq-tri-shave-1.png" title="plot of chunk eq-tri-shave" alt="plot of chunk eq-tri-shave" width="700px" height="700px" />



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

<img src="man/figures/eq-tri-shave-all-1.png" title="plot of chunk eq-tri-shave-all" alt="plot of chunk eq-tri-shave-all" width="700px" height="700px" />

# hexagon maze


An regular hexagonal maze can be constructed in a number of different ways:

1. Decompose the hexagon as 6 equilateral triangle mazes, with one solid line
	 and five lines with holes dividing them.
1. Create two isosceles trapezoid mazes with long sides joined by a line with a
	 hole.
1. Create three parallelogram mazes with one solid line and two lines with
	 holes dividing them.



```r
library(TurtleGraphics)
library(mazealls)
# two trapezoids
turtle_init(1000, 1000)
turtle_up()
turtle_hide()
turtle_do({
    turtle_left(90)
    turtle_forward(distance = 300)
    turtle_right(90)
    hexagon_maze(depth = 5, unit_len = 12, method = "two_trapezoids", 
        draw_boundary = TRUE)
})
```

<img src="man/figures/hex-trapezoids-1.png" title="plot of chunk hex-trapezoids" alt="plot of chunk hex-trapezoids" width="700px" height="700px" />


```r
library(TurtleGraphics)
library(mazealls)
# six triangles
turtle_init(1000, 1000)
turtle_up()
turtle_hide()
turtle_do({
    turtle_left(90)
    turtle_forward(distance = 300)
    turtle_right(90)
    hexagon_maze(depth = 5, unit_len = 12, method = "six_triangles", 
        draw_boundary = TRUE)
})
```

<img src="man/figures/hex-triangles-1.png" title="plot of chunk hex-triangles" alt="plot of chunk hex-triangles" width="700px" height="700px" />


```r
library(TurtleGraphics)
library(mazealls)
# six triangles
turtle_init(1000, 1000)
turtle_up()
turtle_hide()
turtle_do({
    turtle_left(90)
    turtle_forward(distance = 300)
    turtle_right(90)
    hexagon_maze(depth = 5, unit_len = 12, method = "three_parallelograms", 
        draw_boundary = TRUE)
})
```

<img src="man/figures/hex-parallelo-1.png" title="plot of chunk hex-parallelo" alt="plot of chunk hex-parallelo" width="700px" height="700px" />


# trapezoid maze


An isosceles trapezoid maze can be constructed in a number of different ways:

1. Decompose as four trapezoidal mazes with a 'bone' shape between them
	 consisting of two solid lines and three lines with holes.
1. Decompose as a parallelogram and an equilateral triangle with a line
	 with holes between them



```r
library(TurtleGraphics)
library(mazealls)
# four trapezoids
turtle_init(1000, 1000)
turtle_up()
turtle_hide()
turtle_do({
    turtle_left(90)
    turtle_forward(distance = 300)
    turtle_right(90)
    iso_trapezoid_maze(depth = 5, unit_len = 12, method = "four_trapezoids", 
        draw_boundary = TRUE)
})
```

<img src="man/figures/trap-four-1.png" title="plot of chunk trap-four" alt="plot of chunk trap-four" width="700px" height="700px" />


```r
library(TurtleGraphics)
library(mazealls)
# one ear
turtle_init(1000, 1000)
turtle_up()
turtle_hide()
turtle_do({
    turtle_left(90)
    turtle_forward(distance = 300)
    turtle_right(90)
    iso_trapezoid_maze(depth = 5, unit_len = 12, method = "one_ear", 
        draw_boundary = TRUE)
})
```

<img src="man/figures/trap-ear-1.png" title="plot of chunk trap-ear" alt="plot of chunk trap-ear" width="700px" height="700px" />

# Koch snowflake maze

Everyone's favorite snowflake can also be a maze. Simply fill in triangle bumps
with triangular mazes and create lines with holes as needed:


```r
library(TurtleGraphics)
library(mazealls)
# koch
turtle_init(1000, 1000)
turtle_up()
turtle_hide()
turtle_do({
    turtle_left(90)
    turtle_forward(distance = 200)
    turtle_right(90)
    turtle_backward(distance = 300)
    koch_maze(depth = 4, unit_len = 8)
})
```

<img src="man/figures/koch-flake-1.png" title="plot of chunk koch-flake" alt="plot of chunk koch-flake" width="700px" height="700px" />


# Controls

## unit length

The `unit_len` parameter controls the graphical length of one 'unit', which is
the length of holes between sections of the mazes, and is roughly the width
of the 'hallways' of a maze. Here is an example of using different
unit lengths in a stack of trapezoids


```r
library(TurtleGraphics)
library(mazealls)
# stack some trapezoids with different unit_len
turtle_init(2500, 2500)
turtle_up()
turtle_hide()
turtle_do({
    turtle_left(90)
    turtle_forward(distance = 800)
    turtle_right(90)
    clockwise <- TRUE
    for (iii in c(1:6)) {
        iso_trapezoid_maze(depth = 5, unit_len = 2^(6 - 
            iii), method = "four_trapezoids", draw_boundary = TRUE, 
            clockwise = clockwise, end_side = 3, start_from = "midpoint", 
            boundary_lines = c(1, 2, 4), boundary_holes = c(1))
        clockwise <- !clockwise
    }
})
```

<img src="man/figures/unit-len-stack-trap-1.png" title="plot of chunk unit-len-stack-trap" alt="plot of chunk unit-len-stack-trap" width="700px" height="700px" />

## boundaries

The parameters `draw_boundary`, `boundary_lines`, `boundary_holes`, `num_boundary_holes` and `boundary_hole_color` control
the drawing of the final outer boundary of polynomial mazes. Without a boundary
the maze can be used in recursive construction. Adding a boundary provides the
typical entry and exit points of a maze. The parameter `draw_boundary` is a
single Boolean that controls whether the boundary is drawn or not.
The parameter `boundary_lines` may be a scalar Boolean, or a numeric
array giving the indices of which sides should have drawn boundary lines.
The sides are numbered in the order in which they appear, and are
controlled by the `clockwise` parameter. The parameter `boundary_holes`
is a numeric array giving the indices of the boundary lines that should
have holes. If `NULL`, then we uniformly choose `num_boundary_holes` holes 
at random. Holes can be drawn as colored segments with the
`boundary_hole_color`, which is a character array giving the color of each
hole. The value 'clear' stands in for clear holes.


```r
library(TurtleGraphics)
library(mazealls)
# side by side
turtle_init(1000, 400)
turtle_up()
turtle_hide()
turtle_do({
    turtle_left(90)
    turtle_forward(distance = 450)
    turtle_right(90)
    
    parallelogram_maze(unit_len = 10, height = 25, 
        draw_boundary = FALSE, end_side = 3)
    
    turtle_left(90)
    turtle_forward(distance = 30)
    turtle_left(90)
    
    parallelogram_maze(unit_len = 10, height = 25, 
        draw_boundary = TRUE, boundary_lines = c(1, 
            3), boundary_holes = FALSE, end_side = 3)
    
    turtle_left(90)
    turtle_forward(distance = 30)
    turtle_left(90)
    
    parallelogram_maze(unit_len = 10, height = 25, 
        draw_boundary = TRUE, boundary_lines = c(2, 
            4), boundary_holes = c(2, 4), boundary_hole_color = c("ignore", 
            "green", "ignore", "blue"))
})
```

<img src="man/figures/boundary-stuff-1.png" title="plot of chunk boundary-stuff" alt="plot of chunk boundary-stuff" width="700px" height="700px" />

## end side

The `end_side` parameter controls which side of the maze the turtle ends on.
The default value of 1 essentially causes the turtle to end where it 
started. The sides are numbered in the order in which the boundary would be
drawn. Along with the boundary controls, the ending side can be useful to join together 
polygons into more complex mazes, as below:


```r
library(TurtleGraphics)
library(mazealls)
# triangle of hexes
turtle_init(2500, 2500)
turtle_up()
turtle_hide()
ul <- 22
dep <- 4
turtle_do({
    turtle_left(90)
    turtle_forward(distance = 1150)
    turtle_right(90)
    turtle_backward(distance = 650)
    hexagon_maze(unit_len = ul, depth = dep, end_side = 4, 
        draw_boundary = TRUE, boundary_holes = c(1, 
            3, 4))
    parallelogram_maze(unit_len = ul, height = 2^dep, 
        clockwise = FALSE, width = 3 * (2^dep), end_side = 3, 
        draw_boundary = TRUE, num_boundary_holes = 0, 
        boundary_lines = c(2, 4))
    hexagon_maze(unit_len = ul, depth = dep, end_side = 2, 
        draw_boundary = TRUE, boundary_holes = c(1, 
            2))
    parallelogram_maze(unit_len = ul, height = 2^dep, 
        clockwise = FALSE, width = 3 * (2^dep), end_side = 3, 
        draw_boundary = TRUE, num_boundary_holes = 0, 
        boundary_lines = c(2, 4))
    hexagon_maze(unit_len = ul, depth = dep, end_side = 2, 
        draw_boundary = TRUE, boundary_holes = c(1, 
            5))
    parallelogram_maze(unit_len = ul, height = 2^dep, 
        clockwise = FALSE, width = 3 * (2^dep), end_side = 3, 
        draw_boundary = TRUE, num_boundary_holes = 0, 
        boundary_lines = c(2, 4))
})
```

<img src="man/figures/tri-of-hex-1.png" title="plot of chunk tri-of-hex" alt="plot of chunk tri-of-hex" width="700px" height="700px" />


```r
library(TurtleGraphics)
library(mazealls)
# tiling!
tile_bit <- function(unit_len, depth, clockwise = TRUE, 
    draw_boundary = FALSE, boundary_holes = NULL) {
    turtle_col("black")
    parallelogram_maze(unit_len = unit_len, height = 2^depth, 
        clockwise = clockwise, draw_boundary = TRUE, 
        num_boundary_holes = 4)
    turtle_col("red")
    for (iii in c(1:4)) {
        turtle_forward(unit_len * 2^(depth - 1))
        turtle_right(90)
        turtle_forward(unit_len * 2^(depth - 1))
        eq_triangle_maze(unit_len = unit_len, depth = depth, 
            clockwise = !clockwise, draw_boundary = draw_boundary, 
            boundary_lines = ifelse(iii <= 2, 2, 3), 
            num_boundary_holes = 3, end_side = ifelse(iii == 
                4, 2, 1))
        if (iii == 2) {
            turtle_col("blue")
        }
    }
    turtle_col("black")
    if (draw_boundary) {
        blines <- c(1, 2, 4)
    } else {
        blines = 1
    }
    parallelogram_maze(unit_len = unit_len, height = 2^depth, 
        clockwise = clockwise, draw_boundary = TRUE, 
        boundary_lines = blines, boundary_holes = blines, 
        end_side = 3)
    turtle_forward(unit_len * 2^(depth - 1))
    turtle_left(60)
    turtle_forward(unit_len * 2^(depth - 1))
}

turtle_init(2500, 2500, mode = "clip")
turtle_up()
turtle_hide()

x0 <- 220
y0 <- 0
ul <- 20
dep <- 5
turtle_do({
    for (jjj in c(1:5)) {
        turtle_setpos(x = x0, y = y0)
        turtle_setangle(angle = 0)
        replicate(5, tile_bit(unit_len = ul, depth = dep, 
            draw_boundary = TRUE))
        x0 <- x0 + ul * (2^dep) * (1 + sqrt(3)/2)
        y0 <- y0 + ul * (2^(dep - 1))
    }
})
```

<img src="man/figures/tileit-1.png" title="plot of chunk tileit" alt="plot of chunk tileit" width="700px" height="700px" />
