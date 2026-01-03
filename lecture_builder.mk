# Makefile template for building lectures
# Date: 2025
# Author: Daniel Montrallo Flickinger, PhD ; dflickinger@wpi.edu

VENV_ACTIVATE = . /lecturetemplate/venv/bin/activate

all : document video

venv:
	python3 -m venv /lecturetemplate/venv
	$(VENV_ACTIVATE) && python3 -m pip install -r /lecturetemplate/audioGenerator/python_requirements.txt

titleanim: venv
	mkdir -p animation_output
	$(VENV_ACTIVATE) && python3 /lecturetemplate/tet_animation/tetromino_animation.py -n $(lecture_number) -d 5 -o animation_output/title_$(lecture_number)_$(lecture_name).gif

video: venv titleanim $(lecture_name).pdf
	mkdir -p slide_output
	$(VENV_ACTIVATE) && python3 /usr/local/bin/encodeVideo.py $(lecture_name).pdf $(lecture_name).yaml audio_output animation_output/title_$(lecture_number)_$(lecture_name).gif /lecturetemplate/synth_transitions/title_slide.mp3 /lecturetemplate/synth_transitions/outline_slide.mp3 $(lecture_name).mp4
	rm -rf slide_output


install: document video
	cp -f $(lecture_name).pdf /output/
	cp -f $(lecture_name).mp4 /output/

audioclean:
	rm -rf audio_output

clean :
	rm -f $(lecture_name).pdf
	rm -f $(lecture_name).m4v
	rm -f $(lecture_name).mp4
	rm -rf audio_transitions
	rm -rf slide_output
	rm -rf animation_output
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
