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

# Created: 2017-10-03
# Copyright: Steven E. Pav, 2017
# Author: Steven E. Pav
# Comments: Steven E. Pav

#' Generate recursive mazes.
#'
#' Recursive generation of mazes proceeds roughly as follows: subdivide
#' the domain logicall into two or more parts, creating mazes in the 
#' sub-parts, then drawing dividing lines between them with some holes.
#' The holes in the dividing lines should be constructed so that the
#' sub-parts form a tree, with exactly one way to get from one of the
#' sub-parts to any one of the others. Then an optional outer boundary
#' with optional holes is drawn to finish the maze.
#'
#' @section unit length:
#'
#' The \code{unit_len} parameter controls the graphical length of one \sQuote{unit}, 
#' which is the length of holes between sections of the mazes, and is roughly the width
#' of the \sQuote{hallways} of a maze. Here is an example of using different
#' unit lengths in a stack of trapezoids
#'
#' \if{html}{
#' \figure{unit-len-stack-trap-1.png}{options: width="100\%" alt="Figure: Stacked trapezoids"}
#' }
#' \if{latex}{
#' \figure{unit-len-stack-trap-1.png}{options: width=7cm}
#' }
#'
#' @section boundaries:
#'
#' The parameters \code{draw_boundary}, \code{boundary_lines}, \code{boundary_holes}, 
#' \code{num_boundary_holes} and \code{boundary_hole_color} control
#' the drawing of the final outer boundary of polynomial mazes. Without a boundary
#' the maze can be used in recursive construction. Adding a boundary provides the
#' typical entry and exit points of a maze. The parameter \code{draw_boundary} is a
#' single Boolean that controls whether the boundary is drawn or not.
#' The parameter \code{boundary_lines} may be a scalar Boolean, or a numeric
#' array giving the indices of which sides should have drawn boundary lines.
#' The sides are numbered in the order in which they appear, and are
#' controlled by the \code{clockwise} parameter. The parameter \code{boundary_holes}
#' is a numeric array giving the indices of the boundary lines that should
#' have holes. If \code{NULL}, then we uniformly choose \code{num_boundary_holes} holes 
#' at random. Holes can be drawn as colored segments with the
#' \code{boundary_hole_color}, which is a character array giving the color of each
#' hole. The value 'clear' stands in for clear holes.
#' Arrows can optionally be drawn at the boundary holes via the
#' \code{boundary_hole_arrows} parameter, which is either a logical array or a 
#' numerical array indicating which sides should have boundary hole arrows.
#'
#' \if{html}{
#' \figure{boundary-stuff-1.png}{options: width="100\%" alt="Figure: Boundary Examples"}
#' }
#' \if{latex}{
#' \figure{boundary-stuff-1.png}{options: width=7cm}
#' }
#'
#' @section end side:
#'
#' The \code{end_side} parameter controls which side of the maze the turtle ends on.
#' The default value of 1 essentially causes the turtle to end where it 
#' started. The sides are numbered in the order in which the boundary would be
#' drawn. Along with the boundary controls, the ending side can be useful to join together 
#' polygons into more complex mazes.
#'
#' @section Legal Mumbo Jumbo:
#'
#' mazealls is distributed in the hope that it will be useful,
#' but WITHOUT ANY WARRANTY; without even the implied warranty of
#' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#' GNU Lesser General Public License for more details.
#'
#' @template etc
#'
#' @import TurtleGraphics
#'
#' @name mazealls
#' @rdname mazealls
#' @docType package
#' @title generate recursive mazes
#' @keywords package
#' @note
#' 
#' This package is dedicated to my friend, Abie Flaxman, who gave me the idea,
#' and other ideas.
#'
#' @note
#' If you like this package, please endorse the author for \sQuote{mazes} on
#' LinkedIn.
#'
NULL

#' @title News for package 'mazealls':
#'
#' @description 
#'
#' News for package \sQuote{mazealls}
#'
#' \newcommand{\CRANpkg}{\href{https://cran.r-project.org/package=#1}{\pkg{#1}}}
#' \newcommand{\mazealls}{\CRANpkg{mazealls}}
#'
#' @section \mazealls{} Version 0.2.0 (2017-12-12) :
#' \itemize{
#' \item adding octagon, decagon and dodecagon mazes.
#' \item adding Sierpinski triangle, carpet and trapezoid mazes.
#' \item adding hexaflake maze.
#' \item adding option to draw arrows at boundary holes.
#' \item adding boustrophedon factor to parallelogram, triangle, trapezoid,
#' hexagon mazes.
#' }
#'
#' @section \mazealls{} Initial Version 0.1.0 (2017-11-12) :
#' \itemize{
#' \item first CRAN release.
#' }
#'
#' @name mazealls-NEWS
#' @rdname NEWS
NULL

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
