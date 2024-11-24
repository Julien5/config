#!/usr/bin/env bash

function dev.esp8266.open.rtos() {
	initpath;
    DIR=/opt/esp8266/esp8266-toolchain
    export PATH=$PATH:$DIR/compiler/xtensa-lx106-elf/bin/
}

function dev.esp8266() {
	initpath;
    local DIR=/opt/esp8266/esp8266-toolchain-espressif
    export PATH=$PATH:$DIR/compiler/xtensa-lx106-elf/bin
    export IDF_PATH=$DIR/ESP8266_RTOS_SDK/
    export SDK_PATH=$DIR/ESP8266_RTOS_SDK/
}

function dev.avr() {
	initpath
	export PATH=$PATH:/opt/avr/avr-gcc-14.1.0-x64-linux/bin/:/opt/avr/avrdude_Linux_64bit/bin/
}
