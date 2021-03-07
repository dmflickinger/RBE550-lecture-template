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

A completed lecture (in PDF) format is created in the lectureSlides directory.
