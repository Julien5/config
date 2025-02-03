#!/usr/bin/env bash

set -e
set -x

function manuall-install() {
	local name="$1"
	shift
	local URL="$1"
	shift
	local DEST="$1"
	shift

	if [ -d "${DEST}/${name}" ]; then
		echo found "{name}" in "${DEST}"
		return;
	fi
	
	local BURL="$(basename "${URL}")"
	# installing rdp with pip => installs numpy 2, which is
	# incompatible with debian numpy.
	# install rdp 'manually'
	# pip install --target ${DEST} rdp==0.8
	TARBALL=$HOME/Downloads/${name}-${BURL}
	if [ ! -f ${TARBALL} ]; then
		wget "${URL}" -O ${TARBALL}
	fi

	rm -Rf /tmp/extract-${name}
	mkdir -p /tmp/extract-${name}
	cd /tmp/extract-${name}
	
	dname="$(tar --list --file "${TARBALL}"  | head -1)"
	rm -Rf ${dname}
	tar xvf ~/Downloads/${BURL}
	cd ${dname}
	if [ -f setup.py ]; then
		python3 setup.py build
		cp -Rf build/lib/${name} ${DEST}
	elif [ -d ${name} ]; then
		cp -Rf ./${name} ${DEST}
	else
		echo dont know how to build ${name}
		return 1
	fi
	
}


function fix-dependencies() {
	for a in self pip; do
		mkdir -p /opt/python3/${a}
	done
	DEST=/opt/python3/self
	name=rdp
	url="https://files.pythonhosted.org/packages/67/42/80a54cc4387256335c32b48bd42db80967ab5f40d6ffcd8167b3dd988c11/rdp-0.8.tar.gz"
	manuall-install "${name}" "${url}" "${DEST}"

	name=srtm
	#url="https://files.pythonhosted.org/packages/54/57/15689e6a4eac07edd4187f57d2b467ede3e408f0bbd9ae31c002b2aabece/python_srtm-0.6.0.tar.gz"
	url="https://github.com/tkrajina/srtm.py/archive/refs/tags/v0.3.7.tar.gz"
	manuall-install "${name}" "${url}" "${DEST}"
}

function main() {
	fix-dependencies
}

main "$@"
