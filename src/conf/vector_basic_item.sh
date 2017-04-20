#!/bin/bash

__pushd ./assets/minecraft/textures/items/

__vector_render "${1}" "${2}.svg"

__popd

exit
