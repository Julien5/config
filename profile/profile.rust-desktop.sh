#!/usr/bin/env bash

function main() {
	local RSHOME=/opt/rust
	export CARGO_HOME=$RSHOME/cargo
	export RUSTUP_HOME=$RSHOME/rustup
	export CARGO_TARGET_DIR=$HOME/delme/rust-targets
	# mkdir -p ${CARGO_TARGET_DIR}
	. "$RSHOME/cargo/env"
}

main
