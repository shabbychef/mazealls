% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sierpinski_trapezoid_maze.r
\name{sierpinski_trapezoid_maze}
\alias{sierpinski_trapezoid_maze}
\title{sierpinski_trapezoid_maze .}
\usage{
sierpinski_trapezoid_maze(depth, unit_len = 4L, clockwise = TRUE,
  start_from = c("midpoint", "corner"), color1 = "black",
  color2 = "gray40", flip_color_parts = 1, draw_boundary = FALSE,
  num_boundary_holes = 2, boundary_lines = TRUE, boundary_holes = NULL,
  boundary_hole_color = NULL, boundary_hole_locations = NULL,
  boundary_hole_arrows = FALSE, end_side = 1)
}
\arguments{
\item{depth}{the depth of recursion. This controls the
side length: three sides have \code{round(2^depth)} segments
of length \code{unit_len}, while the long side is twice as long.
\code{depth} need not be integral.}

\item{unit_len}{the unit length in graph coordinates. This controls
the width of the \sQuote{holes} in the boundary lines and
generally controls the spacing of mazes.}

\item{clockwise}{whether to draw clockwise.}

\item{start_from}{whether to start from the midpoint of the first side
of a maze, or from the corner facing the first side.}

\item{color1}{The dominant color of the maze.}

\item{color2}{The negative color of the maze.}

\item{flip_color_parts}{a numerical array which can contain values 1
through 4. Those parts of the maze, when drawn recursively, have 
their colors flipped. A value of \code{3} corresponds to a traditional
Sierpinski triangle, while \code{1} corresponds to a Hexaflake.
Values of \code{2} or \code{4} look more like dragon mazes.}

\item{draw_boundary}{a boolean indicating whether a final boundary shall be
drawn around the maze.}

\item{num_boundary_holes}{the number of boundary sides which should be
randomly selected to have holes. Note that the \code{boundary_holes}
parameter takes precedence.}

\item{boundary_lines}{indicates which of the sides of the maze
shall have drawn boundary lines. Can be a logical array indicating
which sides shall have lines, or a numeric array, giving the
index of sides that shall have lines.}

\item{boundary_holes}{an array indicating which of the boundary lines
have holes. If \code{NULL}, then boundary holes are randomly selected
by the \code{num_boundary_holes} parameter. If numeric, indicates
which sides of the maze shall have holes. If a boolean array, indicates
which of the sides shall have holes. These forms are recycled
if needed. See \code{\link{holey_path}}. Note that if no line
is drawn, no hole can be drawn either.}

\item{boundary_hole_color}{the color of boundary holes. A value of
\code{NULL} indicates no colored holes. See \code{\link{holey_path}}
for more details. Can be an array of colors, or colors and the 
value \code{'clear'}, which stands in for \code{NULL} to
indicate no filled hole to be drawn.}

\item{boundary_hole_locations}{the \sQuote{locations} of the boundary holes
within each boundary segment.
A value of \code{NULL} indicates the code may randomly choose, as is
the default.
May be a numeric array. A positive value up to the side length is
interpreted as the location to place the boundary hole.
A negative value is interpreted as counting down from the side
length plus 1. A value of zero corresponds to allowing the 
code to pick the location within a segment.
A value of \code{NA} may cause an error.}

\item{boundary_hole_arrows}{a boolean or boolean array indicating whether to draw
perpendicular double arrows at the boundary holes, as a visual guide. These
can be useful for locating the entry and exit points of a maze.}

\item{end_side}{the number of the side to end on. A value of
1 corresponds to the starting side, while higher numbers
correspond to the drawn side of the figure in the canonical order
(that is, the order induced by the \code{clockwise} parameter).}
}
\value{
nothing; the function is called for side effects only, though in
the future this might return information about the drawn boundary of
the shape.
}
\description{
Recursively draw a Sierpinski isosceles trapezoid maze, 
with three sides consisting
of \eqn{2^{depth}} pieces of length \code{unit_len}, and one long
side of length \eqn{2^{depth+1}} pieces, starting from the
long side.
}
\details{
Draws a maze in an isoscelese trapezoid with three sides of equal length
and one long side of twice that length, starting from the midpoint
of the long side (or the corner before the first side via the
\code{start_from} option). Differently colors the parts of the
maze for a Sierpinski effect.

Here are mazes for different values of \code{flip_color_parts} ranging
from 1 to 4:

\if{html}{
\figure{sierpinski-trapezoids-1.png}{options: width="100\%" alt="Figure: four kinds of Sierpinski trapezoids"}
}
\if{latex}{
\figure{sierpinski-trapezoids-1.png}{options: width=7cm}
}
}
\examples{

require(TurtleGraphics)
turtle_init(1000,1000,mode='clip')
turtle_hide()
turtle_up()
turtle_do({
  turtle_setpos(500,500)
  turtle_setangle(0)
  sierpinski_trapezoid_maze(unit_len=15,depth=4,color1='black',color2='green',
    clockwise=TRUE,draw_boundary=TRUE,boundary_holes=c(1,3))
  sierpinski_trapezoid_maze(unit_len=15,depth=4,color1='black',color2='green',
    clockwise=FALSE,draw_boundary=TRUE,
    boundary_lines=c(2,3,4),boundary_holes=3)
})

# stack some trapezoids!
require(TurtleGraphics)
turtle_init(750,900,mode='clip')
turtle_hide()
turtle_up()
turtle_do({
  turtle_setpos(25,450)
  turtle_setangle(0)
  blines <- c(1,2,4)
  for (dep in seq(from=4,to=0)) {
    sierpinski_trapezoid_maze(unit_len=13,depth=dep,color1='black',color2='green',
      flip_color_parts=2,
      clockwise=TRUE,boundary_lines=blines,draw_boundary=TRUE,boundary_holes=c(1,3),
      end_side=3)
    turtle_right(180)
    blines <- c(1,2,4)
  }
})
\dontrun{
require(TurtleGraphics)
turtle_init(750,900,mode='clip')
turtle_hide()
turtle_up()
turtle_do({
  turtle_setpos(25,450)
  turtle_setangle(0)
  blines <- c(1,2,4)
  for (dep in seq(from=5,to=0)) {
    sierpinski_trapezoid_maze(unit_len=13,depth=dep,color1='black',color2='green',
      flip_color_parts=3,
      clockwise=TRUE,boundary_lines=blines,draw_boundary=TRUE,boundary_holes=c(1,3),
      end_side=3)
    turtle_right(180)
    blines <- c(1,2,4)
  }
})
}

}
\seealso{
\code{\link{iso_trapezoid_maze}},
\code{\link{hexaflake_maze}},
\code{\link{sierpinski_carpet_maze}},
\code{\link{sierpinski_maze}}.
}
\author{
Steven E. Pav \email{shabbychef@gmail.com}
}
\keyword{Sierpinski}
\keyword{plotting}
