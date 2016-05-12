#!/bin/bash
# Will render the resource pack at the given resolution
# Or, if no inputs are given, 128x128px
# If you want to render only one image, specify the resolution,
# then the file, with no .png or .svg

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
	RENDERFILE=$(echo $2".svg")
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
	if [ $ONLYFILE = 0 ]; then
		RENDERFILE=$image
	fi

	if [ $image = $RENDERFILE ]; then

		if [ -z $(echo $image | grep -o "~ignore~") ]; then

			if [ -a $(echo $(basename $image .svg)".sh") ]; then
				bash $(echo $(basename $image .svg)".sh") $RES
				rm $(echo $(basename $image .svg)".sh")
			else
				if ! [ -a $(echo $(basename $image .svg)".png") ]; then
					render $DPI $image
				fi
			fi

		fi

	fi
done

for image in $(ls *.svg 2> /dev/null); do
	rm $image
done

for script in $(ls *.sh 2> /dev/null); do
	rm $script
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
	render 90 "pack.svg"
fi
rm "pack.svg"

cd ../

exit
