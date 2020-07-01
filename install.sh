#!/bin/bash

mkdir -p /usr/local/share/LaTeX_templates/RBE550_lecture/fig

cp -f fig/*.png /usr/local/share/LaTeX_templates/RBE550_lecture/fig/

cp -f template/RBE-550_S2021_lecture_template_preamble.tex /usr/local/share/LaTeX_templates/RBE550_lecture
cp -f template/RBE-550_S2021_lecture_template_final_slide.tex /usr/local/share/LaTeX_templates/RBE550_lecture
