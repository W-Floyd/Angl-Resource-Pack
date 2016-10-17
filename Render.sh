#!/bin/bash
# Will render the resource pack at the given resolution
# Or, if no inputs are given, 128x128px
# If you want to render only one image, specify the resolution,
# then the file, with no .png or .svg
#
# Will choose a .sh file over a .svg file of the same name
# It will also run any .sh files without an ~ignore~ tag
# It will not render any files with an ~ignore~ tag
# It will delete any ~ignore~ files once all work is done
# It will delete any .sh or .svg files once all work is done

NAME="Angl"

if ! [ -z $1 ]; then
	RES=$1
else
	RES=128
fi

DATE=$(date +%Y-%m-%d_%H-%M-%S)

DPI=$(echo "(90*"$RES")/128" | bc -l | rev | sed 's/0*//' | rev)

# quick or slow
# Not really much different, but it will become more apparent
# with larger image sets
MODE="slow"

if [ $MODE = "quick" ]; then
render () {
# DPI and FILE inputs
rsvg-convert -d $1 -p $1 $2 -o $(basename $2 .svg)".png"
}
elif [ $MODE = "slow" ]; then
render () {
# DPI and FILE inputs
inkscape --export-dpi=$1 --export-png $(basename $2 .svg)".png" $2
}
fi

if [ -z $2 ]; then
	ONLYFILE=0
else
	ONLYFILE=1
	RENDERFILE=$2
fi

EXPORT=$(echo $NAME"-"$RES"px/")

if [ -d $EXPORT ]; then
	rm -r $EXPORT
fi

cp -r src/ $EXPORT

cd $EXPORT

cd assets

recurse () {

for file in $(ls -1 *.{svg,sh} 2> /dev/null | grep -v "~ignore~" | rev | sed 's/.*\.//' | rev | sort | uniq); do

	if [ $ONLYFILE = 0 ]; then
		RENDERFILE=$file
	fi

	if [ $file = $RENDERFILE ]; then

		if ! [ -z $(ls -1 $file"."* | grep -o "\.sh") ]; then
			bash $file".sh" $RES
		else
			render $DPI $file".svg"
		fi

	fi
done

for image in $(ls -1 *.{svg,sh} 2> /dev/null); do
	rm $image
done

for ignore in $(ls -1 2> /dev/null | grep '~ignore~'); do
	rm $ignore
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

cp ../EXPORTREADME.md ./README.md

sed -i '5s/.*/'$DATE'/' README.md

if [ $ONLYFILE = 0 ]; then
	inkscape \
	--export-dpi=90 \
	--export-background=white \
	--export-background-opacity=1.0 \
	--export-png "pack.png" \
	"pack.svg"
fi
rm "pack.svg"

cd ../

exit
