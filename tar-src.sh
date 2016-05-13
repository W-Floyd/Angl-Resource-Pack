#!/bin/bash

if [ -a src.tar ]; then
	rm src.tar
fi

tar -cvlf ./src.tar ./src/

exit
