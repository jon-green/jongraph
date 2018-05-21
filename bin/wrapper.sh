#!/bin/bash
while true
do


	cat ../etc/targets | xargs -n 1 -I ^ -P 50 ./collector.sh ^
	./creategraphs.sh
	  sleep 5
done
