#!/bin/bash

# any_texture <SIZE> <FILE> <DEMO_NAME> <SPACING>
#            |unused|

__tile "${2}" 4x4 "./demos/${3}_${4}.png" "${4}"

exit
