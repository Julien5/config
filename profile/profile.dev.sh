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

function dev.rust() {
	initpath
	local F=$JULIEN5CONFIGPATH/profile/profile.rust-desktop.sh
	echo sourcing ${F} 
	. ${F}
	
}

function dev.only-flutter() {
	initpath
	export PATH=${PATH}:/opt/flutter/flutter/bin
	export CHROME_EXECUTABLE=/opt/flutter/chrome/opt/google/chrome/google-chrome
}

function dev.flutter-rust() {
	dev.rust
	export PATH=${PATH}:/opt/flutter/flutter/bin:/opt/flutter/VSCode-linux-x64/bin/
	export CHROME_EXECUTABLE=/opt/flutter/chrome/opt/google/chrome/google-chrome
}
