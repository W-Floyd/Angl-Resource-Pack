#!/bin/bash

# overlay.sh <SIZE> <BASE> <OVERLAY> <OUTPUT> <FADE>
#           |      |                         /      \
#           |unused|                        |optional|
#
# Overlays two images, optionally with the overlay faded by the
# amount specified in option 5.

if [ -z "${5}" ]; then

    __stack "${4}.png" "${2}.png" "${3}.png"

else

    __fade "${3}.png" "_${4}.png" "${5}"

    __stack "${4}.png" "${2}.png" "_${4}.png"

    rm "_${4}.png"

fi

exit
