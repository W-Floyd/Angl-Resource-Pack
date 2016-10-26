#!/bin/bash

__name="Angl"

__size="${1}"

__files="$(echo "$@" | sed 's/ /\n/g' | sed '1d')"

./make-pack.sh "${__size}"

cd "${__name}-${__size}px"

for __file in $(echo "${__files}"); do

	cp "./${__file}" "../$(basename "${__file}")"
	
done

cd ../

exit
