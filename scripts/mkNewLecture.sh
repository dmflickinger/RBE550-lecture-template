#!/bin/bash
# Create a new lecture from the template
# [1] lecture location (name)

mkdir -p $1

cp -f Makefile $1
cp -f RBE-550_lecture_template.tex $1
cp -rf slides $1
