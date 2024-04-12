#!/usr/bin/env bash

set -e
set -x

# xterm -fn 9x15 -bg grey15 -fg grey70 -maximized -T emacs -e "export TERM=xterm-256color; emacs -nw"
STARTER=$HOME/.emacs.d/start-emacs-worker.sh

function start-gui() {
	EXE="$($STARTER find-emacs)"
	cd $HOME
	"${EXE}" --maximized "$@" &> /tmp/emacs.gui.out
}

function start-terminal() {
	xfce4-terminal --maximize --hide-menubar --hide-scrollbar --title=emacs  -e "$STARTER start-nw"
}

function main() {
	if [ $# -gt 0 ]; then
		local cmd="$1"
		shift
		echo "running $cmd" "$@"
		"$cmd" "$@"
		return
	fi
	# default 
	start-terminal
}


main "$@"
