#!/bin/bash

DATE=$(date +%Y-%m-%d_%H-%M-%S)

./Make-Pack.sh

for file in $(ls -1 *.zip); do
	mv $file ../Angl-Resource-Pack-Export/$file
done

cd ../Angl-Resource-Pack-Export

sed -i '3s/.*/'$DATE'/' README.md

git add *

git commit -m ""$DATE""

git push

cd ../Angl-Resource-Pack

exit
