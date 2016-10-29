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

__preprocessed=0
__savework=0

if ! [ -z "$1" ]; then
	if [ "$1" = '-p' ]; then
		__preprocessed=1
		__savework=1
		__resolution="$2"
		
	elif [ "$1" = '-f' ]; then
		__savework=1
		__resolution="$2"
	else
		__resolution="$1"
	fi
else
	__resolution=128
fi

__directory=$(echo "${__pack_name}-${__resolution}px/")

if [ "$__preprocessed" = 0 ]; then

if ! [ -d $__tmp_directory ]; then
	mkdir $__tmp_directory
else
	rm -r $__tmp_directory
	mkdir $__tmp_directory
fi

fi

echo "Rendering ${__resolution}px"

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

if ! [ -z "$__config_script" ]; then
	cp $__config_script ./

	eval "$(echo '\./'"$(basename "$__config_script")" "$__tmp_res" "$(__get_value "$1" OPTIONS)")"

	rm $(basename "$__config_script")

fi


}

###############################################################
# Split all files into their own .xml records, unless told no
###############################################################

__tmppwd=$(pwd)

if [ "$__preprocessed" = 0 ]; then

for __range in $(__get_range $__catalogue ITEM); do
	__read_range "$__catalogue" "$__range" > $__tmp_directory"readrangetmp"
	__name=$(__get_value "${__tmp_directory}readrangetmp" NAME)
	__tmp_name=$(echo "${__tmp_directory}xml/${__name}.xml")
	mkdir -p "$(dirname "$__tmp_name")"
	__read_range "$__catalogue" "$__range" > "$__tmp_name"
done

rm $__tmp_directory"readrangetmp"

cd $__tmp_directory'xml/'

find "$(pwd)" | grep '\.xml' > ../listing

cd "$__tmppwd"

fi

###############################################################
# Set up working space
###############################################################

if ! [ -d "$__directory" ]; then
	mkdir "$__directory"
else
	if [ -a './'"$__directory"'hashes.xml' ]; then
		mv './'"$__directory"'hashes.xml' './hashes.xml'
	fi
fi

cp -r src/* "$__directory"

if [ -d './'"${__directory}"'conf/' ]; then
	rm -r './'"${__directory}"'conf/'
fi

cp -r conf/ './'"$__directory"

###############################################################
# Hash sources unless told not to
###############################################################

if [ "$__preprocessed" = 0 ]; then

###############################################################
# Record hashes in .xml record
###############################################################

for __config in $(cat $__tmp_directory'listing'); do

	__get_value "$__config" CLEANUP >> $__tmp_directory'tmpcleanup'
	__get_value "$__config" CONFIG | sed 's/^\.\///' >> $__tmp_directory'tmpcleanup_config'

done

cat $__tmp_directory'tmpcleanup' | sort | uniq > $__tmp_directory'tmpcleanup2'

cat $__tmp_directory'tmpcleanup_config' | sort | uniq > $__tmp_directory'tmpcleanup2_config'

rm $__tmp_directory'tmpcleanup'

echo '<HASHES>' > $__tmp_directory'tmpcleanuphashes2.xml'

for __source in $(cat $__tmp_directory'tmpcleanup2'); do

	echo '	<ITEM>' >> $__tmp_directory'tmpcleanuphashes2.xml'

	echo '		<NAME>'"$__source"'</NAME>' >> $__tmp_directory'tmpcleanuphashes2.xml'
	echo '		<HASH>'"$(md5sum './src/'$__source)"'</HASH>' >> $__tmp_directory'tmpcleanuphashes2.xml'
	echo '	</ITEM>' >> $__tmp_directory'tmpcleanuphashes2.xml'

done

for __source in $(cat $__tmp_directory'tmpcleanup2_config'); do

	echo '	<CONFIG>' >> $__tmp_directory'tmpcleanuphashes2.xml'

	echo '		<NAME>'"$__source"'</NAME>' >> $__tmp_directory'tmpcleanuphashes2.xml'
	echo '		<HASH>'"$(md5sum './'$__source)"'</HASH>' >> $__tmp_directory'tmpcleanuphashes2.xml'
	echo '	</CONFIG>' >> $__tmp_directory'tmpcleanuphashes2.xml'

done

echo '</HASHES>' >> $__tmp_directory'tmpcleanuphashes2.xml'

rm $__tmp_directory'tmpcleanup2'

rm $__tmp_directory'tmpcleanup2_config'

mv $__tmp_directory'tmpcleanuphashes2.xml' './hashes_new.xml'

fi

if ! [ -a './hashes.xml' ]; then

	echo '<HASHES>' > $__tmp_directory'tmpcleanuphashes2.xml'

	for __range in $(__get_range './hashes_new.xml' ITEM); do
		
		__read_range './hashes_new.xml' "$__range" > /tmp/__read_range
		__set_value '/tmp/__read_range' HASH ''
		cat '/tmp/__read_range' >> $__tmp_directory'tmpcleanuphashes2.xml'
		
	done
	
	for __range in $(__get_range './hashes_new.xml' CONFIG); do
		
		__read_range './hashes_new.xml' "$__range" > /tmp/__read_range
		__set_value '/tmp/__read_range' HASH ''
		cat '/tmp/__read_range' >> $__tmp_directory'tmpcleanuphashes2.xml'
		
	done
	
	echo '</HASHES>' >> $__tmp_directory'tmpcleanuphashes2.xml'
	
	rm '/tmp/__read_range'
	
	mv $__tmp_directory'tmpcleanuphashes2.xml' './hashes.xml'
	
fi

if [ "$(cat './hashes.xml' | md5sum)" = "$(cat './hashes_new.xml' | md5sum)" ]; then
	echo "No changes to sources"
fi

###############################################################
# Split hashes into separate .xml records
###############################################################

for __hash_name in $(echo 'hashes
hashes_new'); do

	if ! [ "$__preprocessed" = 1 -a "$__hash_name" = 'hashes_new' ]; then

	for __range in $(__get_range './'$__hash_name'.xml' ITEM); do
		__read_range './'$__hash_name'.xml' "$__range" > $__tmp_directory"readrangetmp"
		__name=$(__get_value "${__tmp_directory}readrangetmp" NAME)
		__tmp_name=$(echo "${__tmp_directory}${__hash_name}/${__name}.xml")
		mkdir -p "$(dirname "$__tmp_name")"
		mv $__tmp_directory"readrangetmp" "$__tmp_name"
	done
	
	for __range in $(__get_range './'$__hash_name'.xml' CONFIG); do
		__read_range './'$__hash_name'.xml' "$__range" > $__tmp_directory"readrangetmp"
		__name=$(__get_value "${__tmp_directory}readrangetmp" NAME)
		__tmp_name=$(echo "${__tmp_directory}${__hash_name}/${__name}.xml")
		mkdir -p "$(dirname "$__tmp_name")"
		mv $__tmp_directory"readrangetmp" "$__tmp_name"
	done
	
	cd "${__tmp_directory}${__hash_name}/"
	
	find | grep '\.xml' | sed 's/^\.\///' > "${__tmp_directory}${__hash_name}_listing"
	
	cd "$__tmppwd"
	
	fi

done

###############################################################
# Make sure hash .xml records exist for new files
###############################################################

for __hash in $(cat "${__tmp_directory}hashes_new_listing"); do
	if ! [ -a "${__tmp_directory}hashes/${__hash}" ]; then
		mkdir -p "$(dirname "${__tmp_directory}hashes/${__hash}")"
		cp "${__tmp_directory}hashes_new/${__hash}" "${__tmp_directory}hashes/${__hash}"
		__set_value "${__tmp_directory}hashes/${__hash}" HASH ''
	fi
done

###############################################################
# List source files that have been changed, added or removed
###############################################################

touch "${__tmp_directory}changed_source"
touch "${__tmp_directory}new_source"
touch "${__tmp_directory}unchanged_source"
touch "${__tmp_directory}rendered"
touch "${__tmp_directory}to_render"

for __xml in $(cat "${__tmp_directory}hashes_new_listing"); do
	if [ -a "${__tmp_directory}hashes/${__xml}" ]; then
		if ! [ -z "$(__get_value "${__tmp_directory}hashes/${__xml}" HASH)" ]; then
			if ! [ "$(__get_value "${__tmp_directory}hashes/${__xml}" HASH)" = "$(__get_value "${__tmp_directory}hashes_new/${__xml}" HASH)" ]; then
				echo './'"$(__get_value "${__tmp_directory}hashes/${__xml}" NAME)" >> "${__tmp_directory}changed_source"
			else
				echo './'"$(__get_value "${__tmp_directory}hashes/${__xml}" NAME)" >> "${__tmp_directory}unchanged_source"
			fi
		else
			echo './'"$(__get_value "${__tmp_directory}hashes/${__xml}" NAME)" >> "${__tmp_directory}new_source"
		fi
	else
		echo './'"$(__get_value "${__tmp_directory}hashes/${__xml}" NAME)" >> "${__tmp_directory}new_source"
	fi
done

for __xml in $(cat "${__tmp_directory}hashes_listing"); do
	if ! [ -a "${__tmp_directory}hashes_new/${__xml}" ]; then
		echo './'"$(__get_value "${__tmp_directory}hashes/${__xml}" NAME)" >> "${__tmp_directory}removed_source"
	fi
done

cat "${__tmp_directory}changed_source" | sed 's/^\.\///' > "${__tmp_directory}changed_source2"
cat "${__tmp_directory}new_source" | sed 's/^\.\///' > "${__tmp_directory}new_source2"
cat "${__tmp_directory}unchanged_source" | sed 's/^\.\///' > "${__tmp_directory}unchanged_source2"

###############################################################
# Getting to the right place
###############################################################

cd "$__directory"

###############################################################
# Determine files rendered, to render, re-render and remove
###############################################################

for __config in $(cat "${__tmp_directory}listing"); do
	if ! [ -z "$(__get_value "$__config" CLEANUP | grep -Fx "$(cat "${__tmp_directory}changed_source2")")" ]; then
		if [ -a "./$(__get_value "$__config" NAME)" ]; then
			rm "./$(__get_value "$__config" NAME)"
		fi
		echo "$__config" >> "${__tmp_directory}to_render"
	elif ! [ -z "$(__get_value "$__config" CLEANUP | grep -Fx "$(cat "${__tmp_directory}new_source2")")" ]; then
		if [ -a "./$(__get_value "$__config" NAME)" ]; then
			rm "./$(__get_value "$__config" NAME)"
		fi
		echo "$__config" >> "${__tmp_directory}to_render"
	elif ! [ -z "$(__get_value "$__config" CONFIG | grep -Fx "$(cat "${__tmp_directory}changed_source")")" ]; then
		if [ -a "./$(__get_value "$__config" NAME)" ]; then
			rm "./$(__get_value "$__config" NAME)"
		fi
		echo "$__config" >> "${__tmp_directory}to_render"
		for __config2 in $(cat "${__tmp_directory}listing"); do
			if ! [ -z "$(__get_value "$__config2" DEPENDS | grep -Fx $(__get_value "$__config" NAME))" ]; then
				if [ -a "./$(__get_value "$__config2" NAME)" ]; then
					rm "./$(__get_value "$__config2" NAME)"
				fi
				echo "$__config2" >> "${__tmp_directory}to_render"
			fi
		done
	else
		if [ -a "$(echo "$(__get_value "$__config" NAME)")" ]; then
			__get_value "${__config}" NAME >> "${__tmp_directory}rendered"
		else
			echo "$__config" >> "${__tmp_directory}to_render"
		fi
	fi
done

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
		echo '' > $__tmp_directory'tmpdeps2'
	fi
	
	grep -Fxv -f $__tmp_directory'rendered' $__tmp_directory'tmpdeps' > $__tmp_directory'tmpdeps2'
	
	if [ -z "$(cat $__tmp_directory'tmpdeps2')" ]; then
	
		echo "Processing ./$(__get_value $__config NAME)"
		
		__exec "$__config"
		
		__get_value "$__config" NAME >> $__tmp_directory'rendered'
	
	else
	
		echo "${__config}" >> $__tmp_directory'to_render'
	
	fi
	
	sed -i '1d' $__tmp_directory'to_render'
	
fi
	
done

###############################################################
# Remove non-keep and cleanup files
###############################################################

rm -r ./conf/

cd ../

if [ -d "$__directory"_cleaned ]; then
	rm -r "$(echo "$__directory" | sed 's/\/$//')_cleaned"
fi

cp -r "$__directory" "$(echo "$__directory" | sed 's/\/$//')_cleaned"

cd "$(echo "$__directory" | sed 's/\/$//')_cleaned"

for __config in $(cat $__tmp_directory'listing'); do
	if [ "$(__get_value $__config KEEP)" = NO ]; then
		if [ -a './'"$(__get_value $__config NAME)" ]; then
			rm './'"$(__get_value $__config NAME)"
		fi
	fi
	__get_value "$__config" CLEANUP >> "$__tmp_directory"'cleanup'
done

cat "$__tmp_directory"'cleanup' | sort | uniq > "$__tmp_directory"'cleanup2'

for __file in $(cat "$__tmp_directory"'cleanup2' | sort | uniq); do
	if [ -a './'"$__file" ]; then
		rm './'"$__file"
	fi
done

cd ../

if [ "$__savework" = 0 ]; then

rm -r "$__tmp_directory"

else

__verytemporary="$(dirname $__tmp_directory)/__verytemporary/"

mkdir "$__verytemporary"

cp "$__tmp_directory"listing "$__verytemporary"listing
cp -r "$__tmp_directory"hashes_new/ "$__verytemporary"
cp -r "$__tmp_directory"xml/ "$__verytemporary"
cp "$__tmp_directory"hashes_new_listing "$__verytemporary"hashes_new_listing

rm -r "$__tmp_directory"

cp -r "$__verytemporary" "$__tmp_directory"

rm -r "$__verytemporary"

fi

rm 'hashes.xml'

mv 'hashes_new.xml' 'hashes.xml'

mv 'hashes.xml' "$__directory"'hashes.xml'

__end_time=$(date +%s)

echo
echo "Rendered ${__resolution}px in $((__end_time-__start_time)) seconds"
echo

exit
