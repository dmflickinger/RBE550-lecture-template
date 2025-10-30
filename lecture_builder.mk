# Makefile for About Instructor lecture
# Date: 2025
# Author: Daniel Montrallo Flickinger, PhD ; dflickinger@wpi.edu

LATEX_BUILD = xelatex -shell-escape -interaction=nonstopmode -file-line-error

VENV_ACTIVATE = . venv/bin/activate

all : document audio video
document: $(lecture_name).tex
# 	$(MAKE) -C diagrams
	$(LATEX_BUILD) $(lecture_name)
	$(LATEX_BUILD) $(lecture_name)
	makeindex $(lecture_name)-url
	bibtex $(lecture_name)
	bibtex $(lecture_name)
	$(LATEX_BUILD) $(lecture_name)
	$(LATEX_BUILD) $(lecture_name)


venv:
	python3 -m venv venv
	$(VENV_ACTIVATE) && python3 -m pip install -r audioGenerator/python_requirements.txt

testaudio: venv
	mkdir -p audio_output
	$(VENV_ACTIVATE) && python3 unitTests/createAudioFiles.py RBE-550_lecture_template.pdf audio_output

audio: venv
	mkdir -p audio_transitions
	$(VENV_ACTIVATE) && python3 audioGenerator/audioGenerator.py audioGenerator/audio_cfg.yaml audioGenerator/notes_title.txt audio_transitions/title_slide.mp3


video: venv audio
	mkdir -p slide_output
	$(VENV_ACTIVATE) && python3 scripts/encodeVideo.py RBE-550_lecture_template.pdf audio_output RBE-550_lecture_template.mp4
	rmdir slide_output


install: document audio video
	cp -f $(lecture_name).pdf /output/
	cp -f $(lecture_name).mp4 /output/


clean :
	rm -f $(lecture_name).pdf
	rm -f $(lecture_name).m4v
	rm -f $(lecture_name).mp4
	rm -rf audio_output
	rm -rf audio_transitions
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
	rm -rf venv
