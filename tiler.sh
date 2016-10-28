#!/bin/bash
###############################################################
# ./tiler.sh <RESOLUTION> <IMAGE> <GRID>
#
# Example:
# ./tiler 128 assets/minecraft/textures/blocks/dirt.png 5x5
###############################################################

source ./conf/__functions.sh

__name="Angl"

__image="${2}"

./make-pack.sh "${1}"

cd "${__name}-${1}px_cleaned"

__tile './'"${__image}" "${3}" "../$(__mext "$(basename "$__image")")_montage.png"
__tile './'"${__image}" "${3}" "../$(__mext "$(basename "$__image")")_montage_.png" 1

cd ../

rm -r "${__name}-${1}px_cleaned"

exit
