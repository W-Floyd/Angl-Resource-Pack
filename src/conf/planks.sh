#!/bin/bash

__pushd './assets/minecraft/textures/blocks/'

__multiply "../../../../colour_planks_${2}.png" 'planks_generic_overlay.png' "planks_${2}.png"

__popd

exit
