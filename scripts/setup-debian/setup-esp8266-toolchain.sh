#!/usr/bin/env bash

set -e
set -x

# see
# https://docs.espressif.com/projects/esp8266-rtos-sdk/en/latest/get-started/linux-setup.html

SCRIPTDIR="$(dirname $(realpath "$0"))"
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
	pip install --target ${DEST}/python-dependencies cryptography==3.4.8
	pip install --target ${DEST}/python-dependencies pyparsing==2.3.1
}

RTOSTARBALL=ESP8266_RTOS_SDK.tar.gz
function download-rtos() {
	if [ -f ~/Downloads/$RTOSTARBALL ]; then
		return
	fi
	rm -Rf /tmp/dl
	mkdir -p /tmp/dl
	pushd /tmp/dl
	URL=https://github.com/espressif/ESP8266_RTOS_SDK.git
	git clone --recursive ${URL} --depth 1
	mv ESP8266_RTOS_SDK/.git dotgit
	tar zcf ESP8266_RTOS_SDK.tar.gz ESP8266_RTOS_SDK/
	mv ESP8266_RTOS_SDK.tar.gz ~/Downloads
	popd
	rm -Rf /tmp/dl
}

function unpack-rtos() {
	if [ ! -d ${DEST}/ESP8266_RTOS_SDK* ]; then
		tar -C ${DEST}/ -xvf $HOME/Downloads/$RTOSTARBALL
	fi
	if [ ! -d ${DEST}/ESP8266_RTOS_SDK* ]; then
		echo coul not find ${DEST}/ESP8266_RTOS_SDK
		return 1
	fi
	if [ ! -f ${DEST}/ESP8266_RTOS_SDK ]; then
		ln -s ${DEST}/ESP8266_RTOS_SDK* ${DEST}/ESP8266_RTOS_SDK
	fi
}

function install-arduino-core-esp8266() {
	URL=https://github.com/esp8266/Arduino/archive/refs/tags/3.1.2.tar.gz
	TARBALL=/opt/esp8266-toolchain/Arduino-3.1.2.tar.gz
	if [ -f $HOME/Downloads/Arduino-3.1.2.tar.gz ]; then
		cp $HOME/Downloads/Arduino-3.1.2.tar.gz ${TARBALL}
	fi
	if [ ! -f ${TARBALL} ]; then
		wget ${URL} -O ${TARBALL}
	fi
	cd /opt/esp8266-toolchain/
	if [ ! -d Arduino-3.* ]; then
		tar xf ${TARBALL}
	fi
}

function main() {
	init
	download-sdk
	unpack-sdk

	download-rtos
	unpack-rtos

	fix-dependencies

	install-arduino-core-esp8266
}

main "$@"
