
# Copyright (C) 2013-2017 CRS4 

#
# Makefile for my wonderful presentation
#
# Makes several assumptions:
# * your presentation is in a file called presentation.tex
# * you want to use pdflatex
# * your images are in ./img
#
# The Makefile will try to convert images in the formats dia, svg, and eps into pdf,
# so that pdflatex will include them into the final presentation pdf.  For the conversion
# you'll need the programs dia, inkscape and ps2pdf installed on your system.
#
# Authors:  Luca Pireddu <pireddu-at-crs4.it>
#           Simone Leo
#


SHELL=/bin/bash

TEXFILE          = presentation.tex
IMGDIR           = ./img/

Basename         = $(TEXFILE:.tex=)
# all images are converted to PDF
# dia -> svg -> pdf
# svg -> pdf
# eps -> pdf
dias             = $(wildcard $(IMGDIR)/*.dia)
svgs             = $(wildcard $(IMGDIR)/*.svg) $(dias:.dia=.svg)
epss             = $(wildcard $(IMGDIR)/*.eps)

# List of all generated image files (resulting from conversions)
generated        = $(dias:.dia=.svg) $(svgs:.svg=.pdf) $(epss:.eps=.pdf)

# File lists computed on-demand (with := )
IMGFILES         := $(wildcard $(IMGDIR)/*.png) $(wildcard $(IMGDIR)/*.pdf) $(wildcard $(IMGDIR)/*.jpg) $(generated)


.PHONY: all pdf images clean littleclean

#----------------------------------------------------------------
all: pdf

pdf: $(Basename).pdf

presentation.pdf: images $(TEXFILE)
	@echo "########################## Making $@"
	pdflatex $(Basename)
	pdflatex $(Basename)

images: $(IMGFILES)

# Rules to convert images to PDF
%.svg : %.dia
	dia --filter=svg --log-to-stderr --export=$@ $<

%.pdf : %.svg
	inkscape --without-gui --export-area-drawing --export-dpi=300 --export-pdf=$@ $<

%.pdf : %.eps
	ps2pdf -dSubsetFonts=true -dEmbedAllFonts=true -dEPSCrop $< $@

# cleaning

clean: littleclean
	rm -f $(generated)

littleclean:
	rm -f $(Basename).{aux,bbl,blg,log,nav,out,snm,toc,vrb,pdf}
