#!/bin/bash

cd ./assets/minecraft/textures/blocks/

__overlay stone.png stonebrick_overlay.png stonebrick_.png

__multiply stonebrick_.png stonebrick_overlay.png stonebrick.png

rm stonebrick_.png

cd ../../../../

exit
