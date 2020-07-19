#!/usr/bin/env bash

source $JULIEN5CONFIGPATH/scripts/normalize.sh

function other() {
	local f=$1;
	local bb=$(basename $f | cut -f1 -d".") # TODO: support aa.bbb.ccc.h
	if [[ "$fname" == *h ]]; then
		echo "$bb".c
	else
		echo "$bb".h
	fi
}

pid="$1"
line="$2" # #include <foo/bar.h> -> bar
fname="$3" # filename.cpp -> filename.h

if [[ -z "$line" || -z "$fname" ]]; then
	echo missing parameters line and fname;
	exit 1;
fi

dir=$(realpath $(dirname $fname))

if [[ "$line" =~ "include" ]]; then
	included=$(echo "$line" | tr "\t " " " | tr -s " " | cut -f2 -d" " | tr -d "\"<>");
	bname=$(basename "$included")
else
	bname=$(other $fname);
fi

function getdirs() {
	printf "%s " "$dir"
	if [[ -f ~/.op/$pid/projectiles ]]; then
		cat ~/.op/$pid/projectiles | while read a; do printf "%s " "$a"; done;
	fi
}

ret=$(find $(getdirs) -type f -name "$bname" | head -1)
if [[ -f "$ret" ]]; then
	echo -n $(normalize $ret)
fi

