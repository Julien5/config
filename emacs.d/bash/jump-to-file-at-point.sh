#!/usr/bin/env bash

# echo $@ > ~/args

set -e
# set -x

source $JULIEN5CONFIGPATH/scripts/normalize.sh

line="$1" # #include <foo/bar.h> -> bar
fname="$2" # filename.cpp -> filename.h
dirs="${@:3:$#}"
dir=$(dirname $fname)

if [[  -z "$fname" ]]; then
	echo missing fname;
	exit 1;
fi

if [[ "$line" =~ "include" ]]; then
	included=$(echo "$line" | tr "\t " " " | tr -s " " | cut -f2 -d" " | tr -d "\"<>");
	fname=$(basename "$included")
fi


function othername() {
	local f=$1;
	local bb=$(basename $f | cut -f1 -d".") # TODO: support aa.bbb.ccc.h
	if [[ "$fname" == *h ]] && [[ ! "$line" =~ "include" ]]; then
		printf "%s" "-name '$bb.cpp' -or -name '$bb.c'"
	else
		printf "%s" "-name '$bb.h'"
	fi
}

function _getdirs() {
	printf "%s\n" "$dir"
	for d in "$dirs"; do
		printf "%s\n" $d
	done
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
