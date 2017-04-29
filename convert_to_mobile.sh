#!/bin/bash

################################################################################
# __mvf <SOURCE> <DEST>
#
# Move File
# Same as mv, but will fail silently if the file does not exist.
#
################################################################################

__mvf () {
if [ -e "${1}" ]; then
    if ! [ -d "$(dirname "${2}")" ]; then
        mkdir -p "$(dirname "${2}")"
    fi
    mv "${1}" "${2}"
fi
}

################################################################################
# __mvd <SOURCE> <DEST>
#
# Move Directory
# Same as mv, but will fail silently if the directory does not exist.
#
################################################################################

__mvd () {
if [ -d "${1}" ]; then
    if ! [ -d "$(dirname "${2}")" ]; then
        mkdir -p "$(dirname "${2}")"
    fi
    mv "${1}" "${2}"
fi
}

################################################################################

__mvf 'pack.png' 'pack_icon.png'

mv './assets/minecraft/textures/' './textures/'

################################################################################

__pushd './textures/items/'

################################################################################
# Clock/Watch
################################################################################

__tmp () {
for __file in $(echo clock_{00..63}.png); do
    if ! [ -e "${__file}" ]; then
        return 1
    fi
done
return 0
}

if __tmp; then
    __custom_tile $(echo clock_{00..63}.png) 1x64 0 'watch_atlas.png'
fi

for __file in $(echo clock_{00..63}.png); do
    if [ -e "${__file}" ]; then
        rm "${__file}"
    fi
done

################################################################################
# Compass
################################################################################

__tmp () {
for __file in $(echo compass_{00..31}.png); do
    if ! [ -e "${__file}" ]; then
        return 1
    fi
done
return 0
}

if __tmp; then
    __custom_tile $(echo compass_{00..31}.png) 1x64 0 'compass_atlas.png'
fi

for __file in $(echo compass_{00..31}.png); do
    if [ -e "${__file}" ]; then
        rm "${__file}"
    fi
done

################################################################################

__popd

################################################################################

rm -r './textures/gui/title/'

################################################################################

__uuid="$(uuidgen)"

echo "{
  \"header\": {
    \"pack_id\": \"${__uuid}\",
    \"name\": \"Angl\",
    \"packs_version\": \"0.0.1\",
    \"description\": \"A vector resource pack\",
    \"modules\": [
      {
        \"description\": \"A vector resource pack\",
        \"version\": \"0.0.1\",
        \"uuid\": \"${__uuid}\",
        \"type\": \"resources\"
      }
    ]
  }
}" > pack_manifest.json

echo "{
   \"format_version\" : 1,
   \"header\" : {
      \"description\" : \"A vector resource pack\",
      \"name\" : \"Angl\",
      \"uuid\" : \"$(uuidgen)\",
      \"version\" : [ 0, 0, 1 ]
   },
   \"modules\" : [
      {
         \"description\" : \"A vector resource pack\",
         \"type\" : \"resources\",
         \"uuid\" : \"$(uuidgen)\",
         \"version\" : [ 0, 0, 1 ]
      }
   ]
}" > manifest.json

exit
