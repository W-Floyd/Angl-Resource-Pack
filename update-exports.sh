#!/bin/bash

if ! [ -d '../Angl-Resource-Pack-Export' ]; then
    echo "Export dir does not exist."
    exit 1
fi

__date="$(date +%Y-%m-%d_%H-%M-%S)"

./make-pack.sh

for __file in $(ls -1 *.zip); do
	cp "${__file}" "../Angl-Resource-Pack-Export/${__file}"
done

cd ../Angl-Resource-Pack-Export

sed -i '3s/.*/'"${__date}"'/' README.md

git add *

git commit -m "${__date}"

git push

git tag -a "${__date}" -m "Exports updated at ${__date}"

git push --tags

cd ../Angl-Resource-Pack

exit
