#!/bin/bash
./wfb_tx -X $1 -c 161 -p 0 -u 5600 -R 456000 -K ./drone.key -B 20 -M 1 -S 0 -L 0 -G long -k 8 -n 12 -T 0 -i 7669206 -f data wlo1mon
