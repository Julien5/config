#!/usr/bin/env bash

set -e
set -x

# see
# https://docs.espressif.com/projects/esp8266-rtos-sdk/en/latest/get-started/linux-setup.html

TARBALL=xtensa-lx106-elf-gcc8_4_0-esp-2020r3-linux-amd64.tar.gz

function download() {
	URL=https://dl.espressif.com/dl/$TARBALL
	if [ -f ~/Downloads/$TARBALL ]; then
		return
	fi
	wget $URL -O ~/Downloads/$TARBALL
}

function unpack() {
	local DEST=/opt/esp8266-toolchain
	if [ ! -d ${DEST}/xtensa-lx106-elf ]; then
		rm -Rf ${DEST}
		mkdir -p ${DEST}
		tar -C ${DEST}/ -xvf $HOME/Downloads/$TARBALL
	fi
	if [ ! -d ${DEST}/xtensa-lx106-elf ]; then
		echo coul not find ${DEST}/xtensa-lx106-elf
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
	download
	unpack
}

main "$@"
