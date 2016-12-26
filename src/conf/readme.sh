#!/bin/bash

cp README_template.md README.md

sed -i '5s/.*/'"$(date -u +%Y-%m-%d_%H-%M-%S)"'/' README.md

sed -i '8s/.*/'"${1}x${1}px"'/' README.md

sed -i '29s/%YEAR%/'"$(date -u +%Y)"'/' README.md

exit
