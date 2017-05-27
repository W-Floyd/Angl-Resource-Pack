#!/bin/bash

__pushd './assets/minecraft/textures/entity/bed/'

__clip_src_in './bed_wood_cutout.png' './bed_base_wood.png' './tmp_cover.png'

__multiply './tmp_cover.png' './bed_wood_cutout.png' './bed_wood.png'

rm './tmp_cover.png'

__popd

exit
