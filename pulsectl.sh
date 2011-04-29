#!/bin/bash

CUR_VOL=`pacmd list-sinks | awk '/^[[:space:]]+volume:/ { sub(/%/, "", $3); print $3 }'`
STEPS=`pacmd list-sinks | awk '/volume steps:/ { print $3 }'`
MUTED=`pacmd list-sinks | awk '/muted:/ { print $2 }'`

case $1 in
	toggle)
		case $MUTED in
			no) echo `pacmd set-sink-mute 0 1` > /dev/null ;;
			yes) echo `pacmd set-sink-mute 0 0` > /dev/null ;;
		esac
		;;

	up)
		if [ $(($CUR_VOL + 10)) -gt "100" ] ; then
			NV=100
		else
			NV=$(($CUR_VOL+10))
		fi
		NV=$(($STEPS/100*$NV))
		echo `pacmd set-sink-volume 0 $NV` > /dev/null
		;;

	down)
		if [ $(($CUR_VOL - 10)) -lt "0" ] ; then
			NV=0
		else
			NV=$(($CUR_VOL-10))
		fi
		NV=$((STEPS/100*$NV))
		echo $NV
		echo `pacmd set-sink-volume 0 $NV` > /dev/null
		;;
esac
