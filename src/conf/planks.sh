#!/bin/bash

__pushd ./assets/minecraft/textures/blocks/

cp ../../../../colour_planks_"$2".png colour_planks_"$2".png

__multiply colour_planks_"$2".png planks_generic_overlay.png planks_"$2".png

rm colour_planks_"$2".png

__popd

exit
