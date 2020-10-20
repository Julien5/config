#!/usr/bin/env bash

# echo $@ > ~/args

set -e
# set -x

source $JULIEN5CONFIGPATH/scripts/normalize.sh

line="$1" # #include <foo/bar.h> -> foo/bar
fname="$2" # filename.cpp -> filename.h
dirs="${@:3:$#}"
dir=$(dirname $fname)


if [[  -z "$fname" ]]; then
	echo missing fname;
	exit 1;
fi

if [[ "$line" =~ "include" ]]; then
	included=$(echo "$line" | tr "\t " " " | tr -s " " | cut -f2 -d" " | tr -d "\"<>");
	fname="$included"
fi



function corename() {
	local f=$1;
	echo $(basename $f | cut -f1 -d".") # TODO: support aa.bbb.ccc.h
}

function othername() {
	local f=$1;
	local bb=$(corename $f)
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
	echo find $(getdirs) -type f $(othername "$fname") \|  grep $fname 
}

function commonprefix() {
	string1="$1"
	string2="$2"
	printf '%s\x0%s' "$string1" "$string2" | sed 's/\(.*\).*\x0\1.*/\1/'
}

function selectcandidate() {
	declare -A candidates;
	for a in "${@:2:$#}"; do
		c=$(commonprefix $1 $a)
		length=${#c}
		echo $length $a
	done 
}
list=$(eval $(findfile))
count=$(echo "$list" | wc -l)
if [[ "$count" -gt "1" ]]; then
	ret=$(selectcandidate $(realpath $fname) $list | sort -n -r | head -1 | cut -f2 -d" ")
else
	ret=$(realpath $list)
fi
if [[ -f "$ret" ]]; then
 	printf "%s" "$(normalize.path $ret)"
fi
