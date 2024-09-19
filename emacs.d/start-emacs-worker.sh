#!/usr/bin/env bash

set -e
set -x

function find-emacs() {
	if hash emacs; then
		EXE="$(which emacs)"
	else
		EXE=/usr/local/emacs-29-no-pgtk/bin/emacs
	fi
	echo "${EXE}"
}

function start-nw() {
	local P=$HOME/setup/profile/profile.sh
	if [ -f $P ]; then 
		source ${P}
	fi
	export TERM=xterm-256color
	local EXE=$(find-emacs)
	cd $HOME
	"${EXE}" -mm -nw &> /tmp/emacs.nw.out
}

function main() {
	if [ $# -gt 0 ]; then
		cmd="$1"
		shift
		"$cmd" "$@"
		return;
	fi
	start-nw
}

main "$@"
