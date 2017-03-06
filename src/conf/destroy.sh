#!/bin/bash

__pushd ./assets/minecraft/textures/blocks/

__vector_render "${1}" "destroy_stage_${2}.svg"

__fade "destroy_stage_${2}.png" "destroy_stage_${2}_.png" 0.25

mv "destroy_stage_${2}_.png" "destroy_stage_${2}.png"

__popd

exit
