#!/bin/bash

__pushd './assets/minecraft/textures/blocks/'

__fade 'stonebrick_overlay.png' 'stonebrick_overlay_.png' '0.25'

__stack 'stonebrick_.png' 'stone.png' 'stonebrick_overlay_.png'

__multiply 'stonebrick_.png' 'stonebrick_overlay_.png' 'stonebrick.png'

rm 'stonebrick_overlay_.png' 'stonebrick_.png'

__popd

exit
