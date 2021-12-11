#!/usr/bin/env bash

set -e
#set -x

DIR=$(realpath $(dirname $0))
cd $DIR
# backup file.
( pushd keyboards/atreus/keymaps/jbo/ &> /dev/null;  cp -v jbo.json jbo.bak.$(find -name "*.json" | wc -l).json  )
QMKDIR="$(realpath /opt/qmk/qmk_firmware)"
find ~/Downloads/ -name "*.json" -type f | while read file; do
	cp -v $file keyboards/atreus/keymaps/jbo/jbo.json;
	mv -v $file $QMKDIR/keyboards/atreus/keymaps/jbo/jbo.json;
done

#pushd ~/qmk/qmk_firmware/keyboards/atreus/keymaps/jbo/
#\~/qmk/qmk_firmware/bin/qmk compile
#popd
if [[ -z $1 ]]; then
	pushd $QMKDIR
	echo "clean"
	rm -Rf .build
	qmk compile $DIR/keyboards/atreus/keymaps/jbo/jbo.json
	# make -v atreus/promicro:jbo
	HEX=$(find $QMKDIR/.build/ -name "*.hex")
	popd
else
	HEX=$1
fi

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

