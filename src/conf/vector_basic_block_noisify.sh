#!/bin/bash

# vector_any_texture_noisify <SIZE> <IMAGE> <FADE_LEVEL>

__fade noise.png "./assets/minecraft/textures/blocks/${2}_noise.png" "${3}"

__pushd './assets/minecraft/textures/blocks/'

__vector_render "${1}" "${2}.svg"

__clip_dst_in "${2}_noise.png" "${2}.png" "${2}__noise.png"

mv "${2}__noise.png" "${2}_noise.png"

__stack "${2}__.png" "${2}.png" "${2}_noise.png"

mv "${2}__.png" "${2}.png"

rm "${2}_noise.png"

__popd

exit
