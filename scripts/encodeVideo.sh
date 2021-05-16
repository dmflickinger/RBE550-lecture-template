#!/bin/bash

# Convert PDF to directory full of pngs
mkdir -p slideImages
pdftocairo -png -scale-to-x -1 -scale-to-y 2160 $1.pdf slideImages/slide


# Now encode those pngs to video
# ffmpeg -y -r 1/5 -i slideImages/slide-%02d.png -c:v libx264 -r 30 -pix_fmt yuv420p $1.m4v


# Compress the slide images, and remove
tar -czf $1_slides.tar.gz slideImages
rm -rf slideImages

