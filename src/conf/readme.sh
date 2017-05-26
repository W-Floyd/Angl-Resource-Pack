#!/bin/bash

cp README_template.md README.md

sed -i 's/%DATE%/'"$(date -u +%Y-%m-%d_%H-%M-%S)_UTC"'/' README.md

sed -i 's/%SIZE%/'"${1}x${1}px"'/' README.md

sed -i 's/%YEAR%/'"$(date -u +%Y)"'/' README.md

exit
