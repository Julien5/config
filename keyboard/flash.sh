#!/usr/bin/env bash

set -e
set -x
DIR=$(dirname $0)
cd $DIR
# backup file.
( pushd keyboards/atreus/keymaps/jbo/ &> /dev/null;  cp -v jbo.json jbo.bak.$(find -name "*.json" | wc -l).json  )

find ~/Downloads/ -name "*.json" -exec mv -v "{}" keyboards/atreus/keymaps/jbo/jbo.json \;
#pushd ~/qmk/qmk_firmware/keyboards/atreus/keymaps/jbo/
#\~/qmk/qmk_firmware/bin/qmk compile
#popd
./bin/qmk compile keyboards/atreus/keymaps/jbo/jbo.json
# make -v atreus/promicro:jbo 

HEX=$(find .build/ -name "*.hex")

if [[ ! -f $HEX ]]; then
	echo could not find $HEX
	echo "missing filename?"
	exit 1;
fi

function flash() {
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

