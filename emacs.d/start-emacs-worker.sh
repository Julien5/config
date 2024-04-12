#!/usr/bin/env bash

set -e
# set -x

function find-emacs() {
	source ~/.bashrc
	if which emacs; then
		EXE="$(which emacs)"
	else
		EXE=/usr/local/emacs-29-no-pgtk/bin/emacs
	fi
	# "${EXE}" --maximized "$@" &> /tmp/emacs.out
	echo "${EXE}"
}

function start-nw() {
	export TERM=xterm-256color
	local EXE=$(find-emacs)
	cd $HOME
	"${EXE}" -nw &> /tmp/emacs.out
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