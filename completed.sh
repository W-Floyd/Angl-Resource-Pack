#!/bin/bash

__un_named='0'
__catalogue='catalogue.xml'

source functions.sh

for __range in $(__get_range "${__catalogue}" ITEM); do

__read_range "${__catalogue}" "${__range}" > "/tmp/readrangetmp"
__get_value "/tmp/readrangetmp" KEEP > "/tmp/keeptmp"

touch "/tmp/keeptmp" "/tmp/readrangetmp" "/tmp/commontmp" "/tmp/nametmp"

if [ "$(__get_value "/tmp/readrangetmp" KEEP)" = 'YES' ]; then

	__common="$(__get_value "/tmp/readrangetmp" COMMON)"

	if ! [ -z "${__common}" ]; then
	    echo "${__common}" >> "/tmp/commontmp"
	else
	    __get_value "/tmp/readrangetmp" NAME >> "/tmp/nametmp"
	    __un_named="$(echo "${__un_named}+1" | bc)"
	fi
fi

done

echo "Completed features are:

$(cat "/tmp/commontmp" | sort | uniq)

as well as ${__un_named} un-named items, with raw values:

$(cat "/tmp/nametmp" | sort)"

rm "/tmp/keeptmp" "/tmp/readrangetmp" "/tmp/commontmp" "/tmp/nametmp"

exit
