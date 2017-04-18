#!/bin/bash

__pushd ./assets/minecraft/textures/entity/bed/

__clip_src_in './bed_plank_cutout.png' './bed_base_plank.png' './tmp_cover.png'

__multiply './tmp_cover.png' './bed_plank_cutout.png' './bed_plank.png'

rm './tmp_cover.png'

__popd

exit
