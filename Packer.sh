#!/bin/bash

pack=$1
packfile=$(echo $PACK".zip")

cd $pack"/"

zip -Z store -r $packfile ./

mv $packfile ../$packfile

cd ../

exit
