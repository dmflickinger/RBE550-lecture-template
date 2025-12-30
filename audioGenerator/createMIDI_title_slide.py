from midiutil import MIDIFile

# Create a MIDIFile object with 1 track and 1 channel
midi = MIDIFile(1) 

# Add a track name and tempo
track = 0
time = 0
midi.addTrackName(track, time, "My Track")
midi.addTempo(track, time, 60)  # Set tempo to 120 bpm

# Add notes
channel = 0
duration = 1  # In beats

channel = 1 # bass line
volume = 80
midi.addNote(track, channel, 48, time, duration, volume) # C3
time += duration
midi.addNote(track, channel, 45, time, duration, volume) # G3
time += duration
midi.addNote(track, channel, 43, time, duration, volume) # F3
time += duration
midi.addNote(track, channel, 41, time, duration, volume) # E3
time += duration
midi.addNote(track, channel, 39, time, duration*4, volume) # D3

channel = 2 # pad/atmosphere
volume = 60
time = 0
midi.addNote(track, channel, 60, time, duration, volume) # C4
time += duration
midi.addNote(track, channel, 64, time, duration, volume) # E4
time += duration
midi.addNote(track, channel, 67, time, duration, volume) # G4
time += duration
midi.addNote(track, channel, 71, time, duration, volume) # B4
time += duration
midi.addNote(track, channel, 76, time, duration, volume) # C5

channel = 3 # Subtle Rythm
volume = 50
time = 0
midi.addNote(track, channel, 36, time, duration, volume) # kick drum
time = 1
midi.addNote(track, channel, 36, time, duration, volume) # kick drum
time = 2
midi.addNote(track, channel, 36, time, duration, volume) # kick drum


# Save the MIDI file
with open("audio_transitions/title_slide.mid", "wb") as output_file:
    midi.writeFile(output_file)