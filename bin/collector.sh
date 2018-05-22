#!/bin/bash

basedir=/home/jon/jongraph

output=`ping -c 20 -i .2 -W 1 -q $1`
retval=$?

if [ $retval -eq 0 ] # we have some pings
then
    recvd=`echo $output | grep -o '[0-9]\+ received'`
    recvd=${recvd% received}
    lost=`expr 20 - $recvd`
    stats=(`echo $output | grep -o '[0-9.]\+/[0-9.]\+/[0-9.]\+' | tr '/' ' '`)
    min=${stats[0]}
    avg=${stats[1]}
    max=${stats[2]}
elif [ $retval -eq 1 ] # 100% loss
then
    lost=1000
    min='U'
    avg='U'
    max='U'
elif [ $retval -eq 2 ] # host not found
then
    exit $retval
else # other errors
    exit $retval
fi

if [ ! -f $basedir/rrd/$1.rrd ] # create rrd if it doesn't exist
then
    rrdtool create $basedir/rrd/$1.rrd \
    --step 5 \
    DS:lost:GAUGE:120:0:1000 \
    DS:min:GAUGE:120:0:1000 \
    DS:avg:GAUGE:120:0:1000 \
    DS:max:GAUGE:120:0:1000 \
    RRA:MAX:0.5:1:525600

    retval=$?

    if [ $retval -gt 0 ]
    then
        exit 0
    fi
fi

rrdtool update $basedir/rrd/$1.rrd N:$lost:$min:$avg:$max

retval=$?

if [ $retval -gt 0 ]
then
    exit 0
fi

