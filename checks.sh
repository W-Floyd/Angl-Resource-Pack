#!/bin/bash
# checks.sh [-p] <SIZE>
#
# -p tells the script to assume all textures are present and current
#

if ! [ -z "$1" ]; then
	if [ "$1" = '-p' ]; then
		__pre_rendered="1"
		if ! [ -z "$2" ]; then
			__resolution="$2"
		else
			__resolution="128"
		fi
	else
		__resolution="$1"
		__pre_rendered="0"
	fi
else
	__resolution="128"
	__pre_rendered="0"
fi

if [ "$__pre_rendered" = "0" ]; then

./make-pack.sh "$__resolution"

fi

cd checks

for __script in $(ls -1 | grep '.sh'); do
	'./'$__script -p "$__resolution"
done

cd ../

exit
