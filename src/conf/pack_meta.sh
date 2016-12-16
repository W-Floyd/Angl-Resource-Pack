#!/bin/bash

cp pack_template.mcmeta pack.mcmeta

sed -i 's/%RESOLUTION%/'"$1"'px/' pack.mcmeta

sed -i 's/%YEAR%/'"$(date +%Y)"'/' pack.mcmeta

exit
