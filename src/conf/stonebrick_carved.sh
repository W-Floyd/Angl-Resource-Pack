#!/bin/bash

__pushd ./assets/minecraft/textures/blocks/

__fade stonebrick_carved_overlay.png stonebrick_carved_overlay_.png 0.25

__overlay stone.png stonebrick_carved_overlay_.png stonebrick_carved_.png

__multiply stonebrick_carved_.png stonebrick_carved_overlay_.png stonebrick_carved.png

rm stonebrick_carved_overlay_.png stonebrick_carved_.png

__popd

exit
