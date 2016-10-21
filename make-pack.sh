#!/bin/bash

__name="Angl"

__pack_and_render () {
./render.sh "$2"

./packer.sh $1"-"$2"px_cleaned"

rm -r $1"-"$2"px_cleaned/"

mv $1"-"$2"px_cleaned.zip" $1"-"$2"px.zip"
}

if [ -z "$1" ]; then

	for __size in $(seq 5 10); do

		__resolution=$(echo "2^"$__size | bc)

		__pack_and_render "$__name" "$__resolution"

	done

else

	__resolution="$1"

	__pack_and_render "$__name" "$__resolution"

fi

exit
