######################
# 
# Created: 2017-10-03
# Copyright: Steven E. Pav, 2017
# Author: Steven E. Pav
######################

############### FLAGS ###############

VMAJOR 						 = 0
VMINOR 						 = 1
VPATCH  					 = 0
#VDEV 							 =
VDEV 							 = .0006
PKG_NAME 					:= mazealls

RPKG_USES_RCPP 		:= 0

include ./rpkg_make/Makefile

rpkg_make :  ## initialize the Makefile in rpkg_make
	git submodule add https://github.com/shabbychef/rpkg_make.git rpkg_make
	git submodule init
	git submodule update

#for vim modeline: (do not edit)
# vim:ts=2:sw=2:tw=129:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:tags=.tags;:syn=make:ft=make:ai:si:cin:nu:fo=croqt:cino=p0t0c5(0:
