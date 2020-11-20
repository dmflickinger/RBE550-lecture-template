# RBE Lecture Template 

Template and example lecture for an RBE course at WPI.  Use the provided Docker container to build all lectures.  

An example bibliography file is included.  For lectures, create a bibliography file named RBE_resources.bib and add 
the directory as a volume for the Docker container.  


## Build

```sh
mkdir ~/lectureSlides
docker build -t rbe_lecture .
docker run -it --rm -v .:/source -v ~/lectureSlides:/output -v ./bib:/bib rbe_lecture
```

PDF of the lecture is found in the `./output` directory.


