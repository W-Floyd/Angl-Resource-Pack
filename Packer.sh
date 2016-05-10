#!/bin/bash

PACK=$1
PACKFILE=$(echo $PACK".zip")

cd $PACK"/"

zip -Z store -r $PACKFILE ./

mv $PACKFILE ../$PACKFILE

cd ../

exit
