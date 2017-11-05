# Copyright 2017-2017 Steven E. Pav. All Rights Reserved.
# Author: Steven E. Pav

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

# generate the bibliography#FOLDUP
#see also
#http://r.789695.n4.nabble.com/Automating-citations-in-Sweave-td872079.html

FID <- file("rauto.bib", "w")  # open an output file connection

cite.by.name <- function(x){ 
	res <- toBibtex(citation(x)) 
	if (is.list(res)) res <- res[[1]] 
	#2FIX: multiple citations; bleah;
	tofix <- grep("^@.+",res)
	fidx <- tofix[1]
	res[fidx] <- sub("{",paste("{",x,sep=''),res[fidx],fixed=TRUE) 

	if (length(tofix) > 1) {
		for (fidx in tofix[2:length(tofix)]) {
			res[fidx] <- sub("{",paste("{",x,"_",fidx,sep=''),res[fidx],fixed=TRUE) 
		}
	}
	cat(res,file = FID, sep = "\n")
	return(NULL)
} 
z <- sapply( .packages(TRUE), function(x) try( cite.by.name(x) ) )
close(FID)
#UNFOLD

#for vim modeline: (do not edit)
# vim:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=r:ft=r
