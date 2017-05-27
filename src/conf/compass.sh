#!/bin/bash

__pushd './assets/minecraft/textures/items/'

__rotate_exact './compass_movement.png' "./${2}.png" "$(echo "${2}/32" | bc -l)"

__stack "./compass_${2}.png" './compass_background.png' "./${2}.png" './compass_cover.png'

rm "./${2}.png"

__popd

exit
