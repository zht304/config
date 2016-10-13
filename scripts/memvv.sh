#!/bin/bash

pid=`pgrep -x $1`
echo $1":"$pid
if [ -n $2 ]
then
    interval=5
else
    interval=$2
fi
echo "interval="$interval

suffix=`date +%y_%m_%d_%H%M%S`
while true
      do
          top -b -c -n1 -p $pid | grep $1 >> mem_$suffix.log
          sleep $interval
done

