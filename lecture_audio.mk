# Makefile template for building lecture audio features
# Date: 2025
# Author: Daniel Montrallo Flickinger, PhD ; dflickinger@wpi.edu

VENV_ACTIVATE = . /lecturetemplate/venv/bin/activate
SOUND_FONT = FluidR3_GM.sf2 

testaudio: venv
	mkdir -p audio_output
	$(VENV_ACTIVATE) && python3 /usr/local/bin/createAudioFiles.py RBE-550_lecture_template.pdf audio_output

audio: venv
	mkdir -p audio_transitions
	$(VENV_ACTIVATE) \
	&& python3 /lecturetemplate/audioGenerator/createMIDI_title_slide.py \
	&& python3 /lecturetemplate/audioGenerator/createMIDI_outline_slide.py
	fluidsynth -F "temp.wav" $(SOUND_FONT) "audio_transitions/title_slide.mid"
	lame "temp.wav"
	mv temp.mp3 audio_transitions/title_slide.mp3
	fluidsynth -F "temp.wav" $(SOUND_FONT) "audio_transitions/outline_slide.mid"
	lame "temp.wav"
	mv temp.mp3 audio_transitions/outline_slide.mp3
	rm -f temp.wav
	rm -f audio_transitions/title_slide.mid
	rm -f audio_transitions/outline_slide.mid
