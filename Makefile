# Makefile for lecture template
# Date: 2020
# Author: Daniel Montrallo Flickinger, PhD ; dflickinger@wpi.edu

lecture_name = RBE-550_lecture_template


all : document
document: $(lecture_name).tex
#	$(MAKE) -C diagrams
	xelatex -shell-escape -interaction=nonstopmode -file-line-error $(lecture_name)
	xelatex -shell-escape -interaction=nonstopmode -file-line-error $(lecture_name)
	bibtex $(lecture_name)
	bibtex $(lecture_name)
	xelatex -shell-escape -interaction=nonstopmode -file-line-error $(lecture_name)
	xelatex -shell-escape -interaction=nonstopmode -file-line-error $(lecture_name)


install: document
	cp -f $(lecture_name).pdf /output/

clean :
	rm -f $(lecture_name).pdf
	rm -f *.out
	rm -f *.log
	rm -f *.aux
	rm -f *.toc
	rm -f *.lof
	rm -f *.bbl
	rm -f *.blg
	rm -f *.vrb
	rm -f *.nav
	rm -f *.snm
