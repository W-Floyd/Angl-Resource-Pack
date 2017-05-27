#!/bin/bash

__pushd './assets/minecraft/textures/blocks/'

__multiply "../../../../colour_log_${2}.png" "log_generic_overlay.png" "log_${2}.png"

__popd

exit
