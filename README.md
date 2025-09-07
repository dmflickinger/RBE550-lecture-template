# RBE Lecture Template

Template and [example lecture](RBE-550_lecture_template.pdf) for an RBE course at WPI.  Use the provided container to build all lectures.

## Manifest

* LaTeX template, including background images
* [development container](.devcontainer/devcontainer.json) for [VSCode](https://code.visualstudio.com/)
* [build container](Dockerfile)
* [new lecture stub creator](scripts/mkNewLecture.sh)
* [lecture video generator](scripts/encodeVideo.py)

## Dependencies

All required LaTeX packages are installed in the container.  
Obtain the [RBE resources](https://github.com/dmflickinger/RBE550resources) project for the bibliography files.

## Build

```sh
mkdir lectureSlides
docker build -t rbe_lecture .
docker run -it --rm -v .:/source -v lectureSlides:/output -v ../rbe_resources:/bib rbe_lecture
```
