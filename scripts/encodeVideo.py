import os
from PyPDF2 import PdfReader
from moviepy import VideoFileClip, ImageClip, AudioFileClip, ImageSequenceClip, VideoClip, concatenate_videoclips

from pathlib import Path
from natsort import natsorted

import yaml

import argparse
import pathlib


def create_video(video_config):

    # Extract parameters
    pdf_file = video_config.get('pdf_file')
    slides_cfg = video_config.get('slides_cfg')
    audio_dir = video_config.get('audio_dir')
    title_audiofile = video_config.get('title_audiofile')
    outline_audiofile = video_config.get('outline_audiofile')
    output_file = video_config.get('output_file')
    resolution = video_config.get('resolution')
    title_animation = video_config.get('title_animation')

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
        # Convert the PDF page to an image
        from pdf2image import convert_from_path

        images = convert_from_path(pdf_file, fmt='png', size=(None, resolution), first_page=i+1, last_page=i+1)
        image_path = f"slide_output/page_{i+1}.png"
        images[0].save(image_path, 'PNG')
        image_files.append(image_path)

    # Parse the YAML configuration file
    with open(slides_cfg, 'r') as yaml_file:
        slides_config = yaml.safe_load(yaml_file)
    slides_list = slides_config.get('slides', [])
    print(f"Loaded slides configuration: {yaml_file}")

    # Process each slide dictionary in the list
    special_slides = set()
    title_slide = set()
    outline_slides = set()

    for slide_dict in slides_list:
        for field in ['titleslide']:
            if field in slide_dict:
                title_slide.add(slide_dict[field])

        for field in ['outline']:
            if field in slide_dict:
                if isinstance(slide_dict[field], dict):
                    outline_slides.update(slide_dict[field].keys())
                elif isinstance(slide_dict[field], int):
                    outline_slides.add(slide_dict[field])

        for field in ['endbuffer', 'sources', 'urls', 'endslide']:
            if field in slide_dict:
                if isinstance(slide_dict[field], dict):
                    # Handle format like {2: None, 4: None, ...}
                    special_slides.update(slide_dict[field].keys())
                elif isinstance(slide_dict[field], int):
                    # Handle single integer values
                    special_slides.add(slide_dict[field])
        
    print(f"Title slide: {title_slide}")
    print(f"Outline slides: {outline_slides}")
    print(f"Special slides: {sorted(special_slides)}")



    # Get the list of MP3 files from the directory
    audio_path = Path(audio_dir)
    for filename in natsorted(audio_path.iterdir(), key=lambda x: x.name):
        if str(filename).endswith(".mp3"):
            audio_files.append(filename)

    print(f"Found {len(audio_files)} audio files.")

    # Initialize the video clips list
    video_clips = []

    # add an opening animation (if configured)
    if os.path.exists(title_animation):
        video_clips.append(create_title_animation_clip(title_animation, resolution).with_audio(AudioFileClip(title_audiofile)))



    # Create a video clip for each page and its corresponding audio
    for idx in range(num_pages):
        slide_idx = idx + 1


        if slide_idx in title_slide:
            # First slide is the title
            # slide_clip = ImageClip(image_files[idx]).with_duration(AudioFileClip(title_audiofile).duration)
            slide_clip = ImageClip(image_files[idx]).with_duration(5.0) # FIXME: create title audio file of correct duration
            video_clips.append(slide_clip)
            # video_clips.append(slide_clip.with_audio(AudioFileClip(title_audiofile)))
            print(f"Added title slide {slide_idx} with duration {slide_clip.duration}.")

        elif slide_idx in outline_slides:
            # Outline slide
            # slide_clip = ImageClip(image_files[idx]).with_duration(AudioFileClip(outline_audiofile).duration)
            slide_clip = ImageClip(image_files[idx]).with_duration(3.0) # FIXME: create outline audio file of correct duration
            video_clips.append(slide_clip.with_audio(AudioFileClip(outline_audiofile)))
            print(f"Added outline slide {slide_idx} with duration {slide_clip.duration}")

        elif slide_idx in special_slides:
            # Other special slides
            slide_clip = ImageClip(image_files[idx]).with_duration(3.0)
            video_clips.append(slide_clip)
            print(f"Added special slide {slide_idx} with duration {slide_clip.duration}")

        else:
            # Regular slides
            # TODO: make this search through audio_files instead to make sure it's in the list
            audio_clip = AudioFileClip(audio_dir + f"/segment_{slide_idx}.mp3")
            slide_clip = ImageClip(image_files[idx]).with_duration(audio_clip.duration)
            video_clips.append(slide_clip.with_audio(audio_clip))
            print(f"Added slide {slide_idx} with duration {slide_clip.duration}")

    print(f"DONE adding {len(video_clips)} slides.")

    # Concatenate the clips
    final_video = concatenate_videoclips(video_clips, method="compose")

    # Write the final video to file
    final_video.write_videofile(output_file, fps=24)



def create_title_animation_clip(input_fname, res_height):
    """
    Create a video clip from a GIF file scaled to target resolution without interpolation.
    
    Args:
        filename (str): Path to the GIF file
        target_resolution (tuple): Target (width, height) resolution as tuple
        maintain_aspect_ratio (bool): Whether to maintain original aspect ratio
    
    Returns:
        moviepy.editor.VideoFileClip: Scaled video clip ready for concatenation
    
    Raises:
        FileNotFoundError: If the GIF file doesn't exist
        ValueError: If target resolution is invalid
    """
    # Validate input
    if not os.path.exists(input_fname):
        raise FileNotFoundError(f"GIF file not found: {input_fname}")
    
    if res_height <= 0:
        raise ValueError("Resolution dimensions must be positive")
    
    # Create video clip from GIF
    clip = VideoFileClip(input_fname)
    scaled_clip = clip.resized(height=res_height)
 
    return scaled_clip
    


if __name__ == "__main__":

    # TODO: use pathlib for all filename parameters
    parser = argparse.ArgumentParser(description="Encode a video from PDF and a directory of audio files")
    parser.add_argument("pdf", help="path to PDF file with slides")
    parser.add_argument("slides", help="slides configuration file (YAML)")
    parser.add_argument("audio_dir", help="directory with audio files (one per slide)")
    parser.add_argument("title_animation", type=pathlib.Path, help="filename for title animation file")
    parser.add_argument("title_audio", help="filename for title audio file")
    parser.add_argument("outline_audio", help="filename for outline audio file")
    parser.add_argument("video_output", help="video output file")
    parser.add_argument("--resolution", type=int, default=1080, help="resolution of the PDF pages (default: 1080)")
    args = parser.parse_args()

    if not os.path.exists(args.pdf):
        raise ValueError(f"PDF file {args.pdf} does not exist.")
    
    if not os.path.exists(args.slides):
        raise ValueError(f"Slides configuration file {args.slides} does not exist.")
    
    if not os.path.exists(args.audio_dir):
        raise ValueError(f"Audio directory {args.audio_dir} does not exist.")
    
    if not os.path.exists(args.title_animation):
        raise ValueError(f"Title audio file {args.title_animation} does not exist.")

    if not os.path.exists(args.title_audio):
        raise ValueError(f"Title audio file {args.title_audio} does not exist.")
    
    if not os.path.exists(args.outline_audio):
        raise ValueError(f"Outline audio file {args.outline_audio} does not exist.")
    


    # Create video config dictionary
    video_config = {
        'pdf_file': args.pdf,
        'slides_cfg': args.slides,
        'audio_dir': args.audio_dir,
        'title_animation': args.title_animation,
        'title_audiofile': args.title_audio,
        'outline_audiofile': args.outline_audio,
        'output_file': args.video_output,
        'resolution': args.resolution
    }

    create_video(video_config)
