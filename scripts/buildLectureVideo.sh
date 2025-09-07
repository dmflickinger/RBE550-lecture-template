#!/bin/bash

PDF="$1"
DIRECTORY="$2"
OUTPUT="$3"

if [ ! -f "$PDF" ]; then
    echo "Error: Invalid PDF file."
    exit 1
fi

if [ ! -d "$DIRECTORY" ]; then
    echo "Error: Invalid directory."
    exit 1
fi

ffmpeg -y -framerate 24 -i "$PDF" -vcodec libx264 -vf "setpts=0.25*PTS, format=yuv420p" -an -f mp4 -q:v 23 slideshow.mp4

for file in "$DIRECTORY"/*.mp3; do
    filename=$(basename -- $file)
    audio="slideshow_${filename%.*}.aac"
    ffmpeg -y -i "$file" -acodec aac -ar 48000 -ab 256k -f s16le "$audio"
    ffmpeg -y -i slideshow.mp4 -i "$audio" -vcodec copy -acodec copy -map 0:v:0 -map 1:a:0 -shortest -vf "setpts=0.5*PTS" output_$filename.mp4
    rm "$audio"
done

cat concat_list.txt > output_concat.txt
ffmpeg -f concat -safe 0 -i output_concat.txt -c copy final_slideshow.mp4
rm output_*.mp4 slideshow.mp4

mv final_slideshow.mp4 "$OUTPUT"
