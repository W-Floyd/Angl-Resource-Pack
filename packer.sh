#!/bin/bash

__pack="$1"
__packfile=$(echo "$__pack"".zip")

cd "${__pack}/"

zip -qZ store -r "$__packfile" ./

mv "$__packfile" ../"$__packfile"

cd ../

exit
