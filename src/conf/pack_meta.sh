#!/bin/bash

cp pack_template.mcmeta pack.mcmeta

sed -i 's/%RESOLUTION%/'"$1"'px/' pack.mcmeta

sed -i 's/%YEAR%/'"$(date -u +%Y)"'/' pack.mcmeta

if git status &> /dev/null; then

    sed -i 's/%COMMIT%/ - r'"$(git log --format='%h' -- "${__src_dir}" | wc -l)"'/' pack.mcmeta

else

    sed -i 's/%COMMIT%//' pack.mcmeta

fi

exit
