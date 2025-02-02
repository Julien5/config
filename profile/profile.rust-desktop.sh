#!/usr/bin/env bash

function main() {
	local RSHOME=/opt/rust
	export CARGO_HOME=$RSHOME/cargo
	export RUSTUP_HOME=$RSHOME/rustup
	. "$RSHOME/cargo/env"
}

main
