#!/usr/bin/env bash

function dev.esp8266.compiler() {
	local compiler=$1
	shift
	initpath;
    local DIR=/opt/esp8266-toolchain
    export PATH=$PATH:$DIR/gcc/${compiler}/xtensa-lx106-elf/bin
    export IDF_PATH=$DIR/ESP8266_RTOS_SDK
    export SDK_PATH=$DIR/ESP8266_RTOS_SDK
	export PYTHONPATH=/opt/esp8266-toolchain/python-dependencies/
	# do not setup compile database for esp8266 builds
	# clangd fails to *not include* host dirs like /usr/include.
}

function dev.esp8266() {
	dev.esp8266.compiler 8.4.0
}

function dev.avr() {
	initpath
	echo sourcing $JULIEN5CONFIGPATH/profile/profile.avr.sh
	. $JULIEN5CONFIGPATH/profile/profile.avr.sh
}

function dev.pc() {
	initpath
	mkdir -p /tmp/builds/PC/
	rm -f /tmp/builds/build
	ln -s /tmp/builds/PC /tmp/builds/build
}

function dev.rust.desktop() {
	initpath
	local F=$JULIEN5CONFIGPATH/profile/profile.rust-desktop.sh
	echo sourcing ${F} 
	. ${F}
	
}
