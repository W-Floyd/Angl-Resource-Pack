#!/bin/bash

__pushd ./assets/minecraft/textures/entity/bed/

__tile "../../../../../colour_${2}.png" 4x4 "./bed_cover_base_${2}.png"

__popd

exit
