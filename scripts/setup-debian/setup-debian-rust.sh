#!/usr/bin/env bash

set -e
set -x

DESTDIR=/opt/rust

function install-analyzer() {
	local D=${DESTDIR}/analyzer
	mkdir -p ${D}/bin
	local URL=https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz
	curl -L "${URL}" | gunzip -c - > ${D}/bin/rust-analyzer
	chmod +x ${D}/bin/rust-analyzer
}

function install-compiler() {
	mkdir -p $DESTDIR
	if [ ! -e /opt/rust/rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rustc ]; then
		export CARGO_HOME=$DESTDIR/cargo
		export RUSTUP_HOME=$DESTDIR/rustup
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
	fi
}

function main() {
	install-compiler
	install-analyzer
	echo done
}

main "$@"

