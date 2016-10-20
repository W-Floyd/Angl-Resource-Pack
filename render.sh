#!/bin/bash

###############################################################
# Will render the resource pack at the given resolution
# Or, if no inputs are given, 128px
###############################################################
# Set up variables
###############################################################

__start_time=$(date +%s)

__pack_name="Angl"

__tmp_directory='/tmp/texpack/'

__catalogue='catalogue.xml'

if ! [ -z "$1" ]; then
	__resolution="$1"
else
	__resolution=128
fi

__directory=$(echo "${__pack_name}-${__resolution}px/")

if ! [ -d $__tmp_directory ]; then
	mkdir $__tmp_directory
else
	rm -rf $__tmp_directory
	mkdir $__tmp_directory
fi

###############################################################
# Set up functions
###############################################################

source ./conf/__functions.sh

###############################################################
#
# __exec <XML>
#
# Execute
# To be used later
#
###############################################################

__exec () {
if [ -z "$(__get_value $1 SIZE)" ]; then
	__tmp_res=$__resolution
else
	__tmp_res="$(__get_value $1 SIZE)"
fi

__config_script="$(__get_value $1 CONFIG)"
cp $__config_script ./

eval "$(echo '\./'"$(basename "$__config_script")" "$__tmp_res" "$(__get_value "$1" OPTIONS)")"

rm $(basename "$__config_script")
}

###############################################################
# Split all files into their own .xml records
###############################################################

for __range in $(__get_range $__catalogue ITEM); do
	__read_range "$__catalogue" "$__range" > $__tmp_directory"readrangetmp"
	__name=$(__get_value "${__tmp_directory}readrangetmp" NAME)
	__tmp_name=$(echo "${__tmp_directory}xml/${__name}.xml")
	mkdir -p "$(dirname "$__tmp_name")"
	__read_range "$__catalogue" "$__range" > "$__tmp_name"
done

rm $__tmp_directory"readrangetmp"

__tmppwd=$(pwd)

cd $__tmp_directory'xml/'

find "$(pwd)" | grep '\.xml' > ../listing

cp ../listing ../to_render

touch ../rendered

cd "$__tmppwd"

###############################################################
# Set up working space
###############################################################

if [ -d "$__directory" ]; then
	rm -r $__directory
fi

cp -r src/ "$__directory"

cp -r conf/ './'"$__directory"

cd "$__directory"

###############################################################
# Start rendering
###############################################################

__should_exit=0

while [ "$__should_exit" = 0 ]; do

if [ -z "$(cat "$__tmp_directory"'to_render')" ]; then

	__should_exit=1
	
else
	__config=$(cat $__tmp_directory'to_render' | head -n 1)
	
	__get_value $__config DEPENDS | sed 's/^$//' > $__tmp_directory'tmpdeps'
	
	if [ -a $__tmp_directory'tmpdeps2' ]; then
		rm $__tmp_directory'tmpdeps2'
	fi
	
	grep -Fxv -f $__tmp_directory'rendered' $__tmp_directory'tmpdeps' > $__tmp_directory'tmpdeps2'
	
	if [ -z "$(cat $__tmp_directory'tmpdeps2')" ]; then
	
		echo "Processing ./$(__get_value $__config NAME)"
		
		__exec "$__config"
		
		__get_value $__config NAME >> $__tmp_directory'rendered'
	
	else
	
		echo $__config >> $__tmp_directory'to_render'
	
	fi
	
	sed -i '1d' $__tmp_directory'to_render'
	
fi
	
done

###############################################################
# Remove non-keep and cleanup files
###############################################################

for __config in $(cat $__tmp_directory'listing' | grep '\.xml'); do
	if [ "$(__get_value $__config KEEP)" = NO ]; then
		rm './'"$(__get_value $__config NAME)"
	fi
	__get_value "$__config" CLEANUP >> "$__tmp_directory"'cleanup'
done

cat "$__tmp_directory"'cleanup' | sort | uniq > "$__tmp_directory"'cleanup2'

for __file in $(cat "$__tmp_directory"'cleanup2' | sort | uniq); do
	rm './'"$__file"
done

rm -rf ./conf/

rm -rf "$__tmp_directory"

cd ../

__end_time=$(date +%s)

echo
echo
echo "Rendered in $((__end_time-__start_time)) seconds"

exit
