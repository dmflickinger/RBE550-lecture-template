import yaml
import numpy as np
from scipy.io.wavfile import write
import argparse
import fluidsynth
import os
from pydub import AudioSegment

class AudioGenerator:
    """! @brief Audio generator class using FluidSynth for sound synthesis.
         @details Reads in configuration file defining the synthesized waveform,
         sound type, then reads a list of notes to play. Finally, create the
         audio and encode to MP3 format and write the output file.
    """

    def __init__(self, cfg_fname, notes_fname, output_fname):
        """! @brief Initialize audio generator
             @param[in] cfg_fname Configuration file name (YAML)
             @param[in] notes_fname File containing notes to play
             @param[in] output_fname Sound file output (MP3)
             @details Sets parameters and file names, loads configuration
        """
        self.cfg_fname = cfg_fname
        self.notes_fname = notes_fname
        self.output_fname = output_fname

        # Load configuration from YAML file
        with open(cfg_fname, 'r') as f:
            self.config = yaml.safe_load(f)

        # Initialize FluidSynth synthesizer
        self.synth = fluidsynth.Synth()
        self.synth.start(driver="alsa")

        sfid = self.synth.sfload(self.config['soundfont'])
        self.synth.program_select(0, sfid, 0, 0)

    def freq_to_midi(self, frequency):
        """! @brief Convert frequency to MIDI note number
             @param[in] frequency Frequency in Hz
             @return MIDI note number
        """
        return int(69 + 12 * np.log2(frequency / 440))

    def synthesize_with_fluidsynth(self):
        """! @brief Synthesize audio using FluidSynth
             @details Reads the notes file and synthesizes them using FluidSynth.
             The output is saved as a temporary WAV file.
        """
        temp_wav_file = "temp_output.wav"
        self.synth.start(driver="file", file=temp_wav_file)

        with open(self.notes_fname, 'r') as f:
            lines = f.readlines()

            for line in lines:
                note_freq, note_duration = line.strip().split()
                frequency = int(float(note_freq) * 100)  # Convert to cents (MIDI units)
                duration = float(note_duration)

                # Map frequency to MIDI note number
                midi_note = self.freq_to_midi(frequency)
                self.synth.noteon(0, midi_note, 127)
                fluidsynth.sleep(duration)
                self.synth.noteoff(0, midi_note)
                fluidsynth.sleep(0.1)  # Short pause between notes

        return temp_wav_file

    def save_audio(self):
        """! @brief Save generated audio to an MP3 file
             @details Converts the synthesized WAV output from FluidSynth to MP3 format.
        """
        temp_wav_file = self.synthesize_with_fluidsynth()
        audio = AudioSegment.from_wav(temp_wav_file)
        audio.export(self.output_fname, format="mp3")

def main():
    parser = argparse.ArgumentParser(description="Audio Generator")
    parser.add_argument('cfg_fname', type=str, help='Configuration file name (YAML)')
    parser.add_argument('notes_fname', type=str, help='File containing notes to play')
    parser.add_argument('output_fname', type=str, help='Sound file output (MP3)')

    args = parser.parse_args()

    audio_gen = AudioGenerator(args.cfg_fname, args.notes_fname, args.output_fname)
    audio_gen.save_audio()

if __name__ == "__main__":
    main()
