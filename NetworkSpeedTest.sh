#!/bin/bash

dest=$1 # copy test file to this server
dest_port=$2
fs=$3   # size of test file

# by default
if [[ "$dest" = "" ]]; then dest="snaiffer@192.168.1.34"; fi
if [[ "$dest_port" = "" ]]; then dest_port="22"; fi
if [[ "$fs" = "" ]]; then fs=100; fi

tf="/tmp/testfile.bin"
tf_size=${fs}M

source /usr/lib/bash/general.sh

printf "Creating test file... "
dd if=/dev/zero of=$tf bs=$tf_size count=1 &> /dev/null
check_status

echo "Measuring network speed..."
begint=`date +%s` && \
scp -P$dest_port $tf $dest:/tmp/ && \
endt=`date +%s` && \
speed=`echo "scale=1; $fs/($endt - $begint)" | bc -l`
check_status

echo
echo "Speed: $speed MB/s"
echo
