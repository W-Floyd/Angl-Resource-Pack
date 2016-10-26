#!/bin/bash
###############################################################
# ./tiler.sh <RESOLUTION> <IMAGE> <FORMAT>
#
# Example:
# ./tiler 128 assets/minecraft/textures/blocks/dirt.png 5x5
###############################################################

source ./conf/__functions.sh

__name="Angl"

__image="${2}"

./render.sh "${1}"

cd "${__name}-${1}px_cleaned"

__tile () {

__imgseq=$(for __tile in $(seq 1 "$(echo "$(echo ${2} | sed 's/x/\*/')" | bc)"); do echo -n "./${__image} "; done)
montage -geometry +0+0 -tile ${2} ${__imgseq} "${1}_montage" 2> /dev/null
montage -geometry +1+1 -tile ${2} ${__imgseq} "${1}_montage_" 2> /dev/null

mv "${1}_montage" "../$(basename ./$(__mext "${1}")_montage.png)"
mv "${1}_montage_" "../$(basename ./$(__mext "${1}")_montage_.png)"

}

__tile './'"${__image}" "${3}"

cd ../

rm -r "${__name}-${1}px_cleaned"

exit
