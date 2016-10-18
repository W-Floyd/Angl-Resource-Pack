#!/bin/bash
# Will render the resource pack at the given resolution
# Or, if no inputs are given, 128px
# If you want to render only one image, specify the resolution,
# then the file, relative to the top level directory.
# Example
# ./render.sh 512 ./assets/minecraft/textures/blocks/bookshelf.svg
#
# Will also work on non-image files
# Example
# ./render.sh 128 ./pack.mcmeta

__name="Angl"

if ! [ -z $1 ]; then
	__resolution=$1
else
	__resolution=128
fi

__date=$(date +%Y-%m-%d_%H-%M-%S)

__directory=$(echo $__name"-"$__resolution"px/")

cp -r src/ $__directory

if [ -a /tmp/texpack/rendered ]; then
	rm /tmp/texpack/rendered
fi



for line in $(cat catalogue.xml | grep -i '<NAME>'); do



exit
