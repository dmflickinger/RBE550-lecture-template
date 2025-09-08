import os
from PyPDF2 import PdfReader
from moviepy import *

from pathlib import Path
from natsort import natsorted



def create_video(pdf_file, audio_dir, output_file):
    # Load the PDF file
    pdf = PdfReader(pdf_file)
    
    # Get the number of pages in the PDF
    num_pages = len(pdf.pages)

    print(f"Loaded {pdf_file} with {num_pages} slides/pages.")
    
    # Initialize lists to hold the image files (representing PDF pages) and audio files
    image_files = []
    audio_files = []
    
    # Convert PDF pages to images and save them
    for i in range(num_pages):
        page = pdf.pages[i]

        from pdf2image import convert_from_path

        # TODO: specify resolution as argument
        images = convert_from_path(pdf_file, fmt='png', size=(None, 1080), first_page=i+1, last_page=i+1)
        image_path = f"slide_output/page_{i+1}.png"
        images[0].save(image_path, 'PNG')
        image_files.append(image_path)


    # Get the list of MP3 files from the directory
    audio_path = Path(audio_dir)
    for filename in natsorted(audio_path.iterdir(), key=lambda x: x.name):
    # for filename in sorted(os.listdir(audio_dir)):
        if str(filename).endswith(".mp3"):
            audio_files.append(filename)

    print(f"Found {len(audio_files)} audio files.")
    
    # Ensure that the number of audio files matches the number of PDF pages
    if len(audio_files) != num_pages:
        print("Warning: The number of audio files does not match the number of PDF pages.")
        # TODO: change warning to an error and trigger exception
    
    # Initialize the video clips list
    video_clips = []
    
    # Create a video clip for each page and its corresponding audio
    for i in range(min(len(audio_files), len(image_files))):

        image_clip = ImageClip(image_files[i]).with_duration(AudioFileClip(audio_files[i]).duration)
        video_clips.append(image_clip.with_audio(AudioFileClip(audio_files[i])))
        
    
    # Concatenate the clips
    final_video = concatenate_videoclips(video_clips)
    
    # Write the final video to file
    final_video.write_videofile(output_file, fps=24)
    
    # Clean up: delete the image files created
    for image in image_files:
        os.remove(image)

if __name__ == "__main__":

    # TODO: add argument parsing

    # TODO: check that audio output directory exists
    # TODO: create slide_output directory

    pdf_file = 'RBE-550_lecture_template.pdf'
    audio_dir = 'audio_output'
    output_file = 'RBE-550_lecture_template.mp4'

    create_video(pdf_file, audio_dir, output_file)
