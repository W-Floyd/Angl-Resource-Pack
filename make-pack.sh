#!/bin/bash

__name="Angl"

__pack_and_render () {
./render.sh "${3}${2}"

./packer.sh $1"-"$2"px_cleaned"

rm -r $1"-"$2"px_cleaned/"

mv $1"-"$2"px_cleaned.zip" $1"-"$2"px.zip"
}

if [ -z "$1" ]; then

	__seq=$(seq 5 9)
	
	for __size in $(echo "$__seq" | head -n 1); do
	
	__resolution=$(echo "2^"$__size | bc)
	
	__pack_and_render "$__name" "$__resolution"
	
	done

	for __size in $(echo "$__seq" | sed '1d'); do

		__resolution=$(echo "2^"$__size | bc)
		
		cp "./${__name}-$(echo '2^'$(echo "$__seq" | head -n 1) | bc)/hashes.xml" './hashes.xml'
		
		__pack_and_render -p "$__name" "$__resolution"

	done
	
	rm 'hashes.xml'

else

	__resolution="$1"

	__pack_and_render "$__name" "$__resolution"

fi

exit
