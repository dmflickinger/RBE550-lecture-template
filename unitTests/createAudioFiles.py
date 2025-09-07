from gtts import gTTS
import os
from pydub import AudioSegment

def save_mp3(text, filename):
    tts = gTTS(text=text, lang='en', slow=False)
    tts.save(f'{filename}.mp3')
    print(f"saved {filename}.mp3")


if __name__ == "__main__":

    # TODO: read in command line arguments
    # TODO: create mp3 files in a specified directory
    # TODO: create multiple mp3 files (one for each slide)
    # TODO: count the number of pages to calculate the number of files
    # TODO: extract and convert the title text to speech

    text = "Hello, this is a text-to-speech MP3 example."
    save_mp3(text, 'example')