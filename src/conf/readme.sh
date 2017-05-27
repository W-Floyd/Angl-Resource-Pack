#!/bin/bash

cp 'README_template.md' 'README.md'

sed -i 's/%DATE%/'"$(date -u +%Y-%m-%d\\\\_%H-%M-%S)\\\\_UTC"'/' 'README.md'

sed -i 's/%SIZE%/'"${1}x${1}px"'/' 'README.md'

sed -i 's/%YEAR%/'"$(date -u +%Y)"'/' 'README.md'

if git status &> /dev/null; then

    sed -i 's/%COMMIT%/'"$(git log --format='%h' -- "${__src_dir}" | head -n 1)"'/' 'README.md'

else

    sed -i 's/%COMMIT%/Unknown (out of repo render)/' 'README.md'

fi

exit
