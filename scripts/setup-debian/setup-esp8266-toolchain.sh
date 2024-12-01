#!/usr/bin/env bash

set -e
set -x

# see
# https://docs.espressif.com/projects/esp8266-rtos-sdk/en/latest/get-started/linux-setup.html

SDKTARBALL=xtensa-lx106-elf-gcc8_4_0-esp-2020r3-linux-amd64.tar.gz

function download-sdk() {
	URL=https://dl.espressif.com/dl/$SDKTARBALL
	if [ -f ~/Downloads/$SDKTARBALL ]; then
		return
	fi
	wget $URL -O ~/Downloads/$SDKTARBALL
}

function init() {
	owner=$(stat --format '%U' /opt)
	if [ "${owner}" != "julien" ]; then
		echo please run as root:
		echo chown -R julien:julien /opt/
	fi
	DEST=/opt/esp8266-toolchain
	rm -Rf ${DEST}
	mkdir -p ${DEST}
}

function unpack-sdk() {
	if [ ! -d ${DEST}/xtensa-lx106-elf ]; then
		tar -C ${DEST}/ -xvf $HOME/Downloads/$SDKTARBALL
	fi
	if [ ! -d ${DEST}/xtensa-lx106-elf ]; then
		echo could not find ${DEST}/xtensa-lx106-elf
		return 1
	fi
}

function surun() {
	ROOTEXE=$SCRIPTDIR/setup-debian-root.sh
	su root $ROOTEXE "$@"
}

function fix-dependencies() {
	surun install-esp8266-packages
	# debian version of pyparsing is 3.0.4, which is >= 2.4 and does not fit.
	if [ ! -f ~/Downloads/pyparsing-2.3.1.tar.gz ]; then
		wget https://files.pythonhosted.org/packages/b9/b8/6b32b3e84014148dcd60dd05795e35c2e7f4b72f918616c61fdce83d27fc/pyparsing-2.3.1.tar.gz -O ~/Downloads/pyparsing-2.3.1.tar.gz
	fi
	cd /tmp/
	tar xvf ~/Downloads/pyparsing-2.3.1.tar.gz
	cd pyparsing-2.3.1/
	python3 setup.py build
	python3 setup.py install --prefix=${DEST}/python-dependencies
}

RTOSTARBALL=v3.4.tar.gz

function download-rtos() {
	URL=https://github.com/espressif/ESP8266_RTOS_SDK/archive/refs/tags/$RTOSTARBALL
	if [ -f ~/Downloads/$RTOSTARBALL ]; then
		return
	fi
	wget $URL -O ~/Downloads/$RTOSTARBALL
}

function unpack-rtos() {
	if [ ! -d ${DEST}/ESP8266_RTOS_SDK* ]; then
		tar -C ${DEST}/ -xvf $HOME/Downloads/$RTOSTARBALL
	fi
	if [ ! -d ${DEST}/ESP8266_RTOS_SDK* ]; then
		echo coul not find ${DEST}/ESP8266_RTOS_SDK
		return 1
	fi
	ln -s ${DEST}/ESP8266_RTOS_SDK* ${DEST}/ESP8266_RTOS_SDK
}

function main() {
	init
	download-sdk
	unpack-sdk

	download-rtos
	unpack-rtos

	fix-dependencies
}

main "$@"
