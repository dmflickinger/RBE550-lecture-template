from gtts import gTTS
import os
from pydub import AudioSegment
import argparse
from PyPDF2 import PdfReader

def save_mp3(text, filename):
    tts = gTTS(text=text, lang='en', slow=False)
    tts.save(f'{filename}.mp3')
    print(f"saved {filename}.mp3")

if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument("file", help="PDF file path")
    parser.add_argument("output", help="output directory for audio files")
    args = parser.parse_args()

    with open(args.file, 'rb') as slides_file:
        reader = PdfReader(slides_file)

        num_slides = len(reader.pages)
        print(f"{num_slides} slides in {args.file}")

        page_idx = 1
        for page in reader.pages:
            save_mp3(page.extract_text(), f"{args.output}/slide_{page_idx}.mp3")
            page_idx += 1
