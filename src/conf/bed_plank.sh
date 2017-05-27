#!/bin/bash

__pushd './assets/minecraft/textures/entity/bed/'

__clip_src_in './bed_plank_cutout.png' './bed_base_plank.png' './tmp_plank.png'

__multiply './tmp_plank.png' './bed_plank_cutout.png' './bed_plank.png'

rm './tmp_plank.png'

__popd

exit
