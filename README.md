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
docker build -t rbe-lecture-template .
podman run --rm -v .:/source -v ./output:/output -v ./bib:/bib rbe-lecture-template
```
