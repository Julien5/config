#!/usr/bin/env bash

function root-installs() {
	cp /opt/qmk/util/udev/50-qmk.rules /etc/udev/rules.d/
	apt install gcc-arm-none-eabi
	apt install dfu-programmer
	apt install dfu-util
}

function install() {
	PYVENV=$HOME/venv
	if [ ! -d ${PYVENV} ]; then
		python3 -m venv ${PYVENV}
	fi
	${PYVENV}/bin/pip install qmk
	if [ ! -e ~/.local/bin/qmk ]; then
		mkdir -p ~/.local/bin
		ln -s ${PYVENV}/./bin/qmk ~/.local/bin/qmk;
	fi
	export PATH=/usr/local/bin:/usr/bin:/bin:$HOME/.local/bin
	export PATH=$PATH:/opt/avr/avr-gcc-14.1.0-x64-linux/bin/:/opt/avr/avrdude_Linux_64bit/bin/
	# install 
	# 2.2G	/opt/qmk/
	# ./bin/qmk setup --home /opt/qmk
	# then
	# root-installs
	qmk setup --home /opt/qmk
}

function main() {
	# install
	export PATH=/usr/local/bin:/usr/bin:/bin:$HOME/.local/bin
	export PATH=$PATH:/opt/avr/avr-gcc-14.1.0-x64-linux/bin/:/opt/avr/avrdude_Linux_64bit/bin/
	qmk compile keyboards/atreus/keymaps/jbo/jbo.json
}

main "$@"
