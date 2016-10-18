#!/bin/bash

testfunction () {
echo test
}

testfunction2 () {
echo test
}

compgen -A function

for __function in $(compgen -A function); do
export -f $__function
done

./test2.sh

exit
