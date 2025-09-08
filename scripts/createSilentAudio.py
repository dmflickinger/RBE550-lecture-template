import argparse
from pydub import AudioSegment

def create_silent_audio(duration, output_file):
    silence = AudioSegment.silent(duration=duration)
    silence.export(output_file, format="mp3")


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument("duration", type=int, help="Duration in seconds")
    parser.add_argument("output_file", help="Output file name")
    args = parser.parse_args()

    create_silent_audio(args.duration, args.output_file)
    print(f"Created silent audio file: {args.output_file}")