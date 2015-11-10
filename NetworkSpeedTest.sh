#!/bin/bash

source /usr/lib/lib_bash_general/lib_bash_general.sh

fs=100
dest="snaiffer@192.168.1.34"
tf="/tmp/testfile.bin"
tf_size="100M"

printf "Creating test file... "
dd if=/dev/zero of=$tf bs=$tf_size count=1 &> /dev/null
check_status

echo "Establishing connection without password requiest... "
ssh-keygen
ssh-copy-id $dest
check_status

echo "Measuring network speed..."
begint=`date +%s` && \
scp $tf $dest:/tmp/ && \
endt=`date +%s` && \
speed=`echo "scale=1; $fs/($endt - $begint)" | bc -l`
check_status

printf "Tideing up... "
rm -f $tf && \
ssh $dest rm -f $tf
check_status

echo
echo "Speed: $speed MB/s"
echo
