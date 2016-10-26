#!/bin/bash
# grass.sh [-p] <SIZE>
#
# -p tells the script to assume all textures are present and current
#

if ! [ -z "$1" ]; then
	if [ "$1" = '-p' ]; then
		__pre_rendered="1"
		if ! [ -z "$2" ]; then
			__resolution="$1"
		else
			__resolution="128"
		fi
	else
		__resolution="$1"
		__pre_rendered="0"
	fi
else
	__resolution="128"
	__pre_rendered="0"
fi

__texture1="assets/minecraft/textures/blocks/grass_side.png"
__texture1_name="$(basename "${__texture1}")"
__texture2="assets/minecraft/textures/blocks/dirt.png"
__texture2_name="$(basename "${__texture2}")"

cd ../

if [ "$__pre_rendered" = "0" ]; then
	./extract.sh "${__resolution}" "${__texture1}" "${__texture2}"
else
	./extract.sh "${__resolution}" -p "${__texture1}" "${__texture2}"
fi

mv "${__texture1_name}" "./checks/${__texture1_name}"
mv "${__texture2_name}" "./checks/${__texture2_name}"

cd checks

if [ -a "montage_dirt_and_grass.png" ]; then
	rm "montage_dirt_and_grass.png"
fi

if [ -a "montage_dirt_and_grass_.png" ]; then
	rm "montage_dirt_and_grass_.png"
fi

__imgseq1=$(for __tile1 in $(seq 1 3); do echo -n "${__texture1_name} "; done)
__imgseq2=$(for __tile2 in $(seq 1 6); do echo -n "${__texture2_name} "; done)

__imgseq=$(echo "${__imgseq1}${__imgseq2}")

montage -geometry +0+0 -tile 3x3 ${__imgseq} montage_dirt_and_grass.png 2> /dev/null
montage -geometry +1+1 -tile 3x3 ${__imgseq} montage_dirt_and_grass_.png 2> /dev/null

rm "${__texture1_name}"
rm "${__texture2_name}"

exit
