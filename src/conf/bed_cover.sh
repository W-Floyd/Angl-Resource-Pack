#!/bin/bash

__pushd ./assets/minecraft/textures/entity/bed/

__clip_src_in './bed_cover_cutout.png' "./bed_cover_base_${2}.png" './tmp_cover.png'

__multiply './tmp_cover.png' './bed_cover_cutout.png' "./bed_cover_${2}.png"

rm './tmp_cover.png'

__popd

exit
