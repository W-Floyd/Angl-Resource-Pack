#!/bin/bash

name="Angl"

if [ -z $1 ]; then

	for size in $(seq 5 9); do

		res=$(echo "2^"$size | bc)

		./Render.sh $res

		./Packer.sh $name"-"$res"px"

		rm -r $name"-"$res"px/"

	done

else

	res=$1

	./Render.sh $res

	./Packer.sh $name"-"$res"px"

	rm -r $name"-"$res"px/"

fi

exit
