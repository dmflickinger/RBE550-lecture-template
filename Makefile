# Makefile for lecture template
# Date: 2020
# Author: Daniel Montrallo Flickinger, PhD ; dflickinger@wpi.edu

lecture_name = RBE-550_lecture_template


all : document video
document: $(lecture_name).tex
#	$(MAKE) -C diagrams
	xelatex -shell-escape -interaction=nonstopmode -file-line-error $(lecture_name)
	xelatex -shell-escape -interaction=nonstopmode -file-line-error $(lecture_name)
	bibtex $(lecture_name)
	bibtex $(lecture_name)
	xelatex -shell-escape -interaction=nonstopmode -file-line-error $(lecture_name)
	xelatex -shell-escape -interaction=nonstopmode -file-line-error $(lecture_name)

video: $(lecture_name).pdf
	encodeVideo.sh $(lecture_name)

install: document video
	cp -f $(lecture_name).pdf /output/
	cp -f $(lecture_name).m4v /output/
	cp -f $(lecture_name)_slides.tar.gz /output/

clean :
	rm -f $(lecture_name).pdf
	rm -f $(lecture_name).m4v
	rm -f $(lecture_name)_slides.tar.gz
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
