#!/usr/bin/env bash

set -e
set -x

function find-emacs() {
	EXE=/usr/local/emacs-29-no-pgtk/bin/emacs
	if [ -f ${EXE} ]; then
		echo "${EXE}"	
		return
	fi

	EXE=/usr/local/emacs-29.4/bin/emacs
	if [ -f ${EXE} ]; then
		echo "${EXE}"	
		return
	fi

	if hash emacs; then
		echo "$(which emacs)"
		return;
	fi
	# no emacs on this system?
	return 1
}

function start-nw() {
	local P=$HOME/setup/profile/profile.sh
	if [ -f $P ]; then 
		source ${P}
	fi
	export TERM=xterm-256color
	local EXE=$(find-emacs)
	cd $HOME
	printf "starting [%s -mm -nw]\n" "${EXE}" &> /tmp/emacs.nw.out
	"${EXE}" -mm -nw &>> /tmp/emacs.nw.out
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
