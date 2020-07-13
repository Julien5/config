#!/usr/bin/env bash

function other() {
	local f=$1;
	local bb=$(basename $f | cut -f1 -d".") # TODO: support aa.bbb.ccc.h
	if [[ "$fname" == *h ]]; then
		echo "$bb".c
	else
		echo "$bb".h
	fi
}

line=$1 # #include <foo/bar.h> -> bar
fname=$2 # filename.cpp -> filename.h

dir=$(realpath $(dirname $fname))

if [[ "$line" =~ "include" ]]; then
	included=$(echo "$line" | tr "\t " " " | tr -s " " | cut -f2 -d" " | tr -d "\"<>");
	fname="$included"
	bname=$(basename $fname)
else
	fname=$(other $fname);
	bname="$fname"*
fi
	


dirs=$dir
if [[ -f ~/.op/projectiles ]]; then
	dirs="$dir $(cat ~/.op/projectiles)"
fi

ret=$(find $dirs -type f -name "$bname" | head -1)
echo $ret
