#!/bin/bash

__pushd ./assets/minecraft/textures/blocks/

cp "../../../../colour_${2}.png" "./colour_${2}.png"

__multiply "./colour_${2}.png" './concrete_generic_overlay.png' "./concrete_${2}.png"

rm "./colour_${2}.png"

__popd

exit
