#!/bin/bash

cp pack_template.mcmeta pack.mcmeta

sed -i 's/%RESOLUTION%/'"$1"'px/' pack.mcmeta

sed -i 's/%YEAR%/'"$(date -u +%Y)"'/' pack.mcmeta

exit
