#!/bin/bash

NAME="Angl"

for size in $(seq 3 9); do

	RESOLUTION=$(echo "2^"$size | bc)

	bash Render.sh $RESOLUTION

	bash Packer.sh $NAME"-"$RESOLUTION"px"

	rm -r $NAME"-"$RESOLUTION"px/"

done

exit
