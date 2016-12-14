#!/bin/bash

__catalogue='catalogue.xml'

source ./conf/__functions.sh

for __range in $(__get_range $__catalogue ITEM); do

__read_range "$__catalogue" "$__range" > "/tmp/readrangetmp"
__get_value "/tmp/readrangetmp" NAME > "/tmp/nametmp"
__get_value "/tmp/readrangetmp" KEEP > "/tmp/keeptmp"

if [ "$(__get_value "/tmp/readrangetmp" KEEP)" = YES ]; then
	__get_value "/tmp/readrangetmp" NAME
fi

done

rm "/tmp/keeptmp" "/tmp/nametmp" "/tmp/readrangetmp"

exit
