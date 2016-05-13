#!/bin/bash

while true; do
	inotifywait -qq -r -e modify,attrib,close_write,move,create,delete ./src/
	bash Tar-src.sh &> /dev/null
	echo "src.tar updated"
done

exit
