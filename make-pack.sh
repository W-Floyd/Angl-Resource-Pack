#!/bin/bash

__name="Angl"

if [ -z "$1" ]; then

	for __size in $(seq 5 9); do

		__resolution=$(echo "2^"$__size | bc)

		./render.sh "$__resolution"

		./packer.sh $__name"-"$__resolution"px"

		rm -r $__name"-"$__resolution"px/"

	done

else

	__resolution="$1"

	./render.sh "$__resolution"

	./packer.sh $__name"-"$__resolution"px"

	rm -r $__name"-"$__resolution"px/"

fi

exit
