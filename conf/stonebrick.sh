#!/bin/bash

cd ./assets/minecraft/textures/blocks/

__fade stonebrick_overlay.png stonebrick_overlay_.png 0.375

__overlay stone.png stonebrick_overlay_.png stonebrick_.png

__multiply stonebrick_.png stonebrick_overlay_.png stonebrick.png

rm stonebrick_overlay_.png

rm stonebrick_.png

cd ../../../../

exit
