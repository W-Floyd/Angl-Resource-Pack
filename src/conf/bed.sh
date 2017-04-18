#!/bin/bash

__pushd ./assets/minecraft/textures/entity/bed/

__overlay './bed_plank.png' './bed_wood.png' './tmp1.png'

__overlay './tmp1.png' "./bed_cover_${2}.png" './tmp2.png'

__overlay './tmp2.png' "./bed_decal.png" "./${2}.png"

rm './tmp1.png' './tmp2.png'

__popd

exit
