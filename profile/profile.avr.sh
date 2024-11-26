#!/usr/bin/env bash

export PATH=$PATH:/opt/avr/avr-gcc-14.1.0-x64-linux/bin/:/opt/avr/avrdude_Linux_64bit/bin/

function screen () {
	/usr/bin/screen -L /dev/ttyUSB0 9600
}


