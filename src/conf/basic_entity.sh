#!/bin/bash

__pushd ./assets/minecraft/textures/entity/

__render "$1" "${2}.svg"

__popd

exit
