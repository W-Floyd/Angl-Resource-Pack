#!/bin/bash

if [ "${1}" -lt "32" ]; then
    __limited_size="32"
elif [ "${1}" -gt "1024" ]; then
    __limited_size="1024"
else
    __limited_size="${1}"
fi

__vector_render "${__limited_size}" "./assets/minecraft/textures/gui/title/mojang.svg"

convert -size "$(identify -format "%w" "./assets/minecraft/textures/gui/title/mojang.png")x$(identify -format "%h" "./assets/minecraft/textures/gui/title/mojang.png")" "canvas:white" "./assets/minecraft/textures/gui/title/mojang_.png"
__overlay "./assets/minecraft/textures/gui/title/mojang_.png" "./assets/minecraft/textures/gui/title/mojang.png" "./assets/minecraft/textures/gui/title/mojang__.png"
rm "./assets/minecraft/textures/gui/title/mojang_.png"
mv "./assets/minecraft/textures/gui/title/mojang__.png" "./assets/minecraft/textures/gui/title/mojang.png"


exit
