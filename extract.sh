#!/bin/bash

__name="Angl"

__size="${1}"

if [ "${2}" = '-p' ]; then
	__pre_rendered='1'
else
	__pre_rendered='0'
fi

if [ "${__pre_rendered}" = '1' ]; then

	__files="$(echo "$@" | sed 's/ /\n/g' | sed '1,2d')"
	
else

	__files="$(echo "$@" | sed 's/ /\n/g' | sed '1d')"
	
fi

if [ "${__pre_rendered}" = '0' ]; then

	./make-pack.sh "${__size}"
	
fi

cd "${__name}-${__size}px"

for __file in $(echo "${__files}"); do

	cp "./${__file}" "../$(basename "${__file}")"
	
done

cd ../

exit
