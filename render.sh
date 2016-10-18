#!/bin/bash
#set -x
#trap read debug

#
# NEED TO CHECK __get_value
#
###############################################################
# Will render the resource pack at the given resolution
# Or, if no inputs are given, 128px
###############################################################
# Set up variables
###############################################################

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
# Split all files into their own .xml records
###############################################################

for __range in $(__get_range $__catalogue ITEM); do
	__read_range "$__catalogue" "$__range" > $__tmp_directory"readrangetmp"
	__name=$(__get_value "${__tmp_directory}readrangetmp" NAME)
	__tmp_name=$(echo "${__tmp_directory}xml/${__name}\.xml")
	mkdir -p "$(dirname "$__tmp_name")"
	__read_range "$__catalogue" "$__range" > "$__tmp_name"
done

rm $__tmp_directory"readrangetmp"

__tmppwd=$(pwd)

cd $__tmp_directory'xml/'

find "$(pwd)" | grep '\.xml' > ../listing

touch ../rendered

cd "$__tmppwd"

###############################################################
# Set up working space
###############################################################

cp -r src/ "$__directory"

cp -r conf/ './'"$__directory"

cd "$__directory"

###############################################################
# Start rendering
###############################################################

until [ "$(cat "$__tmp_directory"'listing' | sha1sum | sed 's/ .*//')" = "$(cat "$__tmp_directory"'rendered' | sha1sum | sed 's/ .*//')" ]; do

for __config in $(cat "$__tmp_directory"'listing' | grep '\.xml'); do
	if ! [ -z "$(__get_value "$__config" DEPENDS)" ]; then
		break
	fi
	__name="$(__get_value "$__config" NAME)"
	__config_script="$(__get_value "$__config" CONFIG)"
	cp "$__config_script" ./
	__tmp_resolution="$(__get_value "$__config" SIZE)"
	if [ -z "$__tmp_resolution" ]; then
		__tmp_resolution="$__resolution"
	fi
	eval "$(echo '\./'"$(basename $__config_script)" "$__tmp_resolution" "$(__get_value $__config OPTIONS)")"
	echo "$__name" >> "$__tmp_directory"'rendered'
	rm "$(basename "$__config_script")"
	for __config2 in $(cat "$__tmp_directory"'listing'); do
		__set_value "$__config2" DEPENDS "$(__get_value "$__config2" DEPENDS | sed 's/'"$__name"'//')"
	done
done

done

###############################################################
# Remove non-keep and cleanup files
###############################################################

for __config in $(cat $__tmp_directory'listing' | grep '\.xml'); do
	if [ "$(__get_value $__config KEEP)" = NO ]; then
		rm '\./'"$(__get_value $__config NAME)"
	fi
	__get_value "$__config" CLEANUP >> "$__tmp_directory"'cleanup'
done

for __file in $(cat "$__tmp_directory"'cleanup' | sort | uniq); do
	rm '\./'"$__file"
done

rm -rf ./conf/

rm -rf "$__tmp_directory"

cd ../

exit
