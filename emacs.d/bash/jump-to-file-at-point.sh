#!/usr/bin/env bash

# echo $@ > ~/args

set -e
# set -x

source $JULIEN5CONFIGPATH/scripts/normalize.sh

function othername() {
	local f=$1;
	local bb=$(basename $f | cut -f1 -d".") # TODO: support aa.bbb.ccc.h
	if [[ "$fname" == *h ]]; then
		printf "%s" "-name '$bb.cpp' -or -name '$bb.c'"
	else
		printf "%s" "-name '$bb.h'"
	fi
}

pid="$1"
line="$2" # #include <foo/bar.h> -> bar
fname="$3" # filename.cpp -> filename.h

if [[  -z "$fname" ]]; then
	echo missing fname;
	exit 1;
fi

dir=$(normalize.path $(dirname $fname))

if [[ "$line" =~ "include" ]]; then
	included=$(echo "$line" | tr "\t " " " | tr -s " " | cut -f2 -d" " | tr -d "\"<>");
	fname=$(basename "$included")
fi



function _getdirs() {
	printf "%s\n" "$dir"
	if [[ -f ~/.op/$pid/projectiles ]]; then
		cat ~/.op/$pid/projectiles | while read a; do printf "%s\n" "$a"; done;
	fi
}

function getdirs() {
	_getdirs | sort | uniq | tr "\n" " "
}

function findfile() {
	eval find $(getdirs) -type f $(othername "$fname") | head -1
}


ret=$(findfile);
if [[ -f "$ret" ]]; then
 	printf "%s" "$(normalize.path $ret)"
fi
