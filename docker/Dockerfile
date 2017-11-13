#
# dockerfile to CRAN-check with r-dev
#
# docker build --rm -t shabbychef/mazealls-crancheck .
#
# docker run -it --rm --volume $(pwd):/srv:rw mazealls-crancheck
#
# Created: 2017.11.04
# Copyright: Steven E. Pav, 2017
# Author: Steven E. Pav
# Comments: Steven E. Pav

#####################################################
# preamble# FOLDUP
FROM shabbychef/crancheck
MAINTAINER Steven E. Pav, shabbychef@gmail.com
# UNFOLD

#ENV DOCKERFILE_REFRESHED_AT 2017.03.14
ENV DOCKERFILE_REFRESHED_AT 2017.11.13
# see http://crosbymichael.com/dockerfile-best-practices.html
#RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list

RUN (apt-get clean -y ; \
 apt-get update -y -qq; \
 apt-get update --fix-missing );

#RUN (apt-get dist-upgrade -y ; \
#apt-get update -qq ; \
RUN (DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt-get install -q -y --no-install-recommends \ 
  libgs9 texlive-base texlive-binaries \
	libcupsimage2 libcups2 curl wget \
	qpdf pandoc ghostscript \
	texlive-latex-extra texlive-latex-base texlive-fonts-recommended texlive-fonts-extra ; \
	sync ; \
	mkdir -p /usr/local/lib/R/site-library ; \
	chmod -R 777 /usr/local/lib/R/site-library ; \
	sync ; \
	/usr/local/bin/install2.r Rcpp testthat roxygen2 devtools knitr formatR codetools)

# rinstall somethings...
RUN /usr/local/bin/install2.r TurtleGraphics;

RUN groupadd -g 1001 spav && useradd -g spav -u 1001 spav;
USER spav

#####################################################
# entry and cmd# FOLDUP
# these are the default, but remind you that you might want to use /usr/bin/R instead?
# always use array syntax:
ENTRYPOINT ["/usr/local/bin/R","CMD","check","--as-cran","--output=/tmp"]

# ENTRYPOINT and CMD are better together:
CMD ["/srv/*.tar.gz"]
# UNFOLD

#for vim modeline: (do not edit)
# vim:nu:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=Dockerfile:ft=Dockerfile:fo=croql
