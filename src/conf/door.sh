#!/bin/bash

# __base is the base colour to use
# __overlay1 is the image to clip to, and to multiply with
# __overlay2 is multiscreened over the result
# __fade_level is the level to fade __overlay2 to before use
# __decal is straight overlayed on top of it all
# __output is the file to write the final image to

case "${2}" in
    "wood")
        __base='./colour_planks_oak.png'
        __overlay1='./assets/minecraft/textures/blocks/door_wood_overlay.png'
        __overlay2='./assets/minecraft/textures/blocks/door_overlay_plank.png'
        __fade_level='1'
        __decal='./assets/minecraft/textures/blocks/door_wood_decal.png'
        __output='./assets/minecraft/textures/blocks/door_wood.png'
        ;;
    "birch")
        __base='./colour_planks_birch.png'
        __overlay1=''
        __overlay2='./assets/minecraft/textures/blocks/door_overlay_plank.png'
        __fade_level='1'
        __decal=''
        ;;
    "acacia")
        __base='./colour_planks_acacia.png'
        __overlay1=''
        __overlay2='./assets/minecraft/textures/blocks/door_overlay_plank.png'
        __fade_level='1'
        __decal=''
        ;;
    "jungle")
        __base='./colour_planks_jungle.png'
        __overlay1=''
        __overlay2='./assets/minecraft/textures/blocks/door_overlay_plank.png'
        __fade_level='1'
        __decal=''
        ;;
    "spruce")
        __base='./colour_planks_spruce.png'
        __overlay1=''
        __overlay2='./assets/minecraft/textures/blocks/door_overlay_plank.png'
        __fade_level='1'
        __decal=''
        ;;
    "dark_oak")
        __base='./colour_log_big_oak.png'
        __overlay1='./assets/minecraft/textures/blocks/door_dark_oak_overlay.png'
        __overlay2='./assets/minecraft/textures/blocks/door_overlay_log.png'
        __fade_level='1'
        __decal='./assets/minecraft/textures/blocks/door_dark_oak_decal.png'
        __output='./assets/minecraft/textures/blocks/door_dark_oak.png'
        ;;
    "iron")
        __base='./colour_silver.png'
        __overlay1=''
        __overlay2=''
        __fade_level='1'
        __decal=''
        ;;
esac

__tile "${__base}" 1x2 'base.png'

__clip_src_in "${__overlay1}" 'base.png' 'door_cutout.png'

rm 'base.png'

__multiply 'door_cutout.png' "${__overlay1}" 'door_multiplied.png'

rm 'door_cutout.png'

__fade "${__overlay2}" 'overlay2.png' "${__fade_level}"

__clip_src_in "${__overlay1}" 'overlay2.png' 'door_overlay.png'

rm 'overlay2.png'

__multiscreen 'door_multiplied.png' 'door_overlay.png' 'door_multiplied_2.png'

rm 'door_overlay.png'

mv 'door_multiplied_2.png' 'door_multiplied.png'

__stack "${__output}" 'door_multiplied.png' "${__decal}"

rm 'door_multiplied.png'

exit
