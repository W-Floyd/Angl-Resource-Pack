#!/bin/bash

__pushd './assets/minecraft/textures/entity/bed/'

__stack "./${2}.png" './bed_plank.png' './bed_wood.png' "./bed_cover_${2}.png" "./bed_decal.png"

__popd

exit
