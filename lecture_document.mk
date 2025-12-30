# Makefile template for building lecture document
# Date: 2025
# Author: Daniel Montrallo Flickinger, PhD ; dflickinger@wpi.edu

LATEX_BUILD = xelatex -shell-escape -interaction=nonstopmode -file-line-error


document: $(lecture_name).tex
	$(MAKE) -C diagrams
	$(LATEX_BUILD) $(lecture_name)
	$(LATEX_BUILD) $(lecture_name)
	makeindex $(lecture_name)-url
	bibtex $(lecture_name)
	bibtex $(lecture_name)
	$(LATEX_BUILD) $(lecture_name)
	$(LATEX_BUILD) $(lecture_name)
