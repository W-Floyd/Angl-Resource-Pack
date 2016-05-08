#!/bin/bash

PACK=$1
PACKFILE=$(echo $PACK".zip")

cd $PACK"/"

zip -9 -r $PACKFILE ./

mv $PACKFILE ../$PACKFILE

cd ../

exit
