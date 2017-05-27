#!/bin/bash

__pushd './assets/minecraft/textures/blocks/'

__clip_src_in 'ladder_overlay.png' '../../../../colour_planks_oak.png' 'ladder_.png'

__multiply 'ladder_.png' 'ladder_overlay.png' 'ladder.png'

rm 'ladder_.png'

__popd

exit
