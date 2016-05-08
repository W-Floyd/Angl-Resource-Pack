#!/bin/bash

PACK=$1
PACKFILE=$(echo $PACK".zip")

cd $PACK"/"

zip -r $PACKFILE ./

mv $PACKFILE ../$PACKFILE

cd ../

exit
