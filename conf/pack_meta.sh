#!/bin/bash

sed -i 's/\$RESOLUTION\$/'"$1"'px/' pack.mcmeta

exit
