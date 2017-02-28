#!/bin/bash

__pushd ./assets/minecraft/textures/blocks/

cp ../../../../colour_log_birch.png colour_log_birch.png

__overlay colour_log_birch.png log_birch_overlay.png log_birch.png

rm colour_log_birch.png

__popd

exit
