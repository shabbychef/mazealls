#!/bin/bash -e
#
# Created: 2017.03.17
# Copyright: Steven E. Pav, 2017
# Author: Steven E. Pav
# Comments: Steven E. Pav

#git submodule add git@github.com:shabbychef/rpkg_make.git rpkg_make
git submodule add https://github.com/shabbychef/rpkg_make.git rpkg_make
git submodule init
git submodule update
echo rpkg_make >> .Rbuildignore

#for vim modeline: (do not edit)
# vim:ts=2:sw=2:tw=79:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=sh:ft=sh:ai:si:cin:nu:fo=croql:cino=p0t0c5(0:
