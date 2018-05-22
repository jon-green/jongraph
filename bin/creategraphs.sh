#!/bin/bash

basedir=/home/jon/jongraph

for file in $basedir/rrd/*.rrd
    do
        host=${file#$basedir/rrd/}
        host=${host%.rrd}

        rrdtool graph $basedir/www/graphs/$host.png \
        -w 600 -h 160 -a PNG \
	-l 0 -u 150 -c CANVAS#000000 -c FONT#FFFFFF -c BACK#000000 \
        --slope-mode \
        --start -14400 --end now \
        --font DEFAULT:8: \
        --title "$host" \
        --vertical-label "Latency (ms)" \
        --lower-limit 0 \
        --alt-y-grid --rigid \
        DEF:min=$file:min:MAX \
        DEF:avg=$file:avg:MAX \
        DEF:max=$file:max:MAX \
        DEF:lost=$file:lost:MAX \
	COMMENT:"Last updated `date '+%d/%m %H\:%M\:%S'`   " \
        AREA:max#FFFF00:"Max" \
        AREA:avg#0223ca:"Avg" \
        AREA:min#03bd10:"Min" \
	AREA:lost#e11110:"Lost"
done

