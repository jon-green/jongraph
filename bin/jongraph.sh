#!/bin/bash

basedir=/home/jon/jongraph

while true
do


	cat $basedir/etc/targets | xargs -n 1 -I ^ -P 50 $basedir/bin/collector.sh ^
	$basedir/bin/creategraphs.sh
	  sleep 5
done
