#!/bin/bash

__pushd './assets/minecraft/textures/blocks/'

# TODO - Change cobblestone to have correct highlights, then use __multiscreen

__multiply 'stone.png' 'cobblestone_overlay.png' 'cobblestone.png'

__popd

exit
