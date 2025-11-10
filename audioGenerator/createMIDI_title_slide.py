from midiutil import MIDIFile

# Create a MIDIFile object with 1 track and 1 channel
midi = MIDIFile(1) 

# Add a track name and tempo
track = 0
time = 0
midi.addTrackName(track, time, "My Track")
midi.addTempo(track, time, 120)  # Set tempo to 120 bpm

# Add notes
channel = 0
volume = 100  # 0-127
duration = 1  # In beats

# Example notes: Middle C, D, E, F
midi.addNote(track, channel, 60, time, duration, volume) # C4
time += duration
midi.addNote(track, channel, 62, time, duration, volume) # D4
time += duration
midi.addNote(track, channel, 64, time, duration, volume) # E4
time += duration
midi.addNote(track, channel, 65, time, duration, volume) # F4

# Save the MIDI file
with open("audio_transitions/title_slide.mid", "wb") as output_file:
    midi.writeFile(output_file)