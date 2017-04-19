#!/bin/bash

__pushd ./assets/minecraft/textures/blocks/

cp "../../../../colour_${2}.png" "./colour_${2}.png"

__overlay "./colour_${2}.png" './concrete_powder_generic_overlay.png' "./concrete_powder_${2}.png"

rm "./colour_${2}.png"

__popd

exit
