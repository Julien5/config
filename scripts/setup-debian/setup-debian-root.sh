#!/usr/bin/env bash

set -e

SCRIPTDIR="$(dirname "$(realpath "$0")")"

function install-packages() {
	if hash git; then
		echo "git is installed => packages are considered installed"
		return;
	fi
	apt install git curl silversearcher-ag fontconfig
	# build emacs needs:
	apt install build-essential autoconf pkg-config gnutls-bin libtree-sitter-dev libgnutls28-dev libncurses-dev texinfo libjansson4 libjansson-dev

	# cmake, screen good
	apt install cmake screen clangd

	# pip3 in not really necessary
	# apt install python3-pip
	apt install python3-serial
}

function install-bitmap-fonts() {
	if [ -d /usr/local/share/fonts/bitmaps/ ]; then
		echo bitmap fonts are installed
		return;
	fi
	mkdir -p /usr/local/share/fonts/bitmaps/
	cp /home/julien/projects/config/emacs.d/fonts/*.otb /usr/local/share/fonts/bitmaps/
	/sbin/dpkg-reconfigure fontconfig-config
	fc-cache -fv /usr/local/share/fonts/bitmaps/
	fc-list | grep bitmaps 
}

function install-local-emacs() {
	D=$(find /usr/local/ -maxdepth 1 -name "emacs*")
	if [ ! -z $D ]; then
		echo found $D
		return
	fi
	/home/julien/projects/config/emacs.d/build-emacs.sh
	apt install xclip
	ln -s /usr/local/emacs-29.4/bin/emacsclient /usr/local/bin/
	ln -s /usr/local/emacs-29.4/bin/emacs /usr/local/bin/
}

function hello() {
	echo hello
}

function allow-tty-user() {
	cp ${SCRIPTDIR}/50-tty-usb.rules /etc/udev/rules.d/
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
