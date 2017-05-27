#!/bin/bash

__pushd './assets/minecraft/textures/blocks/'

__multiscreen "../../../../colour_${2}.png" './concrete_generic_overlay.png' "./concrete_${2}.png"

__popd

exit
