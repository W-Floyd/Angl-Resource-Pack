#!/bin/bash
# Will render the resource pack at the given resolution
# Or, if no inputs are given, 128x128px.

NAME="Angl"

if ! [ -z $1 ]; then
	RES=$1
else
	RES=128
fi

EXPORT=$(echo $NAME"-"$RES"px/")

if [ -d $EXPORT ]; then
	rm -r $EXPORT
fi

cp -r src/ $EXPORT

cd $EXPORT

cd assets

recurse () {

for image in $(ls *.svg 2> /dev/null); do
	inkscape \
	--export-dpi=$(echo "(90*"$RES")/128" | bc) \
	--export-png \
	$(basename $image .svg)".png" $image
	rm $image
done

for dir in $(ls -d ./*/ 2> /dev/null); do
	cd $dir
	recurse
	cd ../
done

}

recurse

cd ../

cat pack.mcmeta | sed 's/\$RESOLUTION\$/'$RES'px/' > tmp_pack.mcmeta
rm pack.mcmeta
mv tmp_pack.mcmeta pack.mcmeta

inkscape --export-png "pack.png" "pack.svg"
rm "pack.svg"

cd ../

exit
