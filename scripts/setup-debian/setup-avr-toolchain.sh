#!/usr/bin/env bash

set -e
#set -x

function download-worker() {
	local URL=$1
	shift
	local filename=$(basename $URL)
	if [ -f $filename ]; then
		return;
	fi
	if [ -f $HOME/Downloads/$filename ]; then
		cp  $HOME/Downloads/$filename .
		return;
	fi
	wget "$URL"
}

function download-unpack() {
	local name=$1
	shift
	local URL=$1
	shift
	local DESTDIR=$1
	shift
	mkdir -p download/${name}
	cd download/${name}
	printf "download %s.." "${name}"
	download-worker $URL
	local TARBALL=$(find ${PWD} -maxdepth 1 -type f)
	printf " done\n"
	cd ../..
	DIRNAME=$(tar --list --file ${TARBALL} | head -1)
	if [ -d ${DESTDIR}/${DIRNAME} ]; then
		printf "(%s found)\n" "${DESTDIR}/${DIRNAME}"
		return
	fi
	mkdir -p ${DESTDIR}
	cd ${DESTDIR}
	printf "unpack %s.." "${name}"
	tar xf ${TARBALL}
	printf " done\n"
}

function unversion() {
	local ROOT=$1
	shift
	local NAME=$1
	shift
	D=$(find $ROOT -maxdepth 1 -type d -name "${NAME}-*")
	rm -Rf ${NAME}
	mv ${D} ${ROOT}/${NAME}
}

function main() {
	mkdir -p /opt/avr
	cd /opt/avr
	
	download-unpack avr-gcc \
					https://github.com/ZakKemble/avr-gcc-build/releases/download/v14.1.0-1/avr-gcc-14.1.0-x64-linux.tar.bz2 \
					/opt/avr
	echo done

	download-unpack avr-core \
					https://github.com/arduino/ArduinoCore-avr/archive/refs/tags/1.8.6.tar.gz \
					/opt/avr

	COREDIR=$(find /opt/avr/ -maxdepth 1 -type d -name "ArduinoCore-avr-*")
	

	download-unpack AltSoftSerial \
					https://codeload.github.com/PaulStoffregen/AltSoftSerial/tar.gz/refs/tags/1.4 \
					${COREDIR}/libraries/
	unversion ${COREDIR}/libraries AltSoftSerial

	download-unpack LowPower \
					https://codeload.github.com/rocketscream/Low-Power/tar.gz/refs/tags/V1.81 \
					${COREDIR}/libraries/
	unversion ${COREDIR}/libraries Low-Power

	download-unpack LiquidCrystal \
					https://github.com/arduino-libraries/LiquidCrystal/archive/refs/tags/1.0.7.tar.gz \
					${COREDIR}/libraries/
	unversion ${COREDIR}/libraries LiquidCrystal

	download-unpack avrdude \
					https://github.com/avrdudes/avrdude/releases/download/v8.0/avrdude_v8.0_Linux_64bit.tar.gz \
					/opt/avr

	local ROOTEXE=$SCRIPTDIR/setup-debian-root.sh
	su root $ROOTEXE allow-tty-user
}

SCRIPTDIR="$(dirname "$(realpath "$0")")"
main "$@"
echo done
