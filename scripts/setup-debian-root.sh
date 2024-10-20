#!/usr/bin/env bash

set -e

function install-packages() {
	apt install git curl
}

function install-bitmap-fonts() {
	if [ -d /usr/local/share/fonts/bitmaps/ ]; then
		echo bitmap fonts are installed
		return;
	fi
	mkdir -p /usr/local/share/fonts/bitmaps/
	cp /home/julien/projectsconfig/emacs.d/fonts/*.otb /usr/local/share/fonts/bitmaps/
	/sbin/dpkg-reconfigure fontconfig-config
	fc-cache -fv /usr/local/share/fonts/bitmaps/
	fc-list | grep bitmaps 
}

function hello() {
	echo hello
}

function main() {
	local F=$1
	shift
	if [ ! -z $F ]; then
		printf "root: [%s]\n" "${F}"
		$F
		return
	fi
	echo missing job parameter:
	grep ^function $0 | cut -f2 -d" "  | tr -d "()" | grep -v "main" | while read a; do
		printf " * %s\n" "${a}"
	done
}

main "$@"
