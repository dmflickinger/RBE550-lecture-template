#!/bin/bash
# [1] lectures location
# [2] course root directory


for lecture in $1/*; do
    podman run -it --rm -v $lecture:/source -v $2/lectureSlides:/output -v $2/RBE550_resources:/bib rbe_lecture
done

