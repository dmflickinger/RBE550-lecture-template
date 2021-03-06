# RBE Lecture Template 

Template and example lecture for an RBE course at WPI.  Use the provided Docker container to build all lectures.  


## Build

```sh
mkdir lectureSlides
docker build -t rbe_lecture .
docker run -it --rm -v .:/source -v lectureSlides:/output rbe_lecture
```

A completed lecture (in PDF) format is created in the lectureSlides directory.
