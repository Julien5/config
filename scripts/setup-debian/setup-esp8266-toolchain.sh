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

function unpack-sdk() {
	local DEST=/opt/esp8266-toolchain
	if [ ! -d ${DEST}/xtensa-lx106-elf ]; then
		rm -Rf ${DEST}
		mkdir -p ${DEST}
		tar -C ${DEST}/ -xvf $HOME/Downloads/$SDKTARBALL
	fi
	if [ ! -d ${DEST}/xtensa-lx106-elf ]; then
		echo could not find ${DEST}/xtensa-lx106-elf
		return 1
	fi
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
	local DEST=/opt/esp8266-toolchain/
	if [ ! -d ${DEST}/ESP8266_RTOS_SDK ]; then
		rm -Rf ${DEST}
		mkdir -p ${DEST}
		tar -C ${DEST}/ -xvf $HOME/Downloads/$RTOSTARBALL
	fi
	if [ ! -d ${DEST}/ESP8266_RTOS_SDK ]; then
		echo coul not find ${DEST}/ESP8266_RTOS_SDK
		return 1
	fi
}

function init() {
	owner=$(stat --format '%U' /opt)
	if [ "${owner}" != "julien" ]; then
		echo please run as root:
		echo chown -R julien:julien /opt/
	fi
}

function main() {
	init
	download-sdk
	unpack-sdk

	download-rtos
	unpack-rtos
}

main "$@"
