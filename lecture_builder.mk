# Makefile template for building lectures
# Date: 2025
# Author: Daniel Montrallo Flickinger, PhD ; dflickinger@wpi.edu


VENV_ACTIVATE = . venv/bin/activate

SOUND_FONT = FluidR3_GM.sf2 

all : document testaudio audio video

venv:
	python3 -m venv venv
	$(VENV_ACTIVATE) && python3 -m pip install -r audioGenerator/python_requirements.txt

testaudio: venv
	mkdir -p audio_output
	$(VENV_ACTIVATE) && python3 unitTests/createAudioFiles.py RBE-550_lecture_template.pdf audio_output

audio: venv
	mkdir -p audio_transitions
	$(VENV_ACTIVATE) \
	&& python3 audioGenerator/createMIDI_title_slide.py \
	&& python3 audioGenerator/createMIDI_outline_slide.py
	fluidsynth -F "temp.wav" $(SOUND_FONT) "audio_transitions/title_slide.mid"
	lame "temp.wav"
	mv temp.mp3 audio_transitions/title_slide.mp3
	fluidsynth -F "temp.wav" $(SOUND_FONT) "audio_transitions/outline_slide.mid"
	lame "temp.wav"
	mv temp.mp3 audio_transitions/outline_slide.mp3
	rm -f temp.wav
	rm -f audio_transitions/title_slide.mid
	rm -f audio_transitions/outline_slide.mid

titleanim: venv
	mkdir -p animation_output
	$(VENV_ACTIVATE) && python3 tet_animation/tetromino_animation.py -n $(lecture_number) -d 5 -o animation_output/title_$(lecture_number)_$(lecture_name).gif

video: venv document audio testaudio titleanim
	mkdir -p slide_output
	$(VENV_ACTIVATE) && python3 scripts/encodeVideo.py $(lecture_name).pdf $(lecture_name).yaml audio_output animation_output/title_$(lecture_number)_$(lecture_name).gif /lecturetemplate/synth_transitions/title_slide.mp3 /lecturetemplate/synth_transitions/outline_slide.mp3 $(lecture_name).mp4
	rm -rf slide_output


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
