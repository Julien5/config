#!/usr/bin/env bash

set -e
set -x

function install() {
	DESTDIR=/opt/rust
	mkdir -p $DESTDIR
	export CARGO_HOME=$DESTDIR/cargo
	export RUSTUP_HOME=$DESTDIR/rustup
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
}

function main() {
	install
}

main "$@"

