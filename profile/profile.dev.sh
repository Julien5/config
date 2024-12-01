#!/usr/bin/env bash

function dev.esp8266.open.rtos() {
	initpath;
    DIR=/opt/esp8266/esp8266-toolchain
    export PATH=$PATH:$DIR/compiler/xtensa-lx106-elf/bin/
}

function dev.esp8266() {
	initpath;
    local DIR=/opt/esp8266-toolchain/
    export PATH=$PATH:$DIR/xtensa-lx106-elf/bin
    export IDF_PATH=$DIR/ESP8266_RTOS_SDK
    export SDK_PATH=$DIR/ESP8266_RTOS_SDK
	export PYTHONPATH=$(find ${DIR}/python-dependencies/ -name "pyparsing-*.egg" -type d)
}

function dev.avr() {
	initpath
	echo sourcing $JULIEN5CONFIGPATH/profile/profile.avr.sh
	. $JULIEN5CONFIGPATH/profile/profile.avr.sh
}
