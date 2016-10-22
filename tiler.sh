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

__imgseq=$(for __tile in $(seq 1 "$(echo "$(echo ${3} | sed 's/x/\*/')" | bc)"); do echo -n "./${__image} "; done)
montage -geometry +0+0 -tile ${3} ${__imgseq} "./${__image}_montage" 2> /dev/null
montage -geometry +1+1 -tile ${3} ${__imgseq} "./${__image}_montage_" 2> /dev/null

mv "./${__image}_montage" "../$(basename ./$(__mext "${__image}")_montage.png)"
mv "./${__image}_montage_" "../$(basename ./$(__mext "${__image}")_montage_.png)"

cd ../

rm -r "${__name}-${1}px_cleaned"

exit
