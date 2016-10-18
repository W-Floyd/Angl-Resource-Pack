#!/bin/bash
###############################################################
# Will render the resource pack at the given resolution
# Or, if no inputs are given, 128px
###############################################################
# Set up variables
###############################################################

__pack_name="Angl"

__tmp_directory='/tmp/texpack/'

__catalogue='catalogue.xml'

if ! [ -z $1 ]; then
	__resolution=$1
else
	__resolution=128
fi

__directory=$(echo $__pack_name"-"$__resolution"px/")

cp -r src/ $__directory

if ! [ -d $__tmp_directory ]; then
	mkdir /tmp/texpack/
fi

###############################################################
# Set up functions
###############################################################

source ./conf/__functions.sh

###############################################################
# Set up working space
###############################################################



###############################################################
# Split all files into their own .xml records
###############################################################

for __range in $(__get_range $__catalogue ITEM); do
	__name=$(__get_value "$(__read_range $__catalogue $__range)" NAME)
	__tmp_name=$(echo $__tmp_directory""$__name".xml")
	mkdir -p $(dirname $__tmp_name)
	__read_range $__catalogue $__range > $__tmp_name
done

###############################################################
# 
###############################################################



exit
