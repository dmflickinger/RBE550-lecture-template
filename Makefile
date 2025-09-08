# Makefile for lecture template
# Date: 2025
# Author: Daniel Montrallo Flickinger, PhD ; dflickinger@wpi.edu

lecture_name = RBE-550_lecture_template

LATEX_BUILD = xelatex -shell-escape -interaction=nonstopmode -file-line-error

VENV_ACTIVATE = . /lecturetemplate/venv/bin/activate

all : document audio video
document: $(lecture_name).tex
#	$(MAKE) -C diagrams
	$(LATEX_BUILD) $(lecture_name)
	$(LATEX_BUILD) $(lecture_name)
	makeindex $(lecture_name)-url
	bibtex $(lecture_name)
	bibtex $(lecture_name)
	$(LATEX_BUILD) $(lecture_name)
	$(LATEX_BUILD) $(lecture_name)

audio:
	mkdir -p audio_output
	$(VENV_ACTIVATE) && python3 unitTests/createAudioFiles.py RBE-550_lecture_template.pdf audio_output

video:
	mkdir -p slide_output
	$(VENV_ACTIVATE) && python3 scripts/encodeVideo.py
	rmdir slide_output

install: document audio video
	cp -f $(lecture_name).pdf /output/
	cp -f $(lecture_name).mp4 /output/

clean :
	rm -f $(lecture_name).pdf
	rm -f $(lecture_name).m4v
	rm -f $(lecture_name).mp4
	rm -rf audio_output
	rm -rf slide_output
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
	rm -f *.idx
	rm -f *.ilg
	rm -f *.ind
	rm -f *.mst
