#!/usr/bin/env bash

set -e
#set -x

DIR=$(realpath $(dirname $0))
cd $DIR

HEX=$1
if [[ ! -f $HEX ]]; then
	echo could not find $HEX
	echo "missing filename?"
	exit 1;
fi

function flash() {
	# sudo apt install avrdude
	# https://github.com/avrdudes/avrdude/releases
	avrdude  -p atmega32u4 -c avr109 -P /dev/ttyACM0 -U flash:w:$HEX
}

while [[ ! -w /dev/ttyACM0 ]]; do
	echo "wait (press reset)";
	sleep 1;
done;

while true; do
	if ! flash; then
		continue;
	else
		break;
	fi;
done;

