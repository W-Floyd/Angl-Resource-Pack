#!/bin/bash

bash Make-Pack.sh


for file in $(ls -1 *.zip); do
	mv $file ../Angl-Resource-Pack-Export/$file
done

cd ../Angl-Resource-Pack-Export

for file in $(ls -1); do
	git add $file
done

git commit -m ""$(date +%Y-%m-%d_%H-%M-%S)""

git push

cd ../Angl-Resource-Pack

exit
