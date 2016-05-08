#!/bin/bash

inkscape \
--export-dpi=$(echo "(90*"$1")/128" | bc) \
--export-png \
grass_side.png grass_side.svg

REMOVEDIRT=0
if ! [ -a dirt.png ]; then
	REMOVEDIRT=1
	inkscape \
	--export-dpi=$(echo "(90*"$1")/128" | bc) \
	--export-png \
	dirt.png dirt.svg
fi

composite grass_side.png dirt.png grass_side_.png

rm grass_side.png

if [ $REMOVEDIRT = 1 ]; then
	rm dirt.png
fi

mv grass_side_.png grass_side.png

exit
