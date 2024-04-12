#!/usr/bin/env bash

#xterm -fn 9x15 -bg grey15 -fg grey70 -maximized -T emacs -e "export TERM=xterm-256color; emacs -nw"

source ~/.bashrc
if which emacs; then
	EXE="$(which emacs)"
else
	EXE=/usr/local/emacs-29-no-pgtk/bin/emacs
fi

# "${EXE}" --maximized "$@" &> /tmp/emacs.out

xfce4-terminal --maximize --hide-menubar --hide-scrollbar --title=emacs -e "emacs -nw &> /tmp/emacs.out"
