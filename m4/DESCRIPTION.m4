dnl divert here just means the output from basedefs does not appear.
divert(-1)
include(basedefs.m4)
divert(0)dnl
Package: PKG_NAME()
Maintainer: Steven E. Pav <shabbychef@gmail.com>
Authors@R: c(person(c("Steven", "E."), "Pav", role=c("aut","cre"),
    email="shabbychef@gmail.com"))
Version: VERSION()
Date: DATE()
License: LGPL-3
Title: Statistical significance of the Markowitz portfolio
BugReports: https://github.com/shabbychef/PKG_NAME()/issues
Description: a collection of tools for analyzing significance of 
    Markowitz portfolios.
Depends: 
    R (>= 3.0.2)
Imports:
    matrixcalc,
    sandwich,
    gtools
Suggests: 
    SharpeR,
    testthat, 
    knitr
URL: https://github.com/shabbychef/PKG_NAME()
VignetteBuilder: knitr
Collate:
m4_R_FILES()
dnl vim:ts=2:sw=2:tw=79:syn=m4:ft=m4
