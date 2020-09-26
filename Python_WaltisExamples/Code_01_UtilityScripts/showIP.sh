#!/bin/bash



case $1 in
	-f|--foreign)
	IPADRESSE=$(ifconfig | grep "inet addr" | grep -v "127.0.0.1" | sed -e 's/.*inet addr:\(.*\)Bcast.*/\1/')
	shift
	;;
	-l|--lan)
	IPADRESSE=$(ifconfig | grep -A 1 "eth0" | grep "inet addr" | sed -e 's/.*inet addr:\(.*\)Bcast.*/\1/')
	shift
	;;
	-h|--host)
	IPADRESSE=$(ifconfig | grep "inet addr" | grep -v "Bcast" | sed -e 's/.*inet addr:\(.*\)Mask.*/\1/')
	shift
	;;
	*|--default)
	IPADRESSE=$(ifconfig | grep "inet addr" | grep -v "127.0.0.1" | sed -e 's/.*inet addr:\(.*\)Bcast.*/\1/')
	if [ -z $IPADRESSE ]; then
		IPADRESSE=$(ifconfig | grep "inet addr" | sed -e 's/.*inet addr:\(.*\)Mask.*/\1/')
	fi
	;;
	
esac
shift

echo $IPADRESSE