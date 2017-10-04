#! /bin/bash
#
# get ctags in R for, recursively, foo.R
#
# this builds exuberant ctags for R
# you need to have a .ctags file in your
# home directory.
#
# Copyright: Cerebellum Capital, 2008-2009
# Author: Steven E. Pav
# Comments: Steven E. Pav

#CTAGS=exuberant-ctags
if [ "$LINUX_DISTRO" == "CRAPINTOSH" ]; then
	CTAGS=/opt/local/bin/ctags
else
	CTAGS=ctags
fi
echo $CTAGS
CTAGFLAGS='--verbose=no --recurse'
NICE_LEVEL=18
NICE_FLAGS="-n $NICE_LEVEL"
TMP_TAG=.tmp_tags

##set up the R tags
#for minimal disruption, write it to $TMP_TAG and then move it...
nice $NICE_FLAGS $CTAGS -f $TMP_TAG $CTAGFLAGS --language-force=R --exclude='.r\~' --fields=+i \
  `find . -name '*.[rR]' | grep -ve '\.git\|\.staging\|\.Rcheck\|\.local'` 2>/dev/null
if [ -s $TMP_TAG ];
then
	mv $TMP_TAG .R_tags;
else
	echo "empty R tags?" 1>&2 
fi

ln -sf .R_tags .tags

# vim:ts=4:sw=2:tw=180:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=sh:ft=sh:ai:si:cin:nu:fo=croql:cino=p0t0c5(0:
