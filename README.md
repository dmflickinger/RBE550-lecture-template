# RBE Lecture Template 

Template and example lecture for an RBE course at WPI.  Use the provided Docker container to build all lectures.  

## Dependencies

All required LaTeX packages are installed in the container.  
Obtain the [RBE resources](https://github.com/dmflickinger/RBE550resources) project for the bibliography files.


## Build

```sh
mkdir lectureSlides
docker build -t rbe_lecture .
docker run -it --rm -v .:/source -v lectureSlides:/output -v ../rbe_resources:/bib rbe_lecture
```

A completed lecture is created in the lectureSlides directory, this includes:

* PDF of the lecture slides
* .tar.gz of a directory containing 3840 x 2160 PNG images of each slide
* M4V, h264 encoded 4k resolution video of slides (5 seconds per slide)


