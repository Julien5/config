#!/usr/bin/env bash

for a in "$@"; do
	echo $a;
done > ~/args

set -e
set -x

if [[ -z $JULIEN5CONFIGPATH ]]; then
	echo JULIEN5CONFIGPATH is not set
	exit 1
fi

source $JULIEN5CONFIGPATH/scripts/normalize.sh

LINE="$1" # #include <foo/bar.h> -> foo/bar
FILENAME="$2" # filename.cpp -> filename.h

function corename() {
	local f=$1;
	echo $(basename $f | cut -f1 -d".") # TODO: support aa.bbb.ccc.h
}

function parseinclude() {
	echo "$LINE" | tr "\t " " " | tr -s " " | cut -f2 -d" " | tr -d "\"<>"
}

function othername() {
	if [[ "$LINE" =~ "include" ]]; then
		parseinclude
		return;
	fi
	
	if [[ "$FILENAME" == *h ]]; then
		# we are in header file => we want cpp file
		printf "%s" "$(corename $FILENAME).c"
	else
		# we are in cpp file => we want header file
		printf "%s" "$(corename $FILENAME).h"
	fi
}

function projectroot() {
	local D=$1
	while true; do
		if [[ -d $D/.git ]] || [[ -d $D/compile_flags.txt ]]; then
			echo $D
			return 0
		fi
		if [[ "$D" = "/" ]]; then
			break
		fi
		D=$(realpath $D/..)
	done
	return 1
}

function main_include() {
	# if we are processing an include, start at projectroot
	if [[ "$LINE" =~ "include" ]]; then
		if [[ $(dirname $(othername)) = "." ]]; then
			if find $(pwd) -name "$(othername)" | grep -v "#"; then
				return 0
			fi
		fi
		local D=$(projectroot $(pwd))
		if find $D -ipath "*$(othername)*" | grep -v "#"; then
			return 0
		fi
		return 1
	fi
}

function main_no_include() {
	local D=$(dirname $FILENAME)
	R=$(projectroot $D)
	while true; do
		if find $D -name "$(othername)*" | grep .; then
			return 0
		fi
		if [[ $D = $R ]]; then
			break;
		fi
		D=$(realpath $D/..)
	done
	return 1
}


function main() {
	# if we are processing an include, start at projectroot
	if [[ "$LINE" =~ "include" ]]; then
		main_include
		return 
	fi
	main_no_include
}

main
